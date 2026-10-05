<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.interviewx.model.CareerTrack" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<CareerTrack> tracks = (List<CareerTrack>) request.getAttribute("tracks");
    if (tracks == null) tracks = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><title>Choose Career Track - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .track-cards { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 16px; }
        .track-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 24px 20px; text-align: center; cursor: pointer; transition: var(--transition); }
        .track-card:hover { border-color: var(--primary); transform: translateY(-3px); box-shadow: 0 8px 24px rgba(99,102,241,0.15); }
        .track-card.selected { border-color: var(--primary); background: rgba(99,102,241,0.1); }
        .track-icon { font-size: 32px; margin-bottom: 12px; }
        .track-name { font-size: 15px; font-weight: 700; color: var(--text); }
        .track-desc { font-size: 12px; color: var(--text-muted); margin-top: 6px; }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <header class="topbar"><div class="topbar-left"><span class="page-title">Choose Career Track</span></div></header>
    <main class="main-content">
        <div class="page-header">
            <h1>&#127919; Choose Your Career Track</h1>
            <p>Haven't taken the assessment? <a href="<%=request.getContextPath()%>/assessment" style="color:var(--primary-light);">Take assessment for recommendations</a> or choose directly below.</p>
        </div>
        <form method="post" action="<%=request.getContextPath()%>/career/choose" id="chooseForm">
            <div class="track-cards" style="margin-bottom:24px;">
                <% for (CareerTrack t : tracks) { %>
                <div class="track-card" onclick="selectTrack(<%=t.getTrackId()%>, this)">
                    <div class="track-icon">&#128187;</div>
                    <div class="track-name"><%=t.getTrackName()%></div>
                    <div class="track-desc"><%=t.getDescription()%></div>
                </div>
                <% } %>
            </div>
            <input type="hidden" name="trackId" id="selectedTrackId" value="">
            <div style="text-align:center;">
                <button type="submit" class="btn btn-primary btn-lg" id="submitBtn" disabled>
                    &#9989; Confirm Selection
                </button>
            </div>
        </form>
    </main>
</div>
<script>
function selectTrack(id, card) {
    document.querySelectorAll('.track-card').forEach(c => c.classList.remove('selected'));
    card.classList.add('selected');
    document.getElementById('selectedTrackId').value = id;
    document.getElementById('submitBtn').removeAttribute('disabled');
}
</script>
</body>
</html>
