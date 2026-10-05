<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.interviewx.model.*, java.util.*" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String fullName = (String) session.getAttribute("fullName");
    Integer activeProfileId = (Integer) session.getAttribute("activeProfileId");
    if (activeProfileId == null) activeProfileId = 0;

    @SuppressWarnings("unchecked")
    List<PreparationProfile> profiles = (List<PreparationProfile>) request.getAttribute("profiles");
    @SuppressWarnings("unchecked")
    List<CareerTrack> allTracks = (List<CareerTrack>) request.getAttribute("allTracks");
    Student student = (Student) request.getAttribute("student");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Preparation Profiles - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .profile-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 22px;
            transition: var(--transition);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-width: 0;
            overflow: hidden;
        }
        .profile-card:hover {
            border-color: var(--primary);
            box-shadow: 0 8px 30px rgba(0,0,0,0.4);
            transform: translateY(-2px);
        }
        .profile-card.active-profile {
            border: 2px solid var(--primary);
            background: linear-gradient(180deg, rgba(99,102,241,0.08), var(--surface));
        }
        .active-tag-badge {
            background: rgba(16,185,129,0.18);
            color: var(--success);
            border: 1px solid rgba(16,185,129,0.4);
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 12px;
            white-space: nowrap;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            flex-shrink: 0;
        }
        .stat-mini-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            margin: 16px 0;
            background: var(--dark);
            padding: 12px;
            border-radius: var(--radius-sm);
        }
        .stat-mini-item {
            font-size: 12px;
        }
        .stat-mini-item span {
            display: block;
            color: var(--text-muted);
            font-size: 11px;
            margin-bottom: 2px;
        }
        .stat-mini-item strong {
            font-size: 14px;
            color: var(--text);
        }
        .profiles-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(310px, 1fr));
            gap: 20px;
            margin-bottom: 36px;
            width: 100%;
        }
        @media (max-width: 576px) {
            .profiles-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="/sidebar.jsp" %>
    <main class="main-content">
        <!-- Page Header with responsive flex wrapping and overflow prevention -->
        <div class="page-header d-flex justify-content-between align-items-center flex-wrap gap-3" style="max-width: 100%;">
            <div style="min-width: 0; flex: 1 1 300px;">
                <h1>&#128188; My Preparation Profiles</h1>
                <p>Manage and switch between your independent career role targets</p>
            </div>
            <div class="d-flex gap-2 flex-wrap">
                <a href="<%=request.getContextPath()%>/resume" class="btn btn-primary">
                    &#129302; Discover Roles with Resume &rarr;
                </a>
            </div>
        </div>

        <% if (request.getParameter("switched") != null) { %>
            <div class="alert alert-success" style="margin-bottom:20px;">
                &#10003; Successfully switched active preparation context to: <strong><%=request.getParameter("role") != null ? request.getParameter("role") : "Selected Role"%></strong>.
            </div>
        <% } %>

        <% if (profiles == null || profiles.isEmpty()) { %>
            <div class="card text-center" style="padding:50px;">
                <div style="font-size:48px;margin-bottom:14px;">&#127919;</div>
                <h2>No Preparation Profiles Yet</h2>
                <p style="color:var(--text-muted);max-width:500px;margin:0 auto 24px;">
                    Start by discovering career roles that match your technical background, or select a role to begin your tailored preparation.
                </p>
                <div class="d-flex justify-content-center gap-3 flex-wrap">
                    <a href="<%=request.getContextPath()%>/resume" class="btn btn-primary">
                        Upload Resume & Discover Roles
                    </a>
                    <a href="<%=request.getContextPath()%>/career/choose" class="btn btn-secondary">
                        Browse 15 Career Tracks
                    </a>
                </div>
            </div>
        <% } else { %>
            <div class="profiles-grid">
                <% for (PreparationProfile p : profiles) {
                    boolean isActive = (p.getProfileId() == activeProfileId);
                %>
                    <div class="profile-card <%=isActive ? "active-profile" : ""%>">
                        <div>
                            <!-- Header with Role info and ACTIVE CONTEXT badge without overlap -->
                            <div class="d-flex justify-content-between align-items-start gap-2" style="margin-bottom: 14px; min-width: 0;">
                                <div class="d-flex align-items-center gap-3" style="min-width: 0; flex: 1;">
                                    <div class="user-avatar" style="width:46px;height:46px;font-size:18px;background:var(--surface2);flex-shrink:0;">
                                        <%=p.getTrackIcon()%>
                                    </div>
                                    <div style="min-width: 0; flex: 1;">
                                        <h3 style="font-size:17px;font-weight:700;margin:0;color:var(--text);word-break:break-word;line-height:1.3;">
                                            <%=p.getTargetRole()%>
                                        </h3>
                                        <div style="font-size:12px;color:var(--text-muted);margin-top:2px;">
                                            Profile #<%=p.getProfileId()%> &bull; <%=p.getStatus().toUpperCase()%>
                                        </div>
                                    </div>
                                </div>
                                <% if (isActive) { %>
                                    <span class="active-tag-badge">
                                        &#10003; ACTIVE
                                    </span>
                                <% } %>
                            </div>

                            <!-- Readiness Score Dial -->
                            <div style="margin:12px 0;">
                                <div class="d-flex justify-content-between" style="font-size:13px;margin-bottom:6px;">
                                    <span style="color:var(--text-muted);">Placement Readiness</span>
                                    <strong style="color:var(--primary-light);font-size:14px;"><%=p.getReadinessPercent()%>%</strong>
                                </div>
                                <div class="progress-bar-container" style="height:8px;">
                                    <div class="progress-bar" style="width:<%=p.getReadinessPercent()%>%;"></div>
                                </div>
                            </div>

                            <!-- Stats Mini Grid -->
                            <div class="stat-mini-grid">
                                <div class="stat-mini-item">
                                    <span>Roadmap Modules</span>
                                    <strong><%=p.getModulesCompleted()%> / <%=p.getTotalModules()%></strong>
                                </div>
                                <div class="stat-mini-item">
                                    <span>Today's Tasks</span>
                                    <strong><%=p.getTasksCompleted()%> / <%=p.getTotalTasks()%></strong>
                                </div>
                                <div class="stat-mini-item">
                                    <span>CodeLab Solved</span>
                                    <strong><%=p.getProblemsSolved()%></strong>
                                </div>
                                <div class="stat-mini-item">
                                    <span>Mock Interviews</span>
                                    <strong><%=p.getInterviewAttempts()%></strong>
                                </div>
                            </div>
                        </div>

                        <div style="margin-top:14px;padding-top:14px;border-top:1px solid var(--border);">
                            <% if (isActive) { %>
                                <div class="d-flex gap-2">
                                    <a href="<%=request.getContextPath()%>/dashboard.jsp" class="btn btn-primary btn-sm btn-full" style="justify-content:center;">
                                        Open Dashboard &rarr;
                                    </a>
                                </div>
                            <% } else { %>
                                <a href="<%=request.getContextPath()%>/profiles/switch?profileId=<%=p.getProfileId()%>"
                                   class="btn btn-secondary btn-sm btn-full" style="justify-content:center;font-weight:700;">
                                    &#8644; Switch to <%=p.getTargetRole()%>
                                </a>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>

        <!-- Direct Track Selection (Duplicate Checked) -->
        <div class="card" style="margin-top:20px;max-width:100%;">
            <div class="card-header">
                <div class="card-title">&#10010; Quick Add Another Career Target</div>
                <div class="card-subtitle">Choose from standard tracks or use Resume Role Discovery above</div>
            </div>
            <form action="<%=request.getContextPath()%>/profiles/create" method="POST" class="d-flex gap-3 align-items-center flex-wrap">
                <div style="flex:1;min-width:240px;">
                    <select name="trackId" class="form-control" id="trackSelect" onchange="updateRoleName(this)">
                        <% if (allTracks != null) {
                            for (CareerTrack ct : allTracks) { %>
                                <option value="<%=ct.getTrackId()%>" data-name="<%=ct.getTrackName()%>">
                                    <%=ct.getTrackName()%>
                                </option>
                        <%  }
                           } %>
                    </select>
                    <input type="hidden" name="roleName" id="selectedRoleName" value="Frontend Developer">
                </div>
                <button type="submit" class="btn btn-secondary">
                    &#10010; Add Target Profile
                </button>
            </form>
        </div>
    </main>
</div>

<script>
function updateRoleName(sel) {
    const opt = sel.options[sel.selectedIndex];
    document.getElementById('selectedRoleName').value = opt.getAttribute('data-name');
}
document.addEventListener('DOMContentLoaded', function() {
    const sel = document.getElementById('trackSelect');
    if (sel) updateRoleName(sel);
});
</script>
</body>
</html>
