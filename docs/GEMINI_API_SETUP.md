# InterviewX ? Gemini AI Configuration & Setup Guide

This guide explains how to configure and manage the **three separate Google Gemini API keys** used by InterviewX for its AI intelligence features.

---

## Architecture Overview

InterviewX enforces strict separation of concerns by using **three independent Gemini API keys**. This design prevents rate-limit interference, enables independent quota tracking, and isolates service permissions:

`
                      Google Gemini API
                              |
       +----------------------+----------------------+
       |                      |                      |
       v                      v                      v
 ?? Interview AI        ?? Code Analyzer       ?? Resume Analyzer
       |                      |                      |
       v                      v                      v
     KEY #1                 KEY #2                 KEY #3
INTERVIEW_AI_...       CODE_ANALYZER_...      RESUME_ANALYZER_...
`

| Service | Environment Variable | Usage |
| :--- | :--- | :--- |
| **Interview AI** | INTERVIEW_AI_GEMINI_API_KEY | Mock interview question generation, speech answer evaluation, scoring, missing concepts detection, and suggested answers. |
| **Code Analyzer AI** | CODE_ANALYZER_GEMINI_API_KEY | Explaining code line-by-line, logic breakdown, time/space complexity analysis, bug discovery, and alternative approaches. |
| **Resume Analyzer AI** | RESUME_ANALYZER_GEMINI_API_KEY | Resume parsing, skill extraction, career role recommendations, skill-gap analysis, and learning track mappings. |

---

## 1. Obtaining Gemini API Keys

1. Visit [Google AI Studio](https://aistudio.google.com/).
2. Sign in with your Google account.
3. Click **Get API key** in the left navigation.
4. Click **Create API key**.
5. Repeat this process to generate **three distinct API keys** (one for each service).
   - *Tip:* Name them in Google AI Studio as:
     - InterviewX - Interview AI
     - InterviewX - Code Analyzer
     - InterviewX - Resume Analyzer

> **CRITICAL SECURITY NOTE:**
> Never share, commit to Git, or paste your API keys into chat prompts or public repositories.

---

## 2. Recommended: Configure via the Admin Web UI

InterviewX includes a dedicated administrative UI that stores keys securely server-side outside the web application directory.

### Step 1: Log in as Administrator
- Navigate to: http://localhost:8080/InterviewX/login.jsp
- Email: dmin@interviewx.com
- Password: Admin@123

### Step 2: Open the AI Configuration Center
- In the sidebar, click **AI Configuration** under the **Administration** section.
- Direct URL: http://localhost:8080/InterviewX/admin/ai-config

### Step 3: Enter and Save Each API Key
1. **Interview AI**:
   - Paste Key #1 into the *Gemini API Key* field.
   - Click **Save**.
   - Click **Test Connection** to verify connectivity with Google Gemini.
2. **Code Analyzer AI**:
   - Paste Key #2 into the *Gemini API Key* field.
   - Click **Save**.
   - Click **Test Connection**.
3. **Resume Analyzer AI**:
   - Paste Key #3 into the *Gemini API Key* field.
   - Click **Save**.
   - Click **Test Connection**.

When saved, keys are immediately active in server memory without needing to restart Tomcat. The UI displays masked suffixes (????????ABCD) for security.

---

## 3. Storage Architecture & Security

### External Configuration Location
Keys configured through the web interface are saved to an external properties file located **outside** the web root and Eclipse workspace:

`
<user.home>/InterviewX-config/ai.properties
`

On Windows, this resolves to:
`
C:\Users\<username>\InterviewX-config\ai.properties
`

### File Contents Format
`properties
INTERVIEW_AI_GEMINI_API_KEY=your_interview_api_key_here
CODE_ANALYZER_GEMINI_API_KEY=your_code_analyzer_api_key_here
RESUME_ANALYZER_GEMINI_API_KEY=your_resume_analyzer_api_key_here
`

### Security Features
- **Outside Web Root:** Stored in <user.home>, unreachable by HTTP/JSP requests.
- **Git Protection:** The .gitignore file includes i.properties, *.secret.properties, and InterviewX-config/.
- **Database Isolation:** Keys are never stored in MySQL tables.
- **Frontend Masking:** Full keys are never transmitted to browser JavaScript or HTML DOM.
- **Role Guard:** The /admin/ai-config endpoint is strictly guarded and only accessible to users with the ADMIN role. Normal students receive HTTP 403 Forbidden.

---

## 4. Alternative: OS Environment Variables or Eclipse Run Configuration

If preferred, you can also define the keys as OS environment variables or Eclipse Tomcat JVM arguments.

### Option A: Windows Environment Variables (User/System)
1. Press Win + R, type sysdm.cpl, and press Enter.
2. Go to the **Advanced** tab and click **Environment Variables**.
3. Under **User variables**, click **New** and add:
   - Variable: INTERVIEW_AI_GEMINI_API_KEY, Value: <your_key>
   - Variable: CODE_ANALYZER_GEMINI_API_KEY, Value: <your_key>
   - Variable: RESUME_ANALYZER_GEMINI_API_KEY, Value: <your_key>
4. Restart Eclipse and Tomcat to load the new environment variables.

### Option B: Eclipse Tomcat Server Arguments
1. In Eclipse, double-click the **Tomcat 9** server in the *Servers* tab.
2. Click **Open launch configuration**.
3. Go to the **Environment** tab.
4. Add the three environment variables with their respective values.
5. Click **Apply** and restart Tomcat.

---

## 5. Verification & Testing

### Test 1: Interview AI
1. Go to http://localhost:8080/InterviewX/interview.
2. Select **Technical Interview** and click **Start Interview**.
3. Speak or type an answer to the technical question.
4. Click **Submit Answer**.
5. Verify that Gemini returns structured feedback with score breakdown, technical accuracy, missing concepts, and suggested answer.

### Test 2: Code Analyzer AI
1. Go to http://localhost:8080/InterviewX/analyzer (or /code-analyzer).
2. Select language **Java**.
3. Paste a code snippet (e.g. binary search or iteration).
4. Click **Analyze Code**.
5. Verify that the AI returns line-by-line explanation, time/space complexity, and optimization suggestions.

### Test 3: Resume Analyzer AI
1. Go to http://localhost:8080/InterviewX/resume.
2. Upload or paste resume text.
3. Click **Analyze Resume & Discover Roles**.
4. Verify that Gemini processes skills, identifies skill gaps, and recommends aligned roles.
