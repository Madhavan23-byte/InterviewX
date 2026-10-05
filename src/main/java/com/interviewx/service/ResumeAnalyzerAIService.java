package com.interviewx.service;

import com.interviewx.config.GeminiConfig;

/**
 * ResumeAnalyzerAIService - AI-powered resume parsing and role recommendation.
 *
 * Uses RESUME_ANALYZER_GEMINI_API_KEY exclusively.
 * Returns structured JSON for skills extraction, role matching, and learning track suggestions.
 */
public class ResumeAnalyzerAIService extends GeminiBaseService {

    /**
     * Analyze a resume text and return structured JSON with extracted information
     * and role recommendations with evidence and skill gaps.
     *
     * @param resumeText  The full text of the resume
     * @param studentName The student's name (from session/profile)
     * @return Structured JSON string
     */
    public String analyzeResume(String resumeText, String studentName) {
        if (resumeText == null || resumeText.trim().length() < 20) {
            return buildErrorJson("Resume text is too short or empty.");
        }

        String apiKey = GeminiConfig.getResumeAnalyzerKey();
        if (apiKey.isEmpty()) {
            return buildFallbackAnalysis(resumeText, studentName);
        }

        String prompt = ResumePromptBuilder.buildResumeAnalysisPrompt(resumeText, studentName);
        String raw = callGemini(apiKey, prompt);

        if (isError(raw)) {
            System.err.println("[ResumeAnalyzerAI] Gemini error: " + raw);
            return buildFallbackAnalysis(resumeText, studentName);
        }

        return cleanJson(raw);
    }

    /**
     * Extract a specific field from the JSON analysis result.
     * Used by the servlet to pull individual sections.
     */
    public String extractField(String json, String field) {
        if (json == null) return "";
        try {
            String key = "\"" + field + "\"";
            int idx = json.indexOf(key);
            if (idx == -1) return "";
            int colon = json.indexOf(":", idx + key.length());
            if (colon == -1) return "";
            colon++; // skip ':'
            // Skip whitespace
            while (colon < json.length() && Character.isWhitespace(json.charAt(colon))) colon++;
            char first = json.charAt(colon);
            if (first == '"') {
                // String value
                int end = colon + 1;
                while (end < json.length()) {
                    if (json.charAt(end) == '"' && json.charAt(end - 1) != '\\') break;
                    end++;
                }
                return json.substring(colon + 1, end);
            } else if (first == '[' || first == '{') {
                // Array or object
                char open = first, close = (first == '[') ? ']' : '}';
                int depth = 0;
                for (int i = colon; i < json.length(); i++) {
                    if (json.charAt(i) == open) depth++;
                    else if (json.charAt(i) == close) {
                        depth--;
                        if (depth == 0) return json.substring(colon, i + 1);
                    }
                }
            } else {
                // Number or boolean
                int end = colon;
                while (end < json.length() && json.charAt(end) != ',' && json.charAt(end) != '}') end++;
                return json.substring(colon, end).trim();
            }
        } catch (Exception e) {
            System.err.println("[ResumeAnalyzerAI] Field extraction error for: " + field);
        }
        return "";
    }

    private String cleanJson(String raw) {
        if (raw == null) return "{}";
        String trimmed = raw.trim();
        if (trimmed.startsWith("```")) {
            int first = trimmed.indexOf('\n');
            if (first != -1) trimmed = trimmed.substring(first + 1);
            if (trimmed.endsWith("```")) trimmed = trimmed.substring(0, trimmed.lastIndexOf("```")).trim();
        }
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

    private String buildFallbackAnalysis(String resumeText, String studentName) {
        // Basic keyword-based fallback when AI is not configured
        String lower = resumeText.toLowerCase();
        String name = (studentName != null && !studentName.isBlank()) ? studentName : "Unknown";
        String topRole = detectTopRole(lower);

        return "{\n" +
            "  \"candidate_name\": \"" + name + "\",\n" +
            "  \"education\": [],\n" +
            "  \"programming_languages\": " + detectLanguages(lower) + ",\n" +
            "  \"frameworks\": " + detectFrameworks(lower) + ",\n" +
            "  \"databases\": " + detectDatabases(lower) + ",\n" +
            "  \"tools\": [],\n" +
            "  \"all_skills\": [],\n" +
            "  \"projects\": [],\n" +
            "  \"internships\": [],\n" +
            "  \"certifications\": [],\n" +
            "  \"achievements\": [],\n" +
            "  \"domains\": [\"" + topRole + "\"],\n" +
            "  \"experience_level\": \"Fresher\",\n" +
            "  \"strengths\": [\"Technical background detected\"],\n" +
            "  \"role_recommendations\": [\n" +
            "    {\n" +
            "      \"role\": \"" + topRole + "\",\n" +
            "      \"recommendation_level\": \"Good\",\n" +
            "      \"match_score\": 65,\n" +
            "      \"evidence\": [\"Based on keyword detection\"],\n" +
            "      \"skill_gaps\": [\"Configure RESUME_ANALYZER_GEMINI_API_KEY for accurate gap analysis\"],\n" +
            "      \"reasoning\": \"Basic keyword analysis suggests alignment with " + topRole + ". Set RESUME_ANALYZER_GEMINI_API_KEY for a detailed AI assessment.\",\n" +
            "      \"learning_tracks\": [\"Core " + topRole + " Skills\"]\n" +
            "    }\n" +
            "  ],\n" +
            "  \"top_recommendation\": \"" + topRole + "\",\n" +
            "  \"overall_summary\": \"AI resume analysis requires RESUME_ANALYZER_GEMINI_API_KEY to be configured. Basic keyword scan detected " + topRole + " affinity.\"\n" +
            "}";
    }

    private String detectTopRole(String lower) {
        if (lower.contains("solidity") || lower.contains("blockchain")) return "Blockchain Developer";
        if (lower.contains("pytorch") || lower.contains("tensorflow") || lower.contains("machine learning")) return "AI Engineer";
        if (lower.contains("react") || lower.contains("angular") || lower.contains("vue")) return "Frontend Developer";
        if (lower.contains("docker") || lower.contains("kubernetes") || lower.contains("ci/cd")) return "DevOps Engineer";
        if (lower.contains("aws") || lower.contains("azure") || lower.contains("gcp")) return "Cloud Engineer";
        if (lower.contains("java") || lower.contains("spring") || lower.contains("mysql")) return "Backend Developer";
        return "Backend Developer";
    }

    private String detectLanguages(String lower) {
        StringBuilder sb = new StringBuilder("[");
        if (lower.contains("java")) sb.append("\"Java\",");
        if (lower.contains("python")) sb.append("\"Python\",");
        if (lower.contains("javascript") || lower.contains(" js ")) sb.append("\"JavaScript\",");
        if (lower.contains("c++") || lower.contains("cpp")) sb.append("\"C++\",");
        if (lower.contains("sql")) sb.append("\"SQL\",");
        if (sb.length() > 1) sb.setLength(sb.length() - 1);
        sb.append("]");
        return sb.toString();
    }

    private String detectFrameworks(String lower) {
        StringBuilder sb = new StringBuilder("[");
        if (lower.contains("spring")) sb.append("\"Spring Boot\",");
        if (lower.contains("react")) sb.append("\"React\",");
        if (lower.contains("django")) sb.append("\"Django\",");
        if (lower.contains("node")) sb.append("\"Node.js\",");
        if (sb.length() > 1) sb.setLength(sb.length() - 1);
        sb.append("]");
        return sb.toString();
    }

    private String detectDatabases(String lower) {
        StringBuilder sb = new StringBuilder("[");
        if (lower.contains("mysql")) sb.append("\"MySQL\",");
        if (lower.contains("mongodb")) sb.append("\"MongoDB\",");
        if (lower.contains("postgresql") || lower.contains("postgres")) sb.append("\"PostgreSQL\",");
        if (sb.length() > 1) sb.setLength(sb.length() - 1);
        sb.append("]");
        return sb.toString();
    }

    private String buildErrorJson(String msg) {
        return "{\"candidate_name\":\"Unknown\",\"programming_languages\":[],\"frameworks\":[],\"databases\":[],\"tools\":[],\"all_skills\":[],\"projects\":[],\"internships\":[],\"certifications\":[],\"achievements\":[],\"domains\":[],\"experience_level\":\"Unknown\",\"strengths\":[],\"role_recommendations\":[],\"top_recommendation\":\"\",\"overall_summary\":\"" + msg + "\",\"education\":[]}";
    }
}
