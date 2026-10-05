package com.interviewx.service;

import com.interviewx.config.GeminiConfig;
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

/**
 * GeminiBaseService - Shared HTTP transport for all Gemini AI calls.
 *
 * Subclasses pass their specific API key and prompt.
 * Handles timeouts, HTTP errors, rate limits, quota exhaustion gracefully.
 * API keys are NEVER logged or exposed to the browser.
 */
public abstract class GeminiBaseService {

    /**
     * Call the Gemini REST API with the given prompt and API key.
     * Returns the model's text response, or a user-friendly error message.
     */
    protected String callGemini(String apiKey, String prompt) {
        if (apiKey == null || apiKey.isBlank()) {
            return null; // Caller should use fallback
        }
        try {
            URL url = new URL(GeminiConfig.GEMINI_API_URL + apiKey);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setDoOutput(true);
            conn.setConnectTimeout(GeminiConfig.CONNECT_TIMEOUT_MS);
            conn.setReadTimeout(GeminiConfig.READ_TIMEOUT_MS);

            String body = buildRequestBody(prompt);
            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.getBytes(StandardCharsets.UTF_8));
            }

            int status = conn.getResponseCode();
            if (status == 200) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder sb = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) sb.append(line).append("\n");
                    return extractText(sb.toString());
                }
            } else if (status == 429) {
                logError("Gemini quota/rate limit exceeded (429)");
                return "__RATE_LIMITED__";
            } else if (status == 400) {
                logError("Gemini bad request (400)");
                return "__BAD_REQUEST__";
            } else if (status == 403) {
                logError("Gemini invalid API key (403)");
                return "__INVALID_KEY__";
            } else {
                logError("Gemini HTTP error: " + status);
                return "__HTTP_ERROR_" + status + "__";
            }
        } catch (SocketTimeoutException e) {
            logError("Gemini timeout: " + e.getMessage());
            return "__TIMEOUT__";
        } catch (Exception e) {
            logError("Gemini network error: " + e.getMessage());
            return "__NETWORK_ERROR__";
        }
    }

    /** Translate internal error tokens into user-friendly messages. */
    protected String friendlyError(String raw) {
        if (raw == null) return "AI analysis is temporarily unavailable. Please configure the API key.";
        switch (raw) {
            case "__RATE_LIMITED__":
                return "AI service quota exceeded. Please try again in a few minutes.";
            case "__INVALID_KEY__":
                return "AI service is not properly configured. Please contact the administrator.";
            case "__TIMEOUT__":
                return "AI analysis timed out. Please try again with a shorter input.";
            case "__BAD_REQUEST__":
                return "The request could not be processed by the AI service. Please try again.";
            default:
                if (raw.startsWith("__HTTP_ERROR_") || raw.startsWith("__NETWORK_ERROR__")) {
                    return "AI service is temporarily unavailable. Please try again later.";
                }
                return raw; // Actual content
        }
    }

    /** True if the raw result is an error token. */
    protected boolean isError(String raw) {
        return raw == null || raw.startsWith("__");
    }

    private String buildRequestBody(String prompt) {
        return "{\"contents\":[{\"parts\":[{\"text\":" + jsonString(prompt) + "}]}]," +
               "\"generationConfig\":{\"temperature\":0.7,\"maxOutputTokens\":4096}}";
    }

    private String extractText(String json) {
        try {
            // Find "text": "..." in the response
            int idx = json.indexOf("\"text\":");
            if (idx == -1) return "Unable to parse AI response. Please try again.";
            idx = json.indexOf("\"", idx + 7) + 1;
            StringBuilder sb = new StringBuilder();
            for (int i = idx; i < json.length(); i++) {
                char c = json.charAt(i);
                if (c == '\\' && i + 1 < json.length()) {
                    char next = json.charAt(i + 1);
                    if (next == '"') { sb.append('"'); i++; }
                    else if (next == 'n') { sb.append('\n'); i++; }
                    else if (next == 't') { sb.append('\t'); i++; }
                    else if (next == '\\') { sb.append('\\'); i++; }
                    else { sb.append(c); }
                } else if (c == '"') {
                    break;
                } else {
                    sb.append(c);
                }
            }
            String result = sb.toString().trim();
            return result.isEmpty() ? "AI returned an empty response. Please try again." : result;
        } catch (Exception e) {
            return "Unable to parse AI response.";
        }
    }

    protected String jsonString(String s) {
        if (s == null) return "\"\"";
        return "\"" + s.replace("\\", "\\\\")
                       .replace("\"", "\\\"")
                       .replace("\n", "\\n")
                       .replace("\r", "\\r")
                       .replace("\t", "\\t") + "\"";
    }

    private void logError(String msg) {
        System.err.println("[GeminiAI] " + msg);
    }
}
