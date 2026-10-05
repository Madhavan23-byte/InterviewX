package com.interviewx.service;

/**
 * CodeAnalysisPromptBuilder - Creates structured prompts for Code Analyzer AI.
 */
public class CodeAnalysisPromptBuilder {

    /**
     * Build a comprehensive prompt that asks Gemini for structured code analysis.
     * Always returns JSON so the UI can render each section distinctly.
     */
    public static String buildAnalysisPrompt(String language, String code) {
        // Truncate if too large
        String safeCode = (code != null && code.length() > 6000) ? code.substring(0, 6000) + "\n// ... (truncated)" : code;

        return "You are an expert " + language + " software engineer and computer science teacher.\n" +
               "Analyze the following " + language + " code thoroughly.\n" +
               "Return ONLY valid JSON with no markdown, no code fences, no extra text.\n\n" +
               "CODE:\n```" + language + "\n" + safeCode + "\n```\n\n" +
               "Return this exact JSON structure:\n" +
               "{\n" +
               "  \"overall_explanation\": \"<2-3 sentence plain English summary of what this code does>\",\n" +
               "  \"line_by_line\": [\n" +
               "    {\"line\": 1, \"code\": \"<line content>\", \"explanation\": \"<what it does>\"}\n" +
               "  ],\n" +
               "  \"logic_explanation\": \"<Step-by-step logic flow explanation>\",\n" +
               "  \"time_complexity\": \"<Big-O with explanation, e.g. O(n) - single loop through array>\",\n" +
               "  \"space_complexity\": \"<Big-O with explanation>\",\n" +
               "  \"bugs\": [\"<bug or potential issue 1>\", \"<bug 2>\"],\n" +
               "  \"edge_cases\": [\"<edge case 1>\", \"<edge case 2>\"],\n" +
               "  \"improvements\": [\"<improvement 1>\", \"<improvement 2>\"],\n" +
               "  \"alternative_approach\": \"<Describe a different way to solve the same problem>\",\n" +
               "  \"interview_questions\": [\n" +
               "    \"<Interview question about this code 1>\",\n" +
               "    \"<Interview question 2>\",\n" +
               "    \"<Interview question 3>\"\n" +
               "  ],\n" +
               "  \"beginner_explanation\": \"<Explain as if to a complete beginner with an analogy if helpful>\"\n" +
               "}";
    }
}
