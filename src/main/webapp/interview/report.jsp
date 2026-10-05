<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Map<String,Object>> answers = (List<Map<String,Object>>) request.getAttribute("answers");
    Integer interviewId = (Integer) request.getAttribute("interviewId");
    if (answers == null) answers = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Interview Report – InterviewX</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/main.css">
    <style>
        .report-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); margin-bottom: 24px; overflow: hidden; }
        .rc-header { padding: 16px 20px; background: var(--surface2); border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 12px; }
        .rc-qnum { background: var(--primary); color: white; font-size: 12px; font-weight: 800; padding: 4px 10px; border-radius: 12px; }
        .rc-qtitle { font-size: 15px; font-weight: 700; color: var(--text); flex: 1; }
        .rc-score { font-size: 22px; font-weight: 900; }
        .score-good { color: #22c55e; } .score-ok { color: #f59e0b; } .score-bad { color: #ef4444; }
        .rc-body { padding: 20px; display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .rc-answer { background: var(--dark); border-radius: var(--radius-sm); padding: 14px; font-size: 13px; color: var(--text); line-height: 1.7; }
        .rc-section-label { font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; color: var(--text-muted); margin-bottom: 8px; }
        .tag-row { display: flex; flex-wrap: wrap; gap: 6px; }
        .tag-green { background: rgba(34,197,94,0.15); color: #4ade80; padding: 4px 10px; border-radius: 12px; font-size: 12px; }
        .tag-red { background: rgba(239,68,68,0.15); color: #f87171; padding: 4px 10px; border-radius: 12px; font-size: 12px; }
        .tag-blue { background: rgba(99,102,241,0.15); color: #818cf8; padding: 4px 10px; border-radius: 12px; font-size: 12px; }
        .model-answer { background: rgba(99,102,241,0.1); border: 1px solid rgba(99,102,241,0.3); border-radius: var(--radius-sm); padding: 14px; font-size: 13px; line-height: 1.7; color: var(--text); }
        .followup-box { background: rgba(245,158,11,0.1); border: 1px solid rgba(245,158,11,0.3); border-radius: var(--radius-sm); padding: 12px; font-size: 13px; font-style: italic; color: var(--warning); }
        .metrics-row { display: flex; gap: 10px; flex-wrap: wrap; }
        .metric-chip { background: var(--surface2); border-radius: var(--radius-sm); padding: 6px 12px; font-size: 12px; color: var(--text); }
        .metric-chip strong { color: var(--primary-light); }
        @media (max-width: 900px) { .rc-body { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <header class="topbar">
        <div class="topbar-left">
            <a href="<%= request.getContextPath() %>/interview" class="btn btn-secondary btn-sm">← Back to Interviews</a>
            <span class="page-title" style="margin-left:12px;">Interview Report</span>
        </div>
        <div class="topbar-right">
            <span class="badge badge-primary">Interview #<%= interviewId != null ? interviewId : "" %></span>
        </div>
    </header>
    <main class="main-content">
        <div class="page-header">
            <h1>📊 Detailed Interview Report</h1>
            <p>AI-powered analysis of each answer with scores, feedback, and improvement suggestions</p>
        </div>

        <% if (answers.isEmpty()) { %>
        <div class="card" style="text-align:center;padding:60px;">
            <div style="font-size:48px;margin-bottom:16px;">📋</div>
            <h3>No answers found for this interview.</h3>
            <a href="<%= request.getContextPath() %>/interview" class="btn btn-primary" style="margin-top:16px;">Start New Interview</a>
        </div>
        <% } else {
            int totalScore = 0;
            for (Map<String,Object> a : answers) {
                Object s = a.get("score");
                if (s != null) totalScore += (int)(((double)s) * 10);
            }
            int avgScore = answers.isEmpty() ? 0 : totalScore / answers.size();
        %>

        <!-- Summary Card -->
        <div class="card" style="margin-bottom:24px;">
            <div style="display:flex;align-items:center;gap:24px;flex-wrap:wrap;">
                <div style="text-align:center;">
                    <div style="font-size:48px;font-weight:900;color:<%= avgScore>=75?"#22c55e":avgScore>=50?"#f59e0b":"#ef4444" %>"><%= avgScore %>%</div>
                    <div style="font-size:13px;color:var(--text-muted);">Overall Score</div>
                </div>
                <div style="flex:1;">
                    <div style="font-size:18px;font-weight:800;color:var(--text);margin-bottom:8px;">
                        <%= avgScore >= 80 ? "🏆 Excellent Performance!" : avgScore >= 65 ? "✅ Good Effort!" : "📚 Keep Practicing!" %>
                    </div>
                    <div style="font-size:14px;color:var(--text-muted);">
                        Answered <%= answers.size() %> question<%= answers.size()!=1?"s":"" %>.
                        <%= avgScore >= 75 ? "Strong technical foundation." : "Review missing concepts below." %>
                    </div>
                    <div style="margin-top:12px;display:flex;gap:10px;">
                        <a href="<%= request.getContextPath() %>/interview" class="btn btn-primary btn-sm">🔄 New Interview</a>
                        <a href="<%= request.getContextPath() %>/interview/start?type=TECHNICAL" class="btn btn-secondary btn-sm">⚡ Retry</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Per-question breakdown -->
        <% for (int i = 0; i < answers.size(); i++) {
            Map<String,Object> ans = answers.get(i);
            String feedbackJson = (String) ans.get("aiFeedbackJson");
            double rawScore = (ans.get("score") instanceof Double) ? (double)ans.get("score") : 0.0;
            int scoreInt = (int)(rawScore * 10);
            String scoreClass = scoreInt >= 75 ? "score-good" : scoreInt >= 50 ? "score-ok" : "score-bad";
        %>
        <div class="report-card">
            <div class="rc-header">
                <span class="rc-qnum">Q<%= i+1 %></span>
                <div class="rc-qtitle"><%= ans.get("questionText") %></div>
                <div style="display:flex;flex-direction:column;align-items:flex-end;">
                    <span class="rc-score <%= scoreClass %>"><%= scoreInt %>%</span>
                    <span style="font-size:11px;color:var(--text-muted);"><%= ans.get("difficulty") %> • <%= ans.get("topic") %></span>
                </div>
            </div>
            <div class="rc-body" id="rb_<%= i %>">
                <!-- Left: Your Answer + Metrics -->
                <div>
                    <div class="rc-section-label">Your Answer</div>
                    <div class="rc-answer"><%= ans.get("answerText") != null ? ((String)ans.get("answerText")).replace("<","&lt;") : "No answer provided" %></div>
                    <div class="metrics-row" style="margin-top:12px;" id="metrics_<%= i %>">
                        <!-- populated by JS -->
                    </div>
                </div>
                <!-- Right: AI Feedback -->
                <div>
                    <div id="feedback_<%= i %>">
                        <!-- populated by JS -->
                    </div>
                </div>
            </div>
        </div>

        <script>
        (function() {
            var idx = <%= i %>;
            var jsonStr = '<%= feedbackJson != null ? feedbackJson.replace("\\","\\\\").replace("'","\\'").replace("\"","\\\"").replace("\n"," ").replace("\r","") : "{}" %>';
            var fb = {};
            try { fb = JSON.parse(jsonStr); } catch(e) {}

            // Metrics row
            var metrics = document.getElementById('metrics_' + idx);
            if (metrics) {
                var m = [
                    ['Correctness', fb.correctness],
                    ['Accuracy', fb.technical_accuracy],
                    ['Completeness', fb.completeness],
                    ['Communication', fb.communication_rating]
                ].filter(x => x[1]);
                metrics.innerHTML = m.map(x => '<div class="metric-chip">'+x[0]+': <strong>'+x[1]+'</strong></div>').join('');
            }

            // Feedback panel
            var panel = document.getElementById('feedback_' + idx);
            if (panel) {
                var html = '';
                if (fb.detailed_feedback) {
                    html += '<div class="rc-section-label">AI Feedback</div><div class="rc-answer" style="margin-bottom:12px;">'+fb.detailed_feedback+'</div>';
                }
                if (fb.strengths && fb.strengths.length) {
                    html += '<div class="rc-section-label" style="margin-top:10px;">✅ Strengths</div><div class="tag-row" style="margin-bottom:10px;">';
                    fb.strengths.forEach(s => { html += '<span class="tag-green">'+s+'</span>'; });
                    html += '</div>';
                }
                if (fb.missing_concepts && fb.missing_concepts.length) {
                    html += '<div class="rc-section-label">📚 Missing</div><div class="tag-row" style="margin-bottom:10px;">';
                    fb.missing_concepts.forEach(m => { html += '<span class="tag-blue">'+m+'</span>'; });
                    html += '</div>';
                }
                if (fb.suggested_answer) {
                    html += '<div class="rc-section-label" style="margin-top:10px;">💡 Model Answer</div><div class="model-answer">'+fb.suggested_answer+'</div>';
                }
                if (fb.follow_up_question) {
                    html += '<div class="followup-box" style="margin-top:10px;">🔁 '+fb.follow_up_question+'</div>';
                }
                panel.innerHTML = html || '<div style="color:var(--text-muted);font-size:13px;">Configure INTERVIEW_AI_GEMINI_API_KEY for detailed AI feedback.</div>';
            }
        })();
        </script>
        <% } %>

        <% } %>
    </main>
</div>
</body>
</html>
