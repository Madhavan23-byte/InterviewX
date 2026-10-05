<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    String _sbCurrentPage = request.getServletPath();
    if (_sbCurrentPage == null) _sbCurrentPage = "";
    String _sbFullName = (String) session.getAttribute("fullName");
    if (_sbFullName == null) _sbFullName = "Student";
    String _sbInitials = _sbFullName.length() > 0 ? String.valueOf(_sbFullName.charAt(0)).toUpperCase() : "S";
    String _sbActiveRole = (String) session.getAttribute("activeProfileRole");
    if (_sbActiveRole == null) _sbActiveRole = "Backend Developer";
    String _sbUserRole = (String) session.getAttribute("role");
%>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-logo">
        <div class="logo-icon">IX</div>
        <span class="logo-text">InterviewX</span>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-section">
            <div class="nav-label">Overview</div>
            <a href="<%=request.getContextPath()%>/dashboard.jsp" class="nav-item <%=_sbCurrentPage.contains("dashboard") ? "active" : ""%>">
                <span class="nav-icon">&#127968;</span> Dashboard
            </a>
            <a href="<%=request.getContextPath()%>/profiles" class="nav-item <%=_sbCurrentPage.contains("profiles") ? "active" : ""%>">
                <span class="nav-icon">&#128188;</span> My Profiles
            </a>
            <a href="<%=request.getContextPath()%>/profile" class="nav-item <%=_sbCurrentPage.contains("student/profile") || _sbCurrentPage.equals("/profile") ? "active" : ""%>">
                <span class="nav-icon">&#128100;</span> Personal Profile
            </a>
            <a href="<%=request.getContextPath()%>/notifications" class="nav-item <%=_sbCurrentPage.contains("notification") ? "active" : ""%>">
                <span class="nav-icon">&#128276;</span> Notifications
            </a>
        </div>
        <div class="nav-section">
            <div class="nav-label">Role & Learning</div>
            <a href="<%=request.getContextPath()%>/resume" class="nav-item <%=_sbCurrentPage.contains("resume") ? "active" : ""%>">
                <span class="nav-icon">&#128196;</span> Resume & Discovery
            </a>
            <a href="<%=request.getContextPath()%>/learning" class="nav-item <%=_sbCurrentPage.contains("learning") ? "active" : ""%>">
                <span class="nav-icon">&#128218;</span> My Learning
            </a>
            <a href="<%=request.getContextPath()%>/assessment" class="nav-item <%=_sbCurrentPage.contains("assessment") ? "active" : ""%>">
                <span class="nav-icon">&#127919;</span> Skill Assessment
            </a>
            <a href="<%=request.getContextPath()%>/career/roadmap" class="nav-item <%=_sbCurrentPage.contains("roadmap") ? "active" : ""%>">
                <span class="nav-icon">&#128640;</span> My Roadmap
            </a>
            <a href="<%=request.getContextPath()%>/tasks" class="nav-item <%=_sbCurrentPage.contains("task") ? "active" : ""%>">
                <span class="nav-icon">&#9989;</span> Daily Tasks
            </a>
        </div>
        <div class="nav-section">
            <div class="nav-label">Practice</div>
            <a href="<%=request.getContextPath()%>/codelab" class="nav-item <%=_sbCurrentPage.contains("codelab") ? "active" : ""%>">
                <span class="nav-icon">&#128187;</span> CodeLab
            </a>
            <a href="<%=request.getContextPath()%>/analyzer" class="nav-item <%=_sbCurrentPage.contains("analyzer") ? "active" : ""%>">
                <span class="nav-icon">&#129302;</span> AI Analyzer
            </a>
            <a href="<%=request.getContextPath()%>/interview" class="nav-item <%=_sbCurrentPage.contains("interview") ? "active" : ""%>">
                <span class="nav-icon">&#127908;</span> Mock Interview
            </a>
        </div>
        <div class="nav-section">
            <div class="nav-label">Explore</div>
            <a href="<%=request.getContextPath()%>/company" class="nav-item <%=_sbCurrentPage.contains("company") ? "active" : ""%>">
                <span class="nav-icon">&#127970;</span> Companies
            </a>
            <a href="<%=request.getContextPath()%>/store" class="nav-item <%=_sbCurrentPage.contains("store") ? "active" : ""%>">
                <span class="nav-icon">&#128722;</span> Prep Store
            </a>
        </div>
        <% if ("ADMIN".equalsIgnoreCase(_sbUserRole)) { %>
        <div class="nav-section">
            <div class="nav-label">Administration</div>
            <a href="<%=request.getContextPath()%>/admin/ai-config" class="nav-item <%=_sbCurrentPage.contains("ai-config") ? "active" : ""%>">
                <span class="nav-icon">&#9881;&#65039;</span> AI Configuration
            </a>
        </div>
        <% } %>
    </nav>
    <div class="sidebar-footer">
        <a href="<%=request.getContextPath()%>/profiles" style="text-decoration:none;display:block;margin-bottom:12px;padding:8px 10px;background:var(--surface2);border-radius:var(--radius-sm);border:1px solid var(--border);">
            <div style="font-size:10px;text-transform:uppercase;letter-spacing:0.5px;color:var(--primary-light);font-weight:700;">Active Target Role:</div>
            <div style="font-size:12px;font-weight:600;color:var(--text);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                <%=_sbActiveRole%>
            </div>
        </a>
        <div class="d-flex align-items-center gap-2" style="margin-bottom:12px;">
            <div class="user-avatar" style="width:32px;height:32px;font-size:13px;"><%=_sbInitials%></div>
            <div style="overflow:hidden;">
                <div style="font-size:13px;font-weight:600;color:var(--text);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;"><%=_sbFullName%></div>
                <div style="font-size:11px;color:var(--text-muted);"><%= ("ADMIN".equalsIgnoreCase(_sbUserRole)) ? "Administrator" : "Student" %></div>
            </div>
        </div>
        <a href="<%=request.getContextPath()%>/logout" class="btn btn-secondary btn-sm btn-full" style="justify-content:center;">
            &#9099; Sign Out
        </a>
    </div>
</aside>
