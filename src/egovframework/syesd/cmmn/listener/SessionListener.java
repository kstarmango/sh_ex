package egovframework.syesd.cmmn.listener;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.concurrent.atomic.AtomicInteger;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.context.support.WebApplicationContextUtils;

import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;

@WebListener
public class SessionListener implements HttpSessionListener, HttpSessionAttributeListener {

	private static Logger logger = LogManager.getLogger(SessionListener.class);

	private final AtomicInteger sessionCount = new AtomicInteger();

  	public void sessionCreated(HttpSessionEvent se)
  	{
  		
  		HttpServletRequest request_test = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
  		String requestURI = request_test.getRequestURI();
  		// 세션 생성시 호출
  		logger.info("[ session ] created   / id : " + se.getSession().getId());

  		// 세션 활성화 증가
  		sessionCount.incrementAndGet();
  		setActiveSessionCount(se);

		HttpSession session = se.getSession();
        if (session != null)
        {
            HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
            if(request.getHeader("User-Agent").toUpperCase().indexOf("JAVA") < 0)
            {
				WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	            LogsService logsService = (LogsService)wac.getBean("logsService");

				try
				{
		            HashMap<String, Object> query = new HashMap<String, Object>();
		            query.put("USER_ID", "시스템");
		            query.put("PREFIX", "LOG");
		            query.put("USER_AGENT", request.getHeader("User-Agent"));
		            query.put("USER_IPADDR", (request.getHeader("X-FORWARDED-FOR") == null ? request.getRemoteAddr() : request.getHeader("X-FORWARDED-FOR")));

		            String apiKey = request.getParameter("apiKey");
		            if(apiKey == null || "".equals(apiKey) == true)
		            {
		            	query.put("REASON", "CD00000032");
		            	//logsService.insertUserLoginAttemptLogs(query);
		            }
		            else
		            {
		            	query.put("REASON", "CD00000040");
		            	//logsService.insertApiKeyLoginAttemptLogs(query);
		            }
				}
				catch (NullPointerException e)
				{
					logger.error("이력 등록 실패");
				}
            }
        }
 	}
 


  	public void sessionDestroyed(HttpSessionEvent se)
  	{
  		// 세션 활성화 감소
  		sessionCount.decrementAndGet();
  		setActiveSessionCount(se);

        HttpSession session = se.getSession();
        if (session != null && session.getAttribute("userId") != null)
        {
			WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
			LogsService logsService = (LogsService)wac.getBean("logsService");

        	HashMap<String, Object> query = new HashMap<String, Object>();
        	query.put("KEY", RequestMappingConstants.KEY);
        	query.put("USER_ID", session.getAttribute("userId"));
        	query.put("PREFIX", "LOG");
        	query.put("PROGRM_URL", RequestMappingConstants.WEB_LOGOUT);

			try
			{
				/* LOGOUT 이력 등록 - 세션만료 이벤트 발생시 : 자동 및 로그아웃 */
				logsService.insertUserProgrmLogs(query);
			}
			catch (SQLException e)
			{
				logger.error("이력 등록 실패");
			}
        }

  		// 세션 소멸시 호출
  		logger.info("[ session ] destroyed / id : " + se.getSession().getId());
  	}

  	public void attributeAdded(HttpSessionBindingEvent se) {
  		// 프로퍼티 추가시 호출
  		logger.info("[ session ] add     / key  : " + se.getName() + ", value : " + se.getValue());
  	}

  	public void attributeRemoved(HttpSessionBindingEvent se) {
  		// 프로퍼티 삭제시 호출
  		logger.info("[ session ] remove  / key  : " + se.getName());
  	}

  	public void attributeReplaced(HttpSessionBindingEvent se) {
  		// 프로퍼티 변경시 호출
  		logger.info("[ session ] replace / key  : " + se.getName() + ", value : " + se.getValue() + " --> " +  se.getSession().getAttribute(se.getName()));
  	}

	private void setActiveSessionCount(HttpSessionEvent se) {
		// 세션 활성화 개수
		se.getSession().getServletContext().setAttribute("activeSessions", sessionCount.get());

		// 세션 활성화 개수 로깅
		logger.info("Total Active Session: " + sessionCount.get());
	}

}