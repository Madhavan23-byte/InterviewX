package com.interviewx.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.interviewx.config.GeminiConfig;

/**
 * AdminAIConfigServlet - Dedicated administrative controller for configuring
 * the three independent Google Gemini API keys.
 *
 * Security:
 * - Restricted to users with role = "ADMIN".
 * - Normal students cannot view, save, test, or retrieve API keys.
 * - API keys are NEVER returned in plaintext responses.
 * - Saves keys directly to server-side external storage.
 */
@WebServlet(urlPatterns = {"/admin/ai-config", "/admin/ai-config/save", "/admin/ai-config/test"})
public class AdminAIConfigServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            req.setAttribute("errorMessage", "Access Denied: Administrator privileges required to view AI Configuration.");
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
            return;
        }

        // Set configuration attributes for JSP rendering
        req.setAttribute("interviewConfigured", GeminiConfig.isInterviewAIConfigured());
        req.setAttribute("interviewMaskedKey", GeminiConfig.getMaskedInterviewKey());

        req.setAttribute("codeAnalyzerConfigured", GeminiConfig.isCodeAnalyzerConfigured());
        req.setAttribute("codeAnalyzerMaskedKey", GeminiConfig.getMaskedCodeAnalyzerKey());

        req.setAttribute("resumeAnalyzerConfigured", GeminiConfig.isResumeAnalyzerConfigured());
        req.setAttribute("resumeAnalyzerMaskedKey", GeminiConfig.getMaskedResumeAnalyzerKey());

        req.setAttribute("configFilePath", GeminiConfig.getConfigFile().getAbsolutePath());
        req.setAttribute("configDirectory", GeminiConfig.getConfigDirectory().getAbsolutePath());
        req.setAttribute("geminiModel", GeminiConfig.DEFAULT_GEMINI_MODEL);

        req.getRequestDispatcher("/admin/ai-config.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"success\":false,\"message\":\"Session expired. Please log in again.\"}");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.getWriter().write("{\"success\":false,\"message\":\"Access Denied: Administrator privileges required.\"}");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            String path = req.getServletPath();
            if (path.endsWith("/save")) action = "save";
            else if (path.endsWith("/test")) action = "test";
            else action = "";
        }

        String type = req.getParameter("type");
        if (type == null || type.isBlank()) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Missing AI module type parameter.\"}");
            return;
        }

        if ("save".equalsIgnoreCase(action)) {
            handleSaveKey(req, resp, type);
        } else if ("test".equalsIgnoreCase(action)) {
            handleTestConnection(resp, type);
        } else {
            resp.getWriter().write("{\"success\":false,\"message\":\"Unknown action: " + escapeJson(action) + "\"}");
        }
    }

    private void handleSaveKey(HttpServletRequest req, HttpServletResponse resp, String type)
            throws IOException {
        String key = req.getParameter("key");
        if (key == null || key.trim().isEmpty()) {
            resp.getWriter().write("{\"success\":false,\"message\":\"API key cannot be empty.\"}");
            return;
        }

        String cleanedKey = key.trim();
        if (cleanedKey.length() < 10) {
            resp.getWriter().write("{\"success\":false,\"message\":\"API key is suspiciously short. Please paste a valid Gemini API key.\"}");
            return;
        }

        boolean saved = GeminiConfig.saveKey(type, cleanedKey);
        if (saved) {
            String masked = GeminiConfig.getMaskedKey(cleanedKey);
            String title = getModuleTitle(type);
            resp.getWriter().write("{\"success\":true,\"maskedKey\":\"" + escapeJson(masked) +
                    "\",\"message\":\"" + escapeJson(title) + " API key saved and activated successfully!\"}");
        } else {
            resp.getWriter().write("{\"success\":false,\"message\":\"Failed to save key. Please check file permissions.\"}");
        }
    }

    private void handleTestConnection(HttpServletResponse resp, String type)
            throws IOException {
        GeminiConfig.TestResult result = GeminiConfig.testConnection(type);
        resp.getWriter().write("{\"success\":" + result.success +
                ",\"message\":\"" + escapeJson(result.message) + "\"}");
    }

    private String getModuleTitle(String type) {
        String upper = type.toUpperCase();
        if (upper.contains("INTERVIEW")) return "Interview AI";
        if (upper.contains("CODE")) return "Code Analyzer AI";
        if (upper.contains("RESUME")) return "Resume Analyzer AI";
        return "AI Module";
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
