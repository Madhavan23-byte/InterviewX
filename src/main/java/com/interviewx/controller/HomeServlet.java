package com.interviewx.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class HomeServlet
 *
 * This servlet handles the InterviewX home page.
 */
@WebServlet(
    description = "Handles the InterviewX home page",
    urlPatterns = { "/home" }
)
public class HomeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * Default constructor
     */
    public HomeServlet() {
        super();
    }

    /**
     * Handles GET requests.
     *
     * When the user visits:
     * http://localhost:8080/InterviewX/home
     *
     * the request is forwarded to home.jsp.
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/home.jsp")
               .forward(request, response);
    }

    /**
     * Handles POST requests.
     *
     * Currently forwards POST requests to doGet().
     * Later, individual POST operations such as
     * login, registration, etc. will have their
     * own servlets.
     */
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}