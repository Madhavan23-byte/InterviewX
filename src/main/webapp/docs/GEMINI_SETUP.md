# InterviewX — Gemini AI Setup Guide

This guide explains how to configure the three Gemini API keys required for InterviewX's AI features.

> **Security Note**: API keys are loaded **only** from OS environment variables.  
> Never hardcode keys in Java files, JSPs, or JavaScript.  
> Never commit keys to Git.

---

## 1. Create Your Gemini API Keys

1. Go to [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Sign in with your Google account
3. Click **Create API key**
4. Create **three separate keys** (one for each service — allows independent quota management):
   - Key 1 → for **Interview AI**
   - Key 2 → for **Code Analyzer AI**
   - Key 3 → for **Resume Analyzer AI**

---

## 2. Environment Variable Names

| Service | Environment Variable Name |
|---|---|
| Interview AI (Mock Interviews) | `INTERVIEW_AI_GEMINI_API_KEY` |
| Code Analyzer | `CODE_ANALYZER_GEMINI_API_KEY` |
| Resume Analyzer | `RESUME_ANALYZER_GEMINI_API_KEY` |

---

## 3. Set Environment Variables on Windows

### Option A: System Properties (Permanent — Recommended)

1. Press **Win + S** → search **"Edit the system environment variables"**
2. Click **Environment Variables...**
3. Under **System Variables**, click **New** for each key:

```
Variable name:  INTERVIEW_AI_GEMINI_API_KEY
Variable value: AIza...your-key-here...
```

```
Variable name:  CODE_ANALYZER_GEMINI_API_KEY
Variable value: AIza...your-key-here...
```

```
Variable name:  RESUME_ANALYZER_GEMINI_API_KEY
Variable value: AIza...your-key-here...
```

4. Click **OK** on all dialogs.

### Option B: PowerShell (Current Session Only)

```powershell
$env:INTERVIEW_AI_GEMINI_API_KEY    = "AIza...your-key-here..."
$env:CODE_ANALYZER_GEMINI_API_KEY   = "AIza...your-key-here..."
$env:RESUME_ANALYZER_GEMINI_API_KEY = "AIza...your-key-here..."
```

---

## 4. Configure Eclipse to Pass Environment Variables to Tomcat

If you launch Tomcat from Eclipse (not standalone), Eclipse runs Tomcat in its own process and may not inherit system environment variables automatically.

### Steps:

1. In Eclipse → **Run** → **Run Configurations...**
2. Select your **Tomcat 9** server launch configuration  
   *(usually under "Apache Tomcat" or "Server")*
3. Go to the **Environment** tab
4. Click **New** and add each variable:

   | Name | Value |
   |---|---|
   | `INTERVIEW_AI_GEMINI_API_KEY` | `AIza...` |
   | `CODE_ANALYZER_GEMINI_API_KEY` | `AIza...` |
   | `RESUME_ANALYZER_GEMINI_API_KEY` | `AIza...` |

5. Click **Apply** then **Run**

> **Alternative**: In Eclipse → **Servers** panel → double-click your Tomcat 9 server → **Open launch configuration** → **Environment** tab

---

## 5. Restart Tomcat

After setting the environment variables:

- **Standalone Tomcat**: Stop (`shutdown.bat`) and Start (`startup.bat`) Tomcat
- **Eclipse Tomcat**: Right-click server in Servers panel → **Stop** → **Start**

---

## 6. Verify the Application Can Read Them

After restart, open:

```
http://localhost:8080/InterviewX/db-test
```

The page will show the configuration status:

```
INTERVIEW_AI=CONFIGURED | CODE_ANALYZER=CONFIGURED | RESUME_ANALYZER=CONFIGURED
```

If any shows `MISSING`, the environment variable is not being picked up. Try Option B (PowerShell) and relaunch Eclipse from the same PowerShell window.

---

## 7. Test Each AI Feature

### Test 1 — Interview AI

1. Go to `http://localhost:8080/InterviewX/interview`
2. Click **Start Technical Interview**
3. Answer: *"OOP has four pillars: Encapsulation, Abstraction, Inheritance, and Polymorphism..."*
4. Click **Submit Answer & Get AI Feedback**
5. ✅ You should see: Score, Correctness, Strengths, Missing Concepts, Model Answer, Follow-up Question

### Test 2 — Code Analyzer

1. Go to `http://localhost:8080/InterviewX/analyzer`
2. Paste this code:
```java
public class Test {
    public static void main(String[] args) {
        for(int i = 0; i < 5; i++) {
            System.out.println(i);
        }
    }
}
```
3. Click **Analyze Code with AI**
4. ✅ You should see: Overall Explanation, Line-by-Line, Time Complexity O(n), Improvements, Interview Questions

### Test 3 — Resume Analyzer

1. Go to `http://localhost:8080/InterviewX/resume`
2. Upload a PDF resume or paste resume text
3. ✅ You should see: Extracted Skills, Projects, Role Recommendations with evidence and skill gaps

---

## 8. Troubleshooting

| Problem | Solution |
|---|---|
| "AI service is temporarily unavailable" | Check that env var is set and Tomcat was restarted |
| "AI service quota exceeded" | Wait a few minutes; you hit Gemini's rate limit |
| "AI service is not properly configured" | Invalid API key; verify key in AI Studio |
| Features work without keys | Fallback mode is active — basic responses shown |
| Keys set in System Properties but not working in Eclipse | Set them in Eclipse Run Config → Environment tab too |

---

## 9. Security Reminders

- ✅ Keys are read from `System.getenv()` — never from frontend
- ✅ Keys are never logged or printed
- ✅ Keys are never exposed in HTTP responses
- ✅ Three separate keys = independent quota and rotation
- ❌ Never put keys in `web.xml`, `.properties`, or JavaScript files
- ❌ Never commit keys to Git

---

## 10. API Key Limits (Free Tier — Google AI Studio)

| Model | Free Tier |
|---|---|
| `gemini-1.5-flash` | 15 requests/minute, 1500 requests/day |

For higher limits, upgrade to [Google AI Studio paid tier](https://ai.google.dev/pricing).
