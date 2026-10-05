<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.interviewx.model.Company" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Company> companies = (List<Company>) request.getAttribute("companies");
    if (companies == null) companies = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><title>Company Intelligence - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .company-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 16px; }
        .company-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 24px; transition: var(--transition); text-decoration: none; display: block; }
        .company-card:hover { border-color: var(--primary); transform: translateY(-3px); box-shadow: 0 8px 24px rgba(99,102,241,0.15); }
        .company-name { font-size: 18px; font-weight: 800; color: var(--text); margin-bottom: 4px; }
        .company-industry { font-size: 12px; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 10px; }
        .company-desc { font-size: 13px; color: var(--text-muted); line-height: 1.6; margin-bottom: 16px; }
        .skill-tags { display: flex; flex-wrap: wrap; gap: 6px; }
        .skill-tag { font-size: 11px; padding: 3px 10px; border-radius: 12px; background: rgba(99,102,241,0.15); color: var(--primary-light); }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <header class="topbar"><div class="topbar-left"><span class="page-title">Company Intelligence</span></div></header>
    <main class="main-content">
        <div class="page-header">
            <h1>&#127970; Company Intelligence</h1>
            <p>Detailed hiring insights for top companies to help you prepare strategically</p>
        </div>

        <div class="company-grid">
            <% for (Company co : companies) {
                String[] skills = co.getRequiredSkills() != null ? co.getRequiredSkills().split(",") : new String[]{};
            %>
            <a href="<%=request.getContextPath()%>/company/detail?id=<%=co.getCompanyId()%>" class="company-card">
                <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;">
                    <div>
                        <div class="company-name"><%=co.getCompanyName()%></div>
                        <div class="company-industry"><%=co.getIndustry()%></div>
                    </div>
                    <div style="width:48px;height:48px;border-radius:12px;background:linear-gradient(135deg,rgba(99,102,241,0.2),rgba(14,165,233,0.2));display:flex;align-items:center;justify-content:center;font-size:20px;">&#127970;</div>
                </div>
                <div class="company-desc"><%=co.getDescription()%></div>
                <div class="skill-tags">
                    <% for (String skill : skills) { if (!skill.trim().isEmpty()) { %><span class="skill-tag"><%=skill.trim()%></span><% }} %>
                </div>
            </a>
            <% } %>
        </div>
    </main>
</div>
</body>
</html>
