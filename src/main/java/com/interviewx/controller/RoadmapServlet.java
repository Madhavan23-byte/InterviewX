package com.interviewx.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.interviewx.dao.CareerDAO;
import com.interviewx.dao.NotificationDAO;
import com.interviewx.dao.ProfileDAO;
import com.interviewx.dao.ReadinessDAO;

@WebServlet(urlPatterns = {"/roadmap/complete"})
public class RoadmapServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CareerDAO careerDAO;
    private NotificationDAO notificationDAO;
    private ReadinessDAO readinessDAO;
    private ProfileDAO profileDAO;

    @Override
    public void init() {
        careerDAO = new CareerDAO();
        notificationDAO = new NotificationDAO();
        readinessDAO = new ReadinessDAO();
        profileDAO = new ProfileDAO();
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
            int moduleId = Integer.parseInt(req.getParameter("moduleId"));
            boolean ok = careerDAO.markModuleComplete(userId, profileId, moduleId);

            if (ok) {
                // Recompute readiness for this profile
                int trackId = (session.getAttribute("activeProfileTrackId") != null) ?
                    (int) session.getAttribute("activeProfileTrackId") : 2;
                readinessDAO.computeAndSave(userId, profileId, trackId);

                notificationDAO.addNotification(userId,
                    "Roadmap Progress",
                    "Module marked as complete! Your placement readiness score has increased.",
                    "success");
            }

            resp.getWriter().write("{\"success\":" + ok + "}");
        } catch (Exception e) {
            resp.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}