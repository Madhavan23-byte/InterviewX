<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.interviewx.model.CodingProblem, com.interviewx.dao.CodingProblemDAO.*" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String activeRole = (String) session.getAttribute("activeProfileRole");
    if (activeRole == null) activeRole = "General Track";

    @SuppressWarnings("unchecked")
    List<CodingProblem> problems = (List<CodingProblem>) request.getAttribute("problems");
    if (problems == null) problems = new ArrayList<>();

    @SuppressWarnings("unchecked")
    List<String> topics = (List<String>) request.getAttribute("topics");
    if (topics == null) topics = new ArrayList<>();

    @SuppressWarnings("unchecked")
    List<TopicProgress> topicProgress = (List<TopicProgress>) request.getAttribute("topicProgress");
    if (topicProgress == null) topicProgress = new ArrayList<>();

    DashboardStats stats = (DashboardStats) request.getAttribute("stats");
    if (stats == null) stats = new DashboardStats();

    String selDiff = (String) request.getAttribute("selectedDifficulty");
    String selTopic = (String) request.getAttribute("selectedTopic");
    String selStatus = (String) request.getAttribute("selectedStatus");
    String search = (String) request.getAttribute("searchQuery");
    String sortBy = (String) request.getAttribute("sortBy");
    if (sortBy == null) sortBy = "order";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeLab - Striver DSA Practice Arena - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .codelab-hero {
            background: linear-gradient(135deg, rgba(99,102,241,0.12), rgba(14,165,233,0.06));
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 24px;
            margin-bottom: 24px;
        }
        .stats-dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }
        .codelab-stat-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            padding: 18px 20px;
            position: relative;
            overflow: hidden;
        }
        .codelab-stat-card .val {
            font-size: 26px;
            font-weight: 800;
            color: var(--text);
            line-height: 1.1;
        }
        .codelab-stat-card .lbl {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--text-muted);
            margin-top: 6px;
            font-weight: 600;
        }
        .difficulty-breakdown {
            display: flex;
            gap: 14px;
            margin-top: 8px;
            font-size: 12px;
        }
        .diff-pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-weight: 600;
        }
        .topic-accordion {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 18px 20px;
            margin-bottom: 24px;
        }
        .topic-grid-compact {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 10px;
            margin-top: 14px;
            max-height: 240px;
            overflow-y: auto;
            padding-right: 6px;
        }
        .topic-chip {
            background: var(--dark);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            padding: 10px 12px;
            display: block;
            text-decoration: none !important;
            transition: var(--transition);
        }
        .topic-chip:hover, .topic-chip.active {
            border-color: var(--primary);
            background: rgba(99,102,241,0.12);
        }
        .topic-chip-header {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            font-weight: 600;
            color: var(--text);
            margin-bottom: 6px;
        }
        .filter-container {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 18px 20px;
            margin-bottom: 20px;
        }
        .problems-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            overflow: hidden;
        }
        .problems-table th {
            background: rgba(15,23,42,0.8);
            padding: 14px 18px;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: var(--text-muted);
            font-weight: 700;
            border-bottom: 1px solid var(--border);
            text-align: left;
        }
        .problems-table td {
            padding: 14px 18px;
            border-bottom: 1px solid rgba(51,65,85,0.4);
            color: var(--text);
            font-size: 14px;
            vertical-align: middle;
        }
        .problems-table tr:last-child td {
            border-bottom: none;
        }
        .problems-table tr:hover td {
            background: rgba(99,102,241,0.04);
        }
        .status-badge-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            font-size: 13px;
        }
        .status-solved {
            background: rgba(16,185,129,0.15);
            color: var(--success);
            border: 1px solid rgba(16,185,129,0.3);
        }
        .status-attempted {
            background: rgba(245,158,11,0.15);
            color: var(--warning);
            border: 1px solid rgba(245,158,11,0.3);
        }
        .status-none {
            background: rgba(51,65,85,0.4);
            color: var(--text-muted);
            border: 1px solid var(--border);
        }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    
    <header class="topbar">
        <div class="topbar-left">
            <span class="page-title">&#128187; CodeLab &bull; <%=activeRole%></span>
        </div>
        <div class="topbar-right">
            <span style="font-size:13px;color:var(--text-muted);">
                DSA Progress: <strong style="color:var(--success);"><%=stats.solvedCount%></strong> / <%=stats.totalProblems%> (<%=stats.progressPercent%>%)
            </span>
        </div>
    </header>

    <main class="main-content">
        <!-- Hero Header -->
        <div class="codelab-hero d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <h1 style="font-size:24px;font-weight:800;color:var(--text);margin-bottom:6px;">
                    &#128187; Striver A2Z DSA Sheet Roadmap
                </h1>
                <p style="color:var(--text-muted);font-size:14px;margin:0;">
                    Profile-isolated DSA problem solving arena tailored for <strong><%=activeRole%></strong>. Complete topic-wise catalog with dynamic evaluation.
                </p>
            </div>
            <div class="d-flex align-items-center gap-3">
                <div style="text-align:right;">
                    <div style="font-size:12px;color:var(--text-muted);">Context Profile</div>
                    <div style="font-weight:700;color:var(--primary-light);font-size:14px;"><%=activeRole%></div>
                </div>
                <a href="<%=request.getContextPath()%>/profiles" class="btn btn-secondary btn-sm">Switch Role</a>
            </div>
        </div>

        <!-- Dynamic Statistics Dashboard (Part 13) -->
        <div class="stats-dashboard">
            <div class="codelab-stat-card" style="border-top:3px solid var(--primary);">
                <div class="val"><%=stats.totalProblems%></div>
                <div class="lbl">Total Problems</div>
                <div style="font-size:12px;color:var(--text-muted);margin-top:6px;"><%=stats.totalTopics%> Curated Topics</div>
            </div>

            <div class="codelab-stat-card" style="border-top:3px solid var(--success);">
                <div class="val" style="color:var(--success);"><%=stats.solvedCount%></div>
                <div class="lbl">Solved (Accepted)</div>
                <div class="difficulty-breakdown">
                    <span class="diff-pill" style="color:#34d399;">● <%=stats.easySolved%> Easy</span>
                    <span class="diff-pill" style="color:#fbbf24;">● <%=stats.mediumSolved%> Med</span>
                    <span class="diff-pill" style="color:#f87171;">● <%=stats.hardSolved%> Hard</span>
                </div>
            </div>

            <div class="codelab-stat-card" style="border-top:3px solid var(--warning);">
                <div class="val" style="color:var(--warning);"><%=stats.attemptedCount%></div>
                <div class="lbl">Attempted</div>
                <div style="font-size:12px;color:var(--text-muted);margin-top:6px;">In Progress</div>
            </div>

            <div class="codelab-stat-card" style="border-top:3px solid var(--secondary);">
                <div class="val" style="color:var(--secondary);"><%=stats.remainingCount%></div>
                <div class="lbl">Remaining</div>
                <div style="font-size:12px;color:var(--text-muted);margin-top:6px;"><%=100 - stats.progressPercent%>% to Mastery</div>
            </div>

            <div class="codelab-stat-card" style="border-top:3px solid var(--primary-light);">
                <div class="val"><%=stats.progressPercent%>%</div>
                <div class="lbl">Overall Completion</div>
                <div class="progress-bar-container" style="height:6px;margin-top:10px;">
                    <div class="progress-bar" style="width:<%=stats.progressPercent%>%;"></div>
                </div>
            </div>
        </div>

        <!-- Topic-wise Progress Overview (Part 14) -->
        <div class="topic-accordion">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <div>
                    <h3 style="font-size:16px;font-weight:700;color:var(--text);margin:0;">
                        &#128202; Topic Mastery Progress
                    </h3>
                    <div style="font-size:12px;color:var(--text-muted);margin-top:2px;">
                        Calculated from your profile submissions in MySQL. Click any topic to filter problems.
                    </div>
                </div>
                <span class="badge badge-primary"><%=topicProgress.size()%> Topics</span>
            </div>

            <div class="topic-grid-compact">
                <% for (TopicProgress tp : topicProgress) { 
                    boolean isSel = tp.topicName.equals(selTopic);
                %>
                    <a href="<%=request.getContextPath()%>/codelab?topic=<%=java.net.URLEncoder.encode(tp.topicName, "UTF-8")%>" 
                       class="topic-chip <%=isSel ? "active" : ""%>">
                        <div class="topic-chip-header">
                            <span style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;padding-right:6px;"><%=tp.topicName%></span>
                            <span style="color:var(--primary-light);font-size:11px;"><%=tp.solvedProblems%>/<%=tp.totalProblems%></span>
                        </div>
                        <div class="progress-bar-container" style="height:4px;background:rgba(255,255,255,0.06);">
                            <div class="progress-bar" style="width:<%=tp.percent%>%;"></div>
                        </div>
                    </a>
                <% } %>
            </div>
        </div>

        <!-- Problem Search & Filters (Part 7) -->
        <div class="filter-container">
            <form method="get" action="<%=request.getContextPath()%>/codelab" class="d-flex gap-3 align-items-center flex-wrap">
                <!-- Search input -->
                <div style="flex:2;min-width:220px;">
                    <input type="text" name="search" class="form-control" placeholder="Search problems by title, topic, or tags..." 
                           value="<%=search != null ? search : ""%>">
                </div>

                <!-- Topic Filter -->
                <div style="flex:1;min-width:160px;">
                    <select name="topic" class="form-control">
                        <option value="">All Topics (<%=topics.size()%>)</option>
                        <% for (String t : topics) { %>
                            <option value="<%=t%>" <%=t.equals(selTopic) ? "selected" : ""%>><%=t%></option>
                        <% } %>
                    </select>
                </div>

                <!-- Difficulty Filter -->
                <div style="width:140px;">
                    <select name="difficulty" class="form-control">
                        <option value="">All Difficulties</option>
                        <option value="Easy" <%="Easy".equals(selDiff) ? "selected" : ""%>>Easy</option>
                        <option value="Medium" <%="Medium".equals(selDiff) ? "selected" : ""%>>Medium</option>
                        <option value="Hard" <%="Hard".equals(selDiff) ? "selected" : ""%>>Hard</option>
                    </select>
                </div>

                <!-- Status Filter (Solved, Attempted, Not Started) -->
                <div style="width:150px;">
                    <select name="status" class="form-control">
                        <option value="">All Statuses</option>
                        <option value="SOLVED" <%="SOLVED".equalsIgnoreCase(selStatus) ? "selected" : ""%>>Solved</option>
                        <option value="ATTEMPTED" <%="ATTEMPTED".equalsIgnoreCase(selStatus) ? "selected" : ""%>>Attempted</option>
                        <option value="NOT_STARTED" <%="NOT_STARTED".equalsIgnoreCase(selStatus) ? "selected" : ""%>>Not Started</option>
                    </select>
                </div>

                <!-- Sort Filter -->
                <div style="width:140px;">
                    <select name="sortBy" class="form-control">
                        <option value="order" <%="order".equals(sortBy) ? "selected" : ""%>>Sort by Order</option>
                        <option value="difficulty" <%="difficulty".equals(sortBy) ? "selected" : ""%>>Sort Difficulty</option>
                        <option value="title" <%="title".equals(sortBy) ? "selected" : ""%>>Sort Title</option>
                    </select>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary btn-sm">&#128269; Apply</button>
                    <a href="<%=request.getContextPath()%>/codelab" class="btn btn-secondary btn-sm">Reset</a>
                </div>
            </form>
        </div>

        <!-- Problem Catalog Table (Part 7) -->
        <div class="table-wrapper">
            <% if (problems.isEmpty()) { %>
                <div class="card text-center" style="padding:60px 20px;">
                    <div style="font-size:48px;margin-bottom:14px;opacity:0.6;">&#128187;</div>
                    <h3>No Problems Found</h3>
                    <p style="color:var(--text-muted);max-width:400px;margin:0 auto 16px;">
                        No problems match your current search and filter criteria. Try resetting filters.
                    </p>
                    <a href="<%=request.getContextPath()%>/codelab" class="btn btn-secondary">Clear Filters</a>
                </div>
            <% } else { %>
                <table class="problems-table">
                    <thead>
                        <tr>
                            <th style="width:50px;text-align:center;">Status</th>
                            <th style="width:70px;">#</th>
                            <th>Problem Title</th>
                            <th>Topic & Subtopic</th>
                            <th style="width:100px;">Difficulty</th>
                            <th style="width:120px;text-align:right;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (CodingProblem p : problems) {
                            String diffClass = "badge-easy";
                            if ("Medium".equalsIgnoreCase(p.getDifficulty())) diffClass = "badge-medium";
                            else if ("Hard".equalsIgnoreCase(p.getDifficulty())) diffClass = "badge-hard";

                            String status = p.getUserStatus();
                            boolean isSolved = p.isSolved();
                            boolean isAttempted = p.isAttempted();
                        %>
                            <tr>
                                <td style="text-align:center;">
                                    <% if (isSolved) { %>
                                        <span class="status-badge-icon status-solved" title="Solved">&#10003;</span>
                                    <% } else if (isAttempted) { %>
                                        <span class="status-badge-icon status-attempted" title="Attempted">&#9998;</span>
                                    <% } else { %>
                                        <span class="status-badge-icon status-none" title="Not Started">&bull;</span>
                                    <% } %>
                                </td>
                                <td style="font-weight:700;color:var(--text-muted);font-size:13px;">
                                    <%=String.format("%03d", p.getProblemNumber())%>
                                </td>
                                <td>
                                    <a href="<%=request.getContextPath()%>/codelab/problem?id=<%=p.getProblemId()%>" 
                                       style="font-weight:600;color:var(--text);font-size:14px;display:inline-block;"
                                       onmouseover="this.style.color='var(--primary-light)'"
                                       onmouseout="this.style.color='var(--text)'">
                                        <%=p.getTitle()%>
                                    </a>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2 flex-wrap">
                                        <span class="badge" style="background:rgba(99,102,241,0.12);color:var(--primary-light);font-size:10px;">
                                            <%=p.getTopic()%>
                                        </span>
                                        <% if (p.getSubtopic() != null && !p.getSubtopic().equals(p.getTopic())) { %>
                                            <span style="font-size:11px;color:var(--text-muted);">
                                                &bull; <%=p.getSubtopic()%>
                                            </span>
                                        <% } %>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge <%=diffClass%>"><%=p.getDifficulty()%></span>
                                </td>
                                <td style="text-align:right;">
                                    <a href="<%=request.getContextPath()%>/codelab/problem?id=<%=p.getProblemId()%>" 
                                       class="btn <%=isSolved ? "btn-secondary" : "btn-primary"%> btn-sm">
                                        <%=isSolved ? "Practice Again" : "Solve Problem &rarr;"%>
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>

                <div class="d-flex justify-content-between align-items-center" style="margin-top:16px;font-size:13px;color:var(--text-muted);">
                    <span>Showing <%=problems.size()%> of <%=stats.totalProblems%> problems</span>
                    <span>Roadmap: Striver's A2Z DSA Sheet</span>
                </div>
            <% } %>
        </div>
    </main>
</div>
</body>
</html>
