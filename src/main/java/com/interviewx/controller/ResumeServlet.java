package com.interviewx.controller;

import java.io.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.interviewx.dao.*;
import com.interviewx.model.*;
import com.interviewx.service.ResumeService;
import com.interviewx.service.ResumeAnalyzerAIService;
import com.interviewx.config.GeminiConfig;

@WebServlet(urlPatterns = {"/resume", "/resume/upload", "/resume/analyze", "/resume/recommendations", "/resume/select-role"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 25     // 25 MB
)
public class ResumeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ResumeService resumeService;
    private ResumeDAO resumeDAO;
    private StudentDAO studentDAO;
    private ProfileDAO profileDAO;
    private NotificationDAO notificationDAO;
    private CareerDAO careerDAO;
    private ResumeAnalyzerAIService resumeAnalyzerAIService;

    @Override
    public void init() {
        resumeService = new ResumeService();
        resumeDAO = new ResumeDAO();
        studentDAO = new StudentDAO();
        profileDAO = new ProfileDAO();
        notificationDAO = new NotificationDAO();
        careerDAO = new CareerDAO();
        resumeAnalyzerAIService = new ResumeAnalyzerAIService();
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
        String path = req.getServletPath();

        if ("/resume/recommendations".equals(path)) {
            List<RoleRecommendation> recs = resumeDAO.getRecommendations(userId);
            StudentResume latestResume = resumeDAO.getLatestResume(userId);

            req.setAttribute("recommendations", recs);
            req.setAttribute("resume", latestResume);
            req.getRequestDispatcher("/resume/discovery.jsp").forward(req, resp);
        } else {
            // Show resume upload / text paste page
            StudentResume latestResume = resumeDAO.getLatestResume(userId);
            Student student = studentDAO.getStudentByUserId(userId);
            List<PreparationProfile> existingProfiles = profileDAO.getProfilesByUserId(userId);

            req.setAttribute("latestResume", latestResume);
            req.setAttribute("student", student);
            req.setAttribute("existingProfiles", existingProfiles);
            req.getRequestDispatcher("/resume/upload.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        int userId = (int) session.getAttribute("userId");
        String path = req.getServletPath();

        if ("/resume/select-role".equals(path)) {
            handleSelectRole(req, resp, session, userId);
        } else {
            // /resume/upload
            handleResumeUpload(req, resp, userId);
        }
    }

    private void handleResumeUpload(HttpServletRequest req, HttpServletResponse resp, int userId)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String rawText = req.getParameter("resumeText");
        String fileName = "resume_input.txt";
        String fileType = "text/plain";

        // Check if a file was uploaded
        try {
            Part filePart = req.getPart("resumeFile");
            if (filePart != null && filePart.getSize() > 0) {
                String submittedName = filePart.getSubmittedFileName();
                if (submittedName != null && !submittedName.isEmpty()) {
                    fileName = submittedName;
                    fileType = filePart.getContentType();
                }

                // Read file content
                try (InputStream is = filePart.getInputStream()) {
                    byte[] bytes = is.readAllBytes();
                    String fileText = extractTextFromBytes(bytes, fileName);
                    if (fileText != null && fileText.trim().length() > 20) {
                        if (rawText != null && !rawText.trim().isEmpty()) {
                            rawText = rawText + "\n\n" + fileText;
                        } else {
                            rawText = fileText;
                        }
                    }
                }
            }
        } catch (Exception e) {
            // In case of non-multipart fallback
        }

        if (rawText == null || rawText.trim().length() < 10) {
            req.setAttribute("error", "Please provide your resume content (either paste your resume text or upload a file).");
            doGet(req, resp);
            return;
        }

        Student student = studentDAO.getStudentByUserId(userId);

        // 1. Parse and extract intelligence from resume
        StudentResume resume = resumeService.analyzeResumeText(userId, fileName, fileType, rawText, student);

        // 2. Save resume to database
        int resumeId = resumeDAO.saveResume(resume);
        resume.setResumeId(resumeId);

        // 3. Generate role compatibility recommendations
        List<RoleRecommendation> recommendations = resumeService.generateRoleRecommendations(userId, resume, student);

        // 4. Save recommendations to database
        resumeDAO.saveRecommendations(resumeId, userId, recommendations);

        // Deep AI Resume Analysis using RESUME_ANALYZER_GEMINI_API_KEY
        if (GeminiConfig.isResumeAnalyzerConfigured()) {
            try {
                HttpSession ssn = req.getSession(false); String sName = (ssn != null) ? (String) ssn.getAttribute("fullName") : null; if (sName == null || sName.isBlank()) sName = "Candidate";
                String aiJson = resumeAnalyzerAIService.analyzeResume(rawText, sName);
                if (aiJson != null && !aiJson.isBlank()) {
                    String topRole = resumeAnalyzerAIService.extractField(aiJson, "top_recommendation");
                    String overall = resumeAnalyzerAIService.extractField(aiJson, "overall_summary");
                    resumeDAO.saveAiAnalysis(userId, resumeId, aiJson, topRole, overall);
                }
            } catch (Exception e) {
                System.err.println("[ResumeServlet] AI analysis error: " + e.getMessage());
            }
        }

        // 5. Send notification
        notificationDAO.addNotification(userId,
            "Resume Analyzed Successfully",
            "Role Discovery completed! Found " + recommendations.size() + " career roles matching your skills and experience.",
            "success");

        resp.sendRedirect(req.getContextPath() + "/resume/recommendations");
    }

    private void handleSelectRole(HttpServletRequest req, HttpServletResponse resp, HttpSession session, int userId)
            throws IOException {
        String roleName = req.getParameter("roleName");
        String trackIdStr = req.getParameter("trackId");

        if (roleName == null || roleName.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/resume/recommendations");
            return;
        }

        int trackId = 2;
        try { if (trackIdStr != null) trackId = Integer.parseInt(trackIdStr); }
        catch (NumberFormatException e) {}

        Student student = studentDAO.getStudentByUserId(userId);
        int studentId = (student != null) ? student.getStudentId() : userId;

        // Check if student ALREADY has a preparation profile for this role
        PreparationProfile existing = profileDAO.getProfileByUserAndRole(userId, roleName);
        int targetProfileId;

        if (existing != null) {
            // Re-activate existing profile
            targetProfileId = existing.getProfileId();
            profileDAO.updateLastActive(targetProfileId);
            session.setAttribute("activeProfileId", targetProfileId);
            session.setAttribute("activeProfileRole", existing.getTargetRole());
            session.setAttribute("activeProfileTrackId", existing.getTrackId());
            session.setAttribute("activeProfile", existing);

            notificationDAO.addNotification(userId,
                "Switched to " + roleName,
                "Welcome back! Continued preparation on your existing " + roleName + " profile.",
                "info");

            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp?switched=true&role=" + URLEncoder.encode(roleName, StandardCharsets.UTF_8));
        } else {
            // Create brand new preparation profile
            targetProfileId = profileDAO.createProfile(userId, studentId, trackId, roleName, roleName + " Profile");
            PreparationProfile newProfile = profileDAO.getProfileById(targetProfileId);

            session.setAttribute("activeProfileId", targetProfileId);
            session.setAttribute("activeProfileRole", roleName);
            session.setAttribute("activeProfileTrackId", trackId);
            session.setAttribute("activeProfile", newProfile);

            notificationDAO.addNotification(userId,
                "New Preparation Profile Created: " + roleName,
                "Your personalized roadmap and daily preparation tasks for " + roleName + " are ready!",
                "success");

            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp?created=true&role=" + URLEncoder.encode(roleName, StandardCharsets.UTF_8));
        }
    }

    private String extractTextFromBytes(byte[] bytes, String fileName) {
        if (bytes == null || bytes.length == 0) return "";
        String lower = fileName.toLowerCase();

        // Plain text / Markdown
        if (lower.endsWith(".txt") || lower.endsWith(".md") || lower.endsWith(".json")) {
            return new String(bytes, StandardCharsets.UTF_8);
        }

        // Extract printable ASCII/UTF-8 strings from binary formats (PDF, DOCX)
        StringBuilder sb = new StringBuilder();
        int printableCount = 0;
        for (int i = 0; i < bytes.length; i++) {
            byte b = bytes[i];
            if ((b >= 32 && b <= 126) || b == '\n' || b == '\r' || b == '\t') {
                sb.append((char) b);
                printableCount++;
            } else if (printableCount > 0 && sb.length() > 0 && sb.charAt(sb.length() - 1) != ' ') {
                sb.append(' ');
                printableCount = 0;
            }
        }
        return sb.toString();
    }
}