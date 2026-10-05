<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Map<String,Object>> todayTasks = (List<Map<String,Object>>) request.getAttribute("todayTasks");
    int completedToday = request.getAttribute("completedToday") != null ? (int)request.getAttribute("completedToday") : 0;
    int totalToday = request.getAttribute("totalToday") != null ? (int)request.getAttribute("totalToday") : 0;
    int progress = request.getAttribute("progress") != null ? (int)request.getAttribute("progress") : 0;
    if (todayTasks == null) todayTasks = new ArrayList<>();
    String fullName = (String) session.getAttribute("fullName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><title>Daily Tasks - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .task-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 20px; margin-bottom: 12px; display: flex; align-items: center; gap: 16px; transition: var(--transition); }
        .task-card.completed { opacity: 0.6; }
        .task-check { width: 28px; height: 28px; border-radius: 8px; border: 2px solid var(--border); cursor: pointer; display: flex; align-items: center; justify-content: center; background: transparent; color: var(--success); font-size: 16px; transition: var(--transition); flex-shrink: 0; }
        .task-check.done { background: var(--success); border-color: var(--success); color: white; }
        .task-info { flex: 1; }
        .task-title { font-size: 15px; font-weight: 600; color: var(--text); }
        .task-title.done { text-decoration: line-through; }
        .task-desc { font-size: 13px; color: var(--text-muted); margin-top: 3px; }
        .task-meta { display: flex; gap: 12px; margin-top: 8px; align-items: center; }
        .type-badge { font-size: 10px; font-weight: 700; text-transform: uppercase; padding: 3px 10px; border-radius: 4px; }
        .type-LEARN { background: rgba(99,102,241,0.2); color: var(--primary-light); }
        .type-CODE { background: rgba(16,185,129,0.2); color: var(--success); }
        .type-INTERVIEW { background: rgba(14,165,233,0.2); color: var(--secondary); }
        .type-HR { background: rgba(245,158,11,0.2); color: var(--warning); }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <header class="topbar"><div class="topbar-left"><span class="page-title">Daily Tasks</span></div></header>
    <main class="main-content">
        <div class="page-header">
            <h1>&#9989; Today's Preparation Plan</h1>
            <p><%=new java.text.SimpleDateFormat("EEEE, MMMM d, yyyy").format(new java.util.Date())%></p>
        </div>

        <div class="stats-grid" style="margin-bottom:24px;">
            <div class="stat-card">
                <div class="stat-value"><%=completedToday%></div>
                <div class="stat-label">Completed</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%=totalToday - completedToday%></div>
                <div class="stat-label">Remaining</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%=progress%>%</div>
                <div class="stat-label">Today's Progress</div>
            </div>
        </div>

        <div class="card" style="margin-bottom:16px;">
            <div style="display:flex;justify-content:space-between;margin-bottom:10px;font-size:14px;color:var(--text-muted);">
                <span>Daily Progress</span><span><%=progress%>%</span>
            </div>
            <div class="progress-bar-container" style="height:10px;">
                <div class="progress-bar" style="width:<%=progress%>%"></div>
            </div>
        </div>

        <% if (todayTasks.isEmpty()) { %>
        <div class="empty-state" style="padding:60px;background:var(--surface);border-radius:var(--radius);border:1px solid var(--border);">
            <div class="empty-icon">&#128196;</div>
            <h3>No Tasks Today</h3>
            <p style="margin-bottom:20px;">Choose a career track to get personalized daily tasks.</p>
            <a href="<%=request.getContextPath()%>/assessment" class="btn btn-primary">&#127919; Take Assessment</a>
        </div>
        <% } else { %>
            <% for (Map<String,Object> task : todayTasks) {
                boolean done = "completed".equals(task.get("status"));
                String type = (String) task.get("taskType");
                if (type == null) type = "LEARN";
            %>
            <div class="task-card <%=done?"completed":""%>" id="task-<%=task.get("taskId")%>">
                <div class="task-check <%=done?"done":""%>" onclick="completeTask(<%=task.get("taskId")%>, this)">
                    <%=done?"&#10003;":""%>
                </div>
                <div class="task-info">
                    <div class="task-title <%=done?"done":""%>"><%=task.get("title")%></div>
                    <div class="task-desc"><%=task.get("description")%></div>
                    <div class="task-meta">
                        <span class="type-badge type-<%=type%>"><%=type%></span>
                        <span style="font-size:12px;color:var(--text-muted);">&#128337; <%=task.get("estimatedMinutes")%> min</span>
                        <% if (done) { %><span style="font-size:12px;color:var(--success);">&#10003; Done</span><% } %>
                    </div>
                </div>
            </div>
            <% } %>
        <% } %>
    </main>
</div>
<script>
function completeTask(taskId, el) {
    if (el.classList.contains('done')) return;
    fetch('<%=request.getContextPath()%>/tasks/complete', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'taskId=' + taskId
    }).then(r => r.json()).then(data => {
        if (data.success) {
            el.classList.add('done'); el.innerHTML = '&#10003;';
            const card = document.getElementById('task-' + taskId);
            const title = card.querySelector('.task-title');
            if (title) title.classList.add('done');
            card.classList.add('completed');
            setTimeout(() => location.reload(), 500);
        }
    });
}
</script>
</body>
</html>
