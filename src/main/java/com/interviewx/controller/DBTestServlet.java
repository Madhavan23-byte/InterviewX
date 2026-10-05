package com.interviewx.controller;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.interviewx.util.DBConnection;

@WebServlet(
    description = "Tests the InterviewX database connection",
    urlPatterns = { "/db-test" }
)
public class DBTestServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public DBTestServlet() {
        super();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String targetUrl = DBConnection.getUrl();
        String targetUser = DBConnection.getUser();
        boolean isRemote = DBConnection.isConfiguredRemote();

        try {

            Connection connection = DBConnection.getConnection();

            if (connection != null && !connection.isClosed()) {

                response.getWriter().println(
                    "<!DOCTYPE html>"
                );

                response.getWriter().println(
                    "<html><head><title>Database Test - Success</title>"
                    + "<style>body{font-family:system-ui,sans-serif;padding:40px;background:#f8fafc;color:#0f172a;}"
                    + ".card{background:white;padding:30px;border-radius:12px;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);max-width:600px;margin:0 auto;}"
                    + ".badge{display:inline-block;padding:4px 12px;border-radius:9999px;font-weight:600;font-size:14px;background:#dcfce7;color:#166534;}"
                    + "</style></head><body><div class='card'>"
                );

                response.getWriter().println(
                    "<h1>InterviewX Database Connection Successful! 🚀</h1>"
                );

                response.getWriter().println(
                    "<p><span class='badge'>CONNECTED</span></p>"
                );

                response.getWriter().println(
                    "<p><strong>Target URL:</strong> " + escapeHtml(targetUrl) + "</p>"
                );

                response.getWriter().println(
                    "<p><strong>Database User:</strong> " + escapeHtml(targetUser) + "</p>"
                );

                response.getWriter().println(
                    "<p><strong>Configuration Source:</strong> " + (isRemote ? "Remote Cloud Environment Variable (DB_URL)" : "Local Development Default (127.0.0.1:3306)") + "</p>"
                );

                response.getWriter().println(
                    "<p><a href='" + request.getContextPath() + "/login.jsp'>Go to Login</a> | <a href='" + request.getContextPath() + "/register'>Go to Register</a></p>"
                );

                response.getWriter().println(
                    "</div></body></html>"
                );

                connection.close();

            } else {

                response.getWriter().println(
                    "<!DOCTYPE html>"
                );

                response.getWriter().println(
                    "<html><head><title>Database Test - Failed</title>"
                    + "<style>body{font-family:system-ui,sans-serif;padding:40px;background:#f8fafc;color:#0f172a;}"
                    + ".card{background:white;padding:30px;border-radius:12px;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);max-width:600px;margin:0 auto;}"
                    + ".badge{display:inline-block;padding:4px 12px;border-radius:9999px;font-weight:600;font-size:14px;background:#fee2e2;color:#991b1b;}"
                    + "</style></head><body><div class='card'>"
                );

                response.getWriter().println(
                    "<h1>Database Connection Failed ❌</h1>"
                );

                response.getWriter().println(
                    "<p><span class='badge'>DISCONNECTED</span></p>"
                );

                response.getWriter().println(
                    "<p>Connection object is null or closed.</p>"
                );

                response.getWriter().println(
                    "</div></body></html>"
                );
            }

        } catch (Exception e) {

            response.getWriter().println(
                "<!DOCTYPE html>"
            );

            response.getWriter().println(
                "<html><head><title>Database Error</title>"
                + "<style>body{font-family:system-ui,sans-serif;padding:40px;background:#f8fafc;color:#0f172a;}"
                + ".card{background:white;padding:30px;border-radius:12px;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);max-width:600px;margin:0 auto;}"
                + ".badge{display:inline-block;padding:4px 12px;border-radius:9999px;font-weight:600;font-size:14px;background:#fee2e2;color:#991b1b;}"
                + ".err{background:#fef2f2;border:1px solid #fecaca;padding:12px;border-radius:8px;font-family:monospace;font-size:13px;word-break:break-all;color:#991b1b;}"
                + "</style></head><body><div class='card'>"
            );

            response.getWriter().println(
                "<h1>Database Connection Failed ❌</h1>"
            );

            response.getWriter().println(
                "<p><span class='badge'>FAILED</span></p>"
            );

            response.getWriter().println(
                "<p><strong>Target URL:</strong> " + escapeHtml(targetUrl) + "</p>"
            );

            response.getWriter().println(
                "<p><strong>Database User:</strong> " + escapeHtml(targetUser) + "</p>"
            );

            response.getWriter().println(
                "<p><strong>Configuration Source:</strong> " + (isRemote ? "Remote Cloud Environment Variable (DB_URL)" : "Local Development Default (127.0.0.1:3306)") + "</p>"
            );

            response.getWriter().println(
                "<div class='err'>Error: " + escapeHtml(e.getMessage()) + "</div>"
            );

            if (!isRemote) {
                response.getWriter().println(
                    "<h3>How to configure a cloud database for Vercel:</h3>"
                    + "<p>Set the following Environment Variables in your Vercel Project Settings:</p>"
                    + "<ul>"
                    + "<li><code>DB_URL</code> = <code>jdbc:mysql://&lt;cloud-host&gt;:&lt;port&gt;/interviewx</code></li>"
                    + "<li><code>DB_USER</code> = <code>&lt;username&gt;</code></li>"
                    + "<li><code>DB_PASSWORD</code> = <code>&lt;password&gt;</code></li>"
                    + "</ul>"
                );
            }

            response.getWriter().println(
                "</div></body></html>"
            );

            e.printStackTrace();
        }
    }

    private String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}
