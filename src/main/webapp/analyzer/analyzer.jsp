<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    String analysisJson = (String) request.getAttribute("analysisJson");
    String code = (String) request.getAttribute("code");
    String language = (String) request.getAttribute("language");
    String error = (String) request.getAttribute("error");
    Boolean isConfigured = (Boolean) request.getAttribute("isConfigured");
    java.util.List<java.util.Map<String,Object>> recentHistory = (java.util.List<java.util.Map<String,Object>>) request.getAttribute("recentHistory");
    if (code == null) code = "";
    if (language == null) language = "Java";
    if (isConfigured == null) isConfigured = false;
    if (recentHistory == null) recentHistory = new ArrayList<>();
    boolean hasResult = analysisJson != null && !analysisJson.isBlank();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="AI-powered code analyzer — get explanations, complexity analysis, bug detection, and interview questions from your code.">
    <title>AI Code Analyzer – InterviewX</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/main.css">
    <style>
        /* ===== CODE ANALYZER LAYOUT ===== */
        .ca-layout { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .ca-editor { font-family: 'Courier New', 'Fira Code', monospace; font-size: 13px; background: #0f0f1e; color: #e2e8f0; border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 16px; width: 100%; height: 320px; resize: vertical; line-height: 1.6; tab-size: 4; }
        .ca-editor:focus { outline: none; border-color: var(--primary); }
        .lang-bar { display: flex; gap: 8px; margin-bottom: 10px; align-items: center; flex-wrap: wrap; }
        .lang-btn { padding: 6px 14px; border: 1px solid var(--border); border-radius: 20px; font-size: 12px; font-weight: 600; cursor: pointer; background: var(--surface2); color: var(--text-muted); transition: var(--transition); }
        .lang-btn.active { border-color: var(--primary); background: rgba(99,102,241,0.15); color: var(--primary-light); }
        .quick-prompts-row { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 10px; }
        .qp-btn { padding: 5px 12px; border: 1px solid var(--border); border-radius: 16px; font-size: 11px; cursor: pointer; background: var(--surface2); color: var(--text-muted); transition: var(--transition); }
        .qp-btn:hover { border-color: var(--primary); color: var(--primary-light); }
        .no-ai-banner { background: linear-gradient(135deg, rgba(245,158,11,0.1), rgba(99,102,241,0.1)); border: 1px solid rgba(245,158,11,0.3); border-radius: var(--radius); padding: 16px 20px; margin-bottom: 20px; display: flex; align-items: center; gap: 12px; }
        .configured-badge { background: rgba(34,197,94,0.15); border: 1px solid rgba(34,197,94,0.3); border-radius: var(--radius); padding: 16px 20px; margin-bottom: 20px; display: flex; align-items: center; gap: 12px; }

        /* ===== ANALYSIS OUTPUT ===== */
        .ca-result { display: flex; flex-direction: column; gap: 16px; }
        .ca-section { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; }
        .ca-section-header { padding: 12px 16px; background: var(--surface2); border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 10px; cursor: pointer; }
        .ca-section-icon { font-size: 18px; }
        .ca-section-title { font-size: 13px; font-weight: 800; color: var(--text); flex: 1; }
        .ca-section-badge { font-size: 11px; padding: 3px 8px; background: rgba(99,102,241,0.15); border-radius: 10px; color: var(--primary-light); }
        .ca-section-body { padding: 16px; }
        .ca-text { font-size: 14px; color: var(--text); line-height: 1.7; }

        /* Line by line table */
        .line-table { width: 100%; border-collapse: collapse; font-size: 13px; }
        .line-table tr { border-bottom: 1px solid var(--border); }
        .line-table tr:last-child { border-bottom: none; }
        .line-table td { padding: 8px 12px; vertical-align: top; }
        .line-num { color: var(--text-muted); font-family: monospace; width: 40px; text-align: right; padding-right: 16px; }
        .line-code { font-family: 'Courier New', monospace; color: #7dd3fc; background: rgba(0,0,0,0.3); padding: 2px 6px; border-radius: 4px; white-space: pre-wrap; word-break: break-all; max-width: 300px; }
        .line-exp { color: var(--text-muted); font-size: 12px; }

        /* Complexity chips */
        .complexity-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .complexity-card { background: var(--dark); border-radius: var(--radius-sm); padding: 14px 16px; }
        .complexity-label { font-size: 11px; text-transform: uppercase; letter-spacing: 1px; color: var(--text-muted); margin-bottom: 6px; }
        .complexity-value { font-size: 18px; font-weight: 900; font-family: monospace; color: var(--primary-light); }
        .complexity-note { font-size: 12px; color: var(--text-muted); margin-top: 4px; }

        /* Bug / improvement chips */
        .issue-list { display: flex; flex-direction: column; gap: 8px; }
        .issue-item { display: flex; align-items: flex-start; gap: 10px; padding: 10px 12px; background: var(--dark); border-radius: var(--radius-sm); font-size: 13px; color: var(--text); }
        .issue-icon { font-size: 16px; flex-shrink: 0; }

        /* Interview questions */
        .iq-list { display: flex; flex-direction: column; gap: 8px; counter-reset: iq-counter; }
        .iq-item { display: flex; align-items: center; gap: 10px; padding: 12px 14px; background: rgba(99,102,241,0.08); border: 1px solid rgba(99,102,241,0.2); border-radius: var(--radius-sm); font-size: 13px; color: var(--text); cursor: pointer; transition: var(--transition); }
        .iq-item:hover { border-color: var(--primary); background: rgba(99,102,241,0.15); }
        .iq-num { font-size: 12px; font-weight: 800; color: var(--primary-light); min-width: 24px; }

        /* history sidebar */
        .hist-item { padding: 10px 14px; border-bottom: 1px solid var(--border); cursor: pointer; transition: var(--transition); }
        .hist-item:hover { background: var(--surface2); }
        .hist-lang { font-size: 11px; font-weight: 700; color: var(--primary-light); text-transform: uppercase; }
        .hist-preview { font-size: 12px; color: var(--text-muted); font-family: monospace; margin-top: 3px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 200px; }

        /* Loading */
        .analyze-btn { position: relative; overflow: hidden; }
        .analyze-btn::after { content: ''; position: absolute; inset: 0; background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent); transform: translateX(-100%); transition: transform 0.6s; }
        .analyze-btn.loading::after { transform: translateX(100%); }

        @media (max-width: 900px) { .ca-layout { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <header class="topbar">
        <div class="topbar-left">
            <span class="page-title">🤖 AI Code Analyzer</span>
        </div>
        <div class="topbar-right">
            <% if (isConfigured) { %>
            <span class="badge badge-success">✓ AI Configured</span>
            <% } else { %>
            <span class="badge" style="background:rgba(245,158,11,0.2);color:#f59e0b;">⚠ AI Key Missing</span>
            <% } %>
        </div>
    </header>
    <main class="main-content">
        <div class="page-header">
            <h1>🤖 AI Code Analyzer</h1>
            <p>Paste any code — get instant AI explanation, complexity analysis, bug detection, and interview questions</p>
        </div>

        <!-- Config banner -->
        <% if (!isConfigured) { %>
        <div class="no-ai-banner">
            <span style="font-size:24px;">⚙️</span>
            <div>
                <div style="font-weight:700;color:var(--text);">Set up the Code Analyzer AI Key</div>
                <div style="font-size:13px;color:var(--text-muted);margin-top:3px;">
                    Set environment variable <code>CODE_ANALYZER_GEMINI_API_KEY</code> and restart Tomcat. Basic fallback analysis is active.
                    See <a href="<%= request.getContextPath() %>/docs/GEMINI_SETUP.md" style="color:var(--primary-light);">GEMINI_SETUP.md</a> for instructions.
                </div>
            </div>
        </div>
        <% } else { %>
        <div class="configured-badge">
            <span style="font-size:24px;">✅</span>
            <div style="font-weight:600;color:var(--text);">Gemini AI Code Analyzer is active. Powered by CODE_ANALYZER_GEMINI_API_KEY.</div>
        </div>
        <% } %>

        <% if (error != null) { %>
        <div class="alert alert-error" style="margin-bottom:16px;"><strong>Error:</strong> <%= error %></div>
        <% } %>

        <div class="ca-layout">
            <!-- LEFT: Input -->
            <div>
                <form method="post" action="<%= request.getContextPath() %>/analyzer/analyze" id="analyzeForm">
                    <div class="card" style="margin-bottom:16px;">
                        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">
                            <div class="card-title">Code Input</div>
                            <button type="button" class="btn btn-secondary btn-sm" onclick="clearCode()">Clear</button>
                        </div>

                        <!-- Language selector -->
                        <div class="lang-bar" id="langBar">
                            <% String[] langs = {"Java","Python","JavaScript","C++","C","SQL","TypeScript","Go"}; %>
                            <% for (String l : langs) { %>
                            <span class="lang-btn <%= l.equals(language) ? "active" : "" %>" onclick="selectLang(this,'<%= l %>')"><%= l %></span>
                            <% } %>
                        </div>
                        <input type="hidden" name="language" id="langInput" value="<%= language %>">

                        <textarea name="code" id="codeInput" class="ca-editor" spellcheck="false"
                            placeholder="// Paste or write your code here...&#10;// Supports Java, Python, JavaScript, C++, SQL, and more&#10;&#10;public class Example {&#10;    public static void main(String[] args) {&#10;        System.out.println(&quot;Hello, World!&quot;);&#10;    }&#10;}"
                        ><%= code != null ? code.replace("<","&lt;").replace(">","&gt;") : "" %></textarea>

                        <div style="display:flex;justify-content:space-between;align-items:center;margin-top:8px;">
                            <span style="font-size:12px;color:var(--text-muted);" id="charCount">0 characters</span>
                            <span style="font-size:12px;color:var(--text-muted);">Max 8,000 characters</span>
                        </div>
                    </div>

                    <!-- Quick load examples -->
                    <div class="card" style="margin-bottom:16px;">
                        <div class="card-title" style="margin-bottom:10px;">Quick Examples</div>
                        <div class="quick-prompts-row">
                            <span class="qp-btn" onclick="loadExample('bubbleSort')">Bubble Sort</span>
                            <span class="qp-btn" onclick="loadExample('binarySearch')">Binary Search</span>
                            <span class="qp-btn" onclick="loadExample('fibonacci')">Fibonacci</span>
                            <span class="qp-btn" onclick="loadExample('linkedList')">Linked List</span>
                            <span class="qp-btn" onclick="loadExample('factorial')">Factorial</span>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg btn-full analyze-btn" id="analyzeBtn"
                            onclick="startAnalyze(this)">
                        🤖 Analyze Code with AI
                    </button>
                </form>

                <!-- History -->
                <% if (!recentHistory.isEmpty()) { %>
                <div class="card" style="margin-top:16px;">
                    <div class="card-title" style="margin-bottom:0;">Recent Analyses</div>
                    <% for (java.util.Map<String,Object> h : recentHistory) { %>
                    <div class="hist-item">
                        <div class="hist-lang"><%= h.get("language") %></div>
                        <div class="hist-preview"><%= h.get("preview") != null ? h.get("preview").toString().replace("<","&lt;") : "" %></div>
                        <div style="font-size:11px;color:var(--text-muted);margin-top:2px;"><%= h.get("analyzedAt") %></div>
                    </div>
                    <% } %>
                </div>
                <% } %>
            </div>

            <!-- RIGHT: Analysis Output -->
            <div>
                <% if (!hasResult) { %>
                <div class="card" style="text-align:center;padding:60px 24px;">
                    <div style="font-size:48px;margin-bottom:16px;">🤖</div>
                    <div style="font-size:18px;font-weight:700;color:var(--text);margin-bottom:8px;">AI Ready to Analyze</div>
                    <div style="font-size:14px;color:var(--text-muted);">Paste your code on the left and click <strong>Analyze Code</strong> to get instant AI insights including line-by-line explanation, complexity analysis, bug detection, and interview questions.</div>
                </div>
                <% } else {
                    // Parse JSON sections for display
                    String aj = analysisJson;
                %>
                <div class="ca-result" id="analysisResult">

                    <!-- 1. Overall Explanation -->
                    <div class="ca-section">
                        <div class="ca-section-header">
                            <span class="ca-section-icon">📋</span>
                            <span class="ca-section-title">Overall Explanation</span>
                        </div>
                        <div class="ca-section-body">
                            <p class="ca-text" id="overallExp">Loading...</p>
                        </div>
                    </div>

                    <!-- 2. Line-by-Line -->
                    <div class="ca-section">
                        <div class="ca-section-header" onclick="toggleSection(this)">
                            <span class="ca-section-icon">📝</span>
                            <span class="ca-section-title">Line-by-Line Explanation</span>
                            <span class="ca-section-badge" id="lineBadge">...</span>
                            <span style="color:var(--text-muted);">▼</span>
                        </div>
                        <div class="ca-section-body" id="lineByLineBody">
                            <table class="line-table" id="lineTable"><tbody></tbody></table>
                        </div>
                    </div>

                    <!-- 3. Logic Explanation -->
                    <div class="ca-section">
                        <div class="ca-section-header" onclick="toggleSection(this)">
                            <span class="ca-section-icon">🧠</span>
                            <span class="ca-section-title">Logic Flow</span>
                            <span style="color:var(--text-muted);">▼</span>
                        </div>
                        <div class="ca-section-body"><p class="ca-text" id="logicExp">Loading...</p></div>
                    </div>

                    <!-- 4. Complexity -->
                    <div class="ca-section">
                        <div class="ca-section-header">
                            <span class="ca-section-icon">⚡</span>
                            <span class="ca-section-title">Complexity Analysis</span>
                        </div>
                        <div class="ca-section-body">
                            <div class="complexity-grid" id="complexityGrid">
                                <div class="complexity-card"><div class="complexity-label">Time Complexity</div><div class="complexity-value" id="timeComp">—</div><div class="complexity-note" id="timeNote"></div></div>
                                <div class="complexity-card"><div class="complexity-label">Space Complexity</div><div class="complexity-value" id="spaceComp">—</div><div class="complexity-note" id="spaceNote"></div></div>
                            </div>
                        </div>
                    </div>

                    <!-- 5. Bugs -->
                    <div class="ca-section">
                        <div class="ca-section-header" onclick="toggleSection(this)">
                            <span class="ca-section-icon">🐛</span>
                            <span class="ca-section-title">Bugs & Potential Issues</span>
                            <span class="ca-section-badge" id="bugBadge">0</span>
                            <span style="color:var(--text-muted);">▼</span>
                        </div>
                        <div class="ca-section-body"><div class="issue-list" id="bugList"></div></div>
                    </div>

                    <!-- 6. Edge Cases -->
                    <div class="ca-section">
                        <div class="ca-section-header" onclick="toggleSection(this)">
                            <span class="ca-section-icon">🔲</span>
                            <span class="ca-section-title">Edge Cases</span>
                            <span style="color:var(--text-muted);">▼</span>
                        </div>
                        <div class="ca-section-body"><div class="issue-list" id="edgeList"></div></div>
                    </div>

                    <!-- 7. Improvements -->
                    <div class="ca-section">
                        <div class="ca-section-header" onclick="toggleSection(this)">
                            <span class="ca-section-icon">✨</span>
                            <span class="ca-section-title">Improvements & Optimizations</span>
                            <span style="color:var(--text-muted);">▼</span>
                        </div>
                        <div class="ca-section-body"><div class="issue-list" id="improvList"></div></div>
                    </div>

                    <!-- 8. Alternative Approach -->
                    <div class="ca-section">
                        <div class="ca-section-header" onclick="toggleSection(this)">
                            <span class="ca-section-icon">🔀</span>
                            <span class="ca-section-title">Alternative Approach</span>
                            <span style="color:var(--text-muted);">▼</span>
                        </div>
                        <div class="ca-section-body"><p class="ca-text" id="altApproach">Loading...</p></div>
                    </div>

                    <!-- 9. Interview Questions -->
                    <div class="ca-section">
                        <div class="ca-section-header">
                            <span class="ca-section-icon">🎤</span>
                            <span class="ca-section-title">Interview Questions from This Code</span>
                            <span class="ca-section-badge" id="iqBadge">0</span>
                        </div>
                        <div class="ca-section-body"><div class="iq-list" id="iqList"></div></div>
                    </div>

                    <!-- 10. Beginner Explanation -->
                    <div class="ca-section">
                        <div class="ca-section-header" onclick="toggleSection(this)">
                            <span class="ca-section-icon">🌱</span>
                            <span class="ca-section-title">Beginner-Friendly Explanation</span>
                            <span style="color:var(--text-muted);">▼</span>
                        </div>
                        <div class="ca-section-body"><p class="ca-text" id="beginnerExp">Loading...</p></div>
                    </div>

                </div>

                <script>
                // Parse and render the analysis JSON
                const rawJson = <%= analysisJson %>;
                try {
                    const d = (typeof rawJson === 'object') ? rawJson : JSON.parse(rawJson);

                    document.getElementById('overallExp').textContent = d.overall_explanation || 'No explanation returned.';
                    document.getElementById('logicExp').textContent = d.logic_explanation || 'N/A';
                    document.getElementById('altApproach').textContent = d.alternative_approach || 'N/A';
                    document.getElementById('beginnerExp').textContent = d.beginner_explanation || 'N/A';

                    // Complexity
                    const tc = (d.time_complexity || '').split(' - ');
                    document.getElementById('timeComp').textContent = tc[0] || '—';
                    document.getElementById('timeNote').textContent = tc.slice(1).join(' - ') || '';
                    const sc = (d.space_complexity || '').split(' - ');
                    document.getElementById('spaceComp').textContent = sc[0] || '—';
                    document.getElementById('spaceNote').textContent = sc.slice(1).join(' - ') || '';

                    // Line by line
                    const lines = d.line_by_line || [];
                    document.getElementById('lineBadge').textContent = lines.length + ' lines';
                    const tbody = document.querySelector('#lineTable tbody');
                    tbody.innerHTML = lines.map(l => `<tr>
                        <td class="line-num">${l.line}</td>
                        <td><span class="line-code">${escH(l.code || '')}</span></td>
                        <td class="line-exp">${escH(l.explanation || '')}</td>
                    </tr>`).join('');

                    // Bugs
                    const bugs = d.bugs || [];
                    document.getElementById('bugBadge').textContent = bugs.length;
                    document.getElementById('bugList').innerHTML = bugs.length
                        ? bugs.map(b=>`<div class="issue-item"><span class="issue-icon">🐛</span>${escH(b)}</div>`).join('')
                        : '<div style="color:var(--text-muted);font-size:13px;">No bugs detected ✅</div>';

                    // Edge Cases
                    const edges = d.edge_cases || [];
                    document.getElementById('edgeList').innerHTML = edges.length
                        ? edges.map(e=>`<div class="issue-item"><span class="issue-icon">🔲</span>${escH(e)}</div>`).join('')
                        : '<div style="color:var(--text-muted);font-size:13px;">No edge cases listed.</div>';

                    // Improvements
                    const improvements = d.improvements || [];
                    document.getElementById('improvList').innerHTML = improvements.length
                        ? improvements.map(i=>`<div class="issue-item"><span class="issue-icon">✨</span>${escH(i)}</div>`).join('')
                        : '<div style="color:var(--text-muted);font-size:13px;">No improvements suggested.</div>';

                    // Interview Questions
                    const iqs = d.interview_questions || [];
                    document.getElementById('iqBadge').textContent = iqs.length;
                    document.getElementById('iqList').innerHTML = iqs.map((q,i)=>`
                        <div class="iq-item" onclick="copyToClipboard('${escJs(q)}')">
                            <span class="iq-num">Q${i+1}</span>
                            <span>${escH(q)}</span>
                        </div>`).join('');
                } catch(e) {
                    document.getElementById('overallExp').textContent = 'Error parsing AI response: ' + e.message;
                }

                function escH(s){ return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
                function escJs(s){ return String(s).replace(/'/g,"\\'").replace(/\n/g,' '); }
                function copyToClipboard(text) {
                    navigator.clipboard.writeText(text).catch(()=>{});
                }
                </script>

                <% } %>
            </div>
        </div>
    </main>
</div>

<script>
// Language selection
function selectLang(el, lang) {
    document.querySelectorAll('.lang-btn').forEach(b => b.classList.remove('active'));
    el.classList.add('active');
    document.getElementById('langInput').value = lang;
}

// Character counter
document.getElementById('codeInput').addEventListener('input', function() {
    document.getElementById('charCount').textContent = this.value.length + ' characters';
    if (this.value.length > 8000) this.style.borderColor = '#ef4444';
    else this.style.borderColor = '';
});
// Init
document.getElementById('charCount').textContent = document.getElementById('codeInput').value.length + ' characters';

function clearCode() {
    document.getElementById('codeInput').value = '';
    document.getElementById('charCount').textContent = '0 characters';
}

function startAnalyze(btn) {
    const code = document.getElementById('codeInput').value.trim();
    if (!code) { alert('Please paste or write some code first.'); return false; }
    btn.innerHTML = '<span class="loading"></span> Analyzing with AI...';
    btn.disabled = true;
    btn.classList.add('loading');
}

function toggleSection(header) {
    const body = header.nextElementSibling;
    const arrow = header.querySelector('span:last-child');
    if (body.style.display === 'none') {
        body.style.display = '';
        if (arrow) arrow.textContent = '▼';
    } else {
        body.style.display = 'none';
        if (arrow) arrow.textContent = '▶';
    }
}

// Quick examples
const examples = {
    bubbleSort: { lang: 'Java', code: `public class BubbleSort {
    public static void bubbleSort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    int temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                }
            }
        }
    }
}` },
    binarySearch: { lang: 'Java', code: `public class BinarySearch {
    public static int search(int[] arr, int target) {
        int left = 0, right = arr.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (arr[mid] == target) return mid;
            else if (arr[mid] < target) left = mid + 1;
            else right = mid - 1;
        }
        return -1;
    }
}` },
    fibonacci: { lang: 'Python', code: `def fibonacci(n):
    if n <= 1:
        return n
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b` },
    linkedList: { lang: 'Java', code: `class Node { int data; Node next; Node(int d) { data = d; } }
class LinkedList {
    Node head;
    void append(int data) {
        if (head == null) { head = new Node(data); return; }
        Node cur = head;
        while (cur.next != null) cur = cur.next;
        cur.next = new Node(data);
    }
}` },
    factorial: { lang: 'Python', code: `def factorial(n):
    if n < 0:
        raise ValueError("Factorial undefined for negative numbers")
    if n == 0 or n == 1:
        return 1
    return n * factorial(n - 1)` }
};

function loadExample(key) {
    const ex = examples[key];
    if (!ex) return;
    document.getElementById('codeInput').value = ex.code;
    document.getElementById('langInput').value = ex.lang;
    document.querySelectorAll('.lang-btn').forEach(b => {
        b.classList.toggle('active', b.textContent === ex.lang);
    });
    document.getElementById('charCount').textContent = ex.code.length + ' characters';
}
</script>
</body>
</html>
