<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.interviewx.model.Student" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    Student student = (Student) request.getAttribute("student");
    if (student == null) student = new Student();
    String fullName = (String) session.getAttribute("fullName");
    String email = (String) session.getAttribute("email");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <header class="topbar">
        <div class="topbar-left"><span class="page-title">My Profile</span></div>
        <div class="topbar-right">
            <div class="user-menu">
                <div class="user-avatar"><%=fullName != null && fullName.length() > 0 ? fullName.charAt(0) : "S"%></div>
                <span class="user-name"><%=fullName%></span>
            </div>
        </div>
    </header>
    <main class="main-content">
        <div class="page-header">
            <h1>&#128100; Student Profile</h1>
            <p>Keep your profile updated for personalized recommendations</p>
        </div>

        <% if (success != null) { %><div class="alert alert-success">&#9989; <%=success%></div><% } %>
        <% if (error != null) { %><div class="alert alert-danger">&#10060; <%=error%></div><% } %>

        <div class="grid-2">
            <div class="card">
                <div class="card-header"><div class="card-title">Personal Information</div></div>
                <form method="post" action="<%=request.getContextPath()%>/profile">
                    <div class="form-group">
                        <label class="form-label">Full Name</label>
                        <input type="text" class="form-control" value="<%=fullName != null ? fullName : ""%>" readonly style="opacity:0.6;">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" value="<%=email != null ? email : ""%>" readonly style="opacity:0.6;">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Phone</label>
                        <input type="text" name="phone" class="form-control" value="<%=student.getPhone() != null ? student.getPhone() : ""%>" placeholder="Your phone number">
                    </div>
                    <div class="form-group">
                        <label class="form-label">College Name</label>
                        <input type="text" name="collegeName" class="form-control" value="<%=student.getCollegeName() != null ? student.getCollegeName() : ""%>" placeholder="Your college">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Degree / Branch</label>
                        <input type="text" name="degree" class="form-control" value="<%=student.getDegree() != null ? student.getDegree() : ""%>" placeholder="e.g., B.Tech Computer Science">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Graduation Year</label>
                        <input type="number" name="graduationYear" class="form-control" value="<%=student.getGraduationYear() > 0 ? student.getGraduationYear() : ""%>" placeholder="2025" min="2024" max="2030">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Target Role</label>
                        <input type="text" name="targetRole" class="form-control" value="<%=student.getTargetRole() != null ? student.getTargetRole() : ""%>" placeholder="e.g., Backend Developer">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Programming Experience</label>
                        <select name="programmingExperience" class="form-control">
                            <option value="">Select experience level</option>
                            <option value="Beginner" <%="Beginner".equals(student.getProgrammingExperience()) ? "selected" : ""%>>Beginner (0-6 months)</option>
                            <option value="Intermediate" <%="Intermediate".equals(student.getProgrammingExperience()) ? "selected" : ""%>>Intermediate (6 months - 2 years)</option>
                            <option value="Advanced" <%="Advanced".equals(student.getProgrammingExperience()) ? "selected" : ""%>>Advanced (2+ years)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Skills (comma-separated)</label>
                        <input type="text" name="skills" class="form-control" value="<%=student.getSkills() != null ? student.getSkills() : ""%>" placeholder="Java, SQL, Python, JavaScript...">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Interests</label>
                        <input type="text" name="interests" class="form-control" value="<%=student.getInterests() != null ? student.getInterests() : ""%>" placeholder="Web development, AI, Cloud...">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Career Goals</label>
                        <textarea name="careerGoals" class="form-control" placeholder="What do you want to achieve in your career?"><%=student.getCareerGoals() != null ? student.getCareerGoals() : ""%></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">LinkedIn URL</label>
                        <input type="url" name="linkedinUrl" class="form-control" value="<%=student.getLinkedinUrl() != null ? student.getLinkedinUrl() : ""%>" placeholder="https://linkedin.com/in/...">
                    </div>
                    <div class="form-group">
                        <label class="form-label">GitHub URL</label>
                        <input type="url" name="githubUrl" class="form-control" value="<%=student.getGithubUrl() != null ? student.getGithubUrl() : ""%>" placeholder="https://github.com/...">
                    </div>
                    <button type="submit" class="btn btn-primary btn-full">&#128190; Save Profile</button>
                </form>
            </div>

            <!-- Profile Completion Card -->
            <div>
                <div class="card" style="margin-bottom:16px;">
                    <div class="card-title" style="margin-bottom:16px;">Profile Completion</div>
                    <%
                        int filledFields = 0;
                        if (student.getCollegeName() != null && !student.getCollegeName().isEmpty()) filledFields++;
                        if (student.getDegree() != null && !student.getDegree().isEmpty()) filledFields++;
                        if (student.getTargetRole() != null && !student.getTargetRole().isEmpty()) filledFields++;
                        if (student.getSkills() != null && !student.getSkills().isEmpty()) filledFields++;
                        if (student.getCareerGoals() != null && !student.getCareerGoals().isEmpty()) filledFields++;
                        int completionPct = filledFields * 20;
                    %>
                    <div style="font-size:32px;font-weight:800;color:var(--primary-light);margin-bottom:8px;"><%=completionPct%>%</div>
                    <div class="progress-bar-container" style="margin-bottom:16px;">
                        <div class="progress-bar" style="width:<%=completionPct%>%"></div>
                    </div>
                    <div style="font-size:13px;color:var(--text-muted);">
                        Complete your profile to get better personalized recommendations.
                    </div>
                </div>

                <div class="card">
                    <div class="card-title" style="margin-bottom:16px;">Quick Links</div>
                    <div style="display:flex;flex-direction:column;gap:10px;">
                        <a href="<%=request.getContextPath()%>/assessment" class="btn btn-primary">&#127919; Take Career Assessment</a>
                        <a href="<%=request.getContextPath()%>/career/roadmap" class="btn btn-secondary">&#128640; View My Roadmap</a>
                        <a href="<%=request.getContextPath()%>/codelab" class="btn btn-secondary">&#128187; Practice Coding</a>
                        <a href="<%=request.getContextPath()%>/interview" class="btn btn-secondary">&#127908; Mock Interview</a>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
