<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Map<String,Object>> history = (List<Map<String,Object>>) request.getAttribute("history");
    if (history == null) history = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><title>Mock Interview - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .interview-type-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 28px 24px; text-align: center; transition: var(--transition); text-decoration: none; display: block; }
        .interview-type-card:hover { border-color: var(--primary); transform: translateY(-4px); box-shadow: 0 12px 32px rgba(99,102,241,0.2); }
        .it-icon { font-size: 36px; margin-bottom: 12px; display: block; }
        .it-title { font-size: 16px; font-weight: 800; color: var(--text); margin-bottom: 6px; }
        .it-desc { font-size: 13px; color: var(--text-muted); }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <header class="topbar"><div class="topbar-left"><span class="page-title">Mock Interview</span></div></header>
    <main class="main-content">
        <div class="page-header">
            <h1>&#127908; Mock Interview Center</h1>
            <p>Practice all interview rounds and get AI-powered feedback</p>
        </div>

        <!-- Interview Types -->
        <div class="grid-4" style="margin-bottom:32px;">
            <a href="<%=request.getContextPath()%>/interview/start?type=TECHNICAL" class="interview-type-card">
                <span class="it-icon">&#128187;</span>
                <div class="it-title">Technical</div>
                <div class="it-desc">DSA, OOP, DBMS, System Design concepts</div>
            </a>
            <a href="<%=request.getContextPath()%>/interview/start?type=HR" class="interview-type-card">
                <span class="it-icon">&#128101;</span>
                <div class="it-title">HR Interview</div>
                <div class="it-desc">Behavioral, career goals, soft skills</div>
            </a>
            <a href="<%=request.getContextPath()%>/interview/start?type=GD" class="interview-type-card">
                <span class="it-icon">&#128483;</span>
                <div class="it-title">Group Discussion</div>
                <div class="it-desc">Topics, opinions, communication</div>
            </a>
            <div class="interview-type-card" style="opacity:0.5;cursor:not-allowed;">
                <span class="it-icon">&#128221;</span>
                <div class="it-title">Aptitude Test</div>
                <div class="it-desc">Coming soon</div>
            </div>
        </div>

        <!-- History -->
        <div class="card">
            <div class="card-header">
                <div class="card-title">Interview History</div>
                <div class="card-subtitle">Your recent mock interview attempts</div>
            </div>
            <% if (history.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">&#127908;</div>
                <h3>No Interviews Yet</h3>
                <p>Start your first mock interview above!</p>
            </div>
            <% } else { %>
            <div class="table-wrapper">
                <table class="table">
                    <thead><tr><th>Type</th><th>Score</th><th>Status</th><th>Date</th><th>Action</th></tr></thead>
                    <tbody>
                    <% for (Map<String,Object> h : history) { 
                        Object typeObj = h.get("interviewType") != null ? h.get("interviewType") : h.get("type");
                        String typeStr = typeObj != null ? String.valueOf(typeObj) : "TECHNICAL";
                        Object scObj = h.get("overallScore") != null ? h.get("overallScore") : h.get("score");
                        double scVal = (scObj instanceof Number) ? ((Number) scObj).doubleValue() : 0.0;
                    %>
                    <tr>
                        <td><span class="badge badge-primary"><%=typeStr%></span></td>
                        <td style="font-weight:700;color:var(--primary-light);"><%=String.format("%.1f", scVal)%>/10</td>
                        <td><span class="badge <%="completed".equalsIgnoreCase(String.valueOf(h.get("status")))?"badge-success":"badge-warning"%>"><%=h.get("status")%></span></td>
                        <td style="color:var(--text-muted);"><%=h.get("startedAt")%></td>
                        <td><a href="<%=request.getContextPath()%>/interview/report?id=<%=h.get("interviewId")%>" class="btn btn-secondary btn-sm">View Report</a></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </main>
</div>
</body>
</html>
