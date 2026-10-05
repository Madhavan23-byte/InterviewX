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

        try {

            Connection connection = DBConnection.getConnection();

            if (connection != null && !connection.isClosed()) {

                response.getWriter().println(
                    "<!DOCTYPE html>"
                );

                response.getWriter().println(
                    "<html><head><title>Database Test</title></head><body>"
                );

                response.getWriter().println(
                    "<h1>InterviewX Database Connection Successful! 🚀</h1>"
                );

                response.getWriter().println(
                    "<p>Java → JDBC → MySQL is working correctly.</p>"
                );

                response.getWriter().println(
                    "<p>Database: interviewx</p>"
                );

                response.getWriter().println(
                    "<p>Connection Status: CONNECTED</p>"
                );

                response.getWriter().println(
                    "</body></html>"
                );

                connection.close();

            } else {

                response.getWriter().println(
                    "<h1>Database Connection Failed ❌</h1>"
                );

                response.getWriter().println(
                    "<p>Connection object is null or closed.</p>"
                );
            }

        } catch (Exception e) {

            response.getWriter().println(
                "<!DOCTYPE html>"
            );

            response.getWriter().println(
                "<html><head><title>Database Error</title></head><body>"
            );

            response.getWriter().println(
                "<h1>Database Connection Failed ❌</h1>"
            );

            response.getWriter().println(
                "<p>Error: " + e.getMessage() + "</p>"
            );

            response.getWriter().println(
                "</body></html>"
            );

            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}