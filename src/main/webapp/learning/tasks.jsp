<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.interviewx.model.LearningTrack, com.interviewx.model.PreparationProfile" %>
<%
    PreparationProfile activeProfile = (PreparationProfile) request.getAttribute("activeProfile");
    LearningTrack selectedTrack = (LearningTrack) request.getAttribute("selectedTrack");
    List<Map<String, Object>> tasks = (List<Map<String, Object>>) request.getAttribute("tasks");
    Map<String, List<Map<String, Object>>> groupedTasks = (Map<String, List<Map<String, Object>>>) request.getAttribute("groupedTasks");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Learning Tasks — InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
</head>
<body>
    <div class="app-layout">
        <jsp:include page="/sidebar.jsp" />

        <main class="main-content">
            <header class="topbar">
                <div class="d-flex align-items-center gap-3">
                    <a href="<%=request.getContextPath()%>/learning" class="btn btn-secondary btn-sm">
                        &larr; My Learning
                    </a>
                    <div>
                        <h1 class="page-title" style="margin:0;">
                            <%= selectedTrack != null ? selectedTrack.getTrackName() + " — Tasks" : "Today's Course-Specific Tasks" %>
                        </h1>
                        <div style="font-size:12px; color:var(--text-muted);">
                            Active Target Role: <strong><%=activeProfile != null ? activeProfile.getTargetRole() : "Profile"%></strong>
                        </div>
                    </div>
                </div>
            </header>

            <div class="content-body">
                <% if (selectedTrack != null && tasks != null) { %>
                    <!-- Single Track Task List -->
                    <div class="card" style="margin-bottom:24px;">
                        <div class="d-flex justify-content-between align-items-center" style="margin-bottom:16px;">
                            <div>
                                <h3 style="margin:0;"><%=selectedTrack.getTrackName()%> Task Syllabus</h3>
                                <div style="font-size:13px; color:var(--text-muted);"><%=tasks.size()%> total practice challenges</div>
                            </div>
                            <a href="<%=request.getContextPath()%>/learning/track?id=<%=selectedTrack.getTrackId()%>" class="btn btn-secondary btn-sm">
                                View Course Overview
                            </a>
                        </div>

                        <% for (Map<String, Object> task : tasks) { 
                            int taskId = (Integer) task.get("taskId");
                            String status = (String) task.get("status");
                            boolean isDone = "completed".equalsIgnoreCase(status);
                        %>
                            <div class="d-flex justify-content-between align-items-center" style="padding:14px; background:var(--surface2); border:1px solid var(--border); border-radius:var(--radius-md); margin-bottom:10px;">
                                <div>
                                    <div style="font-weight:600; font-size:14px; color:<%=isDone ? "var(--text-muted)" : "var(--text)"%>; text-decoration:<%=isDone ? "line-through" : "none"%>;">
                                        <%=task.get("title")%>
                                    </div>
                                    <div style="font-size:12px; color:var(--text-muted); margin-top:2px;">
                                        <%=task.get("description")%>
                                    </div>
                                    <div style="font-size:11px; color:var(--text-muted); margin-top:4px;">
                                        <span class="badge" style="font-size:10px; padding:1px 6px; background:var(--surface);"><%=task.get("taskType")%></span>
                                        &bull; <%=task.get("estimatedMinutes")%> mins
                                        &bull; Scheduled: <%=task.get("scheduledDate")%>
                                    </div>
                                </div>
                                <div>
                                    <% if (isDone) { %>
                                        <span style="font-size:12px; font-weight:700; color:#4ade80;">&#10004; Completed</span>
                                    <% } else { %>
                                        <form method="POST" action="<%=request.getContextPath()%>/learning/task/complete" style="margin:0;">
                                            <input type="hidden" name="taskId" value="<%=taskId%>">
                                            <input type="hidden" name="trackId" value="<%=selectedTrack.getTrackId()%>">
                                            <input type="hidden" name="timeSpent" value="<%=task.get("estimatedMinutes")%>">
                                            <button type="submit" class="btn btn-primary btn-sm" style="font-size:11px;">
                                                Complete Task &#10004;
                                            </button>
                                        </form>
                                    <% } %>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else if (groupedTasks != null && !groupedTasks.isEmpty()) { %>
                    <!-- Grouped by Course -->
                    <% for (Map.Entry<String, List<Map<String, Object>>> entry : groupedTasks.entrySet()) { 
                        String trackName = entry.getKey();
                        List<Map<String, Object>> trackTaskList = entry.getValue();
                    %>
                        <div class="card" style="margin-bottom:20px;">
                            <div class="d-flex justify-content-between align-items-center" style="margin-bottom:14px; border-bottom:1px solid var(--border); padding-bottom:10px;">
                                <h3 style="margin:0; font-size:18px; color:var(--primary-light);">
                                    &#128218; <%=trackName%>
                                </h3>
                                <span style="font-size:12px; color:var(--text-muted);">
                                    <%=trackTaskList.size()%> tasks scheduled for today
                                </span>
                            </div>

                            <% for (Map<String, Object> task : trackTaskList) { 
                                int taskId = (Integer) task.get("taskId");
                                int ltId = (Integer) task.get("learningTrackId");
                                String status = (String) task.get("status");
                                boolean isDone = "completed".equalsIgnoreCase(status);
                            %>
                                <div class="d-flex justify-content-between align-items-center" style="padding:12px 14px; background:var(--surface2); border:1px solid var(--border); border-radius:var(--radius-md); margin-bottom:10px;">
                                    <div>
                                        <div style="font-weight:600; font-size:14px; color:<%=isDone ? "var(--text-muted)" : "var(--text)"%>; text-decoration:<%=isDone ? "line-through" : "none"%>;">
                                            <%=task.get("title")%>
                                        </div>
                                        <div style="font-size:12px; color:var(--text-muted);">
                                            <span class="badge" style="font-size:10px; padding:1px 5px; background:var(--surface);"><%=task.get("taskType")%></span>
                                            &bull; <%=task.get("estimatedMinutes")%> mins
                                            <% if (task.get("moduleName") != null) { %>
                                                &bull; Module: <%=task.get("moduleName")%>
                                            <% } %>
                                        </div>
                                    </div>
                                    <div>
                                        <% if (isDone) { %>
                                            <span style="font-size:12px; font-weight:700; color:#4ade80;">&#10004; Done</span>
                                        <% } else { %>
                                            <form method="POST" action="<%=request.getContextPath()%>/learning/task/complete" style="margin:0;">
                                                <input type="hidden" name="taskId" value="<%=taskId%>">
                                                <input type="hidden" name="trackId" value="<%=ltId%>">
                                                <input type="hidden" name="timeSpent" value="<%=task.get("estimatedMinutes")%>">
                                                <input type="hidden" name="redirect" value="<%=request.getContextPath()%>/learning/tasks">
                                                <button type="submit" class="btn btn-secondary btn-sm" style="font-size:11px;">
                                                    Mark Done &#10004;
                                                </button>
                                            </form>
                                        <% } %>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                <% } else { %>
                    <div class="empty-state" style="padding:48px 24px; text-align:center; background:var(--surface); border:1px dashed var(--border); border-radius:var(--radius-lg);">
                        <div style="font-size:40px; margin-bottom:12px;">&#9989;</div>
                        <h4 style="margin:0 0 8px 0; color:var(--text);">No Tasks Scheduled</h4>
                        <p style="color:var(--text-muted); max-width:400px; margin:0 auto 16px auto; font-size:14px;">
                            You have no daily learning tasks scheduled for today. Check your learning courses or enroll in a new track!
                        </p>
                        <a href="<%=request.getContextPath()%>/learning" class="btn btn-primary btn-sm">
                            Go to My Learning
                        </a>
                    </div>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>
