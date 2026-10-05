package com.interviewx.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.interviewx.dao.CareerDAO;
import com.interviewx.dao.NotificationDAO;
import com.interviewx.dao.ProfileDAO;
import com.interviewx.dao.StudentDAO;
import com.interviewx.model.CareerTrack;
import com.interviewx.model.PreparationProfile;
import com.interviewx.model.Student;

@WebServlet(urlPatterns = {"/profiles", "/profiles/switch", "/profiles/create"})
public class ProfileSwitchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ProfileDAO profileDAO;
    private StudentDAO studentDAO;
    private CareerDAO careerDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        profileDAO = new ProfileDAO();
        studentDAO = new StudentDAO();
        careerDAO = new CareerDAO();
        notificationDAO = new NotificationDAO();
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

        if ("/profiles/switch".equals(path)) {
            handleSwitch(req, resp, session, userId);
        } else {
            // View "My Preparation Profiles" hub
            List<PreparationProfile> profiles = profileDAO.getProfilesByUserId(userId);
            List<CareerTrack> allTracks = careerDAO.getAllTracks();
            Student student = studentDAO.getStudentByUserId(userId);

            req.setAttribute("profiles", profiles);
            req.setAttribute("allTracks", allTracks);
            req.setAttribute("student", student);
            req.getRequestDispatcher("/student/profiles.jsp").forward(req, resp);
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

        if ("/profiles/create".equals(path)) {
            handleCreate(req, resp, session, userId);
        } else {
            handleSwitch(req, resp, session, userId);
        }
    }

    private void handleSwitch(HttpServletRequest req, HttpServletResponse resp, HttpSession session, int userId)
            throws IOException {
        String profileIdStr = req.getParameter("profileId");
        if (profileIdStr == null || profileIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/profiles");
            return;
        }

        try {
            int profileId = Integer.parseInt(profileIdStr);
            PreparationProfile p = profileDAO.getProfileById(profileId);

            if (p != null && p.getUserId() == userId) {
                profileDAO.updateLastActive(profileId);
                session.setAttribute("activeProfileId", p.getProfileId());
                session.setAttribute("activeProfileRole", p.getTargetRole());
                session.setAttribute("activeProfileTrackId", p.getTrackId());
                session.setAttribute("activeProfile", p);

                String returnUrl = req.getParameter("returnUrl");
                if (returnUrl != null && !returnUrl.trim().isEmpty() && !returnUrl.contains("switch")) {
                    resp.sendRedirect(req.getContextPath() + returnUrl);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/dashboard.jsp?switched=true&role=" +
                        URLEncoder.encode(p.getTargetRole(), StandardCharsets.UTF_8));
                }
                return;
            }
        } catch (NumberFormatException e) {}

        resp.sendRedirect(req.getContextPath() + "/profiles");
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp, HttpSession session, int userId)
            throws IOException {
        String trackIdStr = req.getParameter("trackId");
        String roleName = req.getParameter("roleName");

        int trackId = 2;
        try { if (trackIdStr != null) trackId = Integer.parseInt(trackIdStr); }
        catch (NumberFormatException e) {}

        if (roleName == null || roleName.trim().isEmpty()) {
            CareerTrack t = careerDAO.getTrackById(trackId);
            roleName = (t != null) ? t.getTrackName() : "Software Developer";
        }

        // Duplicate prevention check
        PreparationProfile existing = profileDAO.getProfileByUserAndRole(userId, roleName);
        if (existing != null) {
            // Already exists -> activate it and alert student
            profileDAO.updateLastActive(existing.getProfileId());
            session.setAttribute("activeProfileId", existing.getProfileId());
            session.setAttribute("activeProfileRole", existing.getTargetRole());
            session.setAttribute("activeProfileTrackId", existing.getTrackId());
            session.setAttribute("activeProfile", existing);

            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp?switched=true&existing=true&role=" +
                URLEncoder.encode(roleName, StandardCharsets.UTF_8));
            return;
        }

        Student student = studentDAO.getStudentByUserId(userId);
        int studentId = (student != null) ? student.getStudentId() : userId;

        int newId = profileDAO.createProfile(userId, studentId, trackId, roleName, roleName + " Profile");
        PreparationProfile newProfile = profileDAO.getProfileById(newId);

        session.setAttribute("activeProfileId", newId);
        session.setAttribute("activeProfileRole", roleName);
        session.setAttribute("activeProfileTrackId", trackId);
        session.setAttribute("activeProfile", newProfile);

        notificationDAO.addNotification(userId,
            "Preparation Profile Created: " + roleName,
            "Your dedicated preparation roadmap and daily tasks for " + roleName + " are ready!",
            "success");

        resp.sendRedirect(req.getContextPath() + "/dashboard.jsp?created=true&role=" +
            URLEncoder.encode(roleName, StandardCharsets.UTF_8));
    }
}