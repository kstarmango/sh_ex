package egovframework.syesd.cmmn.filter;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/*
@WebFilter(urlPatterns="/user/*")*/
public class fillter {
	private static Logger logger = LogManager.getLogger(fillter.class);
	
	 public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) servletRequest;
		HttpServletResponse res = (HttpServletResponse) servletResponse;
		
		logger.info("##### filter - before #####");
		chain.doFilter(req, res);
		logger.info("##### filter - after #####");
	 }
}
