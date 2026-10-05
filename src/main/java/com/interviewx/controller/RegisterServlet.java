package com.interviewx.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.interviewx.service.UserService;

@WebServlet(
    description = "Handles InterviewX student registration",
    urlPatterns = { "/register" }
)
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserService userService;


    @Override
    public void init() throws ServletException {

        userService =
            new UserService();

        System.out.println(
            "RegisterServlet initialized successfully."
        );
    }


    // =====================================================
    // GET
    // =====================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
            "/register.jsp"
        ).forward(
            request,
            response
        );
    }


    // =====================================================
    // POST
    // =====================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        request.setCharacterEncoding("UTF-8");


        String fullName =
            request.getParameter("fullName");

        String email =
            request.getParameter("email");

        String password =
            request.getParameter("password");

        String confirmPassword =
            request.getParameter(
                "confirmPassword"
            );


        System.out.println(
            "Registration request received."
        );

        System.out.println(
            "Name = " + fullName
        );

        System.out.println(
            "Email = " + email
        );


        // =================================================
        // PASSWORD MATCH CHECK
        // =================================================

        if (
            password == null ||
            !password.equals(confirmPassword)
        ) {

            request.setAttribute(
                "error",
                "Passwords do not match."
            );

            request.getRequestDispatcher(
                "/register.jsp"
            ).forward(
                request,
                response
            );

            return;
        }


        // =================================================
        // REGISTER USER
        // =================================================

        String result =
            userService.registerUser(
                fullName,
                email,
                password
            );


        // =================================================
        // SUCCESS
        // =================================================

        if ("SUCCESS".equals(result)) {

            System.out.println(
                "Registration successful for: "
                + email
            );

            response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?registered=true"
            );

            return;
        }


        // =================================================
        // FAILURE
        // =================================================

        System.out.println(
            "Registration failed: "
            + result
        );


        request.setAttribute(
            "error",
            result
        );


        request.getRequestDispatcher(
            "/register.jsp"
        ).forward(
            request,
            response
        );
    }
}