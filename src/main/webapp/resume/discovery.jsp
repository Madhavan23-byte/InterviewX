<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.interviewx.model.*, java.util.*" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String fullName = (String) session.getAttribute("fullName");
    @SuppressWarnings("unchecked")
    List<RoleRecommendation> recs = (List<RoleRecommendation>) request.getAttribute("recommendations");
    StudentResume resume = (StudentResume) request.getAttribute("resume");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Role Discovery Recommendations - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .rec-hero {
            background: linear-gradient(135deg, rgba(99,102,241,0.18), rgba(16,185,129,0.12));
            border: 1px solid rgba(99,102,241,0.3);
            border-radius: var(--radius);
            padding: 24px 28px;
            margin-bottom: 24px;
        }
        .advisory-box {
            background: rgba(14,165,233,0.1);
            border: 1px solid rgba(14,165,233,0.25);
            border-radius: var(--radius-sm);
            padding: 12px 18px;
            font-size: 13px;
            color: var(--secondary);
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .rec-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 24px;
            margin-bottom: 18px;
            transition: var(--transition);
        }
        .rec-card:hover {
            border-color: var(--primary);
            box-shadow: 0 6px 24px rgba(0,0,0,0.35);
        }
        .rec-card.strong { border-left: 4px solid var(--success); }
        .rec-card.good { border-left: 4px solid var(--secondary); }
        .rec-card.moderate { border-left: 4px solid var(--warning); }

        .align-badge {
            font-size: 12px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 12px;
            display: inline-block;
        }
        .align-strong { background: rgba(16,185,129,0.2); color: var(--success); border: 1px solid rgba(16,185,129,0.3); }
        .align-good { background: rgba(14,165,233,0.2); color: var(--secondary); border: 1px solid rgba(14,165,233,0.3); }
        .align-moderate { background: rgba(245,158,11,0.2); color: var(--warning); border: 1px solid rgba(245,158,11,0.3); }

        .reasons-list {
            margin: 14px 0;
            padding-left: 20px;
            font-size: 13px;
            color: var(--text);
            line-height: 1.7;
        }
        .skill-tag {
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 6px;
            display: inline-block;
            margin: 2px;
            font-weight: 600;
        }
        .skill-match { background: rgba(16,185,129,0.15); color: var(--success); border: 1px solid rgba(16,185,129,0.3); }
        .skill-gap { background: rgba(245,158,11,0.12); color: var(--warning); border: 1px solid rgba(245,158,11,0.25); }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="/sidebar.jsp" %>
    <main class="main-content">
        <div class="rec-hero">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <div>
                    <span class="badge badge-success" style="margin-bottom:8px;">Discovery Complete</span>
                    <h1 style="font-size:24px;font-weight:800;margin-bottom:4px;">Role Compatibility Analysis</h1>
                    <p style="color:var(--text-muted);font-size:13px;margin:0;">
                        Synthesized from your resume and detected skills. Select a role to initialize its dedicated Preparation Profile.
                    </p>
                </div>
                <div>
                    <a href="<%=request.getContextPath()%>/resume" class="btn btn-secondary btn-sm">
                        &#8634; Re-upload Resume
                    </a>
                </div>
            </div>
        </div>

        <div class="advisory-box">
            <span style="font-size:20px;">&#8505;</span>
            <div>
                <strong>Advisory Recommendations:</strong> Role compatibility analysis is designed to highlight where your current technical profile has immediate momentum. Recommendations are advisory and you may choose to prepare for any career role.
            </div>
        </div>

        <% if (resume != null && resume.getExtractedSkills() != null && !resume.getExtractedSkills().isEmpty()) { %>
            <div class="card" style="margin-bottom:24px;padding:16px 20px;">
                <div style="font-size:13px;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:8px;">
                    Extracted Resume Technical Profile:
                </div>
                <div style="font-size:13px;color:var(--text);line-height:1.6;">
                    <%=resume.getExtractedSkills()%>
                </div>
            </div>
        <% } %>

        <% if (recs == null || recs.isEmpty()) { %>
            <div class="card text-center" style="padding:40px;">
                <div style="font-size:40px;margin-bottom:12px;">&#129300;</div>
                <h3>No Recommendations Generated</h3>
                <p style="color:var(--text-muted);margin-bottom:20px;">Please upload or paste your resume content to trigger role discovery.</p>
                <a href="<%=request.getContextPath()%>/resume" class="btn btn-primary">Go to Resume Upload</a>
            </div>
        <% } else { %>
            <div style="display:flex;flex-direction:column;gap:16px;">
                <% for (RoleRecommendation r : recs) {
                    String alignClass = "moderate";
                    String badgeClass = "align-moderate";
                    if ("Strong alignment".equals(r.getAlignmentLevel())) {
                        alignClass = "strong";
                        badgeClass = "align-strong";
                    } else if ("Good alignment".equals(r.getAlignmentLevel())) {
                        alignClass = "good";
                        badgeClass = "align-good";
                    }
                %>
                    <div class="rec-card <%=alignClass%>">
                        <div class="d-flex justify-content-between align-items-start flex-wrap gap-2" style="margin-bottom:12px;">
                            <div class="d-flex align-items-center gap-3">
                                <div class="user-avatar" style="width:44px;height:44px;font-size:16px;background:var(--surface2);">
                                    <%=r.getTrackIcon()%>
                                </div>
                                <div>
                                    <div class="d-flex align-items-center gap-2">
                                        <h3 style="font-size:18px;font-weight:700;margin:0;color:var(--text);">
                                            <%=r.getRoleName()%>
                                        </h3>
                                        <span class="align-badge <%=badgeClass%>">
                                            <%=r.getAlignmentLevel()%>
                                        </span>
                                    </div>
                                    <div style="font-size:12px;color:var(--text-muted);margin-top:2px;">
                                        Compatibility Score: <strong><%=r.getMatchScore()%>%</strong>
                                    </div>
                                </div>
                            </div>

                            <div>
                                <% if (r.isProfileExists()) { %>
                                    <div style="text-align:right;">
                                        <span class="badge badge-success" style="margin-bottom:6px;display:inline-block;">Active Profile Exists</span>
                                        <div>
                                            <a href="<%=request.getContextPath()%>/profiles/switch?profileId=<%=r.getExistingProfileId()%>"
                                               class="btn btn-secondary btn-sm" style="font-weight:700;">
                                                Continue <%=r.getRoleName()%> &rarr;
                                            </a>
                                        </div>
                                    </div>
                                <% } else { %>
                                    <form action="<%=request.getContextPath()%>/resume/select-role" method="POST" style="margin:0;">
                                        <input type="hidden" name="roleName" value="<%=r.getRoleName()%>">
                                        <input type="hidden" name="trackId" value="<%=r.getTrackId()%>">
                                        <button type="submit" class="btn btn-primary btn-sm" style="font-weight:700;">
                                            &#10010; Prepare for <%=r.getRoleName()%> &rarr;
                                        </button>
                                    </form>
                                <% } %>
                            </div>
                        </div>

                        <!-- Progress Bar -->
                        <div class="progress-bar-container" style="height:6px;margin-bottom:14px;">
                            <div class="progress-bar" style="width:<%=r.getMatchScore()%>%;"></div>
                        </div>

                        <!-- Reasons -->
                        <div style="font-size:13px;font-weight:700;color:var(--text-muted);margin-bottom:4px;">
                            Reasons for Recommendation:
                        </div>
                        <ul class="reasons-list">
                            <% for (String reason : r.getReasonList()) { %>
                                <li><%=reason%></li>
                            <% } %>
                        </ul>

                        <!-- Skills Grid -->
                        <div class="grid-2" style="margin-top:14px;padding-top:12px;border-top:1px solid var(--border);">
                            <div>
                                <div style="font-size:12px;font-weight:600;color:var(--success);margin-bottom:6px;">
                                    &#10003; Detected Relevant Skills:
                                </div>
                                <div>
                                    <% if (r.getSkillMatches() != null && !r.getSkillMatches().isEmpty()) {
                                        for (String s : r.getSkillMatches().split(",")) { %>
                                            <span class="skill-tag skill-match"><%=s.trim()%></span>
                                    <%  }
                                       } else { %>
                                        <span style="font-size:12px;color:var(--text-muted);">None detected in input</span>
                                    <% } %>
                                </div>
                            </div>
                            <div>
                                <div style="font-size:12px;font-weight:600;color:var(--warning);margin-bottom:6px;">
                                    &#9888; Targeted Learning Focus (Roadmap Gaps):
                                </div>
                                <div>
                                    <% if (r.getSkillGaps() != null && !r.getSkillGaps().isEmpty()) {
                                        for (String s : r.getSkillGaps().split(",")) { %>
                                            <span class="skill-tag skill-gap"><%=s.trim()%></span>
                                    <%  }
                                       } else { %>
                                        <span style="font-size:12px;color:var(--text-muted);">Ready for advanced preparation</span>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>

        <div style="text-align:center;margin-top:32px;padding:20px;border-top:1px solid var(--border);">
            <span style="color:var(--text-muted);font-size:13px;margin-right:12px;">Looking for a different direction?</span>
            <a href="<%=request.getContextPath()%>/career/choose" class="btn btn-secondary btn-sm">
                Explore All 15 Career Tracks
            </a>
            <a href="<%=request.getContextPath()%>/profiles" class="btn btn-secondary btn-sm" style="margin-left:8px;">
                View My Preparation Profiles
            </a>
        </div>
    </main>
</div>
</body>
</html>