<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.interviewx.model.*, java.util.*" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String fullName = (String) session.getAttribute("fullName");
    StudentResume latestResume = (StudentResume) request.getAttribute("latestResume");
    Student student = (Student) request.getAttribute("student");
    @SuppressWarnings("unchecked")
    List<PreparationProfile> existingProfiles = (List<PreparationProfile>) request.getAttribute("existingProfiles");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resume & Career Role Discovery - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .discovery-hero {
            background: linear-gradient(135deg, rgba(99,102,241,0.15), rgba(14,165,233,0.1));
            border: 1px solid rgba(99,102,241,0.3);
            border-radius: var(--radius);
            padding: 28px;
            margin-bottom: 28px;
        }
        .flow-steps {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        .flow-step {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-muted);
            background: var(--surface);
            padding: 6px 14px;
            border-radius: 20px;
            border: 1px solid var(--border);
        }
        .flow-step.active {
            color: var(--primary-light);
            border-color: var(--primary);
            background: rgba(99,102,241,0.15);
        }
        .flow-arrow { color: var(--text-muted); font-size: 12px; }
        .sample-btn {
            background: var(--surface2);
            color: var(--text);
            border: 1px solid var(--border);
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 12px;
            cursor: pointer;
            transition: var(--transition);
        }
        .sample-btn:hover {
            border-color: var(--primary);
            color: var(--primary-light);
        }
        .upload-dropzone {
            border: 2px dashed var(--border);
            border-radius: var(--radius);
            padding: 30px;
            text-align: center;
            background: var(--surface);
            transition: var(--transition);
            cursor: pointer;
            margin-bottom: 20px;
        }
        .upload-dropzone:hover {
            border-color: var(--primary);
            background: rgba(99,102,241,0.05);
        }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="/sidebar.jsp" %>
    <main class="main-content">
        <div class="discovery-hero">
            <span class="badge badge-primary" style="margin-bottom:10px;">AI-Powered Career Intelligence</span>
            <h1 style="font-size:26px;font-weight:800;margin-bottom:8px;">Resume-Based Role Discovery</h1>
            <p style="color:var(--text-muted);max-width:750px;font-size:14px;line-height:1.6;">
                Instead of guessing your career direction, let InterviewX analyze your resume, extracted technical skills,
                project portfolio, and stated interests to discover roles with the strongest compatibility.
            </p>
            <div class="flow-steps">
                <div class="flow-step active"><span>1</span> Upload / Paste Resume</div>
                <span class="flow-arrow">&rarr;</span>
                <div class="flow-step"><span>2</span> Extract Skills & Projects</div>
                <span class="flow-arrow">&rarr;</span>
                <div class="flow-step"><span>3</span> Role Alignment Analysis</div>
                <span class="flow-arrow">&rarr;</span>
                <div class="flow-step"><span>4</span> Create Role Preparation Profile</div>
            </div>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger" style="margin-bottom:20px;">
                <%=request.getAttribute("error")%>
            </div>
        <% } %>

        <div class="grid-2">
            <!-- Form Column -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">&#128196; Input Your Resume Content</div>
                    <div class="card-subtitle">Upload a document (.pdf, .txt, .docx) or paste plain text below</div>
                </div>

                <form action="<%=request.getContextPath()%>/resume/upload" method="POST" enctype="multipart/form-data">
                    <div class="upload-dropzone" onclick="document.getElementById('resumeFileInput').click();">
                        <div style="font-size:36px;margin-bottom:8px;">&#128229;</div>
                        <div style="font-weight:600;margin-bottom:4px;">Click to Upload Resume File</div>
                        <div style="font-size:12px;color:var(--text-muted);">PDF, TXT, DOCX, Markdown (Up to 10MB)</div>
                        <input type="file" id="resumeFileInput" name="resumeFile" style="display:none;" onchange="handleFileSelect(this)">
                        <div id="fileSelectedName" style="margin-top:10px;font-size:13px;color:var(--success);font-weight:600;"></div>
                    </div>

                    <div class="form-group">
                        <div class="d-flex justify-content-between align-items-center" style="margin-bottom:8px;">
                            <label class="form-label" style="margin:0;">Or Paste Resume Text & Projects:</label>
                            <div class="d-flex gap-2">
                                <span style="font-size:12px;color:var(--text-muted);align-self:center;">Pre-fill:</span>
                                <button type="button" class="sample-btn" onclick="fillSample('blockchain')">Blockchain</button>
                                <button type="button" class="sample-btn" onclick="fillSample('backend')">Backend</button>
                                <button type="button" class="sample-btn" onclick="fillSample('ai')">AI/ML</button>
                            </div>
                        </div>
                        <textarea class="form-control" id="resumeText" name="resumeText" rows="12"
                            placeholder="Paste your resume text here, including skills, technologies, and projects..."></textarea>
                    </div>

                    <div style="margin-top:20px;">
                        <button type="submit" class="btn btn-primary btn-lg btn-full" style="justify-content:center;">
                            &#129302; Analyze Resume & Discover Career Roles &rarr;
                        </button>
                    </div>
                </form>
            </div>

            <!-- Context & Existing Profiles Column -->
            <div>
                <div class="card" style="margin-bottom:20px;">
                    <div class="card-header">
                        <div class="card-title">&#128736; How Role Discovery Works</div>
                    </div>
                    <ul style="padding-left:18px;color:var(--text-muted);font-size:13px;line-height:1.8;">
                        <li><strong>Skill & Keyword Extraction:</strong> Deep scan across 15 tech domains (Blockchain, Backend, AI, Cloud, DevOps, Mobile, etc.).</li>
                        <li><strong>Project Detection:</strong> Identifies architectural patterns in your project descriptions (e.g. Smart Contracts, REST APIs, Neural Networks).</li>
                        <li><strong>Personal Profile Fusion:</strong> Fuses your resume data with stated career interests and learning goals.</li>
                        <li><strong>Multi-Role Preparation:</strong> Selecting a role creates an independent <em>Preparation Profile</em> without overwriting other targets.</li>
                    </ul>
                    <div style="margin-top:16px;padding:12px;border-radius:var(--radius-sm);background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.2);font-size:12px;color:var(--warning);">
                        <strong>Advisory Notice:</strong> Role recommendations represent compatibility indicators, not rigid assignments. You can prepare for any role of your choice.
                    </div>
                </div>

                <% if (existingProfiles != null && !existingProfiles.isEmpty()) { %>
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <div>
                                <div class="card-title">Existing Preparation Profiles</div>
                                <div class="card-subtitle">You have <%=existingProfiles.size()%> active target profiles</div>
                            </div>
                            <a href="<%=request.getContextPath()%>/profiles" class="btn btn-secondary btn-sm">View All</a>
                        </div>
                        <div style="display:flex;flex-direction:column;gap:10px;">
                            <% for (PreparationProfile ep : existingProfiles) { %>
                                <div style="display:flex;align-items:center;justify-content:space-between;padding:10px 14px;background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);">
                                    <div>
                                        <div style="font-weight:600;font-size:14px;color:var(--text);"><%=ep.getTargetRole()%></div>
                                        <div style="font-size:12px;color:var(--text-muted);">Readiness: <%=ep.getReadinessPercent()%>%</div>
                                    </div>
                                    <a href="<%=request.getContextPath()%>/profiles/switch?profileId=<%=ep.getProfileId()%>" class="btn btn-secondary btn-sm">
                                        Continue &rarr;
                                    </a>
                                </div>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </main>
</div>

<script>
function handleFileSelect(input) {
    if (input.files && input.files[0]) {
        document.getElementById('fileSelectedName').textContent = 'Selected: ' + input.files[0].name;
    }
}

function fillSample(type) {
    const area = document.getElementById('resumeText');
    if (type === 'blockchain') {
        area.value = "MADHAVAN N - BLOCKCHAIN DEVELOPER RESUME\n\n" +
            "SUMMARY:\nPassionate blockchain engineer with hands-on experience developing decentralized applications, Ethereum smart contracts, and Web3 frontend integrations.\n\n" +
            "TECHNICAL SKILLS:\nLanguages & Frameworks: Solidity, JavaScript, TypeScript, Web3.js, Ethers.js, Rust, Hardhat, Foundry, Truffle\n" +
            "Blockchain & Web3: Ethereum, EVM, Smart Contracts, DeFi Protocols, ERC-20, ERC-721, MetaMask, IPFS, Decentralized Governance\n" +
            "Core Concepts: Cryptography, SHA-256, Zero-Knowledge Proofs, Gas Optimization, Reentrancy Security\n\n" +
            "KEY PROJECTS:\n" +
            "• DeFi Automated Market Maker (AMM): Developed and deployed an ERC-20 token swap protocol using Solidity and Hardhat with liquidity pool fee distribution.\n" +
            "• Decentralized Identity Verification DApp: Built a Web3 authentication system using MetaMask, Ethers.js, and IPFS for decentralized credentials.\n" +
            "• Smart Contract Security Audit: Identified and patched reentrancy and integer overflow vulnerabilities in a multi-signature treasury contract.\n\n" +
            "EDUCATION:\nB.Tech in Computer Science and Engineering - CGPA 8.8";
    } else if (type === 'backend') {
        area.value = "ARUN KUMAR - BACKEND DEVELOPER RESUME\n\n" +
            "SUMMARY:\nBackend software engineer skilled in Java, Spring Boot, microservices architecture, relational databases, and high-performance REST APIs.\n\n" +
            "TECHNICAL SKILLS:\nLanguages & Frameworks: Java, Spring Boot, Hibernate, Spring MVC, REST APIs, Microservices, Python\n" +
            "Databases & Tools: MySQL, PostgreSQL, Redis Caching, JDBC, Maven, Docker, Git, Kafka, RabbitMQ\n" +
            "Core Concepts: Data Structures, Algorithms, Object-Oriented Design, System Design, SQL Query Optimization\n\n" +
            "KEY PROJECTS:\n" +
            "• High-Throughput E-Commerce API: Built an inventory and checkout microservice with Spring Boot, MySQL, and Redis caching handling 2,000 req/sec.\n" +
            "• Real-Time Payment Notification Service: Implemented asynchronous event-driven messaging pipeline using RabbitMQ and Spring Cloud.\n" +
            "• Placement Management Portal: Designed relational database schema in MySQL with complex joins, indexes, and connection pooling.\n\n" +
            "EDUCATION:\nB.Tech in Information Technology - CGPA 8.6";
    } else if (type === 'ai') {
        area.value = "PRIYA S - AI & MACHINE LEARNING ENGINEER RESUME\n\n" +
            "SUMMARY:\nAI engineer experienced in building, training, and deploying deep learning models, natural language processing pipelines, and LLM applications.\n\n" +
            "TECHNICAL SKILLS:\nLanguages & Frameworks: Python, PyTorch, TensorFlow, Hugging Face Transformers, Scikit-Learn, Pandas, NumPy\n" +
            "AI & ML Concepts: Large Language Models, Retrieval-Augmented Generation (RAG), Vector Databases (ChromaDB), Embeddings, CNNs, Prompt Engineering\n" +
            "Tools: FastAPI, Docker, MLflow, Jupyter, Git\n\n" +
            "KEY PROJECTS:\n" +
            "• Enterprise RAG Assistant: Built a semantic document search pipeline using LangChain, Hugging Face embeddings, and ChromaDB vector store.\n" +
            "• Sentiment & Intent Classification Model: Fine-tuned BERT transformer on customer feedback achieving 94% classification accuracy.\n" +
            "• Computer Vision Defect Detection: Trained a convolutional neural network with PyTorch for automated defect inspection.\n\n" +
            "EDUCATION:\nB.Tech in Artificial Intelligence & Data Science - CGPA 9.1";
    }
}
</script>
</body>
</html>