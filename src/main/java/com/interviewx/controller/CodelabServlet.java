package com.interviewx.controller;

import java.io.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.interviewx.dao.CodingProblemDAO;
import com.interviewx.dao.CodingProblemDAO.DashboardStats;
import com.interviewx.dao.CodingProblemDAO.TopicProgress;
import com.interviewx.dao.ProfileDAO;
import com.interviewx.dao.ReadinessDAO;
import com.interviewx.model.CodingProblem;
import com.interviewx.model.CodingSubmission;
import com.interviewx.service.CodeExecutionService;
import com.interviewx.service.CodeExecutionService.ExecutionResult;
import com.interviewx.service.CodeExecutionService.TestCaseResult;

@WebServlet(urlPatterns = {"/codelab", "/codelab/problem", "/codelab/run", "/codelab/submit", "/codelab/submissions"})
public class CodelabServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CodingProblemDAO problemDAO;
    private ProfileDAO profileDAO;
    private ReadinessDAO readinessDAO;
    private CodeExecutionService executionService;

    @Override
    public void init() {
        problemDAO = new CodingProblemDAO();
        profileDAO = new ProfileDAO();
        readinessDAO = new ReadinessDAO();
        executionService = new CodeExecutionService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();

        HttpSession session = req.getSession(false);
        int userId = 0;
        int profileId = 0;
        if (session != null && session.getAttribute("userId") != null) {
            userId = (int) session.getAttribute("userId");
            Integer pObj = (Integer) session.getAttribute("activeProfileId");
            profileId = (pObj != null) ? pObj : 0;
        }

        if ("/codelab/problem".equals(path)) {
            String idStr = req.getParameter("id");
            CodingProblem problem = null;
            if (idStr != null) {
                try {
                    problem = problemDAO.getProblemById(Integer.parseInt(idStr), userId, profileId);
                } catch (NumberFormatException e) {}
            }
            if (problem == null) {
                resp.sendRedirect(req.getContextPath() + "/codelab");
                return;
            }

            List<CodingSubmission> submissions = problemDAO.getSubmissionsForProblem(userId, profileId, problem.getProblemId());
            req.setAttribute("problem", problem);
            req.setAttribute("submissions", submissions);
            req.getRequestDispatcher("/codelab/problem.jsp").forward(req, resp);

        } else if ("/codelab/submissions".equals(path)) {
            resp.setContentType("application/json;charset=UTF-8");
            String pIdStr = req.getParameter("problemId");
            int pId = 0;
            if (pIdStr != null) {
                try { pId = Integer.parseInt(pIdStr); } catch (NumberFormatException ignored) {}
            }
            List<CodingSubmission> list = problemDAO.getSubmissionsForProblem(userId, profileId, pId);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                CodingSubmission s = list.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                    .append("\"submissionId\":").append(s.getSubmissionId()).append(",")
                    .append("\"language\":").append(jsonEscape(s.getLanguage())).append(",")
                    .append("\"verdict\":").append(jsonEscape(s.getVerdict())).append(",")
                    .append("\"runtimeMs\":").append(s.getRuntimeMs()).append(",")
                    .append("\"memoryKb\":").append(s.getMemoryKb()).append(",")
                    .append("\"passedTests\":").append(s.getPassedTestCases()).append(",")
                    .append("\"totalTests\":").append(s.getTotalTestCases()).append(",")
                    .append("\"submittedAt\":").append(jsonEscape(String.valueOf(s.getSubmittedAt()))).append(",")
                    .append("\"code\":").append(jsonEscape(s.getCode()))
                    .append("}");
            }
            json.append("]");
            resp.getWriter().write(json.toString());

        } else {
            // Main CodeLab Problem Catalog & Dashboard
            String difficulty = req.getParameter("difficulty");
            String topic = req.getParameter("topic");
            String status = req.getParameter("status");
            String search = req.getParameter("search");
            String sortBy = req.getParameter("sortBy");
            if (sortBy == null || sortBy.trim().isEmpty()) sortBy = "order";

            List<CodingProblem> problems = problemDAO.getAllProblems(userId, profileId, difficulty, topic, status, search, sortBy);
            DashboardStats stats = problemDAO.getCodelabDashboardStats(userId, profileId);
            List<TopicProgress> topicProgress = problemDAO.getTopicProgressList(userId, profileId);
            List<String> topics = problemDAO.getDistinctTopics();

            req.setAttribute("problems", problems);
            req.setAttribute("stats", stats);
            req.setAttribute("topicProgress", topicProgress);
            req.setAttribute("topics", topics);
            req.setAttribute("selectedDifficulty", difficulty);
            req.setAttribute("selectedTopic", topic);
            req.setAttribute("selectedStatus", status);
            req.setAttribute("searchQuery", search);
            req.setAttribute("sortBy", sortBy);

            req.getRequestDispatcher("/codelab/codelab.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        resp.setContentType("application/json;charset=UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.getWriter().write("{\"success\":false,\"verdict\":\"Not logged in\",\"message\":\"Session expired. Please log in.\"}");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        Integer profileIdObj = (Integer) session.getAttribute("activeProfileId");
        int profileId = (profileIdObj != null) ? profileIdObj : 0;

        try {
            int problemId = Integer.parseInt(req.getParameter("problemId"));
            String language = req.getParameter("language");
            String code = req.getParameter("code");
            String customInput = req.getParameter("customInput");

            CodingProblem problem = problemDAO.getProblemById(problemId, userId, profileId);
            if (problem == null) {
                resp.getWriter().write("{\"success\":false,\"verdict\":\"Error\",\"message\":\"Problem not found.\"}");
                return;
            }

            if ("/codelab/run".equals(path)) {
                // RUN CODE ONLY: test against sample/custom cases without changing problem status to SOLVED
                ExecutionResult result = executionService.executeCode(problem, language, code, customInput, false);
                resp.getWriter().write(buildExecutionJsonResponse(result, false, false));

            } else if ("/codelab/submit".equals(path)) {
                // OFFICIAL SUBMISSION: run full test cases, record submission, update progress, update readiness
                ExecutionResult result = executionService.executeCode(problem, language, code, null, true);

                CodingSubmission sub = new CodingSubmission();
                sub.setUserId(userId);
                sub.setProfileId(profileId);
                sub.setProblemId(problemId);
                sub.setLanguage(language != null ? language : "java");
                sub.setCode(code != null ? code : "");
                sub.setVerdict(result.getVerdict());
                sub.setRuntimeMs(result.getRuntimeMs());
                sub.setMemoryKb(result.getMemoryKb());
                sub.setPassedTestCases(result.getPassedTestCases());
                sub.setTotalTestCases(result.getTotalTestCases());
                sub.setErrorDetails(result.getErrorDetails());

                boolean saved = problemDAO.recordSubmission(sub);

                boolean isAccepted = "Accepted".equalsIgnoreCase(result.getVerdict());
                if (saved && isAccepted) {
                    int trackId = (session.getAttribute("activeProfileTrackId") != null) ?
                        (int) session.getAttribute("activeProfileTrackId") : 2;
                    readinessDAO.computeAndSave(userId, profileId, trackId);
                }

                resp.getWriter().write(buildExecutionJsonResponse(result, true, saved));
            }
        } catch (Exception e) {
            resp.getWriter().write("{\"success\":false,\"verdict\":\"Error\",\"message\":" + jsonEscape(e.getMessage()) + "}");
        }
    }

    private String buildExecutionJsonResponse(ExecutionResult res, boolean isSubmit, boolean isSaved) {
        StringBuilder sb = new StringBuilder("{");
        sb.append("\"success\":true,");
        sb.append("\"isSubmit\":").append(isSubmit).append(",");
        sb.append("\"isSaved\":").append(isSaved).append(",");
        sb.append("\"verdict\":").append(jsonEscape(res.getVerdict())).append(",");
        sb.append("\"runtimeMs\":").append(res.getRuntimeMs()).append(",");
        sb.append("\"memoryKb\":").append(res.getMemoryKb()).append(",");
        sb.append("\"passedTests\":").append(res.getPassedTestCases()).append(",");
        sb.append("\"totalTests\":").append(res.getTotalTestCases()).append(",");
        sb.append("\"message\":").append(jsonEscape(res.getMessage())).append(",");
        sb.append("\"errorDetails\":").append(jsonEscape(res.getErrorDetails())).append(",");

        sb.append("\"testCases\":[");
        List<TestCaseResult> tcs = res.getTestCaseResults();
        for (int i = 0; i < tcs.size(); i++) {
            TestCaseResult tc = tcs.get(i);
            if (i > 0) sb.append(",");
            sb.append("{")
                .append("\"caseNumber\":").append(tc.getCaseNumber()).append(",")
                .append("\"input\":").append(jsonEscape(tc.getInput())).append(",")
                .append("\"expected\":").append(jsonEscape(tc.getExpectedOutput())).append(",")
                .append("\"actual\":").append(jsonEscape(tc.getActualOutput())).append(",")
                .append("\"passed\":").append(tc.isPassed())
                .append("}");
        }
        sb.append("]}");
        return sb.toString();
    }

    private String jsonEscape(String s) {
        if (s == null) return "\"\"";
        return "\"" + s.replace("\\", "\\\\")
                       .replace("\"", "\\\"")
                       .replace("\b", "\\b")
                       .replace("\f", "\\f")
                       .replace("\n", "\\n")
                       .replace("\r", "\\r")
                       .replace("\t", "\\t") + "\"";
    }
}
