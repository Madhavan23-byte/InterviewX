package com.interviewx.controller;

import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.interviewx.dao.CareerDAO;
import com.interviewx.model.CareerTrack;

@WebServlet(urlPatterns = {"/assessment", "/assessment/start"})
public class AssessmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CareerDAO careerDAO;

    @Override
    public void init() { careerDAO = new CareerDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/assessment/assessment.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
        int userId = (int) session.getAttribute("userId");

        Map<String, Integer> scores = new HashMap<>();
        scores.put("frontend",    parseScore(req, "frontend"));
        scores.put("backend",     parseScore(req, "backend"));
        scores.put("fullstack",   parseScore(req, "fullstack"));
        scores.put("data",        parseScore(req, "data"));
        scores.put("ai",          parseScore(req, "ai"));
        scores.put("cloud",       parseScore(req, "cloud"));
        scores.put("devops",      parseScore(req, "devops"));
        scores.put("mobile",      parseScore(req, "mobile"));
        scores.put("security",    parseScore(req, "security"));
        scores.put("blockchain",  parseScore(req, "blockchain"));
        scores.put("qa",          parseScore(req, "qa"));
        scores.put("problemSolving", parseScore(req, "problemSolving"));

        // Recommendation logic: find highest scoring interest
        int recommendedTrackId = calculateRecommendedTrack(scores);

        careerDAO.saveAssessment(userId, scores, recommendedTrackId);

        // Build recommendation list for display
        List<Map<String,Object>> recommendations = buildRecommendations(scores);
        List<CareerTrack> allTracks = careerDAO.getAllTracks();

        req.setAttribute("recommendations", recommendations);
        req.setAttribute("allTracks", allTracks);
        req.setAttribute("recommendedTrackId", recommendedTrackId);
        req.getRequestDispatcher("/career/recommendation.jsp").forward(req, resp);
    }

    private int parseScore(HttpServletRequest req, String param) {
        try { return Math.min(10, Math.max(0, Integer.parseInt(req.getParameter(param)))); }
        catch (Exception e) { return 0; }
    }

    private int calculateRecommendedTrack(Map<String,Integer> scores) {
        Map<String, Integer> trackMapping = new LinkedHashMap<>();
        trackMapping.put("frontend",   1);  // Frontend Developer
        trackMapping.put("backend",    2);  // Backend Developer
        trackMapping.put("fullstack",  3);  // Full Stack
        trackMapping.put("qa",         5);  // QA
        trackMapping.put("data",       6);  // Data Analyst
        trackMapping.put("ai",         8);  // AI Engineer
        trackMapping.put("cloud",      10); // Cloud Engineer
        trackMapping.put("devops",     11); // DevOps
        trackMapping.put("security",   12); // Cybersecurity
        trackMapping.put("mobile",     13); // Mobile
        trackMapping.put("blockchain", 15); // Blockchain

        String bestKey = scores.entrySet().stream()
            .filter(e -> trackMapping.containsKey(e.getKey()))
            .max(Map.Entry.comparingByValue())
            .map(Map.Entry::getKey)
            .orElse("backend");

        return trackMapping.getOrDefault(bestKey, 2);
    }

    private List<Map<String,Object>> buildRecommendations(Map<String,Integer> scores) {
        List<Map<String,Object>> recs = new ArrayList<>();
        Map<String, String[]> labels = new LinkedHashMap<>();
        labels.put("backend",    new String[]{"Backend Developer", "2"});
        labels.put("frontend",   new String[]{"Frontend Developer", "1"});
        labels.put("fullstack",  new String[]{"Full Stack Developer", "3"});
        labels.put("ai",         new String[]{"AI Engineer", "8"});
        labels.put("data",       new String[]{"Data Analyst", "6"});
        labels.put("cloud",      new String[]{"Cloud Engineer", "10"});
        labels.put("devops",     new String[]{"DevOps Engineer", "11"});
        labels.put("mobile",     new String[]{"Mobile Developer", "13"});
        labels.put("qa",         new String[]{"QA/Test Engineer", "5"});
        labels.put("security",   new String[]{"Cybersecurity Engineer", "12"});
        labels.put("blockchain", new String[]{"Blockchain Developer", "15"});

        for (Map.Entry<String,String[]> e : labels.entrySet()) {
            int rawScore = scores.getOrDefault(e.getKey(), 0) + scores.getOrDefault("problemSolving", 0) / 2;
            int percent = Math.min(100, rawScore * 10);
            if (percent > 0) {
                Map<String,Object> m = new LinkedHashMap<>();
                m.put("trackName", e.getValue()[0]);
                m.put("trackId", Integer.parseInt(e.getValue()[1]));
                m.put("percentage", percent);
                recs.add(m);
            }
        }

        recs.sort((a, b) -> (int)b.get("percentage") - (int)a.get("percentage"));
        return recs.subList(0, Math.min(5, recs.size()));
    }
}
