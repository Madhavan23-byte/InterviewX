package com.interviewx.model;

public class Student {
    private int studentId;
    private int userId;
    private String collegeName;
    private String degree;
    private int graduationYear;
    private String targetRole;
    private String skills;
    private String interests;
    private String programmingExperience;
    private String careerGoals;
    private String phone;
    private String linkedinUrl;
    private String githubUrl;
    private int profileCompleted;

    public Student() {}

    public Student(int userId) {
        this.userId = userId;
    }

    // Getters and Setters
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getCollegeName() { return collegeName; }
    public void setCollegeName(String collegeName) { this.collegeName = collegeName; }
    public String getDegree() { return degree; }
    public void setDegree(String degree) { this.degree = degree; }
    public int getGraduationYear() { return graduationYear; }
    public void setGraduationYear(int graduationYear) { this.graduationYear = graduationYear; }
    public String getTargetRole() { return targetRole; }
    public void setTargetRole(String targetRole) { this.targetRole = targetRole; }
    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }
    public String getInterests() { return interests; }
    public void setInterests(String interests) { this.interests = interests; }
    public String getProgrammingExperience() { return programmingExperience; }
    public void setProgrammingExperience(String programmingExperience) { this.programmingExperience = programmingExperience; }
    public String getCareerGoals() { return careerGoals; }
    public void setCareerGoals(String careerGoals) { this.careerGoals = careerGoals; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getLinkedinUrl() { return linkedinUrl; }
    public void setLinkedinUrl(String linkedinUrl) { this.linkedinUrl = linkedinUrl; }
    public String getGithubUrl() { return githubUrl; }
    public void setGithubUrl(String githubUrl) { this.githubUrl = githubUrl; }
    public int getProfileCompleted() { return profileCompleted; }
    public void setProfileCompleted(int profileCompleted) { this.profileCompleted = profileCompleted; }
}
