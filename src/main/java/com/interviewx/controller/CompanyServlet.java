package com.interviewx.controller;

import java.io.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.interviewx.dao.CompanyDAO;
import com.interviewx.model.Company;

@WebServlet(urlPatterns = {"/company", "/company/detail"})
public class CompanyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CompanyDAO companyDAO;

    @Override
    public void init() { companyDAO = new CompanyDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/company/detail".equals(path)) {
            try {
                int companyId = Integer.parseInt(req.getParameter("id"));
                Company company = companyDAO.getCompanyById(companyId);
                req.setAttribute("company", company);
                req.getRequestDispatcher("/company/detail.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/company");
            }
        } else {
            req.setAttribute("companies", companyDAO.getAllCompanies());
            req.getRequestDispatcher("/company/company.jsp").forward(req, resp);
        }
    }
}
