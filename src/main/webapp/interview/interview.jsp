<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.interviewx.model.InterviewQuestion" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<InterviewQuestion> questions = (List<InterviewQuestion>) request.getAttribute("questions");
    String interviewType = (String) request.getAttribute("interviewType");
    String activeRole = (String) request.getAttribute("activeRole");
    if (questions == null) questions = new ArrayList<>();
    if (interviewType == null) interviewType = "TECHNICAL";
    if (activeRole == null) activeRole = "Software Engineer";
    Integer interviewId = (Integer) session.getAttribute("currentInterviewId");
    int totalQ = questions.size();
    String typeIcon = "TECHNICAL".equals(interviewType) ? "💻" : "HR".equals(interviewType) ? "👥" : "🗣️";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= interviewType %> Interview – InterviewX</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/main.css">
    <style>
        /* ===== INTERVIEW LAYOUT ===== */
        .interview-shell { display: grid; grid-template-columns: 1fr 380px; grid-template-rows: auto 1fr auto; gap: 0; height: calc(100vh - 60px); }
        .int-left { display: flex; flex-direction: column; padding: 24px; overflow-y: auto; gap: 16px; }
        .int-right { background: var(--surface); border-left: 1px solid var(--border); display: flex; flex-direction: column; }
        .int-bottom { grid-column: 1 / -1; background: var(--surface); border-top: 1px solid var(--border); padding: 16px 24px; display: flex; align-items: center; gap: 12px; }

        /* Question Card */
        .q-nav { display: flex; align-items: center; gap: 12px; }
        .q-counter { font-size: 13px; font-weight: 700; color: var(--text-muted); background: var(--surface2); padding: 6px 14px; border-radius: 20px; }
        .q-progress-bar { flex: 1; height: 4px; background: var(--border); border-radius: 4px; overflow: hidden; }
        .q-progress-fill { height: 100%; background: var(--primary); border-radius: 4px; transition: width 0.3s ease; }
        .q-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 28px; }
        .q-badges { display: flex; gap: 8px; margin-bottom: 14px; flex-wrap: wrap; }
        .q-text { font-size: 18px; font-weight: 700; color: var(--text); line-height: 1.5; margin-bottom: 16px; }
        .q-topic { font-size: 12px; color: var(--text-muted); }
        .answer-area { background: var(--dark); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 16px; color: var(--text); font-size: 14px; line-height: 1.7; resize: vertical; min-height: 160px; width: 100%; font-family: inherit; transition: border-color 0.2s; }
        .answer-area:focus { outline: none; border-color: var(--primary); }

        /* Camera Panel */
        .camera-header { padding: 16px; border-bottom: 1px solid var(--border); font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; color: var(--text-muted); }
        .camera-viewport { background: #0a0a0a; flex: 1; display: flex; align-items: center; justify-content: center; position: relative; overflow: hidden; min-height: 200px; }
        #cameraVideo { width: 100%; height: 100%; object-fit: cover; display: none; }
        .camera-placeholder { text-align: center; color: var(--text-muted); }
        .camera-placeholder .cam-icon { font-size: 48px; margin-bottom: 12px; opacity: 0.4; }
        .camera-controls { padding: 14px; border-top: 1px solid var(--border); display: flex; gap: 8px; flex-wrap: wrap; }
        .cam-btn { flex: 1; padding: 9px 10px; border-radius: var(--radius-sm); font-size: 12px; font-weight: 700; border: 1px solid var(--border); cursor: pointer; transition: var(--transition); background: var(--surface2); color: var(--text); min-width: 70px; text-align: center; }
        .cam-btn.active { background: #dc2626; border-color: #dc2626; color: white; }
        .cam-btn.primary { background: var(--primary); border-color: var(--primary); color: white; }
        .cam-btn:disabled { opacity: 0.4; cursor: not-allowed; }
        .rec-indicator { display: none; position: absolute; top: 12px; right: 12px; background: #dc2626; color: white; font-size: 11px; font-weight: 800; padding: 4px 10px; border-radius: 12px; animation: blink 1s infinite; }
        .rec-indicator.visible { display: block; }
        @keyframes blink { 0%,100% { opacity: 1; } 50% { opacity: 0.4; } }
        .mic-bar-wrap { padding: 10px 14px; border-top: 1px solid var(--border); }
        .mic-bar-label { font-size: 11px; color: var(--text-muted); margin-bottom: 6px; display: flex; justify-content: space-between; }
        .mic-levels { display: flex; gap: 3px; align-items: flex-end; height: 24px; }
        .mic-bar { width: 6px; background: var(--border); border-radius: 3px; transition: height 0.1s; }

        /* AI Feedback overlay */
        .feedback-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.85); display: none; z-index: 1000; align-items: center; justify-content: center; }
        .feedback-overlay.visible { display: flex; }
        .feedback-card { background: var(--dark); border: 1px solid var(--border); border-radius: var(--radius); padding: 32px; max-width: 680px; width: 90vw; max-height: 85vh; overflow-y: auto; }
        .score-ring { width: 90px; height: 90px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 28px; font-weight: 900; margin: 0 auto 16px; border: 4px solid; }
        .score-high { border-color: #22c55e; color: #22c55e; background: rgba(34,197,94,0.1); }
        .score-mid { border-color: #f59e0b; color: #f59e0b; background: rgba(245,158,11,0.1); }
        .score-low { border-color: #ef4444; color: #ef4444; background: rgba(239,68,68,0.1); }
        .fb-section { margin-bottom: 16px; }
        .fb-section-title { font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; color: var(--text-muted); margin-bottom: 8px; }
        .fb-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .fb-item { background: var(--surface2); border-radius: var(--radius-sm); padding: 10px 14px; }
        .fb-item-label { font-size: 11px; color: var(--text-muted); margin-bottom: 4px; }
        .fb-item-value { font-size: 14px; font-weight: 700; color: var(--text); }
        .tag-list { display: flex; flex-wrap: wrap; gap: 6px; }
        .tag { padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 600; }
        .tag-red { background: rgba(239,68,68,0.15); color: #f87171; }
        .tag-green { background: rgba(34,197,94,0.15); color: #4ade80; }
        .tag-blue { background: rgba(99,102,241,0.15); color: #818cf8; }
        .suggested-answer { background: rgba(99,102,241,0.1); border: 1px solid rgba(99,102,241,0.3); border-radius: var(--radius-sm); padding: 14px; font-size: 13px; color: var(--text); line-height: 1.7; white-space: pre-wrap; }
        .follow-up { background: rgba(245,158,11,0.1); border: 1px solid rgba(245,158,11,0.3); border-radius: var(--radius-sm); padding: 14px; font-size: 14px; font-style: italic; color: var(--warning); }

        /* Bottom bar */
        .timer-badge { font-size: 16px; font-weight: 900; color: var(--warning); min-width: 70px; }
        .auto-transcribe-hint { font-size: 12px; color: var(--text-muted); flex: 1; text-align: center; }

        /* Loading state */
        .analyzing-overlay { position: fixed; inset: 0; background: rgba(10,10,20,0.9); z-index: 999; display: none; align-items: center; justify-content: center; flex-direction: column; gap: 16px; }
        .analyzing-overlay.visible { display: flex; }
        .analyze-spinner { width: 60px; height: 60px; border: 4px solid var(--border); border-top-color: var(--primary); border-radius: 50%; animation: spin 0.8s linear infinite; }
        @keyframes spin { to { transform: rotate(360deg); } }

        @media (max-width: 900px) {
            .interview-shell { grid-template-columns: 1fr; }
            .int-right { height: 300px; }
        }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <div style="flex:1;display:flex;flex-direction:column;overflow:hidden;">
        <header class="topbar">
            <div class="topbar-left">
                <span class="page-title"><%= typeIcon %> <%= interviewType %> Interview</span>
                <span class="badge badge-primary" style="margin-left:8px;"><%= activeRole %></span>
            </div>
            <div class="topbar-right">
                <span class="timer-badge" id="timerDisplay">30:00</span>
            </div>
        </header>

        <% if (questions.isEmpty()) { %>
        <main class="main-content">
            <div class="card" style="text-align:center;padding:60px;">
                <div style="font-size:48px;margin-bottom:16px;">🎤</div>
                <h3>No questions available for this interview type.</h3>
                <a href="<%= request.getContextPath() %>/interview" class="btn btn-primary" style="margin-top:16px;">Back to Interviews</a>
            </div>
        </main>
        <% } else { %>

        <div class="interview-shell">
            <!-- LEFT: Question + Answer -->
            <div class="int-left">
                <!-- Navigation -->
                <div class="q-nav">
                    <button class="btn btn-secondary btn-sm" onclick="navigateQ(-1)" id="prevBtn" disabled>← Prev</button>
                    <div class="q-progress-bar"><div class="q-progress-fill" id="progressFill" style="width:<%= (100/totalQ) %>%"></div></div>
                    <span class="q-counter" id="qCounter">1 / <%= totalQ %></span>
                    <button class="btn btn-secondary btn-sm" onclick="navigateQ(1)" id="nextBtn">Next →</button>
                </div>

                <!-- Question Card -->
                <div class="q-card" id="questionCard">
                    <div class="q-badges" id="qBadges">
                        <span class="badge badge-primary" id="qNumBadge">Q1</span>
                        <span id="qDiffBadge" class="badge badge-<%= questions.get(0).getDifficulty().toLowerCase() %>"><%= questions.get(0).getDifficulty() %></span>
                        <span style="font-size:12px;color:var(--text-muted);" id="qTopicBadge"><%= questions.get(0).getTopic() %></span>
                    </div>
                    <div class="q-text" id="qText"><%= questions.get(0).getQuestionText() %></div>
                </div>

                <!-- Answer -->
                <div class="card">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
                        <div class="card-title">Your Answer</div>
                        <div style="display:flex;gap:8px;align-items:center;">
                            <span id="transcribeStatus" style="font-size:12px;color:var(--text-muted);"></span>
                            <button type="button" class="btn btn-secondary btn-sm" id="clearAnswerBtn" onclick="clearAnswer()">Clear</button>
                        </div>
                    </div>
                    <textarea id="answerText" class="answer-area" placeholder="Type your answer here, or use the Record button to transcribe your spoken answer...&#10;&#10;Tip: Be specific. Use examples. Structure your answer clearly."></textarea>
                    <div style="font-size:12px;color:var(--text-muted);margin-top:6px;text-align:right;" id="wordCount">0 words</div>
                </div>
            </div>

            <!-- RIGHT: Camera Panel -->
            <div class="int-right">
                <div class="camera-header">📹 Camera Preview</div>
                <div class="camera-viewport" id="camViewport">
                    <video id="cameraVideo" autoplay muted playsinline></video>
                    <div class="camera-placeholder" id="camPlaceholder">
                        <div class="cam-icon">📷</div>
                        <div style="font-size:13px;">Camera not started</div>
                        <div style="font-size:11px;margin-top:4px;">Click "Start Camera" below</div>
                    </div>
                    <div class="rec-indicator" id="recIndicator">● REC</div>
                </div>
                <div class="mic-bar-wrap">
                    <div class="mic-bar-label"><span>🎤 Mic Level</span><span id="micStatus">Inactive</span></div>
                    <div class="mic-levels" id="micLevels">
                        <% for(int i=0;i<12;i++){ %><div class="mic-bar" id="mb<%= i %>" style="height:4px;"></div><% } %>
                    </div>
                </div>
                <div class="camera-controls">
                    <button class="cam-btn" id="startCamBtn" onclick="startCamera()">📷 Start Camera</button>
                    <button class="cam-btn" id="stopCamBtn" onclick="stopCamera()" disabled>⏹ Stop Cam</button>
                    <button class="cam-btn" id="recordBtn" onclick="toggleRecording()" disabled>🎙 Record</button>
                    <button class="cam-btn" id="retryBtn" onclick="retryAnswer()" disabled>↩ Retry</button>
                </div>
            </div>

            <!-- BOTTOM: Action bar -->
            <div class="int-bottom">
                <button class="btn btn-secondary" onclick="navigateQ(-1)" id="prevBtnBottom">← Previous</button>
                <div class="auto-transcribe-hint" id="bottomHint">Answer question <span id="qNumBottom">1</span> of <%= totalQ %> for <strong><%= activeRole %></strong></div>
                <button class="btn btn-primary" id="submitBtn" onclick="submitCurrentAnswer()">
                    Submit Answer &amp; Get AI Feedback →
                </button>
                <button class="btn btn-success" id="finishBtn" onclick="finishInterview()" style="display:none;">
                    ✅ Finish Interview
                </button>
            </div>
        </div>

        <% } %>
    </div>
</div>

<!-- AI Analyzing overlay -->
<div class="analyzing-overlay" id="analyzingOverlay">
    <div class="analyze-spinner"></div>
    <div style="color:var(--text);font-size:16px;font-weight:700;">Analyzing with Gemini AI...</div>
    <div style="color:var(--text-muted);font-size:13px;">Evaluating your answer for accuracy, completeness, and depth</div>
</div>

<!-- Feedback Overlay -->
<div class="feedback-overlay" id="feedbackOverlay">
    <div class="feedback-card" id="feedbackCard">
        <!-- Populated dynamically -->
    </div>
</div>

<script>
// ===== STATE =====
const interviewId = <%= interviewId != null ? interviewId : 0 %>;
const totalQuestions = <%= totalQ %>;
const contextPath = '<%= request.getContextPath() %>';
const activeRole = '<%= activeRole.replace("'", "\\'") %>';
const interviewType = '<%= interviewType %>';

// Question data from server
const questions = [
    <% for (int i = 0; i < questions.size(); i++) {
        InterviewQuestion q = questions.get(i);
        if (i > 0) out.print(",");
    %>
    { id: <%= q.getQuestionId() %>, text: '<%= q.getQuestionText().replace("'", "\\'").replace("\n", " ") %>', topic: '<%= q.getTopic() != null ? q.getTopic().replace("'", "\\'") : "" %>', difficulty: '<%= q.getDifficulty() %>' }
    <% } %>
];

let currentIndex = 0;
let answers = {};
let submitted = {};
let cameraStream = null;
let mediaRecorder = null;
let audioChunks = [];
let recognition = null;
let isRecording = false;
let micAnalyzer = null;
let animFrame = null;

// ===== TIMER =====
let secondsLeft = 30 * 60;
const timerEl = document.getElementById('timerDisplay');
const timerInterval = setInterval(() => {
    secondsLeft--;
    const m = Math.floor(secondsLeft / 60);
    const s = secondsLeft % 60;
    timerEl.textContent = `${m.toString().padStart(2,'0')}:${s.toString().padStart(2,'0')}`;
    if (secondsLeft <= 300) timerEl.style.color = '#ef4444';
    if (secondsLeft <= 0) { clearInterval(timerInterval); finishInterview(); }
}, 1000);

// ===== NAVIGATION =====
function navigateQ(dir) {
    // Save current answer
    answers[currentIndex] = document.getElementById('answerText').value;
    const newIdx = currentIndex + dir;
    if (newIdx < 0 || newIdx >= totalQuestions) return;
    currentIndex = newIdx;
    loadQuestion(currentIndex);
}

function loadQuestion(idx) {
    const q = questions[idx];
    document.getElementById('qNumBadge').textContent = 'Q' + (idx + 1);
    document.getElementById('qText').textContent = q.text;
    document.getElementById('qTopicBadge').textContent = q.topic;
    document.getElementById('qDiffBadge').textContent = q.difficulty;
    document.getElementById('qDiffBadge').className = 'badge badge-' + q.difficulty.toLowerCase();
    document.getElementById('qCounter').textContent = (idx + 1) + ' / ' + totalQuestions;
    document.getElementById('qNumBottom').textContent = (idx + 1);
    document.getElementById('progressFill').style.width = (((idx + 1) / totalQuestions) * 100) + '%';
    document.getElementById('answerText').value = answers[idx] || '';
    document.getElementById('prevBtn').disabled = idx === 0;
    document.getElementById('prevBtnBottom').disabled = idx === 0;
    document.getElementById('nextBtn').disabled = idx === totalQuestions - 1;
    updateWordCount();

    // Show finish on last question
    const isLast = (idx === totalQuestions - 1);
    document.getElementById('finishBtn').style.display = isLast ? 'inline-flex' : 'none';
    document.getElementById('submitBtn').textContent = submitted[idx]
        ? '✅ Re-submit Answer'
        : 'Submit Answer & Get AI Feedback →';
}

document.getElementById('answerText').addEventListener('input', updateWordCount);
function updateWordCount() {
    const words = document.getElementById('answerText').value.trim().split(/\s+/).filter(w => w).length;
    document.getElementById('wordCount').textContent = words + ' word' + (words !== 1 ? 's' : '');
}

function clearAnswer() {
    if (confirm('Clear your current answer?')) {
        document.getElementById('answerText').value = '';
        updateWordCount();
    }
}

// ===== SUBMIT ANSWER =====
async function submitCurrentAnswer() {
    const answer = document.getElementById('answerText').value.trim();
    if (!answer) { alert('Please write or record your answer before submitting.'); return; }
    const q = questions[currentIndex];
    answers[currentIndex] = answer;

    document.getElementById('analyzingOverlay').classList.add('visible');

    try {
        const formData = new FormData();
        formData.append('interviewId', interviewId);
        formData.append('questionId', q.id);
        formData.append('questionText', q.text);
        formData.append('answer', answer);
        formData.append('interviewType', interviewType);
        formData.append('questionIndex', currentIndex + 1);

        const res = await fetch(contextPath + '/interview/submit', { method: 'POST', body: formData });
        const data = await res.json();

        document.getElementById('analyzingOverlay').classList.remove('visible');

        if (data.success) {
            submitted[currentIndex] = true;
            showFeedback(data.feedbackJson, data.score, q);
        } else {
            alert('Error: ' + (data.error || 'Unknown error'));
        }
    } catch (e) {
        document.getElementById('analyzingOverlay').classList.remove('visible');
        alert('Network error. Please check your connection.');
    }
}

// ===== FEEDBACK UI =====
function showFeedback(feedbackJson, score, question) {
    let fb = {};
    try { fb = JSON.parse(JSON.stringify(feedbackJson)); if (typeof feedbackJson === 'string') fb = JSON.parse(feedbackJson); } catch(e) {}

    const scoreNum = fb.score || score || 0;
    const ringClass = scoreNum >= 75 ? 'score-high' : scoreNum >= 50 ? 'score-mid' : 'score-low';

    const strengths = Array.isArray(fb.strengths) ? fb.strengths : [];
    const weaknesses = Array.isArray(fb.weaknesses) ? fb.weaknesses : [];
    const missing = Array.isArray(fb.missing_concepts) ? fb.missing_concepts : [];
    const topics = Array.isArray(fb.preparation_topics) ? fb.preparation_topics : [];

    document.getElementById('feedbackCard').innerHTML = `
        <div style="text-align:center;margin-bottom:24px;">
            <div class="score-ring ${ringClass}">${scoreNum}</div>
            <div style="font-size:20px;font-weight:800;color:var(--text);">AI Interview Feedback</div>
            <div style="font-size:13px;color:var(--text-muted);margin-top:4px;">${question.text.substring(0,80)}${question.text.length>80?'...':''}</div>
        </div>

        <div class="fb-section">
            <div class="fb-section-title">Performance Metrics</div>
            <div class="fb-grid">
                <div class="fb-item"><div class="fb-item-label">Correctness</div><div class="fb-item-value">${fb.correctness || 'N/A'}</div></div>
                <div class="fb-item"><div class="fb-item-label">Technical Accuracy</div><div class="fb-item-value">${fb.technical_accuracy || 'N/A'}</div></div>
                <div class="fb-item"><div class="fb-item-label">Completeness</div><div class="fb-item-value">${fb.completeness || 'N/A'}</div></div>
                <div class="fb-item"><div class="fb-item-label">Communication</div><div class="fb-item-value">${fb.communication_rating || 'N/A'}</div></div>
            </div>
        </div>

        ${fb.detailed_feedback ? `
        <div class="fb-section">
            <div class="fb-section-title">Detailed Feedback</div>
            <div style="font-size:14px;color:var(--text);line-height:1.7;background:var(--surface2);padding:14px;border-radius:var(--radius-sm);">${fb.detailed_feedback}</div>
        </div>` : ''}

        ${strengths.length ? `
        <div class="fb-section">
            <div class="fb-section-title">✅ Strengths</div>
            <div class="tag-list">${strengths.map(s=>`<span class="tag tag-green">${s}</span>`).join('')}</div>
        </div>` : ''}

        ${weaknesses.length ? `
        <div class="fb-section">
            <div class="fb-section-title">⚠️ Areas to Improve</div>
            <div class="tag-list">${weaknesses.map(w=>`<span class="tag tag-red">${w}</span>`).join('')}</div>
        </div>` : ''}

        ${missing.length ? `
        <div class="fb-section">
            <div class="fb-section-title">📚 Missing Concepts</div>
            <div class="tag-list">${missing.map(m=>`<span class="tag tag-blue">${m}</span>`).join('')}</div>
        </div>` : ''}

        ${fb.suggested_answer ? `
        <div class="fb-section">
            <div class="fb-section-title">💡 Model Answer</div>
            <div class="suggested-answer">${fb.suggested_answer}</div>
        </div>` : ''}

        ${fb.follow_up_question ? `
        <div class="fb-section">
            <div class="fb-section-title">🔁 Follow-up Question</div>
            <div class="follow-up">${fb.follow_up_question}</div>
        </div>` : ''}

        ${topics.length ? `
        <div class="fb-section">
            <div class="fb-section-title">📖 Recommended Preparation</div>
            <div class="tag-list">${topics.map(t=>`<span class="tag tag-blue">${t}</span>`).join('')}</div>
        </div>` : ''}

        <div style="display:flex;gap:10px;margin-top:20px;justify-content:center;">
            <button class="btn btn-secondary" onclick="closeFeedback()">Close</button>
            ${currentIndex < totalQuestions - 1
                ? `<button class="btn btn-primary" onclick="closeFeedback();navigateQ(1)">Next Question →</button>`
                : `<button class="btn btn-success" onclick="finishInterview()">✅ Finish Interview</button>`
            }
        </div>
    `;
    document.getElementById('feedbackOverlay').classList.add('visible');
}

function closeFeedback() {
    document.getElementById('feedbackOverlay').classList.remove('visible');
}

// Close on backdrop click
document.getElementById('feedbackOverlay').addEventListener('click', function(e) {
    if (e.target === this) closeFeedback();
});

// ===== FINISH =====
function finishInterview() {
    if (!confirm('End the interview and view your full report?')) return;
    clearInterval(timerInterval);
    window.location.href = contextPath + '/interview/report?id=' + interviewId;
}

// ===== CAMERA =====
async function startCamera() {
    try {
        cameraStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
        const video = document.getElementById('cameraVideo');
        video.srcObject = cameraStream;
        video.style.display = 'block';
        document.getElementById('camPlaceholder').style.display = 'none';
        document.getElementById('startCamBtn').disabled = true;
        document.getElementById('stopCamBtn').disabled = false;
        document.getElementById('recordBtn').disabled = false;
        setupMicMeter(cameraStream);
    } catch (err) {
        alert('Camera/microphone access denied. You can still type your answers.\n\n' + err.message);
    }
}

function stopCamera() {
    if (cameraStream) {
        cameraStream.getTracks().forEach(t => t.stop());
        cameraStream = null;
    }
    document.getElementById('cameraVideo').style.display = 'none';
    document.getElementById('camPlaceholder').style.display = 'flex';
    document.getElementById('startCamBtn').disabled = false;
    document.getElementById('stopCamBtn').disabled = true;
    document.getElementById('recordBtn').disabled = true;
    document.getElementById('micStatus').textContent = 'Inactive';
    if (animFrame) cancelAnimationFrame(animFrame);
    document.querySelectorAll('.mic-bar').forEach(b => b.style.height = '4px');
}

function toggleRecording() {
    if (isRecording) stopRecording();
    else startRecording();
}

function startRecording() {
    // Use Web Speech API for transcription if available
    if ('webkitSpeechRecognition' in window || 'SpeechRecognition' in window) {
        const SR = window.SpeechRecognition || window.webkitSpeechRecognition;
        recognition = new SR();
        recognition.continuous = true;
        recognition.interimResults = true;
        recognition.lang = 'en-US';

        let finalTranscript = document.getElementById('answerText').value;

        recognition.onresult = (e) => {
            let interim = '';
            for (let i = e.resultIndex; i < e.results.length; i++) {
                if (e.results[i].isFinal) {
                    finalTranscript += e.results[i][0].transcript + ' ';
                } else {
                    interim += e.results[i][0].transcript;
                }
            }
            document.getElementById('answerText').value = finalTranscript + interim;
            updateWordCount();
        };
        recognition.onerror = (e) => {
            document.getElementById('transcribeStatus').textContent = 'Speech error: ' + e.error;
        };
        recognition.start();
        document.getElementById('transcribeStatus').textContent = '🔴 Recording & transcribing...';
    } else {
        document.getElementById('transcribeStatus').textContent = '(Browser speech API unavailable — type your answer)';
    }

    isRecording = true;
    document.getElementById('recordBtn').textContent = '⏹ Stop Recording';
    document.getElementById('recordBtn').classList.add('active');
    document.getElementById('recIndicator').classList.add('visible');
    document.getElementById('retryBtn').disabled = false;
}

function stopRecording() {
    if (recognition) { try { recognition.stop(); } catch(e){} recognition = null; }
    isRecording = false;
    document.getElementById('recordBtn').textContent = '🎙 Record';
    document.getElementById('recordBtn').classList.remove('active');
    document.getElementById('recIndicator').classList.remove('visible');
    document.getElementById('transcribeStatus').textContent = '✅ Recording stopped';
}

function retryAnswer() {
    if (!confirm('Clear this answer and retry?')) return;
    if (isRecording) stopRecording();
    document.getElementById('answerText').value = '';
    updateWordCount();
    document.getElementById('transcribeStatus').textContent = '';
}

// ===== MIC METER =====
function setupMicMeter(stream) {
    try {
        const ctx = new AudioContext();
        const src = ctx.createMediaStreamSource(stream);
        const analyzer = ctx.createAnalyser();
        analyzer.fftSize = 64;
        src.connect(analyzer);
        const data = new Uint8Array(analyzer.frequencyBinCount);
        const bars = document.querySelectorAll('.mic-bar');
        document.getElementById('micStatus').textContent = 'Active';

        function drawMeter() {
            animFrame = requestAnimationFrame(drawMeter);
            analyzer.getByteFrequencyData(data);
            const avg = data.reduce((a, b) => a + b, 0) / data.length;
            bars.forEach((bar, i) => {
                const h = Math.max(4, (data[i] || avg) / 4);
                bar.style.height = Math.min(24, h) + 'px';
                bar.style.background = h > 12 ? 'var(--primary)' : 'var(--border)';
            });
        }
        drawMeter();
    } catch(e) {}
}

// ===== INIT =====
loadQuestion(0);
</script>
</body>
</html>
