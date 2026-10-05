<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.interviewx.dao.*,com.interviewx.model.*,java.util.*" %>
<%
    // Authentication check
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    int userId = (Integer) session.getAttribute("userId");
    String fullName = (String) session.getAttribute("fullName");
    String email = (String) session.getAttribute("email");
    String role = (String) session.getAttribute("role");
    if (fullName == null) fullName = "Student";

    // DAOs
    ProfileDAO profileDAO = new ProfileDAO();
    CareerDAO careerDAO = new CareerDAO();
    TaskDAO taskDAO = new TaskDAO();
    CodingProblemDAO codingDAO = new CodingProblemDAO();
    NotificationDAO notifDAO = new NotificationDAO();
    ReadinessDAO readinessDAO = new ReadinessDAO();
    LearningTrackDAO learningTrackDAO = new LearningTrackDAO();

    // Preparation Profiles
    List<PreparationProfile> allProfiles = profileDAO.getProfilesByUserId(userId);
    Integer activeProfileId = (Integer) session.getAttribute("activeProfileId");
    PreparationProfile activeProfile = null;
    if (activeProfileId != null && activeProfileId > 0) {
        activeProfile = profileDAO.getProfileById(activeProfileId);
    }
    if (activeProfile == null) {
        activeProfile = profileDAO.getActiveProfile(userId);
        if (activeProfile != null) {
            session.setAttribute("activeProfileId", activeProfile.getProfileId());
            session.setAttribute("activeProfileRole", activeProfile.getTargetRole());
            session.setAttribute("activeProfileTrackId", activeProfile.getTrackId());
            session.setAttribute("activeProfile", activeProfile);
        }
    }

    int profileId = (activeProfile != null) ? activeProfile.getProfileId() : 0;
    int trackId = (activeProfile != null) ? activeProfile.getTrackId() : 2;
    String targetRole = (activeProfile != null) ? activeProfile.getTargetRole() : "Software Developer";
    int readinessPercent = (activeProfile != null) ? activeProfile.getReadinessPercent() : 25;

    // Profile-specific data
    int solvedProblems = codingDAO.getSubmissionCount(userId, profileId);
    int completedToday = taskDAO.getTodayCompletedCount(userId, profileId);
    int totalToday = taskDAO.getTodayTotalCount(userId, profileId);
    int taskProgress = totalToday > 0 ? (completedToday * 100 / totalToday) : 0;
    int unreadNotifs = notifDAO.getUnreadCount(userId);
    List<Map<String,Object>> todayTasks = taskDAO.getTasksForToday(userId, profileId);

    // Auto-generate tasks if none today
    if (totalToday == 0) {
        taskDAO.generateDailyTasks(userId, profileId, trackId, targetRole);
        todayTasks = taskDAO.getTasksForToday(userId, profileId);
        totalToday = todayTasks.size();
    }

    // Learning Tracks for active profile (Section 20)
    List<LearningTrack> activeLearningTracks = Collections.emptyList();
    Map<String, List<Map<String, Object>>> groupedLearningTasks = Collections.emptyMap();
    if (profileId > 0) {
        activeLearningTracks = learningTrackDAO.getTracksByProfile(profileId, userId);
        groupedLearningTasks = learningTrackDAO.getTodaysTasksGroupedByTrack(profileId, userId);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - InterviewX</title>
    <meta name="description" content="Your personalized placement preparation dashboard on InterviewX">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .profile-context-bar {
            background: linear-gradient(135deg, rgba(99,102,241,0.22), rgba(14,165,233,0.18));
            border: 1px solid rgba(99,102,241,0.4);
            border-radius: var(--radius);
            padding: 18px 24px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
        }
        .profile-role-title {
            font-size: 20px;
            font-weight: 800;
            color: var(--text);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .task-item {
            display: flex; align-items: center; gap: 14px;
            padding: 14px 0; border-bottom: 1px solid rgba(51,65,85,0.5);
        }
        .task-item:last-child { border-bottom: none; }
        .task-check {
            width: 22px; height: 22px; border-radius: 6px;
            border: 2px solid var(--border); cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            background: transparent; color: var(--success); font-size: 14px;
            transition: var(--transition); flex-shrink: 0;
        }
        .task-check.completed {
            background: var(--success); border-color: var(--success); color: #fff;
        }
        .task-info { flex: 1; }
        .task-title { font-size: 14px; font-weight: 600; color: var(--text); }
        .task-title.done { text-decoration: line-through; color: var(--text-muted); }
        .task-desc { font-size: 12px; color: var(--text-muted); margin-top: 2px; }
        .task-type-tag {
            font-size: 11px; font-weight: 700; padding: 2px 8px;
            border-radius: 4px; text-transform: uppercase;
        }
        .learning-track-row {
            padding: 12px 16px;
            background: var(--surface2);
            border-radius: var(--radius-md);
            margin-bottom: 10px;
            border: 1px solid var(--border);
            transition: all 0.2s ease;
        }
        .learning-track-row:hover {
            border-color: var(--primary-light);
        }
    </style>
</head>
<body>
<div class="app-layout">
    <!-- Sidebar -->
    <jsp:include page="/sidebar.jsp" />

    <!-- Main Content -->
    <main class="main-content">
        <!-- Top Navigation -->
        <header class="topbar">
            <div>
                <h1 class="page-title">Placement Command Center</h1>
                <div style="font-size:13px;color:var(--text-muted);">Welcome back, <%=fullName%>! Preparing for <%=targetRole%></div>
            </div>
            <div class="d-flex align-items-center gap-2">
                <a href="<%=request.getContextPath()%>/profiles" class="btn btn-secondary btn-sm">
                    &#128188; My Profiles (<%=allProfiles.size()%>)
                </a>
                <a href="<%=request.getContextPath()%>/learning" class="btn btn-primary btn-sm">
                    &#128218; My Learning
                </a>
            </div>
        </header>

        <div class="content-body">
            <!-- Active Preparation Profile Context Banner -->
            <div class="profile-context-bar">
                <div>
                    <div style="font-size:11px;text-transform:uppercase;letter-spacing:1px;font-weight:700;color:var(--primary-light);margin-bottom:4px;">
                        Active Preparation Context
                    </div>
                    <div class="profile-role-title">
                        <span>&#128188;</span> <%=targetRole%>
                        <span class="badge" style="font-size:11px;padding:3px 8px;background:rgba(34,197,94,0.15);color:#4ade80;font-weight:600;">ACTIVE</span>
                    </div>
                    <div style="font-size:12px;color:var(--text-muted);margin-top:4px;">
                        All roadmaps, coding tasks, mock interviews & readiness below are strictly isolated for this role.
                    </div>
                </div>

                <div class="d-flex align-items-center gap-3">
                    <div style="text-align:right;">
                        <div style="font-size:11px;color:var(--text-muted);text-transform:uppercase;">Role Readiness</div>
                        <div style="font-size:24px;font-weight:800;color:var(--primary-light);"><%=readinessPercent%>%</div>
                    </div>
                    <div class="d-flex flex-column gap-1">
                        <% for (PreparationProfile p : allProfiles) {
                            boolean isActive = (p.getProfileId() == profileId);
                        %>
                            <% if (!isActive) { %>
                                <a href="<%=request.getContextPath()%>/profiles/switch?profileId=<%=p.getProfileId()%>"
                                   class="btn btn-secondary btn-sm" style="font-size:11px;padding:3px 8px;"
                                   title="Switch to <%=p.getTargetRole()%>">
                                    Switch &rarr; <%=p.getTargetRole().split(" ")[0]%> (<%=p.getReadinessPercent()%>%)
                                </a>
                            <% } %>
                        <% } %>
                    </div>
                </div>
            </div>

            <% if (request.getParameter("switched") != null) { %>
                <div class="alert alert-success" style="margin-bottom:20px;">
                    &#10004; Switched active preparation profile to <strong><%=targetRole%></strong>. All context and daily tasks updated.
                </div>
            <% } %>

            <!-- Stats Grid (Profile-Driven) -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value"><%=solvedProblems%></div>
                    <div class="stat-label">Problems Solved</div>
                    <div class="stat-change" style="color:var(--success);">&#128200; CodeLab for <%=targetRole.split(" ")[0]%></div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%=completedToday%>/<%=totalToday%></div>
                    <div class="stat-label">Tasks Today</div>
                    <div class="stat-change">&#9989; <%=taskProgress%>% Complete</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%=activeLearningTracks.size()%></div>
                    <div class="stat-label">Enrolled Courses</div>
                    <div class="stat-change" style="color:var(--primary-light);">&#128218; Active Learning Tracks</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%=readinessPercent%>%</div>
                    <div class="stat-label">Readiness Score</div>
                    <div class="stat-change" style="color:var(--secondary);">&#128200; Multi-factor Score</div>
                </div>
            </div>

            <!-- SECTION 20: "Your Learning Tracks" Section -->
            <div class="card" style="margin-bottom:24px;">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <div>
                        <div class="card-title">&#128218; Your Learning Tracks (<%=targetRole%>)</div>
                        <div class="card-subtitle">Course-specific progress for <%=targetRole%> preparation</div>
                    </div>
                    <a href="<%=request.getContextPath()%>/learning" class="btn btn-primary btn-sm">
                        View All Learning &rarr;
                    </a>
                </div>

                <% if (activeLearningTracks.isEmpty()) { %>
                    <div class="text-center" style="padding:24px; color:var(--text-muted);">
                        <p style="margin:0 0 10px 0;">No learning tracks added yet for <%=targetRole%>.</p>
                        <a href="<%=request.getContextPath()%>/learning#explore-tracks" class="btn btn-secondary btn-sm">
                            + Explore Recommended Tracks
                        </a>
                    </div>
                <% } else { %>
                    <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(280px, 1fr)); gap:14px; margin-bottom:16px;">
                        <% for (LearningTrack lt : activeLearningTracks) { %>
                            <div class="learning-track-row">
                                <div class="d-flex justify-content-between align-items-center" style="margin-bottom:8px;">
                                    <div style="font-weight:700; font-size:14px; color:var(--text);">
                                        <%=lt.getTrackName()%>
                                    </div>
                                    <span style="font-weight:800; font-size:14px; color:var(--primary-light);">
                                        <%=lt.getProgressPercentage()%>%
                                    </span>
                                </div>
                                <div class="progress-bar-container" style="height:8px; margin-bottom:8px;">
                                    <div class="progress-bar" style="width:<%=lt.getProgressPercentage()%>%"></div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center" style="font-size:11px; color:var(--text-muted);">
                                    <span><%=lt.getCompletedModules()%>/<%=lt.getTotalModules()%> Modules (<%=lt.getModuleProgressPercentage()%>%)</span>
                                    <span><%=lt.getCompletedTasks()%>/<%=lt.getTotalTasks()%> Tasks (<%=lt.getTaskProgressPercentage()%>%)</span>
                                    <a href="<%=request.getContextPath()%>/learning/track?id=<%=lt.getTrackId()%>" style="color:var(--primary-light); text-decoration:none; font-weight:600;">
                                        Open &rarr;
                                    </a>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>

            <!-- Main Grid -->
            <div class="grid-2" style="margin-bottom:24px;">
                <!-- Today's Tasks (Profile-Specific) -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <div>
                            <div class="card-title">Today's Preparation Plan (<%=targetRole%>)</div>
                            <div class="card-subtitle"><%=java.time.LocalDate.now().toString()%> &bull; Profile #<%=profileId%></div>
                        </div>
                        <a href="<%=request.getContextPath()%>/tasks" class="btn btn-secondary btn-sm">View All</a>
                    </div>

                    <% if (todayTasks == null || todayTasks.isEmpty()) { %>
                        <div class="text-center" style="padding:30px;color:var(--text-muted);">
                            <p>No tasks remaining for today. Great job!</p>
                            <a href="<%=request.getContextPath()%>/tasks" class="btn btn-secondary btn-sm mt-2">View Task History</a>
                        </div>
                    <% } else { %>
                        <div id="task-list">
                        <% for (Map<String,Object> t : todayTasks) {
                            boolean isDone = "completed".equals(t.get("status"));
                            String tType = (String) t.get("taskType");
                            if (tType == null) tType = "LEARN";
                        %>
                            <div class="task-item" id="task-<%=t.get("taskId")%>">
                                <div class="task-check <%=isDone ? "completed" : ""%>"
                                     onclick="completeTask(<%=t.get("taskId")%>, this)"
                                     title="<%=isDone ? "Completed" : "Mark as complete"%>">
                                    <%=isDone ? "&#10003;" : ""%>
                                </div>
                                <div class="task-info">
                                    <div class="task-title <%=isDone ? "done" : ""%>"><%=t.get("title")%></div>
                                    <div class="task-desc">&#128337; <%=t.get("estimatedMinutes")%> min</div>
                                </div>
                                <span class="task-type-tag" style="background:rgba(99,102,241,0.15);color:var(--primary);"><%=tType%></span>
                            </div>
                        <% } %>
                        </div>
                        <div class="mt-3">
                            <div style="display:flex;justify-content:space-between;font-size:13px;color:var(--text-muted);margin-bottom:6px;">
                                <span>Progress</span><span><%=taskProgress%>%</span>
                            </div>
                            <div class="progress-bar-container">
                                <div class="progress-bar" style="width:<%=taskProgress%>%"></div>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- Quick Actions -->
                <div>
                    <div class="card" style="margin-bottom:16px;">
                        <div class="card-header">
                            <div class="card-title">Practice Arena (<%=targetRole%>)</div>
                        </div>
                        <div class="quick-actions">
                            <a href="<%=request.getContextPath()%>/learning" class="quick-action-card">
                                <span class="quick-action-icon">&#128218;</span>
                                <div class="quick-action-label">My Learning</div>
                                <div class="quick-action-sub">Track Progress</div>
                            </a>
                            <a href="<%=request.getContextPath()%>/career/roadmap" class="quick-action-card">
                                <span class="quick-action-icon">&#128640;</span>
                                <div class="quick-action-label">My Roadmap</div>
                                <div class="quick-action-sub">Syllabus & Modules</div>
                            </a>
                            <a href="<%=request.getContextPath()%>/codelab" class="quick-action-card">
                                <span class="quick-action-icon">&#128187;</span>
                                <div class="quick-action-label">CodeLab</div>
                                <div class="quick-action-sub">Solve Problems</div>
                            </a>
                            <a href="<%=request.getContextPath()%>/interview/start?type=TECHNICAL" class="quick-action-card">
                                <span class="quick-action-icon">&#127908;</span>
                                <div class="quick-action-label">Mock Interview</div>
                                <div class="quick-action-sub">Technical Round</div>
                            </a>
                            <a href="<%=request.getContextPath()%>/resume" class="quick-action-card">
                                <span class="quick-action-icon">&#128196;</span>
                                <div class="quick-action-label">Role Discovery</div>
                                <div class="quick-action-sub">Resume Analysis</div>
                            </a>
                            <a href="<%=request.getContextPath()%>/profiles" class="quick-action-card">
                                <span class="quick-action-icon">&#128188;</span>
                                <div class="quick-action-label">All Profiles</div>
                                <div class="quick-action-sub">Switch Targets</div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
function completeTask(taskId, el) {
    if (el.classList.contains('completed')) return;
    fetch('<%=request.getContextPath()%>/tasks/complete', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'taskId=' + taskId
    }).then(r => r.json()).then(data => {
        if (data.success) {
            el.classList.add('completed');
            el.innerHTML = '&#10003;';
            const title = el.nextElementSibling.querySelector('.task-title');
            if (title) title.classList.add('done');
            setTimeout(() => location.reload(), 600);
        }
    });
}
</script>
</body>
</html>
