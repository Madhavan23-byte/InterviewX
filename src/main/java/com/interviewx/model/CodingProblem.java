package com.interviewx.model;

import java.sql.Timestamp;

public class CodingProblem {
    private int problemId;
    private int problemNumber;
    private int orderIndex;
    private String title;
    private String description;
    private String difficulty;
    private String topic;
    private String subtopic;
    private String examples;
    private String constraintsText;
    private String hints;
    private String starterCodeJava;
    private String starterCodePython;
    private String starterCodeCpp;
    private String starterCodeJs;
    private String solutionJava;
    private String testCasesJson;
    private String tags;
    private String externalLink;
    private int isActive;

    // Profile-aware user progress fields
    private String userStatus = "NOT_STARTED"; // NOT_STARTED, ATTEMPTED, SOLVED
    private int attemptCount = 0;
    private Timestamp firstAttemptAt;
    private Timestamp lastAttemptAt;
    private Timestamp solvedAt;
    private String lastCode;
    private String lastLanguage;

    public CodingProblem() {}

    public int getProblemId() { return problemId; }
    public void setProblemId(int problemId) { this.problemId = problemId; }

    public int getProblemNumber() { return problemNumber > 0 ? problemNumber : problemId; }
    public void setProblemNumber(int problemNumber) { this.problemNumber = problemNumber; }

    public int getOrderIndex() { return orderIndex; }
    public void setOrderIndex(int orderIndex) { this.orderIndex = orderIndex; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }

    public String getTopic() { return topic; }
    public void setTopic(String topic) { this.topic = topic; }

    public String getSubtopic() { return subtopic != null ? subtopic : topic; }
    public void setSubtopic(String subtopic) { this.subtopic = subtopic; }

    public String getExamples() { return examples; }
    public void setExamples(String examples) { this.examples = examples; }

    public String getConstraintsText() { return constraintsText; }
    public void setConstraintsText(String constraintsText) { this.constraintsText = constraintsText; }

    public String getHints() { return hints; }
    public void setHints(String hints) { this.hints = hints; }

    public String getStarterCodeJava() { return starterCodeJava; }
    public void setStarterCodeJava(String starterCodeJava) { this.starterCodeJava = starterCodeJava; }

    public String getStarterCodePython() { return starterCodePython; }
    public void setStarterCodePython(String starterCodePython) { this.starterCodePython = starterCodePython; }

    public String getStarterCodeCpp() { return starterCodeCpp; }
    public void setStarterCodeCpp(String starterCodeCpp) { this.starterCodeCpp = starterCodeCpp; }

    public String getStarterCodeJs() { return starterCodeJs; }
    public void setStarterCodeJs(String starterCodeJs) { this.starterCodeJs = starterCodeJs; }

    public String getSolutionJava() { return solutionJava; }
    public void setSolutionJava(String solutionJava) { this.solutionJava = solutionJava; }

    public String getTestCasesJson() { return testCasesJson; }
    public void setTestCasesJson(String testCasesJson) { this.testCasesJson = testCasesJson; }

    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }

    public String getExternalLink() { return externalLink; }
    public void setExternalLink(String externalLink) { this.externalLink = externalLink; }

    public int getIsActive() { return isActive; }
    public void setIsActive(int isActive) { this.isActive = isActive; }

    public String getUserStatus() { return userStatus != null ? userStatus : "NOT_STARTED"; }
    public void setUserStatus(String userStatus) { this.userStatus = userStatus; }

    public int getAttemptCount() { return attemptCount; }
    public void setAttemptCount(int attemptCount) { this.attemptCount = attemptCount; }

    public Timestamp getFirstAttemptAt() { return firstAttemptAt; }
    public void setFirstAttemptAt(Timestamp firstAttemptAt) { this.firstAttemptAt = firstAttemptAt; }

    public Timestamp getLastAttemptAt() { return lastAttemptAt; }
    public void setLastAttemptAt(Timestamp lastAttemptAt) { this.lastAttemptAt = lastAttemptAt; }

    public Timestamp getSolvedAt() { return solvedAt; }
    public void setSolvedAt(Timestamp solvedAt) { this.solvedAt = solvedAt; }

    public String getLastCode() { return lastCode; }
    public void setLastCode(String lastCode) { this.lastCode = lastCode; }

    public String getLastLanguage() { return lastLanguage; }
    public void setLastLanguage(String lastLanguage) { this.lastLanguage = lastLanguage; }

    public boolean isSolved() { return "SOLVED".equalsIgnoreCase(userStatus); }
    public boolean isAttempted() { return "ATTEMPTED".equalsIgnoreCase(userStatus); }
}
