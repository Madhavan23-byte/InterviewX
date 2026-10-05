package com.interviewx.controller;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.interviewx.dao.InterviewDAO;
import com.interviewx.dao.ProfileDAO;
import com.interviewx.dao.ReadinessDAO;
import com.interviewx.model.InterviewQuestion;
import com.interviewx.model.PreparationProfile;
import com.interviewx.service.InterviewAIService;
import com.interviewx.util.DBConnection;

@WebServlet(urlPatterns = {"/interview", "/interview/start", "/interview/submit", "/interview/report",
                            "/interview/feedback", "/interview/history", "/interview/question"})
public class InterviewServlet extends HttpServlet {
    private static final long serialVersionUID = 2L;
    private InterviewDAO interviewDAO;
    private InterviewAIService interviewAIService;
    private ReadinessDAO readinessDAO;
    private ProfileDAO profileDAO;

    @Override
    public void init() {
        interviewDAO = new InterviewDAO();
        interviewAIService = new InterviewAIService();
        readinessDAO = new ReadinessDAO();
        profileDAO = new ProfileDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        Integer profileIdObj = (Integer) session.getAttribute("activeProfileId");
        int profileId = (profileIdObj != null) ? profileIdObj : 0;
        String activeRole = (String) session.getAttribute("activeProfileRole");

        if ("/interview/start".equals(path)) {
            handleStartInterview(req, resp, session, userId, profileId, activeRole);
        } else if ("/interview/report".equals(path)) {
            handleReport(req, resp, session, userId, profileId);
        } else if ("/interview/history".equals(path)) {
            handleHistory(req, resp, userId, profileId);
        } else if ("/interview/feedback".equals(path)) {
            handleFeedbackPage(req, resp, session);
        } else {
            // Index page
            List<Map<String, Object>> history = interviewDAO.getInterviewHistory(userId, profileId);
            req.setAttribute("history", history);
            req.setAttribute("activeRole", activeRole);
            req.getRequestDispatcher("/interview/index.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        resp.setContentType("application/json; charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");

        if (session == null || session.getAttribute("userId") == null) {
            resp.getWriter().write("{\"success\":false,\"error\":\"Not logged in\"}");
            return;
        }

        if ("/interview/submit".equals(path)) {
            handleSubmitAnswer(req, resp, session);
        } else if ("/interview/question".equals(path)) {
            handleGetQuestion(req, resp, session);
        }
    }

    // ======================================================
    // START INTERVIEW
    // ======================================================
    private void handleStartInterview(HttpServletRequest req, HttpServletResponse resp,
                                       HttpSession session, int userId, int profileId, String activeRole)
            throws ServletException, IOException {
        String type = req.getParameter("type");
        if (type == null) type = "TECHNICAL";

        String difficulty = req.getParameter("difficulty");
        if (difficulty == null) difficulty = "MEDIUM";

        // Fetch questions from DB (filtered by role if possible)
        List<InterviewQuestion> questions = interviewDAO.getQuestionsByTypeAndRole(type, activeRole);
        if (questions.isEmpty()) {
            questions = interviewDAO.getQuestionsByType(type);
        }

        int interviewId = interviewDAO.startInterview(userId, profileId, type, activeRole);

        session.setAttribute("currentInterviewId", interviewId);
        session.setAttribute("interviewQuestions", questions);
        session.setAttribute("currentQIndex", 0);
        session.setAttribute("interviewType", type);
        session.setAttribute("interviewRole", activeRole);

        req.setAttribute("interviewId", interviewId);
        req.setAttribute("questions", questions);
        req.setAttribute("question", questions.isEmpty() ? null : questions.get(0));
        req.setAttribute("questionIndex", 1);
        req.setAttribute("totalQuestions", questions.size());
        req.setAttribute("interviewType", type);
        req.setAttribute("activeRole", activeRole);
        req.setAttribute("difficulty", difficulty);

        req.getRequestDispatcher("/interview/interview.jsp").forward(req, resp);
    }

    // ======================================================
    // SUBMIT ANSWER (AJAX POST from interview.jsp)
    // ======================================================
    private void handleSubmitAnswer(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws IOException {
        try {
            req.setCharacterEncoding("UTF-8");
            int interviewId = Integer.parseInt(req.getParameter("interviewId"));
            int questionId = Integer.parseInt(req.getParameter("questionId"));
            String answer = req.getParameter("answer");
            String questionText = req.getParameter("questionText");
            String interviewType = req.getParameter("interviewType");
            String targetRole = (String) session.getAttribute("interviewRole");
            if (targetRole == null) targetRole = (String) session.getAttribute("activeProfileRole");
            if (targetRole == null) targetRole = "Software Engineer";

            int qIndex = 0;
            try { qIndex = Integer.parseInt(req.getParameter("questionIndex")); } catch (Exception e) {}

            // Get AI evaluation — uses InterviewAIService with dedicated key
            String feedbackJson = interviewAIService.evaluateAnswer(
                    targetRole, interviewType != null ? interviewType : "TECHNICAL",
                    questionText, answer);

            int score = interviewAIService.extractScore(feedbackJson);
            double scoreDouble = score / 10.0; // Convert 0-100 → 0-10 for DB

            // Save answer with JSON feedback
            saveAnswerWithJson(interviewId, questionId, answer, feedbackJson, scoreDouble);

            @SuppressWarnings("unchecked")
            List<InterviewQuestion> questions = (List<InterviewQuestion>) session.getAttribute("interviewQuestions");
            boolean isLast = (questions == null || qIndex >= questions.size());

            if (isLast) {
                interviewDAO.completeInterview(interviewId, scoreDouble);
                int userId = (int) session.getAttribute("userId");
                Integer profileIdObj = (Integer) session.getAttribute("activeProfileId");
                int profileId = (profileIdObj != null) ? profileIdObj : 0;
                int trackId = (session.getAttribute("activeProfileTrackId") != null) ?
                    (int) session.getAttribute("activeProfileTrackId") : 2;
                readinessDAO.computeAndSave(userId, profileId, trackId);

                // Store feedback in session for the feedback page
                session.setAttribute("lastInterviewFeedback", feedbackJson);
                session.setAttribute("lastInterviewScore", score);
                session.setAttribute("lastInterviewId", interviewId);
            }

            // Build safe JSON response (feedback already from Gemini)
            String safeJson = feedbackJson.replace("\n", " ").replace("\r", "");
            resp.getWriter().write("{\"success\":true,\"score\":" + score +
                ",\"feedbackJson\":" + safeJson +
                ",\"isLast\":" + isLast + "}");
        } catch (Exception e) {
            System.err.println("[InterviewServlet] submit error: " + e.getMessage());
            resp.getWriter().write("{\"success\":false,\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    // ======================================================
    // GET SINGLE QUESTION (navigation - AJAX)
    // ======================================================
    private void handleGetQuestion(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws IOException {
        try {
            int index = Integer.parseInt(req.getParameter("index"));
            @SuppressWarnings("unchecked")
            List<InterviewQuestion> questions = (List<InterviewQuestion>) session.getAttribute("interviewQuestions");
            if (questions == null || index < 0 || index >= questions.size()) {
                resp.getWriter().write("{\"success\":false,\"error\":\"Invalid index\"}");
                return;
            }
            InterviewQuestion q = questions.get(index);
            resp.getWriter().write("{\"success\":true," +
                "\"questionId\":" + q.getQuestionId() + "," +
                "\"questionText\":" + jsonString(q.getQuestionText()) + "," +
                "\"topic\":" + jsonString(q.getTopic()) + "," +
                "\"difficulty\":" + jsonString(q.getDifficulty()) + "," +
                "\"index\":" + (index + 1) + "," +
                "\"total\":" + questions.size() + "}");
        } catch (Exception e) {
            resp.getWriter().write("{\"success\":false,\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    // ======================================================
    // FEEDBACK PAGE (after interview)
    // ======================================================
    private void handleFeedbackPage(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {
        String feedbackJson = (String) session.getAttribute("lastInterviewFeedback");
        Integer score = (Integer) session.getAttribute("lastInterviewScore");
        Integer interviewId = (Integer) session.getAttribute("lastInterviewId");

        req.setAttribute("feedbackJson", feedbackJson);
        req.setAttribute("overallScore", score != null ? score : 0);
        req.setAttribute("interviewId", interviewId);
        req.getRequestDispatcher("/interview/feedback.jsp").forward(req, resp);
    }

    // ======================================================
    // REPORT
    // ======================================================
    private void handleReport(HttpServletRequest req, HttpServletResponse resp,
                               HttpSession session, int userId, int profileId)
            throws ServletException, IOException {
        int interviewId = 0;
        try { interviewId = Integer.parseInt(req.getParameter("id")); } catch (Exception e) {}

        List<Map<String, Object>> answers = interviewDAO.getAnswersWithFeedback(interviewId, userId);
        req.setAttribute("answers", answers);
        req.setAttribute("interviewId", interviewId);
        req.getRequestDispatcher("/interview/report.jsp").forward(req, resp);
    }

    // ======================================================
    // HISTORY
    // ======================================================
    private void handleHistory(HttpServletRequest req, HttpServletResponse resp,
                                int userId, int profileId) throws ServletException, IOException {
        List<Map<String, Object>> history = interviewDAO.getInterviewHistory(userId, profileId);
        resp.setContentType("application/json; charset=UTF-8");
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < history.size(); i++) {
            if (i > 0) sb.append(",");
            Map<String, Object> m = history.get(i);
            sb.append("{");
            sb.append("\"interviewId\":").append(m.get("interviewId")).append(",");
            sb.append("\"interviewType\":").append(jsonString(String.valueOf(m.get("interviewType")))).append(",");
            sb.append("\"overallScore\":").append(m.get("overallScore")).append(",");
            sb.append("\"status\":").append(jsonString(String.valueOf(m.get("status")))).append(",");
            sb.append("\"startedAt\":").append(jsonString(String.valueOf(m.get("startedAt"))));
            sb.append("}");
        }
        sb.append("]");
        resp.getWriter().write(sb.toString());
    }

    // ======================================================
    // HELPERS
    // ======================================================
    private void saveAnswerWithJson(int interviewId, int questionId, String answer,
                                     String feedbackJson, double score) {
        String sql = "INSERT INTO interview_answers (interview_id, question_id, answer_text, ai_feedback, score, ai_feedback_json) " +
                     "VALUES (?,?,?,?,?,?) ON DUPLICATE KEY UPDATE ai_feedback=VALUES(ai_feedback), score=VALUES(score), ai_feedback_json=VALUES(ai_feedback_json)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, interviewId);
            ps.setInt(2, questionId);
            ps.setString(3, answer);
            // Legacy text field — extract detail
            String legacyText = extractDetailedFeedback(feedbackJson);
            ps.setString(4, legacyText);
            ps.setDouble(5, score);
            ps.setString(6, feedbackJson);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private String extractDetailedFeedback(String json) {
        if (json == null) return "";
        try {
            int idx = json.indexOf("\"detailed_feedback\"");
            if (idx == -1) return json.length() > 500 ? json.substring(0, 500) : json;
            int colon = json.indexOf(":", idx);
            int start = json.indexOf("\"", colon + 1) + 1;
            int end = json.indexOf("\"", start);
            while (end > 0 && json.charAt(end - 1) == '\\') end = json.indexOf("\"", end + 1);
            return json.substring(start, end).replace("\\n", "\n").replace("\\\"", "\"");
        } catch (Exception e) {
            return "";
        }
    }

    private String jsonString(String s) {
        if (s == null) return "null";
        return "\"" + s.replace("\\", "\\\\").replace("\"", "\\\"")
                       .replace("\n", "\\n").replace("\r", "\\r") + "\"";
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n");
    }
}
