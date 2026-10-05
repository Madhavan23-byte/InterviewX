package com.interviewx.controller;

import java.io.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.interviewx.dao.*;
import com.interviewx.model.PreparationProfile;

@WebServlet(urlPatterns = {"/tasks", "/tasks/complete"})
public class TaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TaskDAO taskDAO;
    private CareerDAO careerDAO;
    private NotificationDAO notificationDAO;
    private ReadinessDAO readinessDAO;
    private ProfileDAO profileDAO;

    @Override
    public void init() {
        taskDAO = new TaskDAO();
        careerDAO = new CareerDAO();
        notificationDAO = new NotificationDAO();
        readinessDAO = new ReadinessDAO();
        profileDAO = new ProfileDAO();
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

        // Retrieve active profile context
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

        int profileId = (activeProfile != null) ? activeProfile.getProfileId() : 0;
        int trackId = (activeProfile != null) ? activeProfile.getTrackId() : 2;
        String roleName = (activeProfile != null) ? activeProfile.getTargetRole() : "Software Developer";

        // Auto-generate daily tasks for this profile if needed
        taskDAO.generateDailyTasks(userId, profileId, trackId, roleName);

        List<Map<String,Object>> todayTasks = taskDAO.getTasksForToday(userId, profileId);
        int completedToday = taskDAO.getTodayCompletedCount(userId, profileId);
        int totalToday = taskDAO.getTodayTotalCount(userId, profileId);
        int progress = totalToday > 0 ? (completedToday * 100 / totalToday) : 0;

        req.setAttribute("todayTasks", todayTasks);
        req.setAttribute("completedToday", completedToday);
        req.setAttribute("totalToday", totalToday);
        req.setAttribute("progress", progress);
        req.setAttribute("activeProfile", activeProfile);
        req.getRequestDispatcher("/tasks/tasks.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        resp.setContentType("application/json");

        if (session == null || session.getAttribute("userId") == null) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Not logged in\"}");
            return;
        }
        int userId = (int) session.getAttribute("userId");
        Integer profileIdObj = (Integer) session.getAttribute("activeProfileId");
        int profileId = (profileIdObj != null) ? profileIdObj : 0;

        try {
            int taskId = Integer.parseInt(req.getParameter("taskId"));
            boolean ok = taskDAO.completeTask(taskId, userId);

            if (ok) {
                // Recompute readiness for this profile
                int trackId = (session.getAttribute("activeProfileTrackId") != null) ?
                    (int) session.getAttribute("activeProfileTrackId") : 2;
                readinessDAO.computeAndSave(userId, profileId, trackId);

                int done = taskDAO.getTodayCompletedCount(userId, profileId);
                int total = taskDAO.getTodayTotalCount(userId, profileId);
                if (done == total && total > 0) {
                    notificationDAO.addNotification(userId,
                        "All Daily Tasks Completed!",
                        "Fantastic effort! You finished all your preparation tasks for today.",
                        "success");
                }
            }

            resp.getWriter().write("{\"success\":" + ok + "}");
        } catch (Exception e) {
            resp.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}