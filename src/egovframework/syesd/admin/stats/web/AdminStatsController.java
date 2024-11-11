package egovframework.syesd.admin.stats.web;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.syesd.admin.stats.service.AdminStatsService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;

@Controller
public class AdminStatsController extends BaseController  {

	private static Logger logger = LogManager.getLogger(AdminStatsController.class);

	private ObjectMapper mapper;

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "adminStatsService")
	private AdminStatsService adminStatsService;

	@Resource(name = "logsService")
	private LogsService logsService;

	private static final String validUrl   = RequestMappingConstants.WEB_MAIN;
	private static final String invalidUrl = RequestMappingConstants.WEB_LOGIN;

    @PostConstruct
	public void initIt() throws SQLException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}
    
    /*======================================================== 통 계 ========================================================*/
    /* 관리자 통계 - 접속자 조회*/
	@RequestMapping(value = { RequestMappingConstants.WEB_STATS_USER }, method = { RequestMethod.GET, RequestMethod.POST })
	public String userStats(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws SQLException, NullPointerException, IOException {
		response.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if (referer != null && "".equals(referer) == false) {
			
			URL url = new URL(referer);
			String host = url.getHost();

			HttpSession session = getSession();
			if (session != null) {
				CommonSessionVO commonSessionVO = (CommonSessionVO) session.getAttribute("SessionVO");
				String userId = commonSessionVO.getUser_id();
				String userAdmYn = commonSessionVO.getUser_admin_yn();

				if ("Y".equals(userAdmYn) == true && "".equals(userId) == false) {
					
					 // Query parameters
                    HashMap<String, Object> query = new HashMap<>();
                    query.put("KEY", RequestMappingConstants.KEY);
                    
					/* 그룹 표출 */
                    ObjectMapper mapper = new ObjectMapper();
                    /* 그룹 표출 */
                    model.put("grpData", mapper.writeValueAsString(adminStatsService.getmembergrp(query)));
				    
                     //연도_Header
                     model.put("Year", mapper.writeValueAsString( adminStatsService.selectSearchThisYear()));
                     //월_Header
                     model.put("Month", mapper.writeValueAsString( adminStatsService.selectSearchThisMonth()));
                   
					/* 이력 */
					try {
						HashMap<String, Object> param = new HashMap<String, Object>();
						param.put("KEY", RequestMappingConstants.KEY);
						param.put("PREFIX", "LOG");
						param.put("USER_ID", userId);
						param.put("PROGRM_URL", request.getRequestURI());
						param.put("AUDIT_CD", "CD00000013");
						param.put("TRGET_USER_ID", "");

						/* 프로그램 사용 이력 등록 */
						logsService.insertUserProgrmLogs(param);

						/* 감사로그 - 목록 조회 */
						logsService.insertUserAuditLogs(param);
					} catch (SQLException e) {
						logger.error("이력 등록 실패");
					}

					return "admin/stat/userStat.page";
				} else {
					jsHelper.Alert("권한이 없습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
					jsHelper.RedirectUrl(invalidUrl);
				}
			} else {
				jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
				jsHelper.RedirectUrl(invalidUrl);
			}
		} else {
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			jsHelper.RedirectUrl(invalidUrl);
		}

		return null;
	}
	
	/* 관리자 통계 - 접속자 조회 통합 데이터 조회 */
	@RequestMapping(value="/mngStatUserData.do")
	public ModelAndView mngStatUserData(HttpServletRequest request, HttpServletResponse response) throws SQLException, NullPointerException, IOException {
	    response.setCharacterEncoding("UTF-8");

	    String DATAVAL = request.getParameter("DATAVAL");
	    String DEPT_NM = request.getParameter("DEPT_NM");
	    String YEAR = request.getParameter("YEAR");
	    String MONTH = request.getParameter("MONTH");

	    if ("전체".equals(DEPT_NM)) {
	        DEPT_NM = "";
	    }

	    HashMap<String, Object> query = new HashMap<>();
	    query.put("DATAVAL", DATAVAL);
	    query.put("DEPT_NM", DEPT_NM);
	    query.put("YEAR", YEAR);
	    query.put("MONTH", MONTH);
	    query.put("KEY", RequestMappingConstants.KEY);

	    ObjectMapper mapper = new ObjectMapper();
	    HashMap<String, Object> responseMap = new HashMap<>();

	    ModelAndView modelAndView = new ModelAndView();
	    // 통합된 쿼리로 데이터 조회
	    if ("day".equals(DATAVAL)) {
	    	 //responseMap.put("Day", adminStatsService.selectSearchThisDay(query));
	    	 modelAndView.addObject("Day", adminStatsService.selectSearchThisDay(query));
	    }
	    /*responseMap.put("gridSet", adminStatsService.selectSearchData(query));
	    responseMap.put("UserDeptPercent", adminStatsService.getUserDeptPercent(query));

	    String jsonResponse = mapper.writeValueAsString(responseMap);
	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");
	    response.getWriter().print(jsonResponse);*/
	  
	    modelAndView.addObject("gridSet", adminStatsService.selectSearchData(query));
	    modelAndView.addObject("UserDeptPercent", adminStatsService.getUserDeptPercent(query));
	    modelAndView.setViewName("jsonView");
	    
	    return modelAndView;
	}
	    
    /* 관리자 통계 - 메뉴별 조회*/
	@RequestMapping(value = { RequestMappingConstants.WEB_STATS_MENU }, method = { RequestMethod.GET, RequestMethod.POST })
	public String menuStats(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws SQLException, NullPointerException, IOException {
		response.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if (referer != null && "".equals(referer) == false) {
			
			URL url = new URL(referer);
			String host = url.getHost();

			HttpSession session = getSession();
			if (session != null) {
				CommonSessionVO commonSessionVO = (CommonSessionVO) session.getAttribute("SessionVO");
				String userId = commonSessionVO.getUser_id();
				String userAdmYn = commonSessionVO.getUser_admin_yn();

				if ("Y".equals(userAdmYn) == true && "".equals(userId) == false) {
					
				    
                     // 날짜 초기값 - 해당 월의 1일부터 현재날짜
                     LocalDate now = LocalDate.now();
                     LocalDate firstDayOfMonth = now.withDayOfMonth(1);
                     DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                     String START_DT = firstDayOfMonth.format(formatter);
                     String END_DT = now.format(formatter);

                     // Query parameters
                     HashMap<String, Object> query = new HashMap<>();
                     query.put("START_DT", START_DT);
                     query.put("END_DT", END_DT);
                     query.put("DEPT_NM", "");
                     query.put("KEY", RequestMappingConstants.KEY);
                     
                     
                     ObjectMapper mapper = new ObjectMapper();
                     /* 그룹 표출 */
                     model.put("grpData", mapper.writeValueAsString(adminStatsService.getmembergrp(query)));
                     
					/* 이력 */
					try {
						HashMap<String, Object> param = new HashMap<String, Object>();
						param.put("KEY", RequestMappingConstants.KEY);
						param.put("PREFIX", "LOG");
						param.put("USER_ID", userId);
						param.put("PROGRM_URL", request.getRequestURI());
						param.put("AUDIT_CD", "CD00000013");
						param.put("TRGET_USER_ID", "");

						/* 프로그램 사용 이력 등록 */
						logsService.insertUserProgrmLogs(param);

						/* 감사로그 - 목록 조회 */
						logsService.insertUserAuditLogs(param);
					} catch (SQLException e) {
						logger.error("이력 등록 실패");
					}

					return "admin/stat/menuStat.page";
				} else {
					jsHelper.Alert("권한이 없습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
					jsHelper.RedirectUrl(invalidUrl);
				}
			} else {
				jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
				jsHelper.RedirectUrl(invalidUrl);
			}
		} else {
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			jsHelper.RedirectUrl(invalidUrl);
		}

		return null;
	}
	
	/* 관리자 통계 - 메뉴별 조회 그리드 데이터 조회*/
	@RequestMapping(value="/mngStatMenuData.do")
	public ModelAndView menuStatsData(HttpServletRequest request, HttpServletResponse response) throws SQLException, NullPointerException, IOException {
			response.setCharacterEncoding("UTF-8");
			
	    	String DEPT_NM = request.getParameter("DEPT_NM");
			String START_DT = request.getParameter("START_DT");
			String END_DT = request.getParameter("END_DT");

			if ("전체".equals(DEPT_NM)) {
		        DEPT_NM = "";
		    }
			
			HashMap<String, Object> query = new HashMap<>();
		    query.put("START_DT", START_DT);
		    query.put("END_DT", END_DT);
		    query.put("DEPT_NM", DEPT_NM);
		    query.put("KEY", RequestMappingConstants.KEY); 
		  
		    ObjectMapper mapper = new ObjectMapper();
		    HashMap<String, Object> responseMap = new HashMap<>();
		    /*responseMap.put("grid1Ret", adminStatsService.selectUsesMenuStatics(query));
		    responseMap.put("getMenuDeptPercent", adminStatsService.getMenuDeptPercent(query));

		    String jsonResponse = mapper.writeValueAsString(responseMap);
		    response.setCharacterEncoding("UTF-8");
		    response.setContentType("application/json; charset=UTF-8");
		    response.getWriter().print(jsonResponse);*/
		    
		    ModelAndView modelAndView = new ModelAndView();
		    modelAndView.addObject("grid1Ret", adminStatsService.selectUsesMenuStatics(query));
		    modelAndView.addObject("getMenuDeptPercent", adminStatsService.getMenuDeptPercent(query));
		    modelAndView.setViewName("jsonView");

		    return modelAndView;
	}
	
	 
	 	/* 관리자 통계 - 레이어 조회(통합)*/
		@RequestMapping(value = { RequestMappingConstants.WEB_STATS_LAYER }, method = { RequestMethod.GET, RequestMethod.POST })
		public String layerStats(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws SQLException, NullPointerException, IOException {
			response.setCharacterEncoding("UTF-8");

			String referer = request.getHeader("referer");
			if (referer != null && "".equals(referer) == false) {
				
				URL url = new URL(referer);
				String host = url.getHost();

				HttpSession session = getSession();
				if (session != null) {
					CommonSessionVO commonSessionVO = (CommonSessionVO) session.getAttribute("SessionVO");
					String userId = commonSessionVO.getUser_id();
					String userAdmYn = commonSessionVO.getUser_admin_yn();

					if ("Y".equals(userAdmYn) == true && "".equals(userId) == false) {
						
					    
	                     // 날짜 초기값 - 해당 월의 1일부터 현재날짜
	                     LocalDate now = LocalDate.now();
	                     LocalDate firstDayOfMonth = now.withDayOfMonth(1);
	                     DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	                     String START_DT = firstDayOfMonth.format(formatter);
	                     String END_DT = now.format(formatter);

	                     // Query parameters
	                     HashMap<String, Object> query = new HashMap<>();
	                     query.put("START_DT", START_DT);
	                     query.put("END_DT", END_DT);
	                     query.put("DEPT_NM", "");
	                     query.put("KEY", RequestMappingConstants.KEY);
	                     
	                     
	                     ObjectMapper mapper = new ObjectMapper();
	                     /* 그룹 표출 */
	                     model.put("grpData", mapper.writeValueAsString(adminStatsService.getmembergrp(query)));
	                     
						/* 이력 */
						try {
							HashMap<String, Object> param = new HashMap<String, Object>();
							param.put("KEY", RequestMappingConstants.KEY);
							param.put("PREFIX", "LOG");
							param.put("USER_ID", userId);
							param.put("PROGRM_URL", request.getRequestURI());
							param.put("AUDIT_CD", "CD00000013");
							param.put("TRGET_USER_ID", "");

							/* 프로그램 사용 이력 등록 */
							logsService.insertUserProgrmLogs(param);

							/* 감사로그 - 목록 조회 */
							logsService.insertUserAuditLogs(param);
						} catch (SQLException e) {
							logger.error("이력 등록 실패");
						}

						return "admin/stat/layerStat.page";
					} else {
						jsHelper.Alert("권한이 없습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
						jsHelper.RedirectUrl(invalidUrl);
					}
				} else {
					jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
					jsHelper.RedirectUrl(invalidUrl);
				}
			} else {
				jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
				jsHelper.RedirectUrl(invalidUrl);
			}

			return null;
		}
		
		/* 관리자 통계 - 레이어 조회 그리드 데이터 조회*/
		@RequestMapping(value="/mngStatLayerData.do")
		public ModelAndView mngStatLayerData(HttpServletRequest request, HttpServletResponse response) throws SQLException, NullPointerException, IOException {
				response.setCharacterEncoding("UTF-8");
				
				String STAT_TYPE = request.getParameter("STAT_TYPE");
		    	String DEPT_NM = request.getParameter("DEPT_NM");
				String START_DT = request.getParameter("START_DT");
				String END_DT = request.getParameter("END_DT");

				if ("전체".equals(DEPT_NM)) {
			        DEPT_NM = "";
			    }
				
				HashMap<String, Object> query = new HashMap<>();
				query.put("STAT_TYPE", STAT_TYPE);  //통계타입 확인
			    query.put("START_DT", START_DT);
			    query.put("END_DT", END_DT);
			    query.put("DEPT_NM", DEPT_NM);
			    query.put("KEY", RequestMappingConstants.KEY); 
			  
			    ObjectMapper mapper = new ObjectMapper();
			    HashMap<String, Object> responseMap = new HashMap<>();
			    /*responseMap.put("grid1Ret", adminStatsService.selectUsesLayerStatics(query));
			    responseMap.put("LayerDeptPercent", adminStatsService.getLayerDeptPercent(query));

			    String jsonResponse = mapper.writeValueAsString(responseMap);
			    response.setCharacterEncoding("UTF-8");
			    response.setContentType("application/json; charset=UTF-8");
			    response.getWriter().print(jsonResponse);*/
			    
			    ModelAndView modelAndView = new ModelAndView();
			    modelAndView.addObject("grid1Ret", adminStatsService.selectUsesLayerStatics(query));
			    modelAndView.addObject("LayerDeptPercent", adminStatsService.getLayerDeptPercent(query));
			    modelAndView.setViewName("jsonView");

			    return modelAndView;
		}
		
		
		/*======================================================== 누 계 통 계 ========================================================*/
	    /* 관리자 누계통계 - 접속자 조회*/
		@RequestMapping(value = { RequestMappingConstants.WEB_SUM_STATS_USER }, method = { RequestMethod.GET, RequestMethod.POST })
		public String userSumStats(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws SQLException, NullPointerException, IOException {
			response.setCharacterEncoding("UTF-8");

			String referer = request.getHeader("referer");
			if (referer != null && "".equals(referer) == false) {
				
				URL url = new URL(referer);
				String host = url.getHost();

				HttpSession session = getSession();
				if (session != null) {
					CommonSessionVO commonSessionVO = (CommonSessionVO) session.getAttribute("SessionVO");
					String userId = commonSessionVO.getUser_id();
					String userAdmYn = commonSessionVO.getUser_admin_yn();

					if ("Y".equals(userAdmYn) == true && "".equals(userId) == false) {
						
						 // Query parameters
	                    HashMap<String, Object> query = new HashMap<>();
	                    query.put("KEY", RequestMappingConstants.KEY);
	                    
	                    ObjectMapper mapper = new ObjectMapper();
	                    /* 그룹 표출 */
	                    model.put("grpData", mapper.writeValueAsString(adminStatsService.getmembergrp(query)));
					    
	                     //연도_Header
	                     model.put("Year", mapper.writeValueAsString( adminStatsService.selectSearchThisYear()));
	                   
						/* 이력 */
						try {
							HashMap<String, Object> param = new HashMap<String, Object>();
							param.put("KEY", RequestMappingConstants.KEY);
							param.put("PREFIX", "LOG");
							param.put("USER_ID", userId);
							param.put("PROGRM_URL", request.getRequestURI());
							param.put("AUDIT_CD", "CD00000013");
							param.put("TRGET_USER_ID", "");

							/* 프로그램 사용 이력 등록 */
							logsService.insertUserProgrmLogs(param);

							/* 감사로그 - 목록 조회 */
							logsService.insertUserAuditLogs(param);
						} catch (SQLException e) {
							logger.error("이력 등록 실패");
						}

						return "admin/stat/userSumStat.page";
					} else {
						jsHelper.Alert("권한이 없습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
						jsHelper.RedirectUrl(invalidUrl);
					}
				} else {
					jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
					jsHelper.RedirectUrl(invalidUrl);
				}
			} else {
				jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
				jsHelper.RedirectUrl(invalidUrl);
			}

			return null;
		}
		
		/* 관리자 누계통계 - 접속자 조회 통합 데이터 조회 */
		@RequestMapping(value="/mngSumStatUserData.do")
		public ModelAndView mngSumStatUserData(HttpServletRequest request, HttpServletResponse response) throws SQLException, NullPointerException, IOException {
		    response.setCharacterEncoding("UTF-8");

		    String DATAVAL = request.getParameter("DATAVAL");
		    String DEPT_NM = "";
		    //String DEPT_NM = request.getParameter("DEPT_NM");

		    HashMap<String, Object> query = new HashMap<>();
		    query.put("DATAVAL", DATAVAL);
		    query.put("DEPT_NM", DEPT_NM);
		    query.put("KEY", RequestMappingConstants.KEY);

		    ObjectMapper mapper = new ObjectMapper();
		    HashMap<String, Object> responseMap = new HashMap<>();

		    // 통합된 쿼리로 데이터 조회
		    /*responseMap.put("gridSet", adminStatsService.selectSearchData(query));
		    responseMap.put("UserDeptPercent", adminStatsService.getSumStatUserPercent(query));

		    String jsonResponse = mapper.writeValueAsString(responseMap);
		    response.setCharacterEncoding("UTF-8");
		    response.setContentType("application/json; charset=UTF-8");
		    response.getWriter().print(jsonResponse);*/
		    
		    ModelAndView modelAndView = new ModelAndView();
		    modelAndView.addObject("gridSet", adminStatsService.selectSearchData(query));
		    modelAndView.addObject("UserDeptPercent", adminStatsService.getSumStatUserPercent(query));
		    modelAndView.setViewName("jsonView");

		    return modelAndView;
		}
		    
	    /* 관리자 누계통계 - 메뉴별 조회*/
		@RequestMapping(value = { RequestMappingConstants.WEB_SUM_STATS_MENU }, method = { RequestMethod.GET, RequestMethod.POST })
		public String menuSumStats(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws SQLException, NullPointerException, IOException {
			response.setCharacterEncoding("UTF-8");

			String referer = request.getHeader("referer");
			if (referer != null && "".equals(referer) == false) {
				
				URL url = new URL(referer);
				String host = url.getHost();

				HttpSession session = getSession();
				if (session != null) {
					CommonSessionVO commonSessionVO = (CommonSessionVO) session.getAttribute("SessionVO");
					String userId = commonSessionVO.getUser_id();
					String userAdmYn = commonSessionVO.getUser_admin_yn();

					if ("Y".equals(userAdmYn) == true && "".equals(userId) == false) {
						
					    
	                     // Query parameters
	                     HashMap<String, Object> query = new HashMap<>();
	                     query.put("DEPT_NM", "");
	                     query.put("KEY", RequestMappingConstants.KEY);
	                     
	                     
	                     ObjectMapper mapper = new ObjectMapper();
	                     /* 그룹 표출 */
	                     model.put("grpData", mapper.writeValueAsString(adminStatsService.getmembergrp(query)));
	                   //연도_Header
	                     model.put("Year", mapper.writeValueAsString( adminStatsService.selectSearchThisYear()));
	                     
						/* 이력 */
						try {
							HashMap<String, Object> param = new HashMap<String, Object>();
							param.put("KEY", RequestMappingConstants.KEY);
							param.put("PREFIX", "LOG");
							param.put("USER_ID", userId);
							param.put("PROGRM_URL", request.getRequestURI());
							param.put("AUDIT_CD", "CD00000013");
							param.put("TRGET_USER_ID", "");

							/* 프로그램 사용 이력 등록 */
							logsService.insertUserProgrmLogs(param);

							/* 감사로그 - 목록 조회 */
							logsService.insertUserAuditLogs(param);
						} catch (SQLException e) {
							logger.error("이력 등록 실패");
						}

						return "admin/stat/menuSumStat.page";
					} else {
						jsHelper.Alert("권한이 없습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
						jsHelper.RedirectUrl(invalidUrl);
					}
				} else {
					jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
					jsHelper.RedirectUrl(invalidUrl);
				}
			} else {
				jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
				jsHelper.RedirectUrl(invalidUrl);
			}

			return null;
		}
		
		/* 관리자 누계통계 - 메뉴별 조회 그리드 데이터 조회*/
		@RequestMapping(value="/mngSumStatMenuData.do")
		public ModelAndView menuSumStatsData(HttpServletRequest request, HttpServletResponse response) throws SQLException, NullPointerException, IOException {
				response.setCharacterEncoding("UTF-8");
				
		    	String DEPT_NM = request.getParameter("DEPT_NM");

				if ("전체".equals(DEPT_NM)) {
			        DEPT_NM = "";
			    }
				
				HashMap<String, Object> query = new HashMap<>();
			    query.put("DEPT_NM", DEPT_NM);
			    query.put("KEY", RequestMappingConstants.KEY); 
			  
			    ObjectMapper mapper = new ObjectMapper();
			    HashMap<String, Object> responseMap = new HashMap<>();
			    /*responseMap.put("gridSet", adminStatsService.selectSumUsesMenuStatics(query));
			    responseMap.put("SumMenuDeptPercent", adminStatsService.getSumMenuDeptPercent(query));

			    String jsonResponse = mapper.writeValueAsString(responseMap);
			    response.setCharacterEncoding("UTF-8");
			    response.setContentType("application/json; charset=UTF-8");
			    response.getWriter().print(jsonResponse);*/
			    
			    ModelAndView modelAndView = new ModelAndView();
			    modelAndView.addObject("gridSet", adminStatsService.selectSumUsesMenuStatics(query));
			    modelAndView.addObject("SumMenuDeptPercent", adminStatsService.getSumMenuDeptPercent(query));
			    modelAndView.setViewName("jsonView");

			    return modelAndView;
		}
		
		 
		 	/* 관리자 누계통계 - 레이어 조회(통합)*/
			@RequestMapping(value = { RequestMappingConstants.WEB_SUM_STATS_LAYER }, method = { RequestMethod.GET, RequestMethod.POST })
			public String layerSumStats(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws SQLException, NullPointerException, IOException {
				response.setCharacterEncoding("UTF-8");

				String referer = request.getHeader("referer");
				if (referer != null && "".equals(referer) == false) {
					
					URL url = new URL(referer);
					String host = url.getHost();

					HttpSession session = getSession();
					if (session != null) {
						CommonSessionVO commonSessionVO = (CommonSessionVO) session.getAttribute("SessionVO");
						String userId = commonSessionVO.getUser_id();
						String userAdmYn = commonSessionVO.getUser_admin_yn();

						if ("Y".equals(userAdmYn) == true && "".equals(userId) == false) {
							
						    
		                     // Query parameters
		                     HashMap<String, Object> query = new HashMap<>();
		                     query.put("DEPT_NM", "");
		                     query.put("KEY", RequestMappingConstants.KEY);
		                     
		                     
		                     ObjectMapper mapper = new ObjectMapper();
		                     /* 그룹 표출 */
		                     model.put("grpData", mapper.writeValueAsString(adminStatsService.getmembergrp(query)));
		                     //연도_Header
		                     model.put("Year", mapper.writeValueAsString( adminStatsService.selectSearchThisYear()));
		                     
							/* 이력 */
							try {
								HashMap<String, Object> param = new HashMap<String, Object>();
								param.put("KEY", RequestMappingConstants.KEY);
								param.put("PREFIX", "LOG");
								param.put("USER_ID", userId);
								param.put("PROGRM_URL", request.getRequestURI());
								param.put("AUDIT_CD", "CD00000013");
								param.put("TRGET_USER_ID", "");

								/* 프로그램 사용 이력 등록 */
								logsService.insertUserProgrmLogs(param);

								/* 감사로그 - 목록 조회 */
								logsService.insertUserAuditLogs(param);
							} catch (SQLException e) {
								logger.error("이력 등록 실패");
							}

							return "admin/stat/layerSumStat.page";
						} else {
							jsHelper.Alert("권한이 없습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
							jsHelper.RedirectUrl(invalidUrl);
						}
					} else {
						jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
						jsHelper.RedirectUrl(invalidUrl);
					}
				} else {
					jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
					jsHelper.RedirectUrl(invalidUrl);
				}

				return null;
			}
			
			/* 관리자 누계통계 - 레이어 조회 그리드 데이터 조회*/
			@RequestMapping(value="/mngSumStatLayerData.do")
			public ModelAndView mngSumStatLayerData(HttpServletRequest request, HttpServletResponse response) throws SQLException, NullPointerException, IOException {
					response.setCharacterEncoding("UTF-8");
					
					String STAT_TYPE = request.getParameter("STAT_TYPE");
			    	String DEPT_NM = request.getParameter("DEPT_NM");

					if ("전체".equals(DEPT_NM)) {
				        DEPT_NM = "";
				    }
					
					HashMap<String, Object> query = new HashMap<>();
					query.put("STAT_TYPE", STAT_TYPE);  //통계타입 확인
				    query.put("DEPT_NM", DEPT_NM);
				    query.put("KEY", RequestMappingConstants.KEY); 
				  
				    ObjectMapper mapper = new ObjectMapper();
				    HashMap<String, Object> responseMap = new HashMap<>();
				    /*responseMap.put("grid1Ret", adminStatsService.selectSumUsesLayerStatics(query));
				    responseMap.put("SumLayerDeptPercent", adminStatsService.getSumLayerDeptPercent(query));

				    String jsonResponse = mapper.writeValueAsString(responseMap);
				    response.setCharacterEncoding("UTF-8");
				    response.setContentType("application/json; charset=UTF-8");
				    response.getWriter().print(jsonResponse);*/
				    
				    ModelAndView modelAndView = new ModelAndView();
				    modelAndView.addObject("grid1Ret", adminStatsService.selectSumUsesLayerStatics(query));
				    modelAndView.addObject("SumLayerDeptPercent", adminStatsService.getSumLayerDeptPercent(query));
				    modelAndView.setViewName("jsonView");

				    return modelAndView;
			}
		

}
