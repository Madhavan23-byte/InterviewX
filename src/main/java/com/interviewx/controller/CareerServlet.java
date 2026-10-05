package com.interviewx.controller;

import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.interviewx.dao.*;
import com.interviewx.model.CareerTrack;
import com.interviewx.model.PreparationProfile;

@WebServlet(urlPatterns = {"/career/choose", "/career/roadmap"})
public class CareerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CareerDAO careerDAO;
    private TaskDAO taskDAO;
    private NotificationDAO notificationDAO;
    private ProfileDAO profileDAO;

    @Override
    public void init() {
        careerDAO = new CareerDAO();
        taskDAO = new TaskDAO();
        notificationDAO = new NotificationDAO();
        profileDAO = new ProfileDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/career/roadmap".equals(path)) {
            showRoadmap(req, resp);
        } else {
            List<CareerTrack> tracks = careerDAO.getAllTracks();
            req.setAttribute("tracks", tracks);
            req.getRequestDispatcher("/career/choose.jsp").forward(req, resp);
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

        int trackId;
        try { trackId = Integer.parseInt(req.getParameter("trackId")); }
        catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/career/choose");
            return;
        }

        CareerTrack track = careerDAO.getTrackById(trackId);
        String trackName = track != null ? track.getTrackName() : "Software Developer";

        // Check if student already has a profile for this role
        PreparationProfile existing = profileDAO.getProfileByUserAndRole(userId, trackName);
        int profileId;
        if (existing != null) {
            profileId = existing.getProfileId();
            profileDAO.updateLastActive(profileId);
        } else {
            profileId = profileDAO.createProfile(userId, userId, trackId, trackName, trackName + " Profile");
        }

        session.setAttribute("activeProfileId", profileId);
        session.setAttribute("activeProfileRole", trackName);
        session.setAttribute("activeProfileTrackId", trackId);
        session.setAttribute("activeProfile", profileDAO.getProfileById(profileId));

        notificationDAO.addNotification(userId,
            "Career Track Selected: " + trackName,
            "Your dedicated roadmap and daily tasks are ready for " + trackName + ".",
            "success");

        resp.sendRedirect(req.getContextPath() + "/career/roadmap");
    }

    private void showRoadmap(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        int userId = (int) session.getAttribute("userId");

        // Use active preparation profile
        Integer profileIdObj = (Integer) session.getAttribute("activeProfileId");
        PreparationProfile activeProfile = null;
        if (profileIdObj != null && profileIdObj > 0) {
            activeProfile = profileDAO.getProfileById(profileIdObj);
        }
        if (activeProfile == null) {
            activeProfile = profileDAO.getActiveProfile(userId);
            if (activeProfile != null) {
                session.setAttribute("activeProfileId", activeProfile.getProfileId());
                session.setAttribute("activeProfileRole", activeProfile.getTargetRole());
                session.setAttribute("activeProfileTrackId", activeProfile.getTrackId());
                session.setAttribute("activeProfile", activeProfile);
            }
        }

        int trackId = (activeProfile != null) ? activeProfile.getTrackId() : 2;
        int profileId = (activeProfile != null) ? activeProfile.getProfileId() : 0;

        CareerTrack track = careerDAO.getTrackById(trackId);
        List<Map<String,Object>> modules = careerDAO.getRoadmapModules(trackId);
        Set<Integer> completedModules = careerDAO.getCompletedModules(userId, profileId);

        req.setAttribute("track", track);
        req.setAttribute("modules", modules);
        req.setAttribute("completedModules", completedModules);
        req.setAttribute("trackId", trackId);
        req.setAttribute("profileId", profileId);
        req.setAttribute("activeProfile", activeProfile);
        req.getRequestDispatcher("/roadmap/roadmap.jsp").forward(req, resp);
    }
}