<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String currentRole = (String) session.getAttribute("role");
    if (currentRole == null || !"ADMIN".equalsIgnoreCase(currentRole)) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Administrator privileges required.");
        return;
    }

    Boolean interviewConfigured = (Boolean) request.getAttribute("interviewConfigured");
    String interviewMaskedKey = (String) request.getAttribute("interviewMaskedKey");
    if (interviewMaskedKey == null) interviewMaskedKey = "Not Configured";

    Boolean codeAnalyzerConfigured = (Boolean) request.getAttribute("codeAnalyzerConfigured");
    String codeAnalyzerMaskedKey = (String) request.getAttribute("codeAnalyzerMaskedKey");
    if (codeAnalyzerMaskedKey == null) codeAnalyzerMaskedKey = "Not Configured";

    Boolean resumeAnalyzerConfigured = (Boolean) request.getAttribute("resumeAnalyzerConfigured");
    String resumeAnalyzerMaskedKey = (String) request.getAttribute("resumeAnalyzerMaskedKey");
    if (resumeAnalyzerMaskedKey == null) resumeAnalyzerMaskedKey = "Not Configured";

    String configFilePath = (String) request.getAttribute("configFilePath");
    String geminiModel = (String) request.getAttribute("geminiModel");
    if (geminiModel == null) geminiModel = "gemini-1.5-flash";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Configuration Center - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .config-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 24px;
            margin-bottom: 30px;
        }
        .ai-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 24px;
            position: relative;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .ai-card:hover {
            border-color: var(--primary-light);
            box-shadow: 0 4px 20px rgba(99, 102, 241, 0.1);
        }
        .ai-card-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: 12px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .ai-card-title {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--text);
        }
        .ai-card-icon {
            font-size: 1.6rem;
            width: 44px;
            height: 44px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: var(--radius-sm);
            background: rgba(99, 102, 241, 0.15);
            border: 1px solid rgba(99, 102, 241, 0.3);
        }
        .ai-card-desc {
            color: var(--text-muted);
            font-size: 0.9rem;
            line-height: 1.5;
            margin-bottom: 18px;
        }
        .key-input-group {
            display: flex;
            gap: 10px;
            margin-bottom: 12px;
            flex-wrap: wrap;
        }
        .key-input-wrapper {
            position: relative;
            flex: 1;
            min-width: 280px;
        }
        .key-input-wrapper input {
            width: 100%;
            padding: 10px 42px 10px 14px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            color: var(--text);
            font-size: 0.95rem;
            font-family: monospace;
            box-sizing: border-box;
            transition: border-color 0.2s;
        }
        .key-input-wrapper input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.25);
        }
        .toggle-visibility-btn {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            font-size: 1.1rem;
            padding: 4px;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 9999px;
            font-size: 0.82rem;
            font-weight: 600;
        }
        .status-badge.configured {
            background: rgba(16, 185, 129, 0.15);
            color: #34d399;
            border: 1px solid rgba(16, 185, 129, 0.3);
        }
        .status-badge.unconfigured {
            background: rgba(245, 158, 11, 0.15);
            color: #fbbf24;
            border: 1px solid rgba(245, 158, 11, 0.3);
        }
        .status-badge.testing {
            background: rgba(99, 102, 241, 0.15);
            color: #818cf8;
            border: 1px solid rgba(99, 102, 241, 0.3);
        }
        .status-badge.failed {
            background: rgba(239, 68, 68, 0.15);
            color: #f87171;
            border: 1px solid rgba(239, 68, 68, 0.3);
        }
        .msg-box {
            display: none;
            padding: 10px 14px;
            border-radius: var(--radius-sm);
            font-size: 0.88rem;
            margin-top: 10px;
            animation: fadeIn 0.2s ease-in;
        }
        .msg-box.success {
            display: block;
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.3);
            color: #34d399;
        }
        .msg-box.error {
            display: block;
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.3);
            color: #f87171;
        }
        .info-panel {
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 20px 24px;
            margin-top: 30px;
        }
        .info-panel h4 {
            margin: 0 0 10px 0;
            color: var(--text);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .code-tag {
            background: rgba(0, 0, 0, 0.35);
            padding: 2px 8px;
            border-radius: 4px;
            font-family: monospace;
            font-size: 0.88rem;
            color: #a5b4fc;
            border: 1px solid rgba(255, 255, 255, 0.08);
            word-break: break-all;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-4px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .spinner {
            display: inline-block;
            width: 14px;
            height: 14px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 0.8s ease-in-out infinite;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="/sidebar.jsp" %>
    <main class="main-content">
        <header class="topbar">
            <div>
                <h1 style="font-size:1.6rem;font-weight:700;margin:0 0 4px 0;display:flex;align-items:center;gap:10px;">
                    <span>&#9881;&#65039;</span> AI Configuration Center
                </h1>
                <p style="color:var(--text-muted);margin:0;font-size:0.95rem;">
                    Configure and test independent Google Gemini API keys for each AI intelligence module.
                </p>
            </div>
            <div style="display:flex;align-items:center;gap:10px;">
                <span class="badge badge-primary">Model: <%=geminiModel%></span>
                <span class="badge badge-secondary">Admin Mode</span>
            </div>
        </header>

        <div class="content-body" style="padding: 24px;">
            <div class="config-grid">

                <!-- ============================================== -->
                <!-- 1. INTERVIEW AI -->
                <!-- ============================================== -->
                <div class="ai-card" id="card-interview">
                    <div class="ai-card-header">
                        <div class="ai-card-title">
                            <div class="ai-card-icon">&#127908;</div>
                            <div>
                                <div>Interview AI</div>
                                <div style="font-size:0.8rem;font-weight:400;color:var(--text-muted);">
                                    Environment Variable: <span class="code-tag">INTERVIEW_AI_GEMINI_API_KEY</span>
                                </div>
                            </div>
                        </div>
                        <span id="interviewBadge" class="status-badge <%=interviewConfigured ? "configured" : "unconfigured"%>">
                            <%=interviewConfigured ? "Configured (" + interviewMaskedKey + ")" : "Not Configured"%>
                        </span>
                    </div>

                    <div class="ai-card-desc">
                        Gemini API key used exclusively for real-time mock interview question generation,
                        spoken answer evaluation, technical accuracy assessment, and candidate feedback scoring.
                    </div>

                    <div class="key-input-group">
                        <div class="key-input-wrapper">
                            <input type="password" id="interviewKeyInput"
                                   placeholder="Paste Interview AI Gemini API key"
                                   autocomplete="new-password" />
                            <button type="button" class="toggle-visibility-btn" onclick="toggleVisibility('interviewKeyInput', this)" title="Show/Hide">
                                &#128065;
                            </button>
                        </div>
                        <div class="action-buttons">
                            <button type="button" class="btn btn-primary" id="btnSaveInterview" onclick="saveKey('INTERVIEW')">
                                Save
                            </button>
                            <button type="button" class="btn btn-secondary" id="btnTestInterview" onclick="testConnection('INTERVIEW')">
                                Test Connection
                            </button>
                        </div>
                    </div>
                    <div id="msgInterview" class="msg-box"></div>
                </div>

                <!-- ============================================== -->
                <!-- 2. CODE ANALYZER AI -->
                <!-- ============================================== -->
                <div class="ai-card" id="card-code">
                    <div class="ai-card-header">
                        <div class="ai-card-title">
                            <div class="ai-card-icon">&#128187;</div>
                            <div>
                                <div>Code Analyzer AI</div>
                                <div style="font-size:0.8rem;font-weight:400;color:var(--text-muted);">
                                    Environment Variable: <span class="code-tag">CODE_ANALYZER_GEMINI_API_KEY</span>
                                </div>
                            </div>
                        </div>
                        <span id="codeBadge" class="status-badge <%=codeAnalyzerConfigured ? "configured" : "unconfigured"%>">
                            <%=codeAnalyzerConfigured ? "Configured (" + codeAnalyzerMaskedKey + ")" : "Not Configured"%>
                        </span>
                    </div>

                    <div class="ai-card-desc">
                        Gemini API key used exclusively for deep code explanation, line-by-line breakdown,
                        time/space complexity analysis, bug detection, edge case discovery, and alternative approaches.
                    </div>

                    <div class="key-input-group">
                        <div class="key-input-wrapper">
                            <input type="password" id="codeKeyInput"
                                   placeholder="Paste Code Analyzer Gemini API key"
                                   autocomplete="new-password" />
                            <button type="button" class="toggle-visibility-btn" onclick="toggleVisibility('codeKeyInput', this)" title="Show/Hide">
                                &#128065;
                            </button>
                        </div>
                        <div class="action-buttons">
                            <button type="button" class="btn btn-primary" id="btnSaveCode" onclick="saveKey('CODE_ANALYZER')">
                                Save
                            </button>
                            <button type="button" class="btn btn-secondary" id="btnTestCode" onclick="testConnection('CODE_ANALYZER')">
                                Test Connection
                            </button>
                        </div>
                    </div>
                    <div id="msgCode" class="msg-box"></div>
                </div>

                <!-- ============================================== -->
                <!-- 3. RESUME ANALYZER AI -->
                <!-- ============================================== -->
                <div class="ai-card" id="card-resume">
                    <div class="ai-card-header">
                        <div class="ai-card-title">
                            <div class="ai-card-icon">&#128196;</div>
                            <div>
                                <div>Resume Analyzer AI</div>
                                <div style="font-size:0.8rem;font-weight:400;color:var(--text-muted);">
                                    Environment Variable: <span class="code-tag">RESUME_ANALYZER_GEMINI_API_KEY</span>
                                </div>
                            </div>
                        </div>
                        <span id="resumeBadge" class="status-badge <%=resumeAnalyzerConfigured ? "configured" : "unconfigured"%>">
                            <%=resumeAnalyzerConfigured ? "Configured (" + resumeAnalyzerMaskedKey + ")" : "Not Configured"%>
                        </span>
                    </div>

                    <div class="ai-card-desc">
                        Gemini API key used exclusively for intelligent resume parsing, technical skill extraction,
                        career role recommendations, skill-gap analysis, and tailored learning track mappings.
                    </div>

                    <div class="key-input-group">
                        <div class="key-input-wrapper">
                            <input type="password" id="resumeKeyInput"
                                   placeholder="Paste Resume Analyzer Gemini API key"
                                   autocomplete="new-password" />
                            <button type="button" class="toggle-visibility-btn" onclick="toggleVisibility('resumeKeyInput', this)" title="Show/Hide">
                                &#128065;
                            </button>
                        </div>
                        <div class="action-buttons">
                            <button type="button" class="btn btn-primary" id="btnSaveResume" onclick="saveKey('RESUME_ANALYZER')">
                                Save
                            </button>
                            <button type="button" class="btn btn-secondary" id="btnTestResume" onclick="testConnection('RESUME_ANALYZER')">
                                Test Connection
                            </button>
                        </div>
                    </div>
                    <div id="msgResume" class="msg-box"></div>
                </div>

            </div>

            <!-- Configuration Storage Details -->
            <div class="info-panel">
                <h4><span>&#128274;</span> Secure Server-Side Storage Architecture</h4>
                <p style="margin:0 0 10px 0;color:var(--text-muted);font-size:0.9rem;line-height:1.6;">
                    API keys are stored exclusively in local server-side configuration outside of the public web directory.
                    Keys are never exposed in HTML, JavaScript, MySQL users tables, browser cookies, or Git repositories.
                </p>
                <div style="font-size:0.88rem;color:var(--text);margin-bottom:6px;">
                    <strong>Active Configuration File:</strong> <span class="code-tag"><%=configFilePath != null ? configFilePath : "ai.properties"%></span>
                </div>
                <div style="font-size:0.85rem;color:var(--text-muted);">
                    When you save a key above, it is immediately updated in server memory and persisted to the properties file.
                    Restarting Tomcat is optional and not strictly required.
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    const CONTEXT_PATH = '<%=request.getContextPath()%>';

    function toggleVisibility(inputId, btn) {
        const input = document.getElementById(inputId);
        if (input.type === 'password') {
            input.type = 'text';
            btn.innerHTML = '&#128064;';
        } else {
            input.type = 'password';
            btn.innerHTML = '&#128065;';
        }
    }

    function getElementsForType(type) {
        if (type.includes('INTERVIEW')) {
            return {
                input: document.getElementById('interviewKeyInput'),
                badge: document.getElementById('interviewBadge'),
                msg: document.getElementById('msgInterview'),
                btnSave: document.getElementById('btnSaveInterview'),
                btnTest: document.getElementById('btnTestInterview'),
                title: 'Interview AI'
            };
        } else if (type.includes('CODE')) {
            return {
                input: document.getElementById('codeKeyInput'),
                badge: document.getElementById('codeBadge'),
                msg: document.getElementById('msgCode'),
                btnSave: document.getElementById('btnSaveCode'),
                btnTest: document.getElementById('btnTestCode'),
                title: 'Code Analyzer AI'
            };
        } else if (type.includes('RESUME')) {
            return {
                input: document.getElementById('resumeKeyInput'),
                badge: document.getElementById('resumeBadge'),
                msg: document.getElementById('msgResume'),
                btnSave: document.getElementById('btnSaveResume'),
                btnTest: document.getElementById('btnTestResume'),
                title: 'Resume Analyzer AI'
            };
        }
        return null;
    }

    function showMessage(msgElem, text, isSuccess) {
        msgElem.className = 'msg-box ' + (isSuccess ? 'success' : 'error');
        msgElem.innerText = text;
        msgElem.style.display = 'block';
    }

    async function saveKey(type) {
        const els = getElementsForType(type);
        if (!els) return;

        const keyVal = els.input.value.trim();
        if (!keyVal) {
            showMessage(els.msg, 'Please paste an API key before saving.', false);
            els.input.focus();
            return;
        }

        els.btnSave.disabled = true;
        const originalText = els.btnSave.innerHTML;
        els.btnSave.innerHTML = '<span class="spinner"></span> Saving...';

        try {
            const formData = new URLSearchParams();
            formData.append('action', 'save');
            formData.append('type', type);
            formData.append('key', keyVal);

            const resp = await fetch(CONTEXT_PATH + '/admin/ai-config', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            });

            const data = await resp.json();
            if (data.success) {
                showMessage(els.msg, data.message || 'Key saved successfully!', true);
                els.badge.className = 'status-badge configured';
                els.badge.innerText = 'Configured (' + data.maskedKey + ')';
                els.input.value = ''; // Always clear password input after saving
            } else {
                showMessage(els.msg, data.message || 'Failed to save API key.', false);
            }
        } catch (err) {
            showMessage(els.msg, 'Network error while saving API key: ' + err.message, false);
        } finally {
            els.btnSave.disabled = false;
            els.btnSave.innerHTML = originalText;
        }
    }

    async function testConnection(type) {
        const els = getElementsForType(type);
        if (!els) return;

        els.btnTest.disabled = true;
        const originalText = els.btnTest.innerHTML;
        els.btnTest.innerHTML = '<span class="spinner"></span> Testing...';
        els.badge.className = 'status-badge testing';
        els.badge.innerText = 'Testing Connection...';

        try {
            const formData = new URLSearchParams();
            formData.append('action', 'test');
            formData.append('type', type);

            const resp = await fetch(CONTEXT_PATH + '/admin/ai-config', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            });

            const data = await resp.json();
            if (data.success) {
                els.badge.className = 'status-badge configured';
                els.badge.innerText = 'Connection Successful ?';
                showMessage(els.msg, 'Connection Successful ?: Gemini model responded OK.', true);
            } else {
                els.badge.className = 'status-badge failed';
                els.badge.innerText = 'Connection Failed ?';
                showMessage(els.msg, data.message || 'Connection Failed ?', false);
            }
        } catch (err) {
            els.badge.className = 'status-badge failed';
            els.badge.innerText = 'Connection Failed ?';
            showMessage(els.msg, 'Network or server error: ' + err.message, false);
        } finally {
            els.btnTest.disabled = false;
            els.btnTest.innerHTML = originalText;
        }
    }
</script>
</body>
</html>
