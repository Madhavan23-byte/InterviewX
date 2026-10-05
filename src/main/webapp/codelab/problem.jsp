<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.interviewx.model.CodingProblem, com.interviewx.model.CodingSubmission" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String activeRole = (String) session.getAttribute("activeProfileRole");
    if (activeRole == null) activeRole = "Target Role";

    CodingProblem p = (CodingProblem) request.getAttribute("problem");
    if (p == null) {
        response.sendRedirect(request.getContextPath() + "/codelab");
        return;
    }

    @SuppressWarnings("unchecked")
    List<CodingSubmission> submissions = (List<CodingSubmission>) request.getAttribute("submissions");
    if (submissions == null) submissions = new ArrayList<>();

    String diffBadge = "badge-easy";
    if ("Medium".equalsIgnoreCase(p.getDifficulty())) diffBadge = "badge-medium";
    else if ("Hard".equalsIgnoreCase(p.getDifficulty())) diffBadge = "badge-hard";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=p.getTitle()%> - CodeLab - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .ide-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            height: calc(100vh - 110px);
            min-height: 600px;
        }
        .panel-left {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        .panel-right {
            display: flex;
            flex-direction: column;
            gap: 14px;
            height: 100%;
            min-height: 0;
        }
        .panel-tabs {
            display: flex;
            background: rgba(15,23,42,0.6);
            border-bottom: 1px solid var(--border);
            padding: 0 16px;
        }
        .panel-tab {
            padding: 12px 16px;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-muted);
            cursor: pointer;
            border-bottom: 2px solid transparent;
            transition: var(--transition);
        }
        .panel-tab:hover { color: var(--text); }
        .panel-tab.active {
            color: var(--primary-light);
            border-bottom-color: var(--primary);
        }
        .panel-body {
            flex: 1;
            padding: 24px;
            overflow-y: auto;
        }
        .editor-card {
            background: #0d1117;
            border: 1px solid var(--border);
            border-radius: var(--radius);
            display: flex;
            flex-direction: column;
            flex: 1;
            min-height: 0;
            overflow: hidden;
        }
        .editor-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 16px;
            background: rgba(15,23,42,0.8);
            border-bottom: 1px solid var(--border);
        }
        .editor-body-wrapper {
            position: relative;
            flex: 1;
            display: flex;
            min-height: 240px;
            background: #0d1117;
        }
        .line-numbers {
            width: 44px;
            padding: 14px 6px;
            background: #090d13;
            color: #4b5563;
            font-family: 'JetBrains Mono', 'Courier New', monospace;
            font-size: 13px;
            line-height: 21px;
            text-align: right;
            user-select: none;
            border-right: 1px solid rgba(51,65,85,0.4);
            overflow: hidden;
        }
        .code-textarea {
            flex: 1;
            background: transparent;
            color: #f1f5f9;
            font-family: 'JetBrains Mono', 'Courier New', monospace;
            font-size: 13px;
            line-height: 21px;
            padding: 14px 16px;
            border: none;
            outline: none;
            resize: none;
            white-space: pre;
            overflow: auto;
            tab-size: 4;
        }
        .bottom-console {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            display: flex;
            flex-direction: column;
            height: 260px;
            overflow: hidden;
        }
        .console-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 16px;
            background: rgba(15,23,42,0.6);
            border-bottom: 1px solid var(--border);
        }
        .console-tab {
            padding: 10px 14px;
            font-size: 12px;
            font-weight: 600;
            color: var(--text-muted);
            cursor: pointer;
            border-bottom: 2px solid transparent;
        }
        .console-tab.active {
            color: var(--primary-light);
            border-bottom-color: var(--primary);
        }
        .console-body {
            flex: 1;
            padding: 14px 18px;
            overflow-y: auto;
            font-family: inherit;
        }
        .console-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 18px;
            background: rgba(15,23,42,0.4);
            border-top: 1px solid var(--border);
        }
        .test-case-chip {
            padding: 6px 12px;
            background: var(--dark);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 12px;
            cursor: pointer;
            color: var(--text-muted);
        }
        .test-case-chip.active {
            background: rgba(99,102,241,0.15);
            border-color: var(--primary);
            color: var(--primary-light);
            font-weight: 600;
        }
        pre {
            background: var(--dark);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            padding: 12px 16px;
            font-family: 'JetBrains Mono', 'Courier New', monospace;
            font-size: 13px;
            line-height: 1.6;
            color: #cbd5e1;
            white-space: pre-wrap;
            margin: 10px 0;
        }
        .verdict-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: var(--radius-sm);
            font-weight: 700;
            font-size: 14px;
            margin-bottom: 12px;
        }
        .verdict-accepted {
            background: rgba(16,185,129,0.15);
            color: #34d399;
            border: 1px solid rgba(16,185,129,0.4);
        }
        .verdict-wrong {
            background: rgba(239,68,68,0.15);
            color: #f87171;
            border: 1px solid rgba(239,68,68,0.4);
        }
        .verdict-error {
            background: rgba(245,158,11,0.15);
            color: #fbbf24;
            border: 1px solid rgba(245,158,11,0.4);
        }

        /* History Modal */
        .history-modal {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(2,6,23,0.85);
            z-index: 200;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .history-content {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            width: 100%;
            max-width: 780px;
            max-height: 85vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            box-shadow: var(--shadow);
        }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>

    <header class="topbar">
        <div class="topbar-left">
            <a href="<%=request.getContextPath()%>/codelab" class="btn btn-secondary btn-sm" style="padding:6px 12px;">
                &larr; Problem Catalog
            </a>
            <span class="page-title" style="font-size:16px;">
                #<%=String.format("%03d", p.getProblemNumber())%>. <%=p.getTitle()%>
            </span>
        </div>
        <div class="topbar-right">
            <span class="badge <%=diffBadge%>"><%=p.getDifficulty()%></span>
            <span class="badge badge-primary"><%=p.getTopic()%></span>
            <% if (p.isSolved()) { %>
                <span class="badge badge-success">&#10003; Solved (<%=activeRole%>)</span>
            <% } %>
        </div>
    </header>

    <main class="main-content" style="padding: 20px;">
        <div class="ide-container">
            <!-- LEFT PANEL: Problem Details, Examples, Constraints, External Reference -->
            <div class="panel-left">
                <div class="panel-tabs">
                    <div class="panel-tab active" onclick="switchLeftTab('desc', this)">Description</div>
                    <div class="panel-tab" onclick="switchLeftTab('history', this)">
                        Submissions (<span id="historyCountBadge"><%=submissions.size()%></span>)
                    </div>
                    <% if (p.getHints() != null && !p.getHints().trim().isEmpty()) { %>
                        <div class="panel-tab" onclick="switchLeftTab('hints', this)">Hints</div>
                    <% } %>
                </div>

                <!-- Tab 1: Description -->
                <div class="panel-body" id="tab-desc">
                    <div class="d-flex align-items-center gap-2 flex-wrap" style="margin-bottom:14px;">
                        <span class="badge <%=diffBadge%>"><%=p.getDifficulty()%></span>
                        <span class="badge badge-primary"><%=p.getTopic()%></span>
                        <% if (p.getSubtopic() != null) { %>
                            <span class="badge" style="background:var(--surface2);color:var(--text-muted);"><%=p.getSubtopic()%></span>
                        <% } %>
                    </div>

                    <h2 style="font-size:20px;font-weight:800;color:var(--text);margin-bottom:16px;">
                        <%=p.getProblemNumber()%>. <%=p.getTitle()%>
                    </h2>

                    <div style="font-size:14px;color:var(--text);line-height:1.8;margin-bottom:20px;">
                        <%=p.getDescription().replace("\n", "<br>")%>
                    </div>

                    <% if (p.getExamples() != null && !p.getExamples().trim().isEmpty()) { %>
                        <h4 style="font-size:13px;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:6px;">
                            Examples
                        </h4>
                        <pre><%=p.getExamples()%></pre>
                    <% } %>

                    <% if (p.getConstraintsText() != null && !p.getConstraintsText().trim().isEmpty()) { %>
                        <h4 style="font-size:13px;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.5px;margin:20px 0 6px;">
                            Constraints
                        </h4>
                        <pre><%=p.getConstraintsText()%></pre>
                    <% } %>

                    <% if (p.getTags() != null && !p.getTags().trim().isEmpty()) { %>
                        <div style="margin-top:20px;">
                            <div style="font-size:12px;color:var(--text-muted);margin-bottom:8px;font-weight:600;">TOPIC TAGS:</div>
                            <div class="d-flex gap-2 flex-wrap">
                                <% for (String tag : p.getTags().split(",")) { %>
                                    <span class="badge" style="background:var(--dark);border:1px solid var(--border);color:var(--text-muted);font-size:11px;">
                                        <%=tag.trim()%>
                                    </span>
                                <% } %>
                            </div>
                        </div>
                    <% } %>

                    <% if (p.getExternalLink() != null && !p.getExternalLink().trim().isEmpty()) { %>
                        <div style="margin-top:24px;padding:12px 16px;background:rgba(99,102,241,0.08);border:1px solid rgba(99,102,241,0.25);border-radius:var(--radius-sm);font-size:13px;">
                            &#128279; <strong>Roadmap Reference:</strong>
                            <a href="<%=p.getExternalLink()%>" target="_blank" rel="noopener noreferrer" style="color:var(--primary-light);text-decoration:underline;margin-left:4px;">
                                Striver's A2Z DSA Sheet Guide &rarr;
                            </a>
                        </div>
                    <% } %>
                </div>

                <!-- Tab 2: Submissions History -->
                <div class="panel-body" id="tab-history" style="display:none;">
                    <h3 style="font-size:16px;font-weight:700;color:var(--text);margin-bottom:16px;">
                        Submission History (<%=activeRole%>)
                    </h3>

                    <div id="historyTableContainer">
                        <% if (submissions.isEmpty()) { %>
                            <div class="empty-state" style="padding:40px 10px;">
                                <div style="font-size:36px;margin-bottom:10px;opacity:0.6;">&#128221;</div>
                                <h4>No Submissions Yet</h4>
                                <p style="font-size:13px;color:var(--text-muted);">
                                    Write code and click "Submit" to record an official submission for this role profile.
                                </p>
                            </div>
                        <% } else { %>
                            <table class="table" style="font-size:13px;">
                                <thead>
                                    <tr>
                                        <th>Verdict</th>
                                        <th>Language</th>
                                        <th>Runtime</th>
                                        <th>Memory</th>
                                        <th>Submitted</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (CodingSubmission s : submissions) {
                                        boolean isAcc = "Accepted".equalsIgnoreCase(s.getVerdict());
                                    %>
                                        <tr>
                                            <td>
                                                <span class="badge <%=isAcc ? "badge-success" : "badge-danger"%>">
                                                    <%=s.getVerdict()%>
                                                </span>
                                            </td>
                                            <td style="text-transform:capitalize;"><%=s.getLanguage()%></td>
                                            <td><%=s.getRuntimeMs()%> ms</td>
                                            <td><%=String.format("%.1f", s.getMemoryKb() / 1024.0)%> MB</td>
                                            <td style="color:var(--text-muted);font-size:12px;">
                                                <%=s.getSubmittedAt() != null ? s.getSubmittedAt().toString().substring(0, 16) : ""%>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </div>
                </div>

                <!-- Tab 3: Hints -->
                <% if (p.getHints() != null && !p.getHints().trim().isEmpty()) { %>
                    <div class="panel-body" id="tab-hints" style="display:none;">
                        <h3 style="font-size:16px;font-weight:700;color:var(--text);margin-bottom:16px;">
                            &#128161; Algorithmic Hints
                        </h3>
                        <pre style="white-space:pre-wrap;line-height:1.7;"><%=p.getHints()%></pre>
                    </div>
                <% } %>
            </div>

            <!-- RIGHT PANEL: Monospace Code Editor & Interactive Test Runner -->
            <div class="panel-right">
                <!-- Code Editor Card -->
                <div class="editor-card">
                    <div class="editor-header">
                        <div class="d-flex align-items-center gap-3">
                            <select id="languageSelect" class="form-control" style="width:130px;padding:6px 10px;font-size:13px;" onchange="changeLanguage()">
                                <option value="java">Java</option>
                                <option value="python">Python</option>
                                <option value="cpp">C++</option>
                                <option value="javascript">JavaScript</option>
                            </select>
                            <span style="font-size:12px;color:var(--text-muted);" id="editorStatusText">Ready</span>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <button class="btn btn-secondary btn-sm" onclick="resetCode()" title="Reset to Starter Code">&#8635; Reset</button>
                            <button class="btn btn-secondary btn-sm" onclick="clearCode()" title="Clear Editor">&#128465; Clear</button>
                        </div>
                    </div>

                    <div class="editor-body-wrapper">
                        <div class="line-numbers" id="lineNumbers">1</div>
                        <textarea class="code-textarea" id="codeEditor" spellcheck="false"
                                  oninput="updateLineNumbers()" onkeydown="handleTab(event)"><%
                            if (p.getLastCode() != null && !p.getLastCode().trim().isEmpty()) {
                                out.print(p.getLastCode());
                            } else if (p.getStarterCodeJava() != null && !p.getStarterCodeJava().trim().isEmpty()) {
                                out.print(p.getStarterCodeJava());
                            } else {
                                out.print("public class Solution {\n    // Write your solution here\n    public int solve() {\n        return 0;\n    }\n}");
                            }
                        %></textarea>
                    </div>
                </div>

                <!-- Bottom Interactive Test Console -->
                <div class="bottom-console">
                    <div class="console-header">
                        <div class="d-flex">
                            <div class="console-tab active" id="tabBtnTestcases" onclick="switchConsoleTab('cases')">
                                Test Cases
                            </div>
                            <div class="console-tab" id="tabBtnCustom" onclick="switchConsoleTab('custom')">
                                Custom Input
                            </div>
                            <div class="console-tab" id="tabBtnResult" onclick="switchConsoleTab('result')">
                                Execution Result
                            </div>
                        </div>
                        <div style="font-size:12px;color:var(--text-muted);">
                            Sandbox: Active
                        </div>
                    </div>

                    <!-- Console Tab 1: Test Cases -->
                    <div class="console-body" id="consoleTabCases">
                        <div class="d-flex gap-2" id="caseSelectorChips" style="margin-bottom:12px;">
                            <button class="test-case-chip active" onclick="selectCase(0)">Case 1</button>
                            <button class="test-case-chip" onclick="selectCase(1)">Case 2</button>
                        </div>
                        <div id="caseDetailView">
                            <div style="font-size:12px;color:var(--text-muted);font-weight:600;margin-bottom:4px;">INPUT:</div>
                            <pre id="caseInputDisplay" style="margin-top:0;padding:8px 12px;"></pre>
                            <div style="font-size:12px;color:var(--text-muted);font-weight:600;margin-top:8px;margin-bottom:4px;">EXPECTED OUTPUT:</div>
                            <pre id="caseExpectedDisplay" style="margin-top:0;padding:8px 12px;"></pre>
                        </div>
                    </div>

                    <!-- Console Tab 2: Custom Input -->
                    <div class="console-body" id="consoleTabCustom" style="display:none;">
                        <div style="font-size:12px;color:var(--text-muted);font-weight:600;margin-bottom:6px;">CUSTOM TEST INPUT:</div>
                        <textarea id="customInputArea" class="form-control" style="height:100px;font-family:'JetBrains Mono',monospace;font-size:13px;"
                                  placeholder="Enter custom input to test against your solution..."></textarea>
                    </div>

                    <!-- Console Tab 3: Execution Result -->
                    <div class="console-body" id="consoleTabResult" style="display:none;">
                        <div id="resultPlaceholder" style="color:var(--text-muted);text-align:center;padding:30px 0;">
                            Click <strong>"Run Code"</strong> to test sample cases, or <strong>"Submit"</strong> for official evaluation.
                        </div>
                        <div id="resultContent" style="display:none;"></div>
                    </div>

                    <!-- Action Footer -->
                    <div class="console-footer">
                        <div style="font-size:12px;color:var(--text-muted);" id="footerStatusMsg">
                            Profile: <%=activeRole%>
                        </div>
                        <div class="d-flex gap-2">
                            <button class="btn btn-secondary btn-sm" id="btnRunCode" onclick="runCode()">
                                &#9654; Run Code
                            </button>
                            <button class="btn btn-primary btn-sm" id="btnSubmitCode" onclick="submitCode()">
                                &#128640; Submit Code
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
// Starter templates
const templates = {
    java: `<%=p.getStarterCodeJava() != null ? p.getStarterCodeJava().replace("\\", "\\\\").replace("`", "\\`") : "public class Solution {\\n    public int solve() {\\n        return 0;\\n    }\\n}"%>`,
    python: `<%=p.getStarterCodePython() != null ? p.getStarterCodePython().replace("\\", "\\\\").replace("`", "\\`") : "class Solution:\\n    def solve(self):\\n        pass"%>`,
    cpp: `<%=p.getStarterCodeCpp() != null ? p.getStarterCodeCpp().replace("\\", "\\\\").replace("`", "\\`") : "class Solution {\\npublic:\\n    int solve() {\\n        return 0;\\n    }\\n};"%>`,
    javascript: `<%=p.getStarterCodeJs() != null ? p.getStarterCodeJs().replace("\\", "\\\\").replace("`", "\\`") : "function solve() {\\n    return 0;\\n}"%>`
};

let sampleCases = [
    { input: `[2, 5, 1, 3, 0]`, expected: `5` },
    { input: `[8, 10, 5, 7, 9]`, expected: `10` }
];

<% if (p.getExamples() != null) { %>
try {
    const rawExamples = `<%=p.getExamples().replace("\\", "\\\\").replace("`", "\\`")%>`;
    const lines = rawExamples.split('\n');
    let parsedCases = [];
    let curIn = null, curExp = null;
    for (let l of lines) {
        if (l.startsWith("Input:")) curIn = l.substring(6).trim();
        else if (l.startsWith("Output:")) curExp = l.substring(7).trim();
        if (curIn !== null && curExp !== null) {
            parsedCases.push({ input: curIn, expected: curExp });
            curIn = null; curExp = null;
        }
    }
    if (parsedCases.length > 0) sampleCases = parsedCases;
} catch (e) {}
<% } %>

function selectCase(idx) {
    const chips = document.querySelectorAll('.test-case-chip');
    chips.forEach((c, i) => c.classList.toggle('active', i === idx));
    const tc = sampleCases[idx] || sampleCases[0];
    document.getElementById('caseInputDisplay').textContent = tc.input || "(No input specified)";
    document.getElementById('caseExpectedDisplay').textContent = tc.expected || "(Expected output)";
}

function updateLineNumbers() {
    const editor = document.getElementById('codeEditor');
    const lines = editor.value.split('\n').length;
    let html = '';
    for (let i = 1; i <= lines; i++) html += i + '<br>';
    document.getElementById('lineNumbers').innerHTML = html;
}

function handleTab(e) {
    if (e.key === 'Tab') {
        e.preventDefault();
        const start = e.target.selectionStart;
        const end = e.target.selectionEnd;
        e.target.value = e.target.value.substring(0, start) + "    " + e.target.value.substring(end);
        e.target.selectionStart = e.target.selectionEnd = start + 4;
        updateLineNumbers();
    }
}

function changeLanguage() {
    const lang = document.getElementById('languageSelect').value;
    if (templates[lang]) {
        document.getElementById('codeEditor').value = templates[lang];
        updateLineNumbers();
    }
}

function resetCode() {
    changeLanguage();
}

function clearCode() {
    document.getElementById('codeEditor').value = '';
    updateLineNumbers();
}

function switchLeftTab(tabName, el) {
    document.querySelectorAll('.panel-tabs .panel-tab').forEach(t => t.classList.remove('active'));
    el.classList.add('active');
    document.getElementById('tab-desc').style.display = tabName === 'desc' ? 'block' : 'none';
    document.getElementById('tab-history').style.display = tabName === 'history' ? 'block' : 'none';
    const hints = document.getElementById('tab-hints');
    if (hints) hints.style.display = tabName === 'hints' ? 'block' : 'none';
}

function switchConsoleTab(tab) {
    document.getElementById('tabBtnTestcases').classList.toggle('active', tab === 'cases');
    document.getElementById('tabBtnCustom').classList.toggle('active', tab === 'custom');
    document.getElementById('tabBtnResult').classList.toggle('active', tab === 'result');

    document.getElementById('consoleTabCases').style.display = tab === 'cases' ? 'block' : 'none';
    document.getElementById('consoleTabCustom').style.display = tab === 'custom' ? 'block' : 'none';
    document.getElementById('consoleTabResult').style.display = tab === 'result' ? 'block' : 'none';
}

// RUN CODE (Part 9 & 12)
function runCode() {
    executeAction('<%=request.getContextPath()%>/codelab/run', false);
}

// SUBMIT CODE (Part 9 & 12)
function submitCode() {
    executeAction('<%=request.getContextPath()%>/codelab/submit', true);
}

function executeAction(endpoint, isSubmit) {
    const code = document.getElementById('codeEditor').value;
    const lang = document.getElementById('languageSelect').value;
    const customIn = document.getElementById('customInputArea').value;

    if (!code.trim()) {
        switchConsoleTab('result');
        showExecutionResult({ verdict: 'Compilation Error', message: 'Source code is empty.', errorDetails: 'Please write code before running.' });
        return;
    }

    const btn = isSubmit ? document.getElementById('btnSubmitCode') : document.getElementById('btnRunCode');
    const origHtml = btn.innerHTML;
    btn.innerHTML = '<span class="loading"></span> ' + (isSubmit ? 'Evaluating...' : 'Running...');
    btn.disabled = true;

    switchConsoleTab('result');
    document.getElementById('resultPlaceholder').innerHTML = '<span class="loading"></span> Executing in safe sandboxed environment...';
    document.getElementById('resultPlaceholder').style.display = 'block';
    document.getElementById('resultContent').style.display = 'none';

    const params = new URLSearchParams();
    params.append('problemId', '<%=p.getProblemId()%>');
    params.append('language', lang);
    params.append('code', code);
    if (!isSubmit && customIn.trim()) {
        params.append('customInput', customIn);
    }

    fetch(endpoint, {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: params.toString()
    })
    .then(r => r.json())
    .then(data => {
        btn.innerHTML = origHtml;
        btn.disabled = false;
        showExecutionResult(data);
        if (isSubmit && data.isSaved) {
            refreshSubmissionHistory();
        }
    })
    .catch(err => {
        btn.innerHTML = origHtml;
        btn.disabled = false;
        showExecutionResult({
            verdict: 'Execution Error',
            message: 'Server communication error.',
            errorDetails: String(err)
        });
    });
}

function showExecutionResult(res) {
    document.getElementById('resultPlaceholder').style.display = 'none';
    const container = document.getElementById('resultContent');
    container.style.display = 'block';

    const isAccepted = res.verdict === 'Accepted';
    let vClass = isAccepted ? 'verdict-accepted' : (res.verdict === 'Wrong Answer' ? 'verdict-wrong' : 'verdict-error');
    let vIcon = isAccepted ? '&#10003;' : (res.verdict === 'Wrong Answer' ? '&#10007;' : '&#9888;');

    let html = `
        <div class="verdict-tag \${vClass}">
            <span>\${vIcon}</span> \${res.verdict}
        </div>
        <div style="font-size:13px;color:var(--text);margin-bottom:12px;">\${res.message || ''}</div>
    `;

    if (res.runtimeMs || res.memoryKb) {
        html += `
            <div class="d-flex gap-4" style="margin-bottom:14px;font-size:12px;color:var(--text-muted);background:var(--dark);padding:8px 12px;border-radius:var(--radius-sm);border:1px solid var(--border);">
                <span>Runtime: <strong style="color:var(--text);">\${res.runtimeMs} ms</strong></span>
                <span>Memory: <strong style="color:var(--text);">\${(res.memoryKb / 1024).toFixed(1)} MB</strong></span>
                <span>Test Cases: <strong style="color:var(--text);">\${res.passedTests || 0} / \${res.totalTests || 0} passed</strong></span>
            </div>
        `;
    }

    if (res.errorDetails) {
        html += `<pre style="color:#f87171;background:rgba(239,68,68,0.06);border-color:rgba(239,68,68,0.25);">\${res.errorDetails}</pre>`;
    }

    if (res.testCases && res.testCases.length > 0) {
        html += '<div style="margin-top:10px;"><div style="font-size:12px;font-weight:700;color:var(--text-muted);margin-bottom:6px;">TEST CASE RESULTS:</div>';
        res.testCases.forEach(tc => {
            const p = tc.passed;
            html += `
                <div style="background:var(--dark);border:1px solid var(--border);border-radius:var(--radius-sm);padding:8px 12px;margin-bottom:6px;font-size:12px;">
                    <div class="d-flex justify-content-between">
                        <strong>Case #\${tc.caseNumber}</strong>
                        <span style="color:\${p ? 'var(--success)' : 'var(--danger)'};font-weight:700;">\${p ? '&#10003; Passed' : '&#10007; Failed'}</span>
                    </div>
                    <div style="color:var(--text-muted);margin-top:4px;">Input: <code>\${tc.input}</code></div>
                    <div style="color:var(--text-muted);">Expected: <code>\${tc.expected}</code> | Got: <code>\${tc.actual}</code></div>
                </div>
            `;
        });
        html += '</div>';
    }

    container.innerHTML = html;
}

function refreshSubmissionHistory() {
    fetch('<%=request.getContextPath()%>/codelab/submissions?problemId=<%=p.getProblemId()%>')
    .then(r => r.json())
    .then(list => {
        document.getElementById('historyCountBadge').textContent = list.length;
        if (list.length === 0) return;
        let html = `
            <table class="table" style="font-size:13px;">
                <thead>
                    <tr><th>Verdict</th><th>Language</th><th>Runtime</th><th>Memory</th><th>Submitted</th></tr>
                </thead>
                <tbody>
        `;
        list.forEach(s => {
            let isAcc = s.verdict === 'Accepted';
            html += `
                <tr>
                    <td><span class="badge \${isAcc ? 'badge-success' : 'badge-danger'}">\${s.verdict}</span></td>
                    <td style="text-transform:capitalize;">\${s.language}</td>
                    <td>\${s.runtimeMs} ms</td>
                    <td>\${(s.memoryKb / 1024).toFixed(1)} MB</td>
                    <td style="color:var(--text-muted);font-size:12px;">\${s.submittedAt.substring(0, 16)}</td>
                </tr>
            `;
        });
        html += '</tbody></table>';
        document.getElementById('historyTableContainer').innerHTML = html;
    });
}

document.addEventListener('DOMContentLoaded', () => {
    updateLineNumbers();
    selectCase(0);
});
</script>
</body>
</html>
