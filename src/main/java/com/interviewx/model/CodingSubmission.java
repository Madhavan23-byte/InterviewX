package com.interviewx.model;

import java.sql.Timestamp;

public class CodingSubmission {
    private int submissionId;
    private int userId;
    private int profileId;
    private int problemId;
    private String problemTitle;
    private String language;
    private String code;
    private String verdict;
    private int runtimeMs;
    private int memoryKb;
    private int passedTestCases;
    private int totalTestCases;
    private int attemptNumber;
    private String errorDetails;
    private Timestamp submittedAt;

    public CodingSubmission() {}

    public int getSubmissionId() { return submissionId; }
    public void setSubmissionId(int submissionId) { this.submissionId = submissionId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getProfileId() { return profileId; }
    public void setProfileId(int profileId) { this.profileId = profileId; }

    public int getProblemId() { return problemId; }
    public void setProblemId(int problemId) { this.problemId = problemId; }

    public String getProblemTitle() { return problemTitle; }
    public void setProblemTitle(String problemTitle) { this.problemTitle = problemTitle; }

    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getVerdict() { return verdict; }
    public void setVerdict(String verdict) { this.verdict = verdict; }

    public int getRuntimeMs() { return runtimeMs; }
    public void setRuntimeMs(int runtimeMs) { this.runtimeMs = runtimeMs; }

    public int getMemoryKb() { return memoryKb; }
    public void setMemoryKb(int memoryKb) { this.memoryKb = memoryKb; }

    public int getPassedTestCases() { return passedTestCases; }
    public void setPassedTestCases(int passedTestCases) { this.passedTestCases = passedTestCases; }

    public int getTotalTestCases() { return totalTestCases; }
    public void setTotalTestCases(int totalTestCases) { this.totalTestCases = totalTestCases; }

    public int getAttemptNumber() { return attemptNumber; }
    public void setAttemptNumber(int attemptNumber) { this.attemptNumber = attemptNumber; }

    public String getErrorDetails() { return errorDetails; }
    public void setErrorDetails(String errorDetails) { this.errorDetails = errorDetails; }

    public Timestamp getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(Timestamp submittedAt) { this.submittedAt = submittedAt; }
}
