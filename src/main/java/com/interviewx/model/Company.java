package com.interviewx.model;

public class Company {
    private int companyId;
    private String companyName;
    private String industry;
    private String description;
    private String website;
    private String requiredSkills;
    private String interviewStages;
    private String codingExpectations;
    private String technicalExpectations;
    private String hrExpectations;

    public Company() {}

    public int getCompanyId() { return companyId; }
    public void setCompanyId(int companyId) { this.companyId = companyId; }
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    public String getIndustry() { return industry; }
    public void setIndustry(String industry) { this.industry = industry; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getWebsite() { return website; }
    public void setWebsite(String website) { this.website = website; }
    public String getRequiredSkills() { return requiredSkills; }
    public void setRequiredSkills(String requiredSkills) { this.requiredSkills = requiredSkills; }
    public String getInterviewStages() { return interviewStages; }
    public void setInterviewStages(String interviewStages) { this.interviewStages = interviewStages; }
    public String getCodingExpectations() { return codingExpectations; }
    public void setCodingExpectations(String codingExpectations) { this.codingExpectations = codingExpectations; }
    public String getTechnicalExpectations() { return technicalExpectations; }
    public void setTechnicalExpectations(String technicalExpectations) { this.technicalExpectations = technicalExpectations; }
    public String getHrExpectations() { return hrExpectations; }
    public void setHrExpectations(String hrExpectations) { this.hrExpectations = hrExpectations; }
}
