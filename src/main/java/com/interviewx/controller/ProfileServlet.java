package com.interviewx.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.interviewx.dao.StudentDAO;
import com.interviewx.model.Student;

@WebServlet(urlPatterns = {"/profile", "/student/profile"})
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudentDAO studentDAO;

    @Override
    public void init() { studentDAO = new StudentDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        int userId = (int) session.getAttribute("userId");
        Student student = studentDAO.getStudentByUserId(userId);
        if (student == null) {
            studentDAO.createStudentProfile(userId);
            student = new Student();
            student.setUserId(userId);
        }
        req.setAttribute("student", student);
        req.getRequestDispatcher("/student/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
        int userId = (int) session.getAttribute("userId");

        Student s = new Student();
        s.setUserId(userId);
        s.setCollegeName(req.getParameter("collegeName"));
        s.setDegree(req.getParameter("degree"));
        try { s.setGraduationYear(Integer.parseInt(req.getParameter("graduationYear"))); }
        catch (NumberFormatException e) { s.setGraduationYear(0); }
        s.setTargetRole(req.getParameter("targetRole"));
        s.setSkills(req.getParameter("skills"));
        s.setInterests(req.getParameter("interests"));
        s.setProgrammingExperience(req.getParameter("programmingExperience"));
        s.setCareerGoals(req.getParameter("careerGoals"));
        s.setPhone(req.getParameter("phone"));
        s.setLinkedinUrl(req.getParameter("linkedinUrl"));
        s.setGithubUrl(req.getParameter("githubUrl"));

        boolean updated = studentDAO.updateStudent(s);
        if (updated) {
            req.setAttribute("success", "Profile updated successfully!");
        } else {
            studentDAO.createStudentProfile(userId);
            studentDAO.updateStudent(s);
            req.setAttribute("success", "Profile saved!");
        }
        req.setAttribute("student", s);
        req.getRequestDispatcher("/student/profile.jsp").forward(req, resp);
    }
}
