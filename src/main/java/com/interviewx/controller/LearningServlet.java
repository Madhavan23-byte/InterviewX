package com.interviewx.controller;

import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.interviewx.dao.LearningTrackDAO;
import com.interviewx.dao.ProfileDAO;
import com.interviewx.model.LearningTrack;
import com.interviewx.model.LearningModule;
import com.interviewx.model.PreparationProfile;
import com.interviewx.service.LearningTrackService;

@WebServlet(urlPatterns = {
    "/learning",
    "/learning/track",
    "/learning/tasks",
    "/learning/create",
    "/learning/status",
    "/learning/module/complete",
    "/learning/task/complete",
    "/learning/delete",
    "/learning/benchmark"
})
public class LearningServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final LearningTrackDAO trackDAO = new LearningTrackDAO();
    private final LearningTrackService trackService = new LearningTrackService();
    private final ProfileDAO profileDAO = new ProfileDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        PreparationProfile activeProfile = resolveActiveProfile(req, userId);
        int profileId = (activeProfile != null) ? activeProfile.getProfileId() : 0;

        String servletPath = req.getServletPath();
        if (servletPath == null) servletPath = "/learning";

        if ("/learning/track".equals(servletPath)) {
            handleTrackDetail(req, resp, profileId, userId, activeProfile);
        } else if ("/learning/tasks".equals(servletPath)) {
            handleCourseTasks(req, resp, profileId, userId, activeProfile);
        } else {
            handleLearningDashboard(req, resp, profileId, userId, activeProfile);
        }
    }

    private void handleLearningDashboard(HttpServletRequest req, HttpServletResponse resp, int profileId, int userId, PreparationProfile activeProfile)
            throws ServletException, IOException {
        List<LearningTrack> tracks = Collections.emptyList();
        Map<String, List<Map<String, Object>>> groupedTodayTasks = Collections.emptyMap();
        List<LearningTrackService.TrackRecommendation> recommendations = Collections.emptyList();

        if (profileId > 0) {
            tracks = trackDAO.getTracksByProfile(profileId, userId);
            groupedTodayTasks = trackDAO.getTodaysTasksGroupedByTrack(profileId, userId);
            String targetRole = (activeProfile != null) ? activeProfile.getTargetRole() : "Software Engineer";
            recommendations = trackService.getRecommendedTracks(targetRole);

            Set<String> addedNames = new HashSet<>();
            for (LearningTrack t : tracks) {
                addedNames.add(t.getTrackName().toLowerCase());
            }
            List<LearningTrackService.TrackRecommendation> unaddedRecs = new ArrayList<>();
            for (LearningTrackService.TrackRecommendation r : recommendations) {
                if (!addedNames.contains(r.getTrackName().toLowerCase())) {
                    unaddedRecs.add(r);
                }
            }
            req.setAttribute("recommendedTracks", unaddedRecs);
        } else {
            req.setAttribute("recommendedTracks", recommendations);
        }

        req.setAttribute("tracks", tracks);
        req.setAttribute("groupedTodayTasks", groupedTodayTasks);
        req.setAttribute("activeProfile", activeProfile);
        req.getRequestDispatcher("/learning/index.jsp").forward(req, resp);
    }

    private void handleTrackDetail(HttpServletRequest req, HttpServletResponse resp, int profileId, int userId, PreparationProfile activeProfile)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        int trackId = 0;
        try {
            trackId = Integer.parseInt(idStr);
        } catch (NumberFormatException ignored) {}

        if (trackId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/learning?error=Invalid+Course+ID");
            return;
        }

        if (!trackService.isAuthorized(trackId, profileId, userId)) {
            resp.sendRedirect(req.getContextPath() + "/learning?error=Access+denied.+This+course+belongs+to+another+profile+or+user.");
            return;
        }

        LearningTrack track = trackDAO.getTrackById(trackId, profileId, userId);
        if (track == null) {
            resp.sendRedirect(req.getContextPath() + "/learning?error=Course+not+found");
            return;
        }

        List<LearningModule> modules = trackDAO.getModulesByTrack(trackId);
        List<Map<String, Object>> tasks = trackDAO.getTasksByTrack(trackId, profileId);
        List<Map<String, Object>> todayTasks = trackDAO.getTodaysTasksByTrack(trackId, profileId);
        List<Map<String, Object>> completedActivities = trackDAO.getCompletedActivities(trackId);
        Map<String, Object> analytics = trackDAO.getTrackAnalytics(trackId);

        req.setAttribute("track", track);
        req.setAttribute("modules", modules);
        req.setAttribute("tasks", tasks);
        req.setAttribute("todayTasks", todayTasks);
        req.setAttribute("completedActivities", completedActivities);
        req.setAttribute("analytics", analytics);
        req.setAttribute("activeProfile", activeProfile);

        req.getRequestDispatcher("/learning/detail.jsp").forward(req, resp);
    }

    private void handleCourseTasks(HttpServletRequest req, HttpServletResponse resp, int profileId, int userId, PreparationProfile activeProfile)
            throws ServletException, IOException {
        String trackIdStr = req.getParameter("id");
        if (trackIdStr != null && !trackIdStr.isEmpty()) {
            int trackId = Integer.parseInt(trackIdStr);
            if (!trackService.isAuthorized(trackId, profileId, userId)) {
                resp.sendRedirect(req.getContextPath() + "/learning?error=Access+denied");
                return;
            }
            LearningTrack track = trackDAO.getTrackById(trackId, profileId, userId);
            List<Map<String, Object>> tasks = trackDAO.getTasksByTrack(trackId, profileId);
            req.setAttribute("selectedTrack", track);
            req.setAttribute("tasks", tasks);
        } else {
            Map<String, List<Map<String, Object>>> grouped = trackDAO.getTodaysTasksGroupedByTrack(profileId, userId);
            req.setAttribute("groupedTasks", grouped);
        }

        req.setAttribute("activeProfile", activeProfile);
        req.getRequestDispatcher("/learning/tasks.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        PreparationProfile activeProfile = resolveActiveProfile(req, userId);
        int profileId = (activeProfile != null) ? activeProfile.getProfileId() : 0;

        String servletPath = req.getServletPath();
        if (servletPath == null) servletPath = "";

        if ("/learning/create".equals(servletPath)) {
            String trackName = req.getParameter("trackName");
            String description = req.getParameter("description");
            String category = req.getParameter("category");
            String icon = req.getParameter("icon");

            if (trackName != null && !trackName.trim().isEmpty() && profileId > 0) {
                int newTrackId = trackService.createTrackWithCurriculum(profileId, userId, trackName.trim(), description, category, icon);
                if (newTrackId > 0) {
                    resp.sendRedirect(req.getContextPath() + "/learning/track?id=" + newTrackId + "&msg=Course+successfully+added!");
                    return;
                } else {
                    resp.sendRedirect(req.getContextPath() + "/learning?error=This+course+is+already+active+in+your+profile");
                    return;
                }
            }
            resp.sendRedirect(req.getContextPath() + "/learning");

        } else if ("/learning/status".equals(servletPath)) {
            int trackId = Integer.parseInt(req.getParameter("trackId"));
            String status = req.getParameter("status");
            trackService.updateStatus(trackId, status, profileId, userId);
            resp.sendRedirect(req.getContextPath() + "/learning/track?id=" + trackId + "&msg=Status+updated+to+" + status);

        } else if ("/learning/module/complete".equals(servletPath)) {
            int moduleId = Integer.parseInt(req.getParameter("moduleId"));
            int trackId = Integer.parseInt(req.getParameter("trackId"));
            trackService.completeModule(moduleId, trackId, profileId, userId);

            String redirect = req.getParameter("redirect");
            if (redirect != null && !redirect.isEmpty()) {
                resp.sendRedirect(redirect);
            } else {
                resp.sendRedirect(req.getContextPath() + "/learning/track?id=" + trackId + "&msg=Module+marked+as+completed!");
            }

        } else if ("/learning/task/complete".equals(servletPath)) {
            int taskId = Integer.parseInt(req.getParameter("taskId"));
            int trackId = 0;
            try { trackId = Integer.parseInt(req.getParameter("trackId")); } catch (Exception ignored) {}
            int timeSpent = 30;
            try { timeSpent = Integer.parseInt(req.getParameter("timeSpent")); } catch (Exception ignored) {}

            trackService.completeTask(taskId, trackId, profileId, userId, timeSpent);

            String redirect = req.getParameter("redirect");
            if (redirect != null && !redirect.isEmpty()) {
                resp.sendRedirect(redirect);
            } else if (trackId > 0) {
                resp.sendRedirect(req.getContextPath() + "/learning/track?id=" + trackId + "&msg=Task+completed+successfully!");
            } else {
                resp.sendRedirect(req.getContextPath() + "/learning?msg=Task+completed+successfully!");
            }

        } else if ("/learning/delete".equals(servletPath)) {
            int trackId = Integer.parseInt(req.getParameter("trackId"));
            trackService.deleteTrack(trackId, profileId, userId);
            resp.sendRedirect(req.getContextPath() + "/learning?msg=Course+removed+from+your+profile");

        } else if ("/learning/benchmark".equals(servletPath)) {
            if (profileId > 0) {
                trackService.setupSection28Benchmark(profileId, userId);
                resp.sendRedirect(req.getContextPath() + "/learning?msg=Section+28+Test+Benchmark+Initialized+Successfully!");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/learning?error=No+active+profile");
        } else {
            resp.sendRedirect(req.getContextPath() + "/learning");
        }
    }

    private PreparationProfile resolveActiveProfile(HttpServletRequest req, int userId) {
        HttpSession session = req.getSession(false);
        if (session != null) {
            PreparationProfile active = (PreparationProfile) session.getAttribute("activeProfile");
            if (active != null && active.getUserId() == userId) {
                return active;
            }
            Integer pId = (Integer) session.getAttribute("activeProfileId");
            if (pId != null && pId > 0) {
                active = profileDAO.getProfileById(pId);
                if (active != null && active.getUserId() == userId) {
                    session.setAttribute("activeProfile", active);
                    return active;
                }
            }
        }
        PreparationProfile active = profileDAO.getActiveProfile(userId);
        if (active != null && session != null) {
            session.setAttribute("activeProfile", active);
            session.setAttribute("activeProfileId", active.getProfileId());
            session.setAttribute("activeProfileRole", active.getTargetRole());
            session.setAttribute("activeProfileTrackId", active.getTrackId());
        }
        return active;
    }
}
