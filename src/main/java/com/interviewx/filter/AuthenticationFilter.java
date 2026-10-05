package com.interviewx.filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

/**
 * AuthenticationFilter - Protects all authenticated pages and servlets.
 * Redirects unauthenticated users to the login page.
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
    "/dashboard.jsp",
    "/profile", "/student/*",
    "/profiles", "/profiles/*",
    "/resume", "/resume/*",
    "/learning", "/learning/*",
    "/assessment", "/assessment/*",
    "/career/*",
    "/roadmap/*",
    "/tasks", "/tasks/*",
    "/codelab", "/codelab/*",
    "/analyzer", "/analyzer/*",
    "/interview", "/interview/*",
    "/company", "/company/*",
    "/store", "/store/*",
    "/notifications", "/notifications/*",
    "/admin/*",
    "/api/*"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpServletResponse httpResp = (HttpServletResponse) response;

        HttpSession session = httpReq.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("userId") != null);

        if (isLoggedIn) {
            chain.doFilter(request, response);
        } else {
            httpResp.sendRedirect(httpReq.getContextPath() + "/login.jsp?expired=true");
        }
    }

    @Override public void init(FilterConfig f) {}
    @Override public void destroy() {}
}
