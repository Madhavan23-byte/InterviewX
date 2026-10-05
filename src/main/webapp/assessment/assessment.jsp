<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    String fullName = (String) session.getAttribute("fullName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Career Assessment - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .assessment-section { margin-bottom: 32px; }
        .assessment-section h3 { font-size: 16px; font-weight: 700; color: var(--text); margin-bottom: 16px; padding-bottom: 10px; border-bottom: 1px solid var(--border); }
        .interest-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 14px; }
        .interest-item { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 16px; transition: var(--transition); }
        .interest-item:hover { border-color: var(--primary); }
        .interest-label { font-size: 14px; font-weight: 600; color: var(--text); margin-bottom: 10px; display: flex; justify-content: space-between; }
        .interest-label span { color: var(--primary-light); font-weight: 700; }
        .interest-slider { width: 100%; -webkit-appearance: none; appearance: none; height: 6px; border-radius: 3px; background: var(--dark); outline: none; cursor: pointer; }
        .interest-slider::-webkit-slider-thumb { -webkit-appearance: none; width: 18px; height: 18px; border-radius: 50%; background: var(--primary); cursor: pointer; border: 2px solid white; }
        .step-indicator { display: flex; gap: 6px; margin-bottom: 28px; }
        .step { flex: 1; height: 4px; border-radius: 2px; background: var(--border); transition: var(--transition); }
        .step.active { background: var(--primary); }
        .step.done { background: var(--success); }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <header class="topbar">
        <div class="topbar-left"><span class="page-title">Career Assessment</span></div>
    </header>
    <main class="main-content">
        <div class="page-header">
            <h1>&#127919; Career Assessment</h1>
            <p>Rate your interest level for each area (0 = Not interested, 10 = Very interested). This helps us recommend the best career track for you.</p>
        </div>

        <form method="post" action="<%=request.getContextPath()%>/assessment" id="assessmentForm">
            <div class="card">
                <div class="assessment-section">
                    <h3>&#128187; Software Development Interests</h3>
                    <div class="interest-grid">
                        <div class="interest-item">
                            <div class="interest-label">Frontend Development <span id="frontend-val">5</span></div>
                            <input type="range" name="frontend" class="interest-slider" min="0" max="10" value="5" oninput="document.getElementById('frontend-val').textContent=this.value">
                            <div style="font-size:12px;color:var(--text-muted);margin-top:6px;">HTML, CSS, JavaScript, React, UI Design</div>
                        </div>
                        <div class="interest-item">
                            <div class="interest-label">Backend Development <span id="backend-val">5</span></div>
                            <input type="range" name="backend" class="interest-slider" min="0" max="10" value="5" oninput="document.getElementById('backend-val').textContent=this.value">
                            <div style="font-size:12px;color:var(--text-muted);margin-top:6px;">Java, APIs, Databases, Server-side logic</div>
                        </div>
                        <div class="interest-item">
                            <div class="interest-label">Full Stack <span id="fullstack-val">5</span></div>
                            <input type="range" name="fullstack" class="interest-slider" min="0" max="10" value="5" oninput="document.getElementById('fullstack-val').textContent=this.value">
                            <div style="font-size:12px;color:var(--text-muted);margin-top:6px;">Both frontend and backend development</div>
                        </div>
                        <div class="interest-item">
                            <div class="interest-label">Mobile Development <span id="mobile-val">3</span></div>
                            <input type="range" name="mobile" class="interest-slider" min="0" max="10" value="3" oninput="document.getElementById('mobile-val').textContent=this.value">
                            <div style="font-size:12px;color:var(--text-muted);margin-top:6px;">Android, iOS, Flutter, React Native</div>
                        </div>
                    </div>
                </div>

                <div class="assessment-section">
                    <h3>&#129302; Data & AI Interests</h3>
                    <div class="interest-grid">
                        <div class="interest-item">
                            <div class="interest-label">Data Analysis <span id="data-val">5</span></div>
                            <input type="range" name="data" class="interest-slider" min="0" max="10" value="5" oninput="document.getElementById('data-val').textContent=this.value">
                            <div style="font-size:12px;color:var(--text-muted);margin-top:6px;">SQL, Excel, Tableau, business insights</div>
                        </div>
                        <div class="interest-item">
                            <div class="interest-label">AI / Machine Learning <span id="ai-val">5</span></div>
                            <input type="range" name="ai" class="interest-slider" min="0" max="10" value="5" oninput="document.getElementById('ai-val').textContent=this.value">
                            <div style="font-size:12px;color:var(--text-muted);margin-top:6px;">ML models, deep learning, NLP, computer vision</div>
                        </div>
                    </div>
                </div>

                <div class="assessment-section">
                    <h3>&#9729;&#65039; Infrastructure & Operations</h3>
                    <div class="interest-grid">
                        <div class="interest-item">
                            <div class="interest-label">Cloud Computing <span id="cloud-val">3</span></div>
                            <input type="range" name="cloud" class="interest-slider" min="0" max="10" value="3" oninput="document.getElementById('cloud-val').textContent=this.value">
                            <div style="font-size:12px;color:var(--text-muted);margin-top:6px;">AWS, GCP, Azure, cloud architecture</div>
                        </div>
                        <div class="interest-item">
                            <div class="interest-label">DevOps <span id="devops-val">3</span></div>
                            <input type="range" name="devops" class="interest-slider" min="0" max="10" value="3" oninput="document.getElementById('devops-val').textContent=this.value">
                            <div style="font-size:12px;color:var(--text-muted);margin-top:6px;">Docker, Kubernetes, CI/CD, automation</div>
                        </div>
                        <div class="interest-item">
                            <div class="interest-label">Cybersecurity <span id="security-val">3</span></div>
                            <input type="range" name="security" class="interest-slider" min="0" max="10" value="3" oninput="document.getElementById('security-val').textContent=this.value">
                            <div style="font-size:12px;color:var(--text-muted);margin-top:6px;">Network security, ethical hacking, compliance</div>
                        </div>
                        <div class="interest-item">
                            <div class="interest-label">Blockchain <span id="blockchain-val">2</span></div>
                            <input type="range" name="blockchain" class="interest-slider" min="0" max="10" value="2" oninput="document.getElementById('blockchain-val').textContent=this.value">
                            <div style="font-size:12px;color:var(--text-muted);margin-top:6px;">Smart contracts, DApps, Web3, crypto</div>
                        </div>
                        <div class="interest-item">
                            <div class="interest-label">QA / Testing <span id="qa-val">3</span></div>
                            <input type="range" name="qa" class="interest-slider" min="0" max="10" value="3" oninput="document.getElementById('qa-val').textContent=this.value">
                            <div style="font-size:12px;color:var(--text-muted);margin-top:6px;">Manual testing, automation, Selenium, quality</div>
                        </div>
                    </div>
                </div>

                <div class="assessment-section">
                    <h3>&#129488; Problem Solving Ability</h3>
                    <div class="interest-grid">
                        <div class="interest-item">
                            <div class="interest-label">Problem Solving <span id="problemSolving-val">5</span></div>
                            <input type="range" name="problemSolving" class="interest-slider" min="0" max="10" value="5" oninput="document.getElementById('problemSolving-val').textContent=this.value">
                            <div style="font-size:12px;color:var(--text-muted);margin-top:6px;">How comfortable are you with algorithmic problem solving?</div>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-lg btn-full">
                    &#128640; Get Career Recommendations
                </button>
            </div>
        </form>
    </main>
</div>
</body>
</html>
