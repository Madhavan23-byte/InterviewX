package com.interviewx.service;

import com.interviewx.config.GeminiConfig;

/**
 * InterviewAIService - AI-powered interview evaluation and question generation.
 *
 * Uses INTERVIEW_AI_GEMINI_API_KEY exclusively.
 * Returns structured JSON from Gemini for rich UI feedback rendering.
 */
public class InterviewAIService extends GeminiBaseService {

    /**
     * Evaluate a student's interview answer and return structured JSON feedback.
     *
     * @param targetRole    The preparation role (e.g. "Backend Developer")
     * @param interviewType "TECHNICAL", "HR", "GD"
     * @param question      The interview question asked
     * @param studentAnswer The student's typed/transcribed answer
     * @return JSON string with score, feedback, suggestions — or fallback text
     */
    public String evaluateAnswer(String targetRole, String interviewType,
                                  String question, String studentAnswer) {
        String apiKey = GeminiConfig.getInterviewKey();
        if (apiKey.isEmpty()) {
            return buildFallbackEvaluation(question, studentAnswer);
        }
        String prompt = InterviewPromptBuilder.buildEvaluationPrompt(
                targetRole, interviewType, question, studentAnswer);
        String raw = callGemini(apiKey, prompt);

        if (isError(raw)) {
            System.err.println("[InterviewAI] Gemini error: " + raw);
            return buildFallbackEvaluation(question, studentAnswer);
        }
        // Gemini may wrap JSON in text — extract the JSON object
        return extractJson(raw);
    }

    /**
     * Generate AI interview questions for a given role/difficulty.
     * Returns a JSON array of question objects.
     */
    public String generateQuestions(String targetRole, String interviewType,
                                     String difficulty, int count,
                                     String skills, String resumeSummary) {
        String apiKey = GeminiConfig.getInterviewKey();
        if (apiKey.isEmpty()) {
            return "[]"; // Caller will fall back to DB questions
        }
        String prompt = InterviewPromptBuilder.buildQuestionGenerationPrompt(
                targetRole, interviewType, difficulty, count, skills, resumeSummary);
        String raw = callGemini(apiKey, prompt);
        if (isError(raw)) return "[]";
        return extractJson(raw);
    }

    /** Compute a simple integer score from the JSON response. */
    public int extractScore(String evaluationJson) {
        try {
            int idx = evaluationJson.indexOf("\"score\"");
            if (idx == -1) return 65;
            int colon = evaluationJson.indexOf(":", idx);
            int end = evaluationJson.indexOf(",", colon);
            if (end == -1) end = evaluationJson.indexOf("}", colon);
            String num = evaluationJson.substring(colon + 1, end).trim();
            // strip non-numeric
            num = num.replaceAll("[^0-9]", "");
            int score = Integer.parseInt(num);
            return Math.min(100, Math.max(0, score));
        } catch (Exception e) {
            return 65;
        }
    }

    // ====== FALLBACKS ======

    private String buildFallbackEvaluation(String question, String answer) {
        int words = (answer == null) ? 0 : answer.trim().split("\\s+").length;
        int score = Math.min(75, 40 + (words > 100 ? 30 : words / 4));

        return "{" +
            "\"score\":" + score + "," +
            "\"correctness\":\"Partially Correct\"," +
            "\"relevance\":\"Relevant\"," +
            "\"completeness\":\"" + (words > 80 ? "Mostly Complete" : "Incomplete") + "\"," +
            "\"technical_accuracy\":\"Medium\"," +
            "\"communication_rating\":\"" + (words > 50 ? "Good" : "Fair") + "\"," +
            "\"strengths\":[\"You attempted to answer the question\",\"" + (words > 50 ? "Reasonable detail provided" : "Answer is concise") + "\"]," +
            "\"weaknesses\":[\"AI evaluation unavailable — configure INTERVIEW_AI_GEMINI_API_KEY for detailed feedback\"]," +
            "\"missing_concepts\":[\"Unable to determine without AI analysis\"]," +
            "\"suggested_answer\":\"Configure the Gemini Interview AI key to receive a model answer for this question.\"," +
            "\"follow_up_question\":\"Can you elaborate further on this topic?\"," +
            "\"preparation_topics\":[\"Review the question topic\",\"Study core concepts\"]," +
            "\"detailed_feedback\":\"Basic evaluation: Your answer contained " + words + " words. " +
                "For detailed AI-powered feedback referencing your actual answer, please configure the INTERVIEW_AI_GEMINI_API_KEY environment variable.\"" +
            "}";
    }

    private String extractJson(String text) {
        if (text == null) return "{}";
        // Find the outermost { ... } or [ ... ]
        int start = -1;
        char open = '{', close = '}';
        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);
            if (c == '{' || c == '[') {
                start = i;
                open = c;
                close = (c == '{') ? '}' : ']';
                break;
            }
        }
        if (start == -1) return text;
        int depth = 0;
        for (int i = start; i < text.length(); i++) {
            char c = text.charAt(i);
            if (c == open) depth++;
            else if (c == close) {
                depth--;
                if (depth == 0) return text.substring(start, i + 1);
            }
        }
        return text.substring(start);
    }
}
