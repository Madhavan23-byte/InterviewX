<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.interviewx.model.CareerTrack" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Map<String,Object>> recommendations = (List<Map<String,Object>>) request.getAttribute("recommendations");
    List<CareerTrack> allTracks = (List<CareerTrack>) request.getAttribute("allTracks");
    Integer recommendedTrackId = (Integer) request.getAttribute("recommendedTrackId");
    String fullName = (String) session.getAttribute("fullName");
    if (recommendations == null) recommendations = new ArrayList<>();
    if (allTracks == null) allTracks = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Career Recommendation - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .rec-card {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 20px; margin-bottom: 12px;
            display: flex; align-items: center; gap: 16px;
            transition: var(--transition);
        }
        .rec-card:first-child { border-color: rgba(99,102,241,0.5); background: rgba(99,102,241,0.06); }
        .rec-rank { width: 36px; height: 36px; border-radius: 50%; background: var(--surface2); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 14px; flex-shrink: 0; }
        .rec-rank.top { background: linear-gradient(135deg, var(--primary), var(--secondary)); color: white; }
        .rec-info { flex: 1; }
        .rec-name { font-size: 16px; font-weight: 700; color: var(--text); }
        .rec-pct { font-size: 22px; font-weight: 800; color: var(--primary-light); }
        .rec-bar { flex: 1; background: var(--dark); border-radius: 4px; height: 6px; margin-top: 6px; }
        .rec-bar-fill { height: 100%; border-radius: 4px; background: linear-gradient(90deg, var(--primary), var(--secondary)); }
        .track-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 10px; margin-top: 16px; }
        .track-option { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 14px 12px; text-align: center; cursor: pointer; transition: var(--transition); }
        .track-option:hover, .track-option.selected { border-color: var(--primary); background: rgba(99,102,241,0.1); }
        .track-option input { display: none; }
        .track-option .track-name { font-size: 13px; font-weight: 600; color: var(--text); margin-top: 6px; }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <header class="topbar">
        <div class="topbar-left"><span class="page-title">Career Recommendation</span></div>
    </header>
    <main class="main-content">
        <div class="page-header">
            <h1>&#127775; Your Career Recommendations</h1>
            <p>Based on your assessment. These are recommendations — you choose your career track!</p>
        </div>

        <div class="grid-2">
            <!-- Recommendations -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">Top Recommended Tracks</div>
                    <div class="card-subtitle">Based on your interest profile</div>
                </div>
                <% for (int i = 0; i < recommendations.size(); i++) {
                    Map<String,Object> rec = recommendations.get(i);
                    int pct = (int) rec.get("percentage");
                %>
                <div class="rec-card">
                    <div class="rec-rank <%=i==0?"top":""%>"><%=i+1%></div>
                    <div class="rec-info">
                        <div class="rec-name"><%=rec.get("trackName")%></div>
                        <div class="rec-bar"><div class="rec-bar-fill" style="width:<%=pct%>%"></div></div>
                    </div>
                    <div class="rec-pct"><%=pct%>%</div>
                </div>
                <% } %>
                <div class="alert alert-info" style="margin-top:12px;">
                    &#128161; These percentages indicate fit based on your interests. Choose the track that excites you most!
                </div>
            </div>

            <!-- Track Selection -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">Choose Your Career Track</div>
                    <div class="card-subtitle">This sets your roadmap and daily tasks</div>
                </div>
                <form method="post" action="<%=request.getContextPath()%>/career/choose">
                    <div class="track-grid">
                        <% for (CareerTrack track : allTracks) { %>
                        <label class="track-option <%=track.getTrackId() == (recommendedTrackId != null ? recommendedTrackId : 0) ? "selected" : ""%>">
                            <input type="radio" name="trackId" value="<%=track.getTrackId()%>" <%=track.getTrackId() == (recommendedTrackId != null ? recommendedTrackId : 0) ? "checked" : ""%>>
                            <div style="font-size:22px;">&#128187;</div>
                            <div class="track-name"><%=track.getTrackName()%></div>
                        </label>
                        <% } %>
                    </div>
                    <button type="submit" class="btn btn-primary btn-lg btn-full" style="margin-top:20px;">
                        &#9989; Confirm Career Track & Start Preparation
                    </button>
                </form>
            </div>
        </div>
    </main>
</div>
<script>
document.querySelectorAll('.track-option').forEach(opt => {
    opt.addEventListener('click', function() {
        document.querySelectorAll('.track-option').forEach(o => o.classList.remove('selected'));
        this.classList.add('selected');
    });
});
</script>
</body>
</html>
