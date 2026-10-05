package com.interviewx.model;

public class InterviewQuestion implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int questionId;
    private String interviewType;
    private String questionText;
    private String topic;
    private String difficulty;

    public InterviewQuestion() {}

    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    public String getInterviewType() { return interviewType; }
    public void setInterviewType(String interviewType) { this.interviewType = interviewType; }
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }
    public String getTopic() { return topic; }
    public void setTopic(String topic) { this.topic = topic; }
    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }
}
