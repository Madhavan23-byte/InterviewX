<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.interviewx.model.LearningTrack, com.interviewx.model.PreparationProfile, com.interviewx.service.LearningTrackService.TrackRecommendation" %>
<%
    PreparationProfile activeProfile = (PreparationProfile) request.getAttribute("activeProfile");
    List<LearningTrack> tracks = (List<LearningTrack>) request.getAttribute("tracks");
    if (tracks == null) tracks = Collections.emptyList();

    Map<String, List<Map<String, Object>>> groupedTodayTasks = (Map<String, List<Map<String, Object>>>) request.getAttribute("groupedTodayTasks");
    if (groupedTodayTasks == null) groupedTodayTasks = Collections.emptyMap();

    List<TrackRecommendation> recommendations = (List<TrackRecommendation>) request.getAttribute("recommendedTracks");
    if (recommendations == null) recommendations = Collections.emptyList();

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");

    int totalActiveTracks = 0;
    int completedTracks = 0;
    int totalModulesDone = 0;
    int totalTasksToday = 0;

    for (LearningTrack t : tracks) {
        if ("COMPLETED".equals(t.getStatus())) completedTracks++;
        else totalActiveTracks++;
        totalModulesDone += t.getCompletedModules();
        totalTasksToday += t.getTodaysTasksCount();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Learning Tracks — InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .learning-header {
            background: linear-gradient(135deg, rgba(30, 41, 59, 0.9) 0%, rgba(15, 23, 42, 0.95) 100%);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 24px 28px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
        }
        .track-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .track-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 24px;
            transition: all 0.25s ease;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .track-card:hover {
            transform: translateY(-3px);
            border-color: var(--primary-light);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.4);
        }
        .track-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 14px;
        }
        .track-card-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--text);
            margin: 0 0 6px 0;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .track-badge {
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 9999px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .badge-in_progress { background: rgba(59, 130, 246, 0.15); color: #60a5fa; border: 1px solid rgba(59, 130, 246, 0.3); }
        .badge-completed { background: rgba(34, 197, 94, 0.15); color: #4ade80; border: 1px solid rgba(34, 197, 94, 0.3); }
        .badge-paused { background: rgba(245, 158, 11, 0.15); color: #fbbf24; border: 1px solid rgba(245, 158, 11, 0.3); }
        .badge-not_started { background: rgba(148, 163, 184, 0.15); color: #94a3b8; border: 1px solid rgba(148, 163, 184, 0.3); }

        .progress-container {
            margin: 16px 0;
        }
        .progress-label-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
            margin-bottom: 6px;
        }
        .progress-pct {
            font-weight: 700;
            color: var(--primary-light);
            font-size: 15px;
        }
        .progress-bar-bg {
            height: 10px;
            background: var(--surface2);
            border-radius: 9999px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }
        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--primary) 0%, var(--primary-light) 100%);
            border-radius: 9999px;
            transition: width 0.6s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .metrics-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin: 14px 0;
            padding: 12px;
            background: var(--surface2);
            border-radius: var(--radius-md);
            font-size: 13px;
        }
        .metric-item {
            display: flex;
            flex-direction: column;
        }
        .metric-title {
            color: var(--text-muted);
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 2px;
        }
        .metric-value {
            font-weight: 700;
            color: var(--text);
        }

        .today-tasks-section {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-bottom: 30px;
        }
        .task-group-card {
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            background: var(--surface2);
            padding: 16px 20px;
            margin-bottom: 14px;
        }
        .task-item-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        .task-item-row:last-child {
            border-bottom: none;
        }
        .rec-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 16px;
        }
        .rec-card {
            background: var(--surface);
            border: 1px dashed var(--border);
            border-radius: var(--radius-md);
            padding: 18px;
            transition: all 0.2s;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .rec-card:hover {
            border-color: var(--primary);
            background: rgba(99, 102, 241, 0.03);
        }
    </style>
</head>
<body>
    <div class="app-layout">
        <jsp:include page="/sidebar.jsp" />

        <main class="main-content">
            <header class="topbar">
                <div>
                    <h1 class="page-title" style="margin:0;">My Learning Tracks & Courses</h1>
                    <div style="font-size:13px; color:var(--text-muted);">
                        Course-specific modular curriculum and daily targeted study tasks
                    </div>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <a href="<%=request.getContextPath()%>/learning/tasks" class="btn btn-secondary btn-sm">
                        &#128197; Today's Tasks Plan
                    </a>
                    <a href="#explore-tracks" class="btn btn-primary btn-sm">
                        + Add Learning Track
                    </a>
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

                <!-- Active Preparation Profile Banner -->
                <div class="learning-header">
                    <div>
                        <div style="font-size:11px; text-transform:uppercase; font-weight:700; color:var(--primary-light); letter-spacing:1px; margin-bottom:4px;">
                            Active Preparation Context
                        </div>
                        <h2 style="margin:0 0 6px 0; font-size:22px; color:var(--text); font-weight:700;">
                            <%= (activeProfile != null) ? activeProfile.getTargetRole() : "General Engineering" %>
                        </h2>
                        <div style="font-size:13px; color:var(--text-muted); max-width:650px;">
                            All learning tracks, syllabus modules, daily tasks, and progress below belong exclusively to your 
                            <strong><%= (activeProfile != null) ? activeProfile.getTargetRole() : "active" %></strong> preparation profile.
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-3">
                        <div style="text-align:right;">
                            <div style="font-size:11px; color:var(--text-muted); text-transform:uppercase;">Role Readiness</div>
                            <div style="font-size:24px; font-weight:800; color:var(--primary-light);">
                                <%= (activeProfile != null) ? activeProfile.getReadinessScore() : 0.0 %>%
                            </div>
                        </div>
                        <a href="<%=request.getContextPath()%>/profiles" class="btn btn-secondary btn-sm" title="Switch to another role profile">
                            &#8644; Switch Profile
                        </a>
                    </div>
                </div>

                <!-- Metrics Overview -->
                <div class="d-flex gap-3 flex-wrap" style="margin-bottom:24px;">
                    <div class="stat-card" style="flex:1; min-width:180px;">
                        <div class="stat-title">Active Courses</div>
                        <div class="stat-value" style="color:#60a5fa;"><%=totalActiveTracks%></div>
                        <div style="font-size:12px; color:var(--text-muted);"><%=completedTracks%> completed</div>
                    </div>
                    <div class="stat-card" style="flex:1; min-width:180px;">
                        <div class="stat-title">Completed Modules</div>
                        <div class="stat-value" style="color:#4ade80;"><%=totalModulesDone%></div>
                        <div style="font-size:12px; color:var(--text-muted);">Across all tracks</div>
                    </div>
                    <div class="stat-card" style="flex:1; min-width:180px;">
                        <div class="stat-title">Today's Tasks</div>
                        <div class="stat-value" style="color:#fbbf24;"><%=totalTasksToday%></div>
                        <div style="font-size:12px; color:var(--text-muted);">Scheduled for today</div>
                    </div>
                </div>

                <!-- Learning Tracks Grid -->
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
                    <h3 style="margin:0; font-size:18px; font-weight:700;">Your Enrolled Learning Tracks</h3>
                    <div style="font-size:12px; color:var(--text-muted);">
                        <%=tracks.size()%> <%=tracks.size() == 1 ? "track" : "tracks"%> enrolled
                    </div>
                </div>

                <% if (tracks.isEmpty()) { %>
                    <div class="empty-state" style="padding:48px 24px; text-align:center; background:var(--surface); border:1px dashed var(--border); border-radius:var(--radius-lg); margin-bottom:30px;">
                        <div style="font-size:40px; margin-bottom:12px;">&#128218;</div>
                        <h4 style="margin:0 0 8px 0; color:var(--text);">No learning tracks enrolled yet</h4>
                        <p style="color:var(--text-muted); max-width:500px; margin:0 auto 16px auto; font-size:14px;">
                            Start an independent learning track below to begin structured syllabus modules and daily practice tasks for your <%= (activeProfile != null) ? activeProfile.getTargetRole() : "target" %> profile.
                        </p>
                        <a href="#explore-tracks" class="btn btn-primary btn-sm">
                            + Choose a Recommended Track
                        </a>
                    </div>
                <% } else { %>
                    <div class="track-grid">
                        <% for (LearningTrack t : tracks) { %>
                            <div class="track-card">
                                <div>
                                    <div class="track-card-header">
                                        <div>
                                            <span style="font-size:11px; text-transform:uppercase; letter-spacing:0.5px; color:var(--primary-light); font-weight:700;">
                                                <%=t.getCategory()%>
                                            </span>
                                            <h4 class="track-card-title"><%=t.getTrackName()%></h4>
                                        </div>
                                        <span class="track-badge badge-<%=t.getStatus().toLowerCase()%>">
                                            <%=t.getStatus().replace('_', ' ')%>
                                        </span>
                                    </div>

                                    <!-- Progress Bar -->
                                    <div class="progress-container">
                                        <div class="progress-label-row">
                                            <span style="color:var(--text-muted);">Overall Progress</span>
                                            <span class="progress-pct"><%=t.getProgressPercentage()%>%</span>
                                        </div>
                                        <div class="progress-bar-bg">
                                            <div class="progress-bar-fill" style="width: <%=t.getProgressPercentage()%>%;"></div>
                                        </div>
                                    </div>

                                    <!-- Metrics Breakdown (Independent Module and Task progress) -->
                                    <div class="metrics-grid">
                                        <div class="metric-item">
                                            <span class="metric-title">Modules Completed</span>
                                            <span class="metric-value">
                                                <%=t.getCompletedModules()%> / <%=t.getTotalModules()%>
                                                <span style="font-size:11px; font-weight:400; color:var(--text-muted);">
                                                    (<%=t.getModuleProgressPercentage()%>%)
                                                </span>
                                            </span>
                                        </div>
                                        <div class="metric-item">
                                            <span class="metric-title">Tasks Completed</span>
                                            <span class="metric-value">
                                                <%=t.getCompletedTasks()%> / <%=t.getTotalTasks()%>
                                                <span style="font-size:11px; font-weight:400; color:var(--text-muted);">
                                                    (<%=t.getTaskProgressPercentage()%>%)
                                                </span>
                                            </span>
                                        </div>
                                        <div class="metric-item" style="grid-column: span 2;">
                                            <span class="metric-title">Current Topic</span>
                                            <span class="metric-value" style="font-size:12px; font-weight:500; color:var(--text-muted); white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
                                                &rarr; <%=t.getCurrentModuleName() != null ? t.getCurrentModuleName() : "Ready to begin"%>
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="d-flex align-items-center justify-content-between" style="margin-top:16px; pt-2; border-top:1px solid rgba(255,255,255,0.05);">
                                    <div style="font-size:12px; color:var(--text-muted);">
                                        <strong><%=t.getTodaysTasksCount()%></strong> today's <%=t.getTodaysTasksCount() == 1 ? "task" : "tasks"%>
                                    </div>
                                    <a href="<%=request.getContextPath()%>/learning/track?id=<%=t.getTrackId()%>" class="btn btn-primary btn-sm">
                                        View Course &rarr;
                                    </a>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>

                <!-- Today's Tasks Grouped by Track (Section 4, 10) -->
                <% if (!groupedTodayTasks.isEmpty()) { %>
                    <div class="today-tasks-section">
                        <div class="d-flex justify-content-between align-items-center" style="margin-bottom:18px;">
                            <div>
                                <h3 style="margin:0 0 4px 0; font-size:18px; font-weight:700;">Today's Learning Tasks by Track</h3>
                                <div style="font-size:13px; color:var(--text-muted);">
                                    Tasks are organized per course so your daily learning plan is completely transparent.
                                </div>
                            </div>
                            <a href="<%=request.getContextPath()%>/learning/tasks" class="btn btn-secondary btn-sm">
                                View Full Schedule
                            </a>
                        </div>

                        <% for (Map.Entry<String, List<Map<String, Object>>> entry : groupedTodayTasks.entrySet()) { 
                            String trackName = entry.getKey();
                            List<Map<String, Object>> tasksList = entry.getValue();
                        %>
                            <div class="task-group-card">
                                <div class="d-flex justify-content-between align-items-center" style="margin-bottom:10px; border-bottom:1px solid var(--border); padding-bottom:8px;">
                                    <div class="d-flex align-items-center gap-2">
                                        <span style="font-size:14px; font-weight:700; color:var(--primary-light); text-transform:uppercase;">
                                            &#128218; <%=trackName%>
                                        </span>
                                    </div>
                                    <span style="font-size:12px; color:var(--text-muted);">
                                        <%=tasksList.size()%> <%=tasksList.size() == 1 ? "task" : "tasks"%>
                                    </span>
                                </div>

                                <% for (Map<String, Object> task : tasksList) { 
                                    int taskId = (Integer) task.get("taskId");
                                    int ltId = (Integer) task.get("learningTrackId");
                                    String status = (String) task.get("status");
                                    boolean isDone = "completed".equalsIgnoreCase(status);
                                %>
                                    <div class="task-item-row">
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
                                                <span style="font-size:12px; font-weight:700; color:#4ade80;">&#10004; Completed</span>
                                            <% } else { %>
                                                <form method="POST" action="<%=request.getContextPath()%>/learning/task/complete" style="display:inline;">
                                                    <input type="hidden" name="taskId" value="<%=taskId%>">
                                                    <input type="hidden" name="trackId" value="<%=ltId%>">
                                                    <input type="hidden" name="timeSpent" value="<%=task.get("estimatedMinutes")%>">
                                                    <input type="hidden" name="redirect" value="<%=request.getContextPath()%>/learning">
                                                    <button type="submit" class="btn btn-secondary btn-sm" style="font-size:11px; padding:4px 10px;">
                                                        Mark Done &#10004;
                                                    </button>
                                                </form>
                                            <% } %>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                <% } %>

                <!-- Recommended Tracks Section (Section 5, 25) -->
                <div id="explore-tracks" style="margin-top:30px;">
                    <div style="margin-bottom:16px;">
                        <h3 style="margin:0 0 4px 0; font-size:18px; font-weight:700;">
                            Recommended Courses for <%= (activeProfile != null) ? activeProfile.getTargetRole() : "Your Profile" %>
                        </h3>
                        <div style="font-size:13px; color:var(--text-muted);">
                            Tailored course tracks recommended based on your target role, roadmap, and required technical competencies.
                        </div>
                    </div>

                    <% if (recommendations.isEmpty()) { %>
                        <div style="padding:16px; background:var(--surface); border:1px solid var(--border); border-radius:var(--radius-md); color:var(--text-muted); font-size:13px;">
                            All recommended learning tracks for this role are already active in your profile!
                        </div>
                    <% } else { %>
                        <div class="rec-grid">
                            <% for (TrackRecommendation rec : recommendations) { %>
                                <div class="rec-card">
                                    <div>
                                        <div class="d-flex justify-content-between align-items-center" style="margin-bottom:8px;">
                                            <span style="font-size:11px; text-transform:uppercase; color:var(--primary-light); font-weight:700;">
                                                <%=rec.getCategory()%>
                                            </span>
                                        </div>
                                        <h4 style="margin:0 0 6px 0; font-size:16px; color:var(--text); font-weight:700;">
                                            <%=rec.getTrackName()%>
                                        </h4>
                                        <p style="font-size:12px; color:var(--text-muted); margin:0 0 10px 0; line-height:1.4;">
                                            <%=rec.getDescription()%>
                                        </p>
                                        <div style="font-size:11px; color:#94a3b8; background:var(--surface2); padding:6px 8px; border-radius:4px; margin-bottom:14px;">
                                            &#128161; <%=rec.getWhyRecommended()%>
                                        </div>
                                    </div>
                                    <form method="POST" action="<%=request.getContextPath()%>/learning/create">
                                        <input type="hidden" name="trackName" value="<%=rec.getTrackName()%>">
                                        <input type="hidden" name="description" value="<%=rec.getDescription()%>">
                                        <input type="hidden" name="category" value="<%=rec.getCategory()%>">
                                        <input type="hidden" name="icon" value="<%=rec.getIcon()%>">
                                        <button type="submit" class="btn btn-secondary btn-sm btn-full" style="justify-content:center;">
                                            + Start Course
                                        </button>
                                    </form>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                </div>

                <!-- Custom Course Creation -->
                <div style="margin-top:30px; background:var(--surface); border:1px solid var(--border); border-radius:var(--radius-lg); padding:20px 24px;">
                    <h4 style="margin:0 0 8px 0; font-size:16px;">Add a Custom Learning Track</h4>
                    <p style="font-size:13px; color:var(--text-muted); margin:0 0 16px 0;">
                        Want to learn a specific topic not listed above? Create a custom course and the system will automatically scaffold structured syllabus modules and practice tasks.
                    </p>
                    <form method="POST" action="<%=request.getContextPath()%>/learning/create" class="d-flex gap-2 flex-wrap">
                        <input type="text" name="trackName" placeholder="e.g. Docker & Kubernetes, Rust, System Design" class="form-input" style="flex:1; min-width:240px;" required>
                        <input type="text" name="category" placeholder="Category (e.g. DevOps, Core, Tool)" class="form-input" style="width:180px;">
                        <button type="submit" class="btn btn-primary btn-sm">
                            Create & Scaffold Track
                        </button>
                    </form>
                </div>

                <!-- Section 28 Benchmark Runner (Optional Quick Setup) -->
                <% if (activeProfile != null && activeProfile.getTargetRole().toLowerCase().contains("ai")) { %>
                    <div style="margin-top:24px; padding:16px 20px; background:rgba(99, 102, 241, 0.08); border:1px solid rgba(99, 102, 241, 0.25); border-radius:var(--radius-md); display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
                        <div>
                            <div style="font-size:13px; font-weight:700; color:var(--primary-light);">
                                &#9874; Section 28 Test Benchmark Setup
                            </div>
                            <div style="font-size:12px; color:var(--text-muted);">
                                Automatically configure Machine Learning (10 modules, 6 done; 20 tasks, 12 done) and Frontend Development (8 modules, 3 done; 21 tasks, 8 done).
                            </div>
                        </div>
                        <form method="POST" action="<%=request.getContextPath()%>/learning/benchmark">
                            <button type="submit" class="btn btn-secondary btn-sm">
                                Run Section 28 Benchmark
                            </button>
                        </form>
                    </div>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>
