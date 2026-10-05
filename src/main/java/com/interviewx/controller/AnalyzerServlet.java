package com.interviewx.controller;

import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.interviewx.service.CodeAnalyzerAIService;
import com.interviewx.util.DBConnection;
import com.interviewx.config.GeminiConfig;

@WebServlet(urlPatterns = {"/analyzer", "/analyzer/analyze", "/code-analyzer"})
public class AnalyzerServlet extends HttpServlet {
    private static final long serialVersionUID = 2L;
    private CodeAnalyzerAIService codeAnalyzerService;

    @Override
    public void init() {
        codeAnalyzerService = new CodeAnalyzerAIService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        int userId = (int) session.getAttribute("userId");
        req.setAttribute("isConfigured", GeminiConfig.isCodeAnalyzerConfigured());
        req.setAttribute("recentHistory", getRecentHistory(userId));
        req.getRequestDispatcher("/analyzer/analyzer.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        int userId = (int) session.getAttribute("userId");

        String language = req.getParameter("language");
        String code = req.getParameter("code");

        if (language == null || language.isBlank()) language = "Java";
        if (code == null) code = "";

        // Size check — server-side validation
        if (code.length() > GeminiConfig.MAX_CODE_LENGTH * 2) {
            req.setAttribute("error", "Code submission too large. Maximum " + (GeminiConfig.MAX_CODE_LENGTH / 1000) + "K characters allowed.");
            req.setAttribute("language", language);
            req.setAttribute("code", code.substring(0, 500) + "...");
            req.setAttribute("isConfigured", GeminiConfig.isCodeAnalyzerConfigured());
            req.getRequestDispatcher("/analyzer/analyzer.jsp").forward(req, resp);
            return;
        }

        // Analyze with AI — uses CODE_ANALYZER_GEMINI_API_KEY exclusively
        String analysisJson = codeAnalyzerService.analyzeCode(language, code);

        // Save to history (with JSON column for new UI, legacy column for old references)
        saveHistory(userId, language, code, analysisJson);

        req.setAttribute("language", language);
        req.setAttribute("code", code);
        req.setAttribute("analysisJson", analysisJson);
        req.setAttribute("isConfigured", GeminiConfig.isCodeAnalyzerConfigured());
        req.setAttribute("recentHistory", getRecentHistory(userId));
        req.getRequestDispatcher("/analyzer/analyzer.jsp").forward(req, resp);
    }

    private void saveHistory(int userId, String language, String code, String analysisJson) {
        String sql = "INSERT INTO code_analysis_history (user_id, language, code_snippet, ai_response_json, ai_response) VALUES (?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, language);
            ps.setString(3, code.length() > 3000 ? code.substring(0, 3000) : code);
            ps.setString(4, analysisJson);
            // Legacy text column — extract overall explanation
            String legacy = extractOverall(analysisJson);
            ps.setString(5, legacy);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private java.util.List<java.util.Map<String, Object>> getRecentHistory(int userId) {
        java.util.List<java.util.Map<String, Object>> list = new java.util.ArrayList<>();
        String sql = "SELECT analysis_id, language, analyzed_at, LEFT(code_snippet, 100) as preview " +
                     "FROM code_analysis_history WHERE user_id=? ORDER BY analyzed_at DESC LIMIT 5";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.util.Map<String, Object> m = new java.util.LinkedHashMap<>();
                    m.put("id", rs.getInt("analysis_id"));
                    m.put("language", rs.getString("language"));
                    m.put("analyzedAt", rs.getTimestamp("analyzed_at"));
                    m.put("preview", rs.getString("preview"));
                    list.add(m);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private String extractOverall(String json) {
        if (json == null) return "";
        try {
            int idx = json.indexOf("\"overall_explanation\"");
            if (idx == -1) return "";
            int colon = json.indexOf(":", idx);
            int start = json.indexOf("\"", colon + 1) + 1;
            int end = json.indexOf("\"", start);
            while (end > 0 && json.charAt(end - 1) == '\\') end = json.indexOf("\"", end + 1);
            return json.substring(start, Math.min(end, start + 500));
        } catch (Exception e) { return ""; }
    }
}
