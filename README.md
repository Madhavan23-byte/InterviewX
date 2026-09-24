# InterviewX — AI-Powered Mock Placement & Interview Platform

InterviewX is a realistic, production-quality college placement-training and mock interview simulation platform where students can practice an authentic 3-stage recruitment process (Coding → Group Discussion → HR Panel Interview) with immediate AI-powered scoring, feedback, and comprehensive placement readiness reports.

---

## 🚀 Live Demo & Access

- **Frontend URL:** [http://localhost:5173/](http://localhost:5173/)
- **Backend API & Swagger Docs:** [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)
- **Health Check:** [http://127.0.0.1:8000/api/health](http://127.0.0.1:8000/api/health)

### 🔑 Demo Credentials (1-Click Fill on Login)

| Role | Email | Password | Details |
|------|-------|----------|---------|
| **Student Candidate** | `student@demo.com` | `password123` | Aditya Sharma, National Institute of Technology |
| **Placement Officer / Interviewer** | `interviewer@demo.com` | `password123` | Dr. Priya Nair, Corporate Relations & Placement Director |

---

## 🛠️ Technology Stack

- **Frontend:**
  - React 19 + Vite 8
  - Tailwind CSS 3 (modern dark mode palette, glassmorphism, responsive cards)
  - React Router DOM 7 (role-guarded protected routes)
  - Axios (JWT bearer interceptors, centralized error handling)
  - Lucide React (feather-style modern icons)
  - Canvas Confetti (celebratory placement completion)
- **Backend:**
  - Python 3 + FastAPI
  - Pydantic v2 (strict request & response models)
  - PyJWT & Bcrypt (production password hashing & HS256 tokens)
  - Uvicorn (ASGI web server)
- **Database:**
  - Dual-mode resilient persistence:
    - Primary: MongoDB (`MONGO_URI`, e.g., `mongodb://localhost:27017/interviewx`)
    - Fallback: Persistent document store (`backend/data/interviewx_db.json`) that automatically engages if local MongoDB server is offline, guaranteeing 100% hackathon reliability with zero crashes and full disk persistence across restarts.
  - Collections: `users`, `mock_drives`, `coding_questions`, `gd_topics`, `hr_questions`, `interview_attempts`, `round_results`, `final_results`.
- **AI Evaluation Engine:**
  - Google Gemini API (`gemini-1.5-flash`) through backend service.
  - Deterministic intelligent fallback evaluator ensuring full functionality even if API key is not configured or network quota is exceeded.

---

## 🔄 Complete 3-Round Placement Pipeline

```
Student Login
   ↓
Student Dashboard (Company selection: TCS, Infosys, Zoho)
   ↓
[Round 1: Algorithmic Coding] (Weight: 40%)
   - Problem Statement, Constraints, Examples
   - Language selector (Python 3, JavaScript, Java, C++)
   - Safe test case runner with immediate pass/fail diagnostics
   ↓
[Round 2: Group Discussion (GD)] (Weight: 25%)
   - Authentic placement topic (e.g., "Will AI replace traditional jobs?")
   - Real-time simulated peer discourse (Rohan, Meera, Vikram)
   - Structured candidate response
   - AI Criteria Evaluation: Clarity, Relevance, Structure, Communication, Critical Thinking
   ↓
[Round 3: HR / Personal Interview] (Weight: 35%)
   - Recruiter avatar & prompt guidance (STAR method)
   - 6 Core Placement Questions (Self-Intro, Value Fit, Capstone Project, Strengths, Weaknesses, 5-Year Vision)
   - AI Communication indicators scoring
   ↓
Final Placement Performance Report
   - Overall Score (0-100)
   - Round-wise weighted scores
   - Key Evaluated Strengths & Actionable Improvements
   - Recommended Practice Areas & Printable PDF report
   ↓
Placement Officer Dashboard
   - Candidate cohort monitoring table
   - Real-time progression tracking & score audit
   - Mock drive creator with custom rounds & difficulty toggles
```

---

## 📦 Project Structure

```
interviewx/
├── backend/
│   ├── data/
│   │   └── interviewx_db.json      # Persistent document store
│   ├── routers/
│   │   ├── auth_router.py          # /api/auth (login, me, register)
│   │   ├── drives_router.py        # /api/drives (CRUD, questions resolution)
│   │   ├── interviews_router.py    # /api/interviews (start, run-code, rounds, complete)
│   │   ├── results_router.py       # /api/results & /api/interviewer (reports, monitoring, analytics)
│   │   └── ai_router.py            # /api/ai (direct GD & HR evaluation)
│   ├── services/
│   │   ├── ai_service.py           # Gemini integration & deterministic heuristics
│   │   └── code_evaluator.py       # Sandboxed, controlled test case execution
│   ├── auth.py                     # Bcrypt hashing & JWT verification
│   ├── config.py                   # Environment configuration
│   ├── database.py                 # Dual-mode PyMongo/DocumentStore manager
│   ├── models.py                   # Pydantic data schemas
│   ├── seed_data.py                # Database seeder (drives, questions, accounts)
│   ├── main.py                     # FastAPI entrypoint & CORS middleware
│   ├── .env                        # Local configuration
│   └── .env.example
├── frontend/
│   ├── src/
│   │   ├── api/
│   │   │   └── client.js           # Axios instance with JWT interceptor
│   │   ├── components/
│   │   │   ├── Navbar.jsx          # Role-aware navigation header
│   │   │   ├── ProgressIndicator.jsx# Visual round stepper
│   │   │   ├── Timer.jsx           # Clamped persistent countdown timer
│   │   │   ├── StatusBadge.jsx     # Difficulty & state chips
│   │   │   ├── Modal.jsx           # Accessible dialog
│   │   │   └── ProtectedRoute.jsx  # Role-based route guard
│   │   ├── context/
│   │   │   ├── AuthContext.jsx     # User session state
│   │   │   └── ToastContext.jsx    # Alert toast notifications
│   │   ├── pages/
│   │   │   ├── LandingPage.jsx     # Marketing & feature showcase
│   │   │   ├── auth/
│   │   │   │   └── LoginPage.jsx   # Role switcher & 1-click demo login
│   │   │   ├── student/
│   │   │   │   └── StudentDashboard.jsx # Active drives & student stats
│   │   │   ├── interview/
│   │   │   │   ├── InterviewRoom.jsx   # Master round coordinator
│   │   │   │   ├── CodingRound.jsx     # Editor & test case validation
│   │   │   │   ├── GDRound.jsx         # Peer discussion simulation & AI
│   │   │   │   ├── HRRound.jsx         # HR panel questions & communication
│   │   │   │   └── ResultReportPage.jsx# Placement report & confetti
│   │   │   └── interviewer/
│   │   │       ├── InterviewerDashboard.jsx # Cohort monitoring & stats
│   │   │       └── CreateDriveModal.jsx     # Drive creator modal
│   │   ├── App.jsx                 # Route declarations
│   │   ├── main.jsx
│   │   └── index.css               # Tailwind directives & dark theme
│   ├── index.html
│   ├── tailwind.config.js
│   └── vite.config.js              # Proxy to port 8000
└── README.md
```

---

## ⚙️ Running Locally

### 1. Start the Backend (Port 8000)
```powershell
cd C:\Users\madha\.gemini\antigravity-ide\scratch\interviewx\backend
python -m uvicorn main:app --host 127.0.0.1 --port 8000 --reload
```

### 2. Start the Frontend (Port 5173)
```powershell
cd C:\Users\madha\.gemini\antigravity-ide\scratch\interviewx\frontend
npm run dev
```

Visit **http://localhost:5173/** in your browser.

---

## 📡 Complete REST API Endpoints

### Authentication
- `POST /api/auth/login` — Authenticate student or interviewer, return JWT & user profile
- `GET /api/auth/me` — Return current authenticated session profile
- `POST /api/auth/register` — Create candidate or interviewer account

### Mock Placement Drives
- `GET /api/drives` — List available mock drives
- `GET /api/drives/{id}` — Get drive details with resolved questions, GD topic, and HR prompts
- `POST /api/drives` — Create mock drive (*Placement Officer only*)
- `PUT /api/drives/{id}` — Update or toggle drive status (*Placement Officer only*)
- `DELETE /api/drives/{id}` — Remove mock drive (*Placement Officer only*)

### Interview Simulation Flow
- `POST /api/interviews/start` — Initialize or resume mock placement attempt
- `GET /api/interviews/{id}` — Get active attempt state, current round, scores
- `POST /api/interviews/run-code` — Run sandboxed code against visible test cases
- `POST /api/interviews/{id}/coding` — Submit coding solutions, calculate score, advance to GD
- `POST /api/interviews/{id}/gd` — Submit GD response, run AI evaluation, advance to HR
- `POST /api/interviews/{id}/hr` — Submit HR answers, run AI communication assessment
- `POST /api/interviews/{id}/complete` — Calculate weighted final score (40% / 25% / 35%), generate strengths, improvements, and practice recommendations

### Results & Placement Analytics
- `GET /api/results/{interview_id}` — Detailed performance report for candidate
- `GET /api/interviewer/results` — Candidate monitoring table for placement officer
- `GET /api/interviewer/analytics` — Cohort statistics, round averages, and completion rates

### AI Evaluation
- `POST /api/ai/evaluate/gd` — Evaluate GD contribution against 5 communication criteria
- `POST /api/ai/evaluate/hr` — Evaluate HR answers against professional readiness criteria
