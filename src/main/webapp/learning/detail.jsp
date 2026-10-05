<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.interviewx.model.LearningTrack, com.interviewx.model.LearningModule, com.interviewx.model.PreparationProfile" %>
<%
    LearningTrack track = (LearningTrack) request.getAttribute("track");
    PreparationProfile activeProfile = (PreparationProfile) request.getAttribute("activeProfile");
    List<LearningModule> modules = (List<LearningModule>) request.getAttribute("modules");
    if (modules == null) modules = Collections.emptyList();

    List<Map<String, Object>> tasks = (List<Map<String, Object>>) request.getAttribute("tasks");
    if (tasks == null) tasks = Collections.emptyList();

    List<Map<String, Object>> todayTasks = (List<Map<String, Object>>) request.getAttribute("todayTasks");
    if (todayTasks == null) todayTasks = Collections.emptyList();

    List<Map<String, Object>> completedActivities = (List<Map<String, Object>>) request.getAttribute("completedActivities");
    if (completedActivities == null) completedActivities = Collections.emptyList();

    Map<String, Object> analytics = (Map<String, Object>) request.getAttribute("analytics");
    if (analytics == null) analytics = Collections.emptyMap();

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");

    int hours = track != null ? track.getTimeSpentMinutes() / 60 : 0;
    int mins = track != null ? track.getTimeSpentMinutes() % 60 : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=track != null ? track.getTrackName() : "Course"%> — Course Progress — InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .course-hero {
            background: linear-gradient(135deg, rgba(30, 41, 59, 0.95) 0%, rgba(15, 23, 42, 0.98) 100%);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 28px;
            margin-bottom: 24px;
        }
        .stats-grid-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }
        .two-col-layout {
            display: grid;
            grid-template-columns: 1.6fr 1fr;
            gap: 24px;
        }
        @media (max-width: 992px) {
            .two-col-layout { grid-template-columns: 1fr; }
        }
        .module-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 18px;
            border-radius: var(--radius-md);
            background: var(--surface2);
            border: 1px solid var(--border);
            margin-bottom: 10px;
            transition: all 0.2s ease;
        }
        .module-item.status-completed {
            border-color: rgba(34, 197, 94, 0.3);
            background: rgba(34, 197, 94, 0.04);
        }
        .module-item.status-current {
            border-color: var(--primary-light);
            background: rgba(99, 102, 241, 0.08);
            box-shadow: 0 0 15px rgba(99, 102, 241, 0.1);
        }
        .task-card-row {
            padding: 12px 16px;
            background: var(--surface2);
            border-radius: var(--radius-md);
            border: 1px solid var(--border);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .activity-timeline {
            position: relative;
            padding-left: 24px;
        }
        .activity-timeline::before {
            content: '';
            position: absolute;
            left: 7px;
            top: 6px;
            bottom: 6px;
            width: 2px;
            background: var(--border);
        }
        .timeline-node {
            position: relative;
            margin-bottom: 16px;
        }
        .timeline-node::before {
            content: '';
            position: absolute;
            left: -21px;
            top: 5px;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: var(--primary-light);
            border: 2px solid var(--surface);
        }
    </style>
</head>
<body>
    <div class="app-layout">
        <jsp:include page="/sidebar.jsp" />

        <main class="main-content">
            <header class="topbar">
                <div class="d-flex align-items-center gap-3">
                    <a href="<%=request.getContextPath()%>/learning" class="btn btn-secondary btn-sm">
                        &larr; All Courses
                    </a>
                    <div>
                        <h1 class="page-title" style="margin:0;"><%=track.getTrackName()%></h1>
                        <div style="font-size:12px; color:var(--text-muted);">
                            Active Target Role: <strong><%=activeProfile != null ? activeProfile.getTargetRole() : "Profile"%></strong>
                        </div>
                    </div>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <!-- Status selector form -->
                    <form method="POST" action="<%=request.getContextPath()%>/learning/status" style="display:inline;">
                        <input type="hidden" name="trackId" value="<%=track.getTrackId()%>">
                        <select name="status" class="form-input" style="padding:4px 10px; font-size:12px;" onchange="this.form.submit()">
                            <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(track.getStatus()) ? "selected" : "" %>>In Progress</option>
                            <option value="PAUSED" <%= "PAUSED".equals(track.getStatus()) ? "selected" : "" %>>Paused</option>
                            <option value="COMPLETED" <%= "COMPLETED".equals(track.getStatus()) ? "selected" : "" %>>Completed</option>
                        </select>
                    </form>
                    <form method="POST" action="<%=request.getContextPath()%>/learning/delete" style="display:inline;" onsubmit="return confirm('Remove this learning track from your active profile?');">
                        <input type="hidden" name="trackId" value="<%=track.getTrackId()%>">
                        <button type="submit" class="btn btn-danger btn-sm" style="font-size:12px;">
                            &#128465; Remove
                        </button>
                    </form>
                </div>
            </header>

            <div class="content-body">
                <% if (msg != null) { %>
                    <div class="alert alert-success" style="margin-bottom:20px;">
                        &#10004; <%=msg%>
                    </div>
                <% } %>
                <% if (error != null) { %>
                    <div class="alert alert-danger" style="margin-bottom:20px;">
                        &#9888; <%=error%>
                    </div>
                <% } %>

                <!-- Hero Section with Description & Progress -->
                <div class="course-hero">
                    <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
                        <div>
                            <span class="badge" style="background:rgba(99, 102, 241, 0.2); color:var(--primary-light); font-size:11px; padding:4px 10px;">
                                <%=track.getCategory()%>
                            </span>
                            <h2 style="margin:8px 0 6px 0; font-size:24px; font-weight:800; color:var(--text);">
                                <%=track.getTrackName()%>
                            </h2>
                            <p style="margin:0; font-size:14px; color:var(--text-muted); max-width:700px; line-height:1.5;">
                                <%=track.getDescription() != null ? track.getDescription() : "Comprehensive modular preparation track."%>
                            </p>
                        </div>
                        <div style="text-align:right;">
                            <div style="font-size:12px; color:var(--text-muted); text-transform:uppercase;">Overall Track Progress</div>
                            <div style="font-size:36px; font-weight:800; color:var(--primary-light);">
                                <%=track.getProgressPercentage()%>%
                            </div>
                            <span class="track-badge badge-<%=track.getStatus().toLowerCase()%>">
                                <%=track.getStatus().replace('_', ' ')%>
                            </span>
                        </div>
                    </div>

                    <div style="margin-top:20px;">
                        <div class="progress-bar-bg" style="height:12px;">
                            <div class="progress-bar-fill" style="width: <%=track.getProgressPercentage()%>%;"></div>
                        </div>
                    </div>
                </div>

                <!-- Section 12 Required Stats Grid -->
                <div class="stats-grid-row">
                    <div class="stat-card">
                        <div class="stat-title">Overall Progress</div>
                        <div class="stat-value" style="color:var(--primary-light);"><%=track.getProgressPercentage()%>%</div>
                        <div style="font-size:11px; color:var(--text-muted);">Independent Track Score</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-title">Modules</div>
                        <div class="stat-value" style="color:#4ade80;">
                            <%=track.getCompletedModules()%> / <%=track.getTotalModules()%>
                        </div>
                        <div style="font-size:11px; color:var(--text-muted);"><%=track.getModuleProgressPercentage()%>% completed</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-title">Daily Tasks</div>
                        <div class="stat-value" style="color:#60a5fa;">
                            <%=track.getCompletedTasks()%> / <%=track.getTotalTasks()%>
                        </div>
                        <div style="font-size:11px; color:var(--text-muted);"><%=track.getTaskProgressPercentage()%>% completed</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-title">Time Spent</div>
                        <div class="stat-value" style="color:#fbbf24;">
                            <%=hours%>h <%=mins%>m
                        </div>
                        <div style="font-size:11px; color:var(--text-muted);">Dedicated practice time</div>
                    </div>
                    <div class="stat-card" style="grid-column: span 2;">
                        <div class="stat-title">Current Module & Next Task</div>
                        <div style="font-weight:700; font-size:14px; color:var(--text); margin-top:2px;">
                            &rarr; <%=track.getCurrentModuleName()%>
                        </div>
                        <div style="font-size:12px; color:var(--primary-light); margin-top:4px;">
                            Next Task: <%=track.getNextTaskTitle()%>
                        </div>
                    </div>
                </div>

                <!-- Two-Column Layout -->
                <div class="two-col-layout">
                    <!-- Left Column: Curriculum Modules & Daily Tasks -->
                    <div>
                        <!-- Curriculum Modules (Section 12) -->
                        <div class="card" style="margin-bottom:24px;">
                            <div class="d-flex justify-content-between align-items-center" style="margin-bottom:16px;">
                                <div>
                                    <h3 style="margin:0; font-size:18px; font-weight:700;">Curriculum Modules</h3>
                                    <div style="font-size:12px; color:var(--text-muted);">
                                        <%=track.getCompletedModules()%> of <%=track.getTotalModules()%> completed
                                    </div>
                                </div>
                                <span style="font-size:12px; font-weight:700; color:#4ade80;">
                                    <%=track.getModuleProgressPercentage()%>% Module Progress
                                </span>
                            </div>

                            <% 
                                boolean foundCurrent = false;
                                for (LearningModule mod : modules) { 
                                    boolean isDone = "COMPLETED".equals(mod.getStatus());
                                    boolean isCurrent = !isDone && !foundCurrent;
                                    if (isCurrent) foundCurrent = true;
                            %>
                                <div class="module-item <%= isDone ? "status-completed" : (isCurrent ? "status-current" : "") %>">
                                    <div class="d-flex align-items-center gap-3">
                                        <div style="font-size:18px; width:28px; text-align:center;">
                                            <% if (isDone) { %>
                                                <span style="color:#4ade80;">&#10004;</span>
                                            <% } else if (isCurrent) { %>
                                                <span style="color:var(--primary-light); font-weight:800;">&rarr;</span>
                                            <% } else { %>
                                                <span style="color:var(--text-muted);">&#9675;</span>
                                            <% } %>
                                        </div>
                                        <div>
                                            <div style="font-weight:700; font-size:14px; color:<%= isDone ? "#94a3b8" : "var(--text)" %>;">
                                                <%=mod.getModuleName()%>
                                            </div>
                                            <div style="font-size:12px; color:var(--text-muted);">
                                                <%=mod.getDescription() != null ? mod.getDescription() : ""%>
                                            </div>
                                        </div>
                                    </div>

                                    <div>
                                        <% if (isDone) { %>
                                            <span style="font-size:11px; color:#4ade80; font-weight:700;">Completed</span>
                                        <% } else { %>
                                            <form method="POST" action="<%=request.getContextPath()%>/learning/module/complete" style="margin:0;">
                                                <input type="hidden" name="moduleId" value="<%=mod.getModuleId()%>">
                                                <input type="hidden" name="trackId" value="<%=track.getTrackId()%>">
                                                <button type="submit" class="btn btn-secondary btn-sm" style="font-size:11px; padding:3px 8px;">
                                                    Mark Done &#10004;
                                                </button>
                                            </form>
                                        <% } %>
                                    </div>
                                </div>
                            <% } %>
                        </div>

                        <!-- Today's Tasks for this course -->
                        <div class="card" style="margin-bottom:24px;">
                            <div class="d-flex justify-content-between align-items-center" style="margin-bottom:14px;">
                                <div>
                                    <h3 style="margin:0; font-size:18px; font-weight:700;">Today's Practice Tasks</h3>
                                    <div style="font-size:12px; color:var(--text-muted);">
                                        Scheduled daily tasks for <%=track.getTrackName()%>
                                    </div>
                                </div>
                                <span class="badge" style="background:rgba(59, 130, 246, 0.15); color:#60a5fa;">
                                    <%=todayTasks.size()%> <%=todayTasks.size() == 1 ? "task" : "tasks"%> today
                                </span>
                            </div>

                            <% if (todayTasks.isEmpty()) { %>
                                <div style="padding:20px; text-align:center; color:var(--text-muted); font-size:13px; background:var(--surface2); border-radius:var(--radius-md);">
                                    No pending tasks scheduled for today. Great job!
                                </div>
                            <% } else { %>
                                <% for (Map<String, Object> task : todayTasks) { 
                                    int taskId = (Integer) task.get("taskId");
                                    String status = (String) task.get("status");
                                    boolean isDone = "completed".equalsIgnoreCase(status);
                                %>
                                    <div class="task-card-row">
                                        <div style="flex:1;">
                                            <div style="font-weight:600; font-size:14px; color:<%=isDone ? "var(--text-muted)" : "var(--text)"%>; text-decoration:<%=isDone ? "line-through" : "none"%>;">
                                                <%=task.get("title")%>
                                            </div>
                                            <div style="font-size:12px; color:var(--text-muted);">
                                                <span class="badge" style="font-size:10px; padding:2px 6px; background:var(--surface);"><%=task.get("taskType")%></span>
                                                &bull; <%=task.get("estimatedMinutes")%> mins
                                                <% if (task.get("moduleName") != null) { %>
                                                    &bull; <%=task.get("moduleName")%>
                                                <% } %>
                                            </div>
                                        </div>
                                        <div>
                                            <% if (isDone) { %>
                                                <span style="font-size:12px; font-weight:700; color:#4ade80;">&#10004; Done</span>
                                            <% } else { %>
                                                <form method="POST" action="<%=request.getContextPath()%>/learning/task/complete" style="margin:0;">
                                                    <input type="hidden" name="taskId" value="<%=taskId%>">
                                                    <input type="hidden" name="trackId" value="<%=track.getTrackId()%>">
                                                    <input type="hidden" name="timeSpent" value="<%=task.get("estimatedMinutes")%>">
                                                    <button type="submit" class="btn btn-primary btn-sm" style="font-size:11px; padding:4px 10px;">
                                                        Complete Task &#10004;
                                                    </button>
                                                </form>
                                            <% } %>
                                        </div>
                                    </div>
                                <% } %>
                            <% } %>
                        </div>

                        <!-- All Tasks Syllabus & Schedule -->
                        <div class="card">
                            <div class="d-flex justify-content-between align-items-center" style="margin-bottom:14px;">
                                <h3 style="margin:0; font-size:18px; font-weight:700;">Full Practice Task Roster</h3>
                                <span style="font-size:12px; color:var(--text-muted);">
                                    <%=track.getCompletedTasks()%> of <%=track.getTotalTasks()%> done (<%=track.getTaskProgressPercentage()%>%)
                                </span>
                            </div>

                            <div style="max-height:400px; overflow-y:auto; padding-right:6px;">
                                <% for (Map<String, Object> task : tasks) { 
                                    int taskId = (Integer) task.get("taskId");
                                    String status = (String) task.get("status");
                                    boolean isDone = "completed".equalsIgnoreCase(status);
                                %>
                                    <div class="task-card-row" style="padding:10px 14px;">
                                        <div style="flex:1;">
                                            <div style="font-weight:600; font-size:13px; color:<%=isDone ? "var(--text-muted)" : "var(--text)"%>; text-decoration:<%=isDone ? "line-through" : "none"%>;">
                                                <%=task.get("title")%>
                                            </div>
                                            <div style="font-size:11px; color:var(--text-muted);">
                                                <span class="badge" style="font-size:9px; padding:1px 5px; background:var(--surface);"><%=task.get("taskType")%></span>
                                                &bull; <%=task.get("estimatedMinutes")%> mins
                                            </div>
                                        </div>
                                        <div>
                                            <% if (isDone) { %>
                                                <span style="font-size:11px; font-weight:700; color:#4ade80;">&#10004;</span>
                                            <% } else { %>
                                                <form method="POST" action="<%=request.getContextPath()%>/learning/task/complete" style="margin:0;">
                                                    <input type="hidden" name="taskId" value="<%=taskId%>">
                                                    <input type="hidden" name="trackId" value="<%=track.getTrackId()%>">
                                                    <input type="hidden" name="timeSpent" value="<%=task.get("estimatedMinutes")%>">
                                                    <button type="submit" class="btn btn-secondary btn-sm" style="font-size:10px; padding:2px 6px;">
                                                        Mark Done
                                                    </button>
                                                </form>
                                            <% } %>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Course-Specific Analytics & What Did I Complete? -->
                    <div>
                        <!-- Course Analytics with Chart.js (Section 23) -->
                        <div class="card" style="margin-bottom:24px;">
                            <h3 style="margin:0 0 16px 0; font-size:18px; font-weight:700;">Course Analytics</h3>
                            <div style="margin-bottom:20px;">
                                <div style="font-size:12px; font-weight:700; color:var(--text-muted); text-transform:uppercase; margin-bottom:8px;">
                                    Module Progress
                                </div>
                                <canvas id="moduleChart" height="180"></canvas>
                            </div>

                            <div>
                                <div style="font-size:12px; font-weight:700; color:var(--text-muted); text-transform:uppercase; margin-bottom:8px;">
                                    Task Breakdown by Type
                                </div>
                                <canvas id="taskTypeChart" height="180"></canvas>
                            </div>
                        </div>

                        <!-- "What Did I Complete?" View (Section 22) -->
                        <div class="card">
                            <h3 style="margin:0 0 4px 0; font-size:18px; font-weight:700;">What Did I Complete?</h3>
                            <div style="font-size:12px; color:var(--text-muted); margin-bottom:16px;">
                                Completed curriculum milestones and practice log for <%=track.getTrackName()%>.
                            </div>

                            <% if (completedActivities.isEmpty()) { %>
                                <div style="padding:20px; text-align:center; color:var(--text-muted); font-size:13px; background:var(--surface2); border-radius:var(--radius-md);">
                                    No completed activities recorded yet. Complete a module or task to build your practice history!
                                </div>
                            <% } else { %>
                                <div class="activity-timeline">
                                    <% for (Map<String, Object> act : completedActivities) { 
                                        String type = (String) act.get("itemType");
                                        int tSpent = (Integer) act.get("timeSpent");
                                    %>
                                        <div class="timeline-node">
                                            <div class="d-flex align-items-center gap-2">
                                                <span class="badge" style="font-size:10px; background:<%= "MODULE".equals(type) ? "rgba(34, 197, 94, 0.2)" : "rgba(59, 130, 246, 0.2)" %>; color:<%= "MODULE".equals(type) ? "#4ade80" : "#60a5fa" %>;">
                                                    <%=type%>
                                                </span>
                                                <span style="font-size:11px; color:var(--text-muted);">
                                                    <%=act.get("completedAt") != null ? act.get("completedAt").toString().substring(0, 16) : "Completed"%>
                                                </span>
                                            </div>
                                            <div style="font-weight:600; font-size:13px; color:var(--text); margin-top:2px;">
                                                <%=act.get("title")%>
                                            </div>
                                            <% if (tSpent > 0) { %>
                                                <div style="font-size:11px; color:var(--text-muted);">
                                                    Time spent: <%=tSpent%> minutes
                                                </div>
                                            <% } %>
                                        </div>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Chart.js Initialization -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Module Donut Chart
            var completedMods = <%=track.getCompletedModules()%>;
            var pendingMods = Math.max(0, <%=track.getTotalModules()%> - completedMods);
            var ctxMod = document.getElementById('moduleChart');
            if (ctxMod) {
                new Chart(ctxMod, {
                    type: 'doughnut',
                    data: {
                        labels: ['Completed Modules', 'Remaining Modules'],
                        datasets: [{
                            data: [completedMods, pendingMods],
                            backgroundColor: ['#22c55e', '#334155'],
                            borderWidth: 0
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: { position: 'bottom', labels: { color: '#94a3b8', font: { size: 11 } } }
                        },
                        cutout: '70%'
                    }
                });
            }

            // Task Type Chart
            <%
                Map<String, Integer> types = (Map<String, Integer>) analytics.get("taskTypes");
                StringBuilder labelsSb = new StringBuilder("[");
                StringBuilder dataSb = new StringBuilder("[");
                if (types != null) {
                    for (Map.Entry<String, Integer> e : types.entrySet()) {
                        labelsSb.append("'").append(e.getKey()).append("',");
                        dataSb.append(e.getValue()).append(",");
                    }
                }
                labelsSb.append("]");
                dataSb.append("]");
            %>
            var ctxTask = document.getElementById('taskTypeChart');
            if (ctxTask) {
                new Chart(ctxTask, {
                    type: 'bar',
                    data: {
                        labels: <%=labelsSb.toString()%>,
                        datasets: [{
                            label: 'Tasks',
                            data: <%=dataSb.toString()%>,
                            backgroundColor: '#6366f1',
                            borderRadius: 4
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: { beginAtZero: true, ticks: { color: '#94a3b8', stepSize: 1 }, grid: { color: '#334155' } },
                            x: { ticks: { color: '#94a3b8' }, grid: { display: false } }
                        },
                        plugins: {
                            legend: { display: false }
                        }
                    }
                });
            }
        });
    </script>
</body>
</html>
