package com.interviewx.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection - Centralized database connection manager for InterviewX.
 *
 * Supports:
 * 1. Environment variables (for cloud/container deployments like Vercel, Render, Railway, AWS):
 *    - DB_URL / MYSQL_URL / DATABASE_URL
 *    - DB_USER / MYSQL_USER
 *    - DB_PASSWORD / MYSQL_PASSWORD
 * 2. System properties (for JVM-level configuration):
 *    - db.url, db.user, db.password / db.pass
 * 3. Default fallback for local MySQL development:
 *    - jdbc:mysql://127.0.0.1:3306/interviewx?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
 *    - user: root, password: root
 */
public class DBConnection {

    private static final String DEFAULT_URL =
            "jdbc:mysql://127.0.0.1:3306/interviewx"
            + "?useSSL=false"
            + "&serverTimezone=UTC"
            + "&allowPublicKeyRetrieval=true";

    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "root";

    public static String getUrl() {
        // Priority 1: Environment variables
        String url = System.getenv("DB_URL");
        if (url == null || url.trim().isEmpty()) {
            url = System.getenv("MYSQL_URL");
        }
        if (url == null || url.trim().isEmpty()) {
            url = System.getenv("DATABASE_URL");
        }
        if (url != null && !url.trim().isEmpty()) {
            url = url.trim();
            if (!url.startsWith("jdbc:")) {
                url = "jdbc:" + url;
            }
            return url;
        }

        // Priority 2: System property
        String propUrl = System.getProperty("db.url");
        if (propUrl != null && !propUrl.trim().isEmpty()) {
            return propUrl.trim();
        }

        // Priority 3: Local development default
        return DEFAULT_URL;
    }

    public static String getUser() {
        String user = System.getenv("DB_USER");
        if (user == null || user.trim().isEmpty()) {
            user = System.getenv("MYSQL_USER");
        }
        if (user != null && !user.trim().isEmpty()) {
            return user.trim();
        }

        String propUser = System.getProperty("db.user");
        if (propUser != null && !propUser.trim().isEmpty()) {
            return propUser.trim();
        }

        return DEFAULT_USER;
    }

    public static String getPassword() {
        String pass = System.getenv("DB_PASSWORD");
        if (pass == null) {
            pass = System.getenv("MYSQL_PASSWORD");
        }
        if (pass != null) {
            return pass;
        }

        String propPass = System.getProperty("db.password");
        if (propPass == null) {
            propPass = System.getProperty("db.pass");
        }
        if (propPass != null) {
            return propPass;
        }

        return DEFAULT_PASSWORD;
    }

    public static boolean isConfiguredRemote() {
        return (System.getenv("DB_URL") != null && !System.getenv("DB_URL").trim().isEmpty())
            || (System.getenv("MYSQL_URL") != null && !System.getenv("MYSQL_URL").trim().isEmpty())
            || (System.getenv("DATABASE_URL") != null && !System.getenv("DATABASE_URL").trim().isEmpty())
            || (System.getProperty("db.url") != null && !System.getProperty("db.url").trim().isEmpty());
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                "MySQL JDBC Driver not found. Check mysql-connector JAR.",
                e
            );
        }

        return DriverManager.getConnection(
            getUrl(),
            getUser(),
            getPassword()
        );
    }

    /** Close resources safely (null-safe). */
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try { r.close(); } catch (Exception ignored) {}
            }
        }
    }
}
