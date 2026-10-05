package com.interviewx.service;

import com.interviewx.config.GeminiConfig;

/**
 * CodeAnalyzerAIService - AI-powered code explanation and analysis.
 *
 * Uses CODE_ANALYZER_GEMINI_API_KEY exclusively.
 * NEVER executes the submitted code — analysis only.
 * Returns structured JSON for rich UI sectioned display.
 */
public class CodeAnalyzerAIService extends GeminiBaseService {

    /**
     * Analyze code and return structured JSON with 11 sections.
     *
     * @param language The programming language
     * @param code     The code to analyze (will be truncated if too large)
     * @return JSON string with analysis sections, or error message
     */
    public String analyzeCode(String language, String code) {
        // Validate size
        if (code == null || code.trim().isEmpty()) {
            return buildErrorJson("No code provided.");
        }
        if (code.length() > GeminiConfig.MAX_CODE_LENGTH) {
            code = code.substring(0, GeminiConfig.MAX_CODE_LENGTH) + "\n// ... [truncated for analysis]";
        }

        String apiKey = GeminiConfig.getCodeAnalyzerKey();
        if (apiKey.isEmpty()) {
            return buildFallbackAnalysis(language, code);
        }

        String prompt = CodeAnalysisPromptBuilder.buildAnalysisPrompt(language, code);
        String raw = callGemini(apiKey, prompt);

        if (isError(raw)) {
            System.err.println("[CodeAnalyzerAI] Gemini error: " + raw);
            if ("__RATE_LIMITED__".equals(raw)) {
                return buildErrorJson("AI service quota exceeded. Please try again in a few minutes.");
            }
            return buildFallbackAnalysis(language, code);
        }

        // Clean up JSON if Gemini wrapped it in markdown
        return cleanJson(raw);
    }

    private String cleanJson(String raw) {
        if (raw == null) return "{}";
        String trimmed = raw.trim();
        // Remove markdown code fences if present
        if (trimmed.startsWith("```")) {
            int first = trimmed.indexOf('\n');
            if (first != -1) trimmed = trimmed.substring(first + 1);
            if (trimmed.endsWith("```")) trimmed = trimmed.substring(0, trimmed.lastIndexOf("```")).trim();
        }
        // Find JSON object
        int start = trimmed.indexOf('{');
        if (start == -1) return raw;
        int depth = 0;
        for (int i = start; i < trimmed.length(); i++) {
            char c = trimmed.charAt(i);
            if (c == '{') depth++;
            else if (c == '}') {
                depth--;
                if (depth == 0) return trimmed.substring(start, i + 1);
            }
        }
        return trimmed.substring(start);
    }

    private String buildFallbackAnalysis(String language, String code) {
        String lines = buildLineByLine(code);
        int lc = code.split("\n").length;
        return "{\n" +
            "  \"overall_explanation\": \"AI Code Analyzer is not configured. Set CODE_ANALYZER_GEMINI_API_KEY to enable full AI analysis. Code contains " + lc + " lines of " + language + ".\",\n" +
            "  \"line_by_line\": " + lines + ",\n" +
            "  \"logic_explanation\": \"Configure CODE_ANALYZER_GEMINI_API_KEY for detailed logic analysis.\",\n" +
            "  \"time_complexity\": \"Unable to determine without AI analysis.\",\n" +
            "  \"space_complexity\": \"Unable to determine without AI analysis.\",\n" +
            "  \"bugs\": [\"AI analysis required to detect bugs.\"],\n" +
            "  \"edge_cases\": [\"AI analysis required.\"],\n" +
            "  \"improvements\": [\"Set CODE_ANALYZER_GEMINI_API_KEY for improvement suggestions.\"],\n" +
            "  \"alternative_approach\": \"Configure the Code Analyzer Gemini API key for alternative approach suggestions.\",\n" +
            "  \"interview_questions\": [\"What does this code do?\", \"What is the time complexity?\", \"How would you test this?\"],\n" +
            "  \"beginner_explanation\": \"This is " + lc + " lines of " + language + " code. Configure the AI key for a beginner-friendly explanation.\"\n" +
            "}";
    }

    private String buildLineByLine(String code) {
        if (code == null) return "[]";
        String[] lines = code.split("\n");
        StringBuilder sb = new StringBuilder("[");
        int limit = Math.min(lines.length, 30);
        for (int i = 0; i < limit; i++) {
            if (i > 0) sb.append(",");
            String line = lines[i].replace("\"", "\\\"").replace("\t", "  ");
            sb.append("{\"line\":").append(i + 1)
              .append(",\"code\":\"").append(line.trim()).append("\"")
              .append(",\"explanation\":\"Configure CODE_ANALYZER_GEMINI_API_KEY for line explanations.\"}");
        }
        if (lines.length > 30) {
            sb.append(",{\"line\":\"...\",\"code\":\"" + (lines.length - 30) + " more lines\",\"explanation\":\"Truncated for fallback mode\"}");
        }
        sb.append("]");
        return sb.toString();
    }

    private String buildErrorJson(String msg) {
        return "{\"overall_explanation\":\"" + msg + "\",\"line_by_line\":[],\"logic_explanation\":\"\",\"time_complexity\":\"\",\"space_complexity\":\"\",\"bugs\":[],\"edge_cases\":[],\"improvements\":[],\"alternative_approach\":\"\",\"interview_questions\":[],\"beginner_explanation\":\"\"}";
    }
}
