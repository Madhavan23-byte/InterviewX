<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.interviewx.model.CareerTrack" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    CareerTrack track = (CareerTrack) request.getAttribute("track");
    List<Map<String,Object>> modules = (List<Map<String,Object>>) request.getAttribute("modules");
    Set<Integer> completedModules = (Set<Integer>) request.getAttribute("completedModules");
    int trackId = request.getAttribute("trackId") != null ? (int)request.getAttribute("trackId") : 0;
    if (modules == null) modules = new ArrayList<>();
    if (completedModules == null) completedModules = new HashSet<>();
    int totalModules = modules.size();
    int completedCount = completedModules.size();
    int roadmapProgress = totalModules > 0 ? completedCount * 100 / totalModules : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><title>My Roadmap - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .roadmap-timeline { position: relative; }
        .roadmap-timeline::before { content: ''; position: absolute; left: 22px; top: 0; bottom: 0; width: 2px; background: var(--border); }
        .module-item { display: flex; gap: 20px; margin-bottom: 16px; position: relative; }
        .module-dot { width: 46px; height: 46px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 800; flex-shrink: 0; position: relative; z-index: 1; border: 3px solid var(--border); background: var(--dark); color: var(--text-muted); }
        .module-dot.completed { background: var(--success); border-color: var(--success); color: white; }
        .module-dot.current { background: var(--primary); border-color: var(--primary); color: white; }
        .module-content { flex: 1; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 16px; }
        .module-content.completed { border-color: rgba(16,185,129,0.3); }
        .module-name { font-size: 15px; font-weight: 700; color: var(--text); }
        .module-desc { font-size: 13px; color: var(--text-muted); margin-top: 4px; }
        .module-meta { display: flex; gap: 12px; margin-top: 10px; }
        .module-tag { font-size: 11px; color: var(--text-muted); }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <header class="topbar"><div class="topbar-left"><span class="page-title">My Roadmap</span></div></header>
    <main class="main-content">
        <% if (track == null) { %>
        <div class="page-header"><h1>&#128640; Learning Roadmap</h1></div>
        <div class="card" style="text-align:center;padding:60px;">
            <div style="font-size:48px;margin-bottom:16px;">&#127919;</div>
            <h3 style="color:var(--text);margin-bottom:8px;">No Career Track Selected</h3>
            <p style="color:var(--text-muted);margin-bottom:20px;">Take the career assessment or choose a track to see your personalized roadmap.</p>
            <a href="<%=request.getContextPath()%>/assessment" class="btn btn-primary btn-lg">&#127919; Take Assessment</a>
        </div>
        <% } else { %>
        <div class="page-header">
            <h1>&#128640; <%=track.getTrackName()%> Roadmap</h1>
            <p>Your personalized learning path to become a <%=track.getTrackName()%></p>
        </div>

        <!-- Progress Summary -->
        <div class="stats-grid" style="margin-bottom:24px;">
            <div class="stat-card">
                <div class="stat-value"><%=completedCount%>/<%=totalModules%></div>
                <div class="stat-label">Modules Completed</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%=roadmapProgress%>%</div>
                <div class="stat-label">Roadmap Progress</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%=totalModules - completedCount%></div>
                <div class="stat-label">Modules Remaining</div>
            </div>
        </div>

        <div class="grid-2">
            <div class="card">
                <div class="card-header d-flex justify-content-between">
                    <div><div class="card-title">Learning Path</div><div class="card-subtitle">Click "Done" to mark modules as complete</div></div>
                </div>
                <div class="roadmap-timeline">
                    <% boolean foundCurrent = false;
                    for (int i = 0; i < modules.size(); i++) {
                        Map<String,Object> mod = modules.get(i);
                        int moduleId = (int) mod.get("moduleId");
                        boolean isDone = completedModules.contains(moduleId);
                        boolean isCurrent = !isDone && !foundCurrent;
                        if (isCurrent) foundCurrent = true;
                    %>
                    <div class="module-item">
                        <div class="module-dot <%=isDone?"completed":isCurrent?"current":""%>">
                            <%=isDone?"&#10003;":String.valueOf(i+1)%>
                        </div>
                        <div class="module-content <%=isDone?"completed":""%>">
                            <div style="display:flex;justify-content:space-between;align-items:center;">
                                <div class="module-name"><%=mod.get("moduleName")%></div>
                                <% if (!isDone) { %>
                                <button class="btn btn-success btn-sm" onclick="markDone(<%=moduleId%>, this)">Done</button>
                                <% } else { %>
                                <span class="badge badge-success">&#10003; Completed</span>
                                <% } %>
                            </div>
                            <div class="module-desc"><%=mod.get("description")%></div>
                            <div class="module-meta">
                                <span class="module-tag">&#128337; <%=mod.get("estimatedDays")%> days</span>
                                <% if (isCurrent) { %><span class="badge badge-primary" style="font-size:10px;">Current</span><% } %>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>

            <div>
                <div class="card" style="margin-bottom:16px;">
                    <div class="card-title" style="margin-bottom:16px;">Overall Progress</div>
                    <div style="font-size:36px;font-weight:800;color:var(--primary-light);margin-bottom:8px;"><%=roadmapProgress%>%</div>
                    <div class="progress-bar-container" style="margin-bottom:12px;">
                        <div class="progress-bar" style="width:<%=roadmapProgress%>%"></div>
                    </div>
                    <a href="<%=request.getContextPath()%>/assessment" class="btn btn-secondary btn-sm">&#127919; Retake Assessment</a>
                </div>
                <div class="card">
                    <div class="card-title" style="margin-bottom:12px;">Quick Actions</div>
                    <div style="display:flex;flex-direction:column;gap:8px;">
                        <a href="<%=request.getContextPath()%>/codelab" class="btn btn-primary">&#128187; Practice Coding</a>
                        <a href="<%=request.getContextPath()%>/interview/start?type=TECHNICAL" class="btn btn-secondary">&#127908; Mock Interview</a>
                        <a href="<%=request.getContextPath()%>/tasks" class="btn btn-secondary">&#9989; Daily Tasks</a>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </main>
</div>
<script>
function markDone(moduleId, btn) {
    fetch('<%=request.getContextPath()%>/roadmap/complete', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'moduleId=' + moduleId
    }).then(r => r.json()).then(data => {
        if (data.success) {
            btn.parentElement.querySelector('.module-name').style.textDecoration = 'line-through';
            btn.innerHTML = '<span class="badge badge-success">&#10003; Completed</span>';
            btn.outerHTML = '<span class="badge badge-success">&#10003; Completed</span>';
            btn.closest('.module-dot')?.classList.add('completed');
        }
    });
}
</script>
</body>
</html>
