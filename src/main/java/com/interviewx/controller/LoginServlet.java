package com.interviewx.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.interviewx.dao.ProfileDAO;
import com.interviewx.dao.UserDAO;
import com.interviewx.model.PreparationProfile;
import com.interviewx.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private ProfileDAO profileDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        profileDAO = new ProfileDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Please enter your email address.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (password == null || password.isEmpty()) {
            request.setAttribute("error", "Please enter your password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        email = email.trim().toLowerCase();

        User user = userDAO.findByEmail(email);

        if (user == null) {
            if (userDAO.getLastError() != null) {
                request.setAttribute("error", "Database connection failed (" + userDAO.getLastError() + ").");
            } else {
                request.setAttribute("error", "Invalid email or password.");
            }
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String enteredPasswordHash = hashPassword(password);
        if (enteredPasswordHash == null || !enteredPasswordHash.equals(user.getPasswordHash())) {
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // CREATE SESSION
        HttpSession session = request.getSession(true);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("fullName", user.getFullName());
        session.setAttribute("email", user.getEmail());
        session.setAttribute("role", user.getRole());

        // Initialize Active Preparation Profile context
        try {
            PreparationProfile activeProfile = profileDAO.getActiveProfile(user.getUserId());
            if (activeProfile != null) {
                session.setAttribute("activeProfileId", activeProfile.getProfileId());
                session.setAttribute("activeProfileRole", activeProfile.getTargetRole());
                session.setAttribute("activeProfileTrackId", activeProfile.getTrackId());
                session.setAttribute("activeProfile", activeProfile);
            }
        } catch (Exception e) {
            System.out.println("Warning: Could not load active profile on login: " + e.getMessage());
        }

        session.setMaxInactiveInterval(30 * 60);

        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
    }

    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }
}
