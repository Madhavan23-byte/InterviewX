package com.interviewx.service;

/**
 * InterviewPromptBuilder - Creates structured, role-specific prompts for Interview AI.
 */
public class InterviewPromptBuilder {

    /**
     * Build a comprehensive prompt for evaluating a student's interview answer.
     * Returns prompt that asks Gemini for structured JSON feedback.
     */
    public static String buildEvaluationPrompt(String targetRole, String interviewType,
                                                String question, String studentAnswer) {
        String roleContext = buildRoleContext(targetRole, interviewType);

        return "You are an expert technical interviewer evaluating a student for a " + targetRole +
               " role. You must return ONLY valid JSON with no markdown, no code fences.\n\n" +
               "CONTEXT:\n" + roleContext + "\n\n" +
               "INTERVIEW TYPE: " + interviewType + "\n" +
               "QUESTION: " + question + "\n" +
               "STUDENT ANSWER: " + (studentAnswer == null || studentAnswer.isBlank()
                   ? "[No answer provided]" : studentAnswer) + "\n\n" +
               "Evaluate thoroughly and return this exact JSON structure:\n" +
               "{\n" +
               "  \"score\": <0-100 integer>,\n" +
               "  \"correctness\": \"<Accurate/Partially Correct/Incorrect>\",\n" +
               "  \"relevance\": \"<Highly Relevant/Relevant/Off-Topic>\",\n" +
               "  \"completeness\": \"<Complete/Mostly Complete/Incomplete>\",\n" +
               "  \"technical_accuracy\": \"<High/Medium/Low>\",\n" +
               "  \"communication_rating\": \"<Excellent/Good/Fair/Poor>\",\n" +
               "  \"strengths\": [\"strength1\", \"strength2\"],\n" +
               "  \"weaknesses\": [\"weakness1\", \"weakness2\"],\n" +
               "  \"missing_concepts\": [\"concept1\", \"concept2\"],\n" +
               "  \"suggested_answer\": \"<A model answer for this question>\",\n" +
               "  \"follow_up_question\": \"<One follow-up question based on their answer>\",\n" +
               "  \"preparation_topics\": [\"topic1\", \"topic2\", \"topic3\"],\n" +
               "  \"detailed_feedback\": \"<2-3 sentence constructive feedback referencing the actual answer>\"\n" +
               "}";
    }

    /**
     * Build a prompt for generating interview questions for a specific role.
     */
    public static String buildQuestionGenerationPrompt(String targetRole, String interviewType,
                                                        String difficulty, int count,
                                                        String skills, String resumeSummary) {
        return "You are an expert interviewer. Generate " + count + " unique " + interviewType +
               " interview questions for a " + targetRole + " candidate.\n\n" +
               "Difficulty: " + difficulty + "\n" +
               "Focus skills: " + (skills != null ? skills : "core " + targetRole + " skills") + "\n" +
               (resumeSummary != null && !resumeSummary.isBlank() ?
                   "Candidate background: " + resumeSummary + "\n" : "") +
               "\nReturn ONLY valid JSON array:\n" +
               "[\n" +
               "  {\n" +
               "    \"question_text\": \"<question>\",\n" +
               "    \"topic\": \"<topic>\",\n" +
               "    \"difficulty\": \"" + difficulty + "\",\n" +
               "    \"expected_keywords\": [\"keyword1\", \"keyword2\"],\n" +
               "    \"hint\": \"<optional hint for the student>\"\n" +
               "  }\n" +
               "]";
    }

    private static String buildRoleContext(String role, String type) {
        if (role == null) return "General software engineering";
        switch (role.toLowerCase()) {
            case "backend developer":
            case "java developer":
                return "Backend/Java: Focus on Java, Spring Boot, JDBC, REST APIs, OOP, Design Patterns, SQL, DBMS, Data Structures";
            case "frontend developer":
                return "Frontend: Focus on JavaScript, HTML/CSS, React, DOM manipulation, browser APIs, responsive design";
            case "full stack developer":
                return "Full Stack: Both frontend (HTML/CSS/JS/React) and backend (Node.js/Java/APIs/Databases)";
            case "ai engineer":
            case "machine learning engineer":
                return "AI/ML: Python, PyTorch, TensorFlow, Scikit-learn, NLP, Deep Learning, Model Evaluation, MLOps";
            case "data scientist":
            case "data analyst":
                return "Data: Statistics, SQL, Python, pandas, visualization, machine learning fundamentals, business intelligence";
            case "blockchain developer":
                return "Blockchain: Solidity, Ethereum, Smart Contracts, DeFi, Web3.js, EVM, Consensus mechanisms";
            case "devops engineer":
                return "DevOps: Docker, Kubernetes, CI/CD, Jenkins, Linux, Ansible, Terraform, monitoring";
            case "cloud engineer":
                return "Cloud: AWS/Azure/GCP services, serverless, IAM, VPC, Terraform, cloud-native architecture";
            default:
                return "Software Engineering fundamentals: DSA, OOP, DBMS, OS, Networking, System Design";
        }
    }
}
