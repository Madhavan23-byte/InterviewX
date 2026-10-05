package com.interviewx.ai;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

/**
 * AIService - Integrates with Google Gemini API for AI-powered features.
 *
 * API KEY MUST BE SET via environment variable or system property:
 *   GEMINI_API_KEY=your_key_here
 *
 * Never hardcode API keys in source code.
 *
 * Current status: Stub implementation with clear fallback message.
 * When you have a Gemini API key, set the environment variable and uncomment the API call.
 */
public class AIService {

    // Read API key from environment variable - NEVER hardcode
    private static final String API_KEY = System.getenv("GEMINI_API_KEY") != null
        ? System.getenv("GEMINI_API_KEY")
        : System.getProperty("gemini.api.key", "");

    private static final String GEMINI_API_URL =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=";

    /**
     * Analyze code with AI - explain, find bugs, check complexity.
     */
    public String analyzeCode(String language, String code, String question) {
        if (API_KEY.isEmpty()) {
            return generateFallbackCodeAnalysis(language, code, question);
        }
        String prompt = "You are an expert " + language + " programming teacher helping a student. " +
            "The student has the following code:\n\n```" + language + "\n" + code + "\n```\n\n" +
            "Student's question: " + question + "\n\n" +
            "Please provide: 1) Answer to their question 2) Time complexity 3) Space complexity " +
            "4) Any bugs or improvements. Be clear and beginner-friendly.";
        return callGeminiAPI(prompt);
    }

    /**
     * Evaluate an interview answer.
     */
    public String evaluateInterviewAnswer(String interviewType, String question, String answer) {
        if (API_KEY.isEmpty()) {
            return generateFallbackEvaluation(interviewType, question, answer);
        }
        String prompt = "You are an expert interviewer evaluating a student's interview answer. " +
            "Interview Type: " + interviewType + "\n" +
            "Question: " + question + "\n" +
            "Student's Answer: " + answer + "\n\n" +
            "Please provide: 1) Score out of 10 2) What was good 3) What needs improvement " +
            "4) Model answer 5) Tips for better response. Be constructive and encouraging.";
        return callGeminiAPI(prompt);
    }

    /**
     * Generate career recommendation explanation.
     */
    public String explainCareerRecommendation(String careerTrack, String studentSkills) {
        if (API_KEY.isEmpty()) {
            return "AI explanation unavailable. Gemini API key not configured. " +
                   "Based on your assessment, " + careerTrack + " aligns with your interest profile. " +
                   "Set GEMINI_API_KEY environment variable to enable detailed AI explanations.";
        }
        String prompt = "A student has been recommended the career track: " + careerTrack + ". " +
            "Their current skills/interests: " + studentSkills + ". " +
            "Explain in 3-4 sentences why this career is a good fit and what they should focus on learning next.";
        return callGeminiAPI(prompt);
    }

    /**
     * Generate skill gap analysis.
     */
    public String analyzeSkillGap(String targetRole, String currentSkills) {
        if (API_KEY.isEmpty()) {
            return "AI skill gap analysis requires Gemini API key. " +
                   "For " + targetRole + " role, focus on building core technical skills, " +
                   "practicing coding problems, and preparing for system design questions. " +
                   "Set GEMINI_API_KEY to enable personalized analysis.";
        }
        String prompt = "A student wants to become a " + targetRole + ". " +
            "Their current skills: " + currentSkills + ". " +
            "Please identify: 1) Top 5 missing skills 2) Priority order to learn them " +
            "3) Estimated time for each 4) Resources to learn. Keep it concise and actionable.";
        return callGeminiAPI(prompt);
    }

    /**
     * Call Gemini API with the given prompt.
     */
    private String callGeminiAPI(String prompt) {
        try {
            URL url = new URL(GEMINI_API_URL + API_KEY);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(15000);
            conn.setReadTimeout(30000);

            // Build JSON request body
            String jsonBody = "{\"contents\":[{\"parts\":[{\"text\":" +
                escapeJson(prompt) + "}]}]}";

            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder sb = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) sb.append(line);
                    return extractTextFromGeminiResponse(sb.toString());
                }
            } else {
                return "AI service temporarily unavailable (HTTP " + responseCode + "). Please try again later.";
            }
        } catch (Exception e) {
            System.err.println("Gemini API error: " + e.getMessage());
            return "AI service temporarily unavailable. Please try again later.";
        }
    }

    /**
     * Extract text from Gemini API JSON response.
     */
    private String extractTextFromGeminiResponse(String json) {
        try {
            int textStart = json.indexOf("\"text\":");
            if (textStart == -1) return "Unable to parse AI response.";
            textStart = json.indexOf("\"", textStart + 7) + 1;
            int textEnd = json.indexOf("\"", textStart);
            // Handle escaped quotes in content
            while (textEnd > 0 && json.charAt(textEnd - 1) == '\\') {
                textEnd = json.indexOf("\"", textEnd + 1);
            }
            String raw = json.substring(textStart, textEnd);
            return raw.replace("\\n", "\n").replace("\\t", "\t").replace("\\\"", "\"").replace("\\\\", "\\");
        } catch (Exception e) {
            return "Unable to parse AI response.";
        }
    }

    private String escapeJson(String text) {
        return "\"" + text.replace("\\", "\\\\").replace("\"", "\\\"")
            .replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t") + "\"";
    }

    // ====== FALLBACK RESPONSES (when API key not configured) ======

    private String generateFallbackCodeAnalysis(String language, String code, String question) {
        return "## Code Analysis\n\n" +
            "**Note:** Gemini AI is not yet configured. Set the `GEMINI_API_KEY` environment variable to enable full AI analysis.\n\n" +
            "**Your Question:** " + question + "\n\n" +
            "**Language:** " + language + "\n\n" +
            "**General Tips:**\n" +
            "- Ensure your logic handles edge cases (empty input, null values)\n" +
            "- Follow naming conventions for " + language + "\n" +
            "- Consider time and space complexity\n" +
            "- Use clear variable names for readability\n\n" +
            "To enable full AI-powered analysis, configure your Gemini API key.";
    }

    private String generateFallbackEvaluation(String type, String question, String answer) {
        int wordCount = answer == null ? 0 : answer.split("\\s+").length;
        double score = Math.min(7.0, 3.0 + (wordCount > 50 ? 2.0 : wordCount / 25.0));

        return "## Interview Evaluation\n\n" +
            "**Note:** Gemini AI is not yet configured. This is a basic evaluation.\n\n" +
            "**Score: " + String.format("%.1f", score) + "/10**\n\n" +
            "**Answer Length:** " + wordCount + " words\n\n" +
            (wordCount > 50
                ? "**Good:** Your answer has good detail. Keep elaborating with specific examples.\n"
                : "**Improvement:** Try to elaborate more with specific examples and details.\n") +
            "\n**Tips:**\n" +
            "- Use the STAR method for behavioral questions (Situation, Task, Action, Result)\n" +
            "- Be specific with technical concepts\n" +
            "- Structure your answer with clear beginning, middle, and end\n\n" +
            "Set GEMINI_API_KEY environment variable to enable detailed AI evaluation.";
    }
}
