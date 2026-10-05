<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.interviewx.model.Company" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    Company co = (Company) request.getAttribute("company");
    if (co == null) { response.sendRedirect(request.getContextPath() + "/company"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><title><%=co.getCompanyName()%> - Company Intel</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .intel-section { background: var(--dark); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 20px; margin-bottom: 14px; }
        .intel-label { font-size: 11px; text-transform: uppercase; letter-spacing: 1px; color: var(--text-muted); font-weight: 700; margin-bottom: 8px; display: flex; align-items: center; gap: 6px; }
        .intel-value { font-size: 14px; color: var(--text); line-height: 1.7; }
        .stage-chips { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 8px; }
        .stage-chip { padding: 6px 14px; background: rgba(99,102,241,0.15); color: var(--primary-light); border-radius: 20px; font-size: 13px; font-weight: 600; }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <header class="topbar">
        <div class="topbar-left">
            <a href="<%=request.getContextPath()%>/company" class="btn btn-secondary btn-sm" style="margin-right:8px;">&#8592;</a>
            <span class="page-title"><%=co.getCompanyName()%></span>
        </div>
    </header>
    <main class="main-content">
        <div class="page-header">
            <h1>&#127970; <%=co.getCompanyName()%></h1>
            <p><%=co.getDescription()%></p>
        </div>

        <div class="grid-2">
            <div>
                <div class="intel-section">
                    <div class="intel-label">&#127891; Industry</div>
                    <div class="intel-value"><%=co.getIndustry()%></div>
                </div>
                <div class="intel-section">
                    <div class="intel-label">&#128170; Required Skills</div>
                    <div class="intel-value">
                        <% if (co.getRequiredSkills() != null) {
                            for (String s : co.getRequiredSkills().split(",")) { %>
                        <span class="badge badge-primary" style="margin:2px;"><%=s.trim()%></span>
                        <% }} %>
                    </div>
                </div>
                <div class="intel-section">
                    <div class="intel-label">&#127981; Interview Stages</div>
                    <div class="stage-chips">
                        <% if (co.getInterviewStages() != null) {
                            for (String s : co.getInterviewStages().split(",")) { %>
                        <span class="stage-chip"><%=s.trim()%></span>
                        <% }} %>
                    </div>
                </div>
            </div>
            <div>
                <div class="intel-section">
                    <div class="intel-label">&#128187; Coding Expectations</div>
                    <div class="intel-value"><%=co.getCodingExpectations()%></div>
                </div>
                <div class="intel-section">
                    <div class="intel-label">&#129489;&#8205;&#128187; Technical Expectations</div>
                    <div class="intel-value"><%=co.getTechnicalExpectations()%></div>
                </div>
                <div class="intel-section">
                    <div class="intel-label">&#128101; HR Round Expectations</div>
                    <div class="intel-value"><%=co.getHrExpectations()%></div>
                </div>
            </div>
        </div>

        <div class="card" style="margin-top:20px;">
            <div class="card-title" style="margin-bottom:16px;">Prepare for <%=co.getCompanyName()%></div>
            <div style="display:flex;gap:12px;flex-wrap:wrap;">
                <a href="<%=request.getContextPath()%>/codelab" class="btn btn-primary">&#128187; Practice Coding</a>
                <a href="<%=request.getContextPath()%>/interview/start?type=TECHNICAL" class="btn btn-secondary">&#127908; Mock Technical</a>
                <a href="<%=request.getContextPath()%>/interview/start?type=HR" class="btn btn-secondary">&#128101; Mock HR</a>
                <a href="<%=request.getContextPath()%>/assessment" class="btn btn-secondary">&#127919; Career Assessment</a>
            </div>
        </div>
    </main>
</div>
</body>
</html>
