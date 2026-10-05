package com.interviewx.model;

public class CareerTrack {
    private int trackId;
    private String trackName;
    private String description;
    private String icon;

    public CareerTrack() {}
    public CareerTrack(int trackId, String trackName, String description, String icon) {
        this.trackId = trackId;
        this.trackName = trackName;
        this.description = description;
        this.icon = icon;
    }

    public int getTrackId() { return trackId; }
    public void setTrackId(int trackId) { this.trackId = trackId; }
    public String getTrackName() { return trackName; }
    public void setTrackName(String trackName) { this.trackName = trackName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }
}
