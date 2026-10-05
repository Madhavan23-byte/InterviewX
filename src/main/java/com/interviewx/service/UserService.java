package com.interviewx.service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import com.interviewx.dao.UserDAO;
import com.interviewx.dao.StudentDAO;
import com.interviewx.model.User;

public class UserService {

    private final UserDAO userDAO;
    private final StudentDAO studentDAO;

    public UserService() {
        userDAO = new UserDAO();
        studentDAO = new StudentDAO();
    }

    /**
     * Registers a new user and automatically creates their student profile.
     *
     * @param fullName user's full name
     * @param email    user's email
     * @param password plain password entered by user
     * @return "SUCCESS" or error message
     */
    public String registerUser(String fullName, String email, String password) {

        // Validate full name
        if (fullName == null || fullName.trim().isEmpty()) {
            return "Please enter your full name.";
        }

        // Validate email
        if (email == null || email.trim().isEmpty()) {
            return "Please enter your email.";
        }
        if (!isValidEmail(email)) {
            return "Please enter a valid email address.";
        }

        // Validate password
        if (password == null || password.length() < 8) {
            return "Password must contain at least 8 characters.";
        }

        // Clean input
        fullName = fullName.trim();
        email = email.trim().toLowerCase();

        // Check whether email already exists
        if (userDAO.emailExists(email)) {
            return "An account with this email already exists.";
        }

        // Check if emailExists encountered a database connectivity error
        if (userDAO.getLastError() != null) {
            return "Database connection failed. Please ensure the database is running and configured (" + userDAO.getLastError() + ").";
        }

        // Hash password (SHA-256)
        String passwordHash = hashPassword(password);
        if (passwordHash == null) {
            return "Unable to secure the password.";
        }

        // Create User object
        User user = new User(fullName, email, passwordHash, "STUDENT");

        // Save user to DB
        boolean created = userDAO.createUser(user);

        if (created) {
            // Auto-create student profile record
            User savedUser = userDAO.findByEmail(email);
            if (savedUser != null) {
                studentDAO.createStudentProfile(savedUser.getUserId());
            }
            return "SUCCESS";
        }

        // Check if createUser failed due to database connectivity
        if (userDAO.getLastError() != null) {
            return "Database connection failed (" + userDAO.getLastError() + ").";
        }

        return "Registration failed. Please try again.";
    }

    /**
     * Validates basic email format.
     */
    private boolean isValidEmail(String email) {
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    }

    /**
     * Creates a SHA-256 hash of the password.
     * The actual password is NEVER stored in the database.
     */
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
