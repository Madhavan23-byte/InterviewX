package com.interviewx.service;

/**
 * ResumePromptBuilder - Creates structured prompts for Resume Analyzer AI.
 */
public class ResumePromptBuilder {

    /**
     * Build a comprehensive resume analysis prompt.
     * Returns prompt that asks for structured JSON extraction of resume data
     * plus role recommendations with evidence and skill gaps.
     */
    public static String buildResumeAnalysisPrompt(String resumeText, String studentName) {
        String safeName = (studentName != null && !studentName.isBlank()) ? studentName : "the student";
        String safeText = (resumeText != null && resumeText.length() > 8000)
                          ? resumeText.substring(0, 8000) + "\n[...truncated...]" : resumeText;

        return "You are an expert career counselor and technical recruiter analyzing a resume for a college student.\n" +
               "Analyze the resume of " + safeName + " thoroughly.\n" +
               "Return ONLY valid JSON with no markdown, no code fences, no extra text.\n\n" +
               "RESUME TEXT:\n" + safeText + "\n\n" +
               "Return this exact JSON structure:\n" +
               "{\n" +
               "  \"candidate_name\": \"<extracted name or 'Unknown'>\",\n" +
               "  \"education\": [\n" +
               "    {\"degree\": \"<degree>\", \"institution\": \"<college>\", \"year\": \"<year>\", \"cgpa\": \"<cgpa if mentioned>\"}\n" +
               "  ],\n" +
               "  \"programming_languages\": [\"Java\", \"Python\"],\n" +
               "  \"frameworks\": [\"Spring Boot\", \"React\"],\n" +
               "  \"databases\": [\"MySQL\", \"MongoDB\"],\n" +
               "  \"tools\": [\"Git\", \"Docker\"],\n" +
               "  \"all_skills\": [\"<every skill mentioned>\"],\n" +
               "  \"projects\": [\n" +
               "    {\"name\": \"<project name>\", \"tech_stack\": [\"tech1\"], \"description\": \"<brief>\", \"impact\": \"<achievement if any>\"}\n" +
               "  ],\n" +
               "  \"internships\": [\n" +
               "    {\"company\": \"<company>\", \"role\": \"<role>\", \"duration\": \"<duration>\", \"technologies\": [\"tech1\"]}\n" +
               "  ],\n" +
               "  \"certifications\": [\"<certification name and issuer>\"],\n" +
               "  \"achievements\": [\"<hackathon wins, publications, rankings, etc>\"],\n" +
               "  \"domains\": [\"<domain areas like Web Development, Machine Learning, etc>\"],\n" +
               "  \"experience_level\": \"<Fresher/Junior/Mid-level>\",\n" +
               "  \"strengths\": [\"<key strength 1>\", \"<strength 2>\"],\n" +
               "  \"role_recommendations\": [\n" +
               "    {\n" +
               "      \"role\": \"<role name e.g. Backend Developer>\",\n" +
               "      \"recommendation_level\": \"<Strong/Good/Moderate>\",\n" +
               "      \"match_score\": <0-100 integer>,\n" +
               "      \"evidence\": [\"<skill/project that matches>\"],\n" +
               "      \"skill_gaps\": [\"<missing skill 1>\", \"<missing skill 2>\"],\n" +
               "      \"reasoning\": \"<2 sentence explanation of why this role fits or doesn't>\",\n" +
               "      \"learning_tracks\": [\"<recommended learning track/course 1>\"]\n" +
               "    }\n" +
               "  ],\n" +
               "  \"top_recommendation\": \"<The single best-fit role name>\",\n" +
               "  \"overall_summary\": \"<3-4 sentence honest assessment of this student's profile and career readiness>\"\n" +
               "}";
    }
}
