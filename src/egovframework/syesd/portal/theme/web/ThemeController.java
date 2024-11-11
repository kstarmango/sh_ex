package egovframework.syesd.portal.theme.web;

import java.io.File;
import java.net.URL;
import java.nio.file.Paths;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.file.service.impl.FileServiceImpl;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.syesd.cmmn.util.ImageUtils;
import egovframework.syesd.cmmn.util.KeyGenerateUtil;
import egovframework.syesd.portal.theme.service.ThemeService;
import egovframework.zaol.common.OraclePaginationInfo;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;

@Controller
public class ThemeController extends BaseController {


	/* 현재 사용X
	 * private static Logger logger = LogManager.getLogger(ThemeController.class);

	private ObjectMapper mapper;

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "themeService")
	private ThemeService themeService;

	@Resource(name = "logsService")
	private LogsService logsService;

	private static final String validUrl   = RequestMappingConstants.WEB_MAIN;
	private static final String invalidUrl = RequestMappingConstants.WEB_LOGIN;

    @PostConstruct
	public void initIt() throws Exception {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}

	@RequestMapping(value=RequestMappingConstants.WEB_THEME)
    public String themeMain(HttpServletRequest request,
							HttpServletResponse response,
							ModelMap model) throws Exception
    {
    	response.setCharacterEncoding("UTF-8");

    	String referer = request.getHeader("referer");
    	if(referer != null && "".equals(referer) == false)
    	{
			URL url = new URL(referer);
			String host = url.getHost();

	    	HttpSession session = getSession();
	    	if(session != null)
	    	{
	    		CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
	            
	            String userAdmYn = commonSessionVO.getUser_admin_yn();

            	 이력 
            	try
    			{
	            	HashMap<String, Object> param = new HashMap<String, Object>();
	            	param.put("KEY", RequestMappingConstants.KEY);
			       	param.put("PREFIX", "LOG");
	            	param.put("USER_ID", userId);
	            	param.put("PROGRM_URL", request.getRequestURI());

            		 프로그램 사용 이력 등록 
    				logsService.insertUserProgrmLogs(param);
    			}
    			catch (Exception e)
    			{
    				logger.error("이력 등록 실패" + e.getMessage());
    			}

            	return "portal/theme/contents.page";
	    	}
	    	else
	    	{
		    	jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
	        	jsHelper.RedirectUrl(invalidUrl);
		    }
    	}
    	else
    	{
    		jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
     	   	jsHelper.RedirectUrl(invalidUrl);
    	}

    	return null;
    }

    @RequestMapping(value = RequestMappingConstants.WEB_THEME_LIST,
 			method = {RequestMethod.GET,RequestMethod.POST})
	public ModelAndView themeList(HttpServletRequest request,
								  HttpServletResponse response,
				   	   	  		  @RequestParam(value="pageIndex", required=false) Integer pageIndex,
				   	   	  		  @RequestParam(value="pageUnit",  required=false) Integer pageUnit,
				   	   	  		  @RequestParam(value="pageSize",  required=false) Integer pageSize,
								  ModelMap model) throws Exception
	{
    	response.setCharacterEncoding("UTF-8");
    	request.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			URL url = new URL(referer);
			String host = url.getHost();

			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
		        
		        String userAdmYn = commonSessionVO.getUser_admin_yn();

		        if("".equals(userId) == false)
		        {
			       	if(pageIndex == null || pageIndex == 0)  pageIndex = 1;
		        	if(pageUnit  == null || pageUnit  == 0)  pageUnit  = propertiesService.getInt("pageUnit");
		        	if(pageSize  == null || pageSize  == 0)  pageSize  = propertiesService.getInt("pageSize");

		        	OraclePaginationInfo view01Cnt = new OraclePaginationInfo();
		        	view01Cnt.setCurrentPageNo     (pageIndex);
		        	view01Cnt.setRecordCountPerPage(pageUnit );
		        	view01Cnt.setPageSize          (pageSize );

		        	HashMap<String, Object> query = new HashMap<String, Object>();
		        	query.put("KEY", RequestMappingConstants.KEY);
		        	query.put("INS_USER", userId);
		        	query.put("SERCH_GB", 		request.getParameter("s_serch_gb"));
		        	query.put("SERCH_NM", 		request.getParameter("s_serch_nm"));
		        	query.put("FIRST_INDEX", 	view01Cnt.getFirstRecordIndex());
		        	query.put("LAST_INDEX",  	view01Cnt.getLastRecordIndex());

		        	List themeList = themeService.selectThemeList(query);

		        	view01Cnt.setTotalRecordCount(themeService.selectThemeListCount(query));

					ModelAndView modelAndView = new ModelAndView();
					modelAndView.addObject("themeInfo", themeList);
					modelAndView.addObject("total", view01Cnt.getTotalRecordCount());
					modelAndView.addObject("result", "Y");
					modelAndView.setViewName("jsonView");

					 이력 
		        	try
					{
		            	HashMap<String, Object> param = new HashMap<String, Object>();
		            	param.put("KEY", RequestMappingConstants.KEY);
		            	param.put("PREFIX", "LOG");
		            	param.put("USER_ID", userId);
		            	param.put("PROGRM_URL", request.getRequestURI());

		        		 프로그램 사용 이력 등록 
						logsService.insertUserProgrmLogs(param);
					}
					catch (Exception e)
					{
						logger.error("이력 등록 실패" + e.getMessage());
					}

		        	return modelAndView;
		        }
		        else
		        {
		    		jsHelper.Alert("권한이 없습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
		    		jsHelper.RedirectUrl(invalidUrl);
		        }
			}
			else
			{
		    	jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    	jsHelper.RedirectUrl(invalidUrl);
		    }
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			   	jsHelper.RedirectUrl(invalidUrl);
		}

		return null;
    }

    @RequestMapping(value = RequestMappingConstants.WEB_THEME_DETAIL,
					method = {RequestMethod.POST})
	public ModelAndView themeDetail(HttpServletRequest request,
			   	   	  			 HttpServletResponse response,
			   	   	  		     @RequestParam(value="id",  required=true) String theme_no,
			   	   	  		     ModelMap model) throws Exception
	{
		response.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			URL url = new URL(referer);
			String host = url.getHost();

			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
		       
		        String userAdmYn = commonSessionVO.getUser_admin_yn();

		        if("".equals(userId) == false)
		        {
		        	if("".equals(theme_no) == false)
		        	{
		            	 컨텐츠 
		            	HashMap<String, Object> query = new HashMap<String, Object>();
		            	query.put("KEY", RequestMappingConstants.KEY);
		            	query.put("USER_ID", userId);
		            	query.put("THEME_NO", theme_no);

		                ModelAndView modelAndView = new ModelAndView();
		                modelAndView.addObject("themeInfo", themeService.selectThemeInfoDetail(query));
		                modelAndView.addObject("layerInfo", themeService.selectThemeLayerList(query));
		                modelAndView.addObject("result", "Y");
		                modelAndView.setViewName("jsonView");

		                 조회수 
					   	try
						{
			                query.put("UPD_USER", userId);
			                query.put("VIEW_CNT", "update");

			                themeService.updateThemeInfo(query);
						}
						catch (Exception e)
						{
							logger.error("조회수 증가 실패" + e.getMessage());
						}

					   	 이력 
					   	try
						{
					       	HashMap<String, Object> param = new HashMap<String, Object>();
					       	param.put("KEY", RequestMappingConstants.KEY);
					       	param.put("PREFIX", "LOG");
					       	param.put("USER_ID", userId);
					       	param.put("PROGRM_URL", request.getRequestURI());

				   			 프로그램 사용 이력 등록 
							logsService.insertUserProgrmLogs(param);
						}
						catch (Exception e)
						{
							logger.error("이력 등록 실패" + e.getMessage());
						}

		            	return modelAndView;
		        	}
		        	else
		        	{
			    		jsHelper.Alert("입력된 정보가 옳바르지 않습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			    		jsHelper.RedirectUrl(invalidUrl);
		        	}
		        }
		        else
		        {
		    		jsHelper.Alert("권한이 없습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
		    		jsHelper.RedirectUrl(invalidUrl);
		        }
			}
			else
			{
		    	jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    	jsHelper.RedirectUrl(invalidUrl);
		    }
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			   	jsHelper.RedirectUrl(invalidUrl);
		}

		return null;
	}

    @RequestMapping(value = {RequestMappingConstants.WEB_THEME_EDIT},
		 		method = {RequestMethod.POST})
    public ModelAndView themeEdit(HttpServletRequest request,
			   	   	  		      HttpServletResponse response,
			   	   	  		      @RequestParam(value="id",  required=true) String theme_no,
			   	   	  		      @RequestParam(value="title",  required=false) String title,
			   	   	  		      @RequestParam(value="othbc_yn",  required=false) String othbc_yn,
			   	   	  		      @RequestParam(value="use_yn",  required=false) String use_yn,
			   	   	  		      ModelMap model) throws Exception
	{
		response.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			URL url = new URL(referer);
			String host = url.getHost();

			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
				
				String userAdmYn = commonSessionVO.getUser_admin_yn();

				if("".equals(userId) == false)
				{
					if("".equals(theme_no) == false)
					{
					   	 컨텐츠 
					   	HashMap<String, Object> query = new HashMap<String, Object>();
					   	query.put("KEY", RequestMappingConstants.KEY);
					   	query.put("UPD_USER", userId);
					   	query.put("THEME_NO", theme_no);
					   	query.put("TITLE", title);
					   	query.put("OTHBC_YN", othbc_yn);
					   	query.put("USE_YN", use_yn);

					   	ModelAndView modelAndView = new ModelAndView();
					   	modelAndView.addObject("apikeyInfo", themeService.updateThemeInfo(query));
					   	modelAndView.addObject("result", "Y");
					   	modelAndView.setViewName("jsonView");

					   	 이력 
					   	try
							{
					       	HashMap<String, Object> param = new HashMap<String, Object>();
					       	param.put("KEY", RequestMappingConstants.KEY);
					       	param.put("PREFIX", "LOG");
					       	param.put("USER_ID", userId);
					       	param.put("PROGRM_URL", request.getRequestURI());

					   		 프로그램 사용 이력 등록 
								logsService.insertUserProgrmLogs(param);
							}
							catch (Exception e)
							{
								logger.error("이력 등록 실패" + e.getMessage());
							}

					   	return modelAndView;
					}
					else
					{
						jsHelper.Alert("입력된 정보가 옳바르지 않습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
						jsHelper.RedirectUrl(invalidUrl);
					}
				}
				else
				{
					jsHelper.Alert("권한이 없습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
					jsHelper.RedirectUrl(invalidUrl);
				}
			}
			else
			{
				jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
				jsHelper.RedirectUrl(invalidUrl);
			}
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			jsHelper.RedirectUrl(invalidUrl);
		}

		return null;
	}

    @RequestMapping(value = {RequestMappingConstants.WEB_THEME_ADD},
					method = {RequestMethod.POST})
	public ModelAndView themeAdd(HttpServletRequest request,
			   	   	  		      HttpServletResponse response,
			   	   	  		      @RequestParam(value="title",  required=true) String title,
			   	   	  		      @RequestParam(value="image",  required=true) String image,
			   	   	  		      @RequestParam(value="othbc_yn",  required=true) String othbc_yn,
			   	   	  		      @RequestParam(value="layers",  required=true) String layers,
			   	   	  		      @RequestParam(value="file_grp",  required=false) String file_grp,
			   	   	  		      ModelMap model) throws Exception
	{
		response.setCharacterEncoding("UTF-8");

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			URL url = new URL(referer);
			String host = url.getHost();

			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
				
				String userAdmYn = commonSessionVO.getUser_admin_yn();

				if("".equals(userId) == false)
				{
					// 파일 저장
					String groupNo = file_grp;							// 파일 업로드된 경우
					if(file_grp != null && "".equals(file_grp) == true)	// 화면 캡쳐된 경우
					{
						String[] data = image.split(",");
						String ext = data[0].split(";")[0].split("/")[1];

						GregorianCalendar today = new GregorianCalendar();
						int year  = today.get (Calendar.YEAR );
						int month = today.get (Calendar.MONTH ) + 1;

		    	    	String fileName = KeyGenerateUtil.shuffleStringAlphanumeric(10);
		    	    	String saveName = UUID.randomUUID().toString() + "." + ext;
		    	    	String savePath = FileServiceImpl.FOLDER_FORMAT.format(new Object[]{String.valueOf(year), String.valueOf(month)}) + File.separator;
		    	    	String writePath = RequestMappingConstants.TOMCAT_PATH + RequestMappingConstants.UPLOAD_FOLDER + savePath + saveName;

		    	    	File file = new File(writePath);
		    	    	ImageUtils.decode(image, file);

		    	    	// 파일 등록
		    	    	HashMap<String, Object> map = new HashMap<String, Object>();
		    	    	map.put("KEY", 		 RequestMappingConstants.KEY);
		    	    	map.put("INS_USER",  userId);

		    	    	map.put("FPREFIX",   "FNO");
		    	    	map.put("GPREFIX",   "GNO");
		    	    	map.put("FILE_IDX",  1);
		    	    	map.put("FILE_NAME", fileName);
		    	    	map.put("FILE_EXT" , ext);
		    	    	map.put("SAVE_NAME", saveName);
		    	    	map.put("SAVE_PATH", savePath);

	    	    		map.put("FILE_GRP",  "N");

						groupNo = themeService.insertFile(map);
						groupNo = groupNo.replace((String)map.get("FPREFIX"), (String)map.get("GPREFIX"));
					}

				   	 컨텐츠 등록 
    	    		List<Map<String, Object>> layerList = mapper.readValue(layers, List.class);

				   	HashMap<String, Object> query = new HashMap<String, Object>();
				   	query.put("KEY", RequestMappingConstants.KEY);
				   	query.put("PREFIX", "TNO");
				   	query.put("INS_USER", userId);
				   	query.put("TITLE", title);
				   	query.put("FILE_GRP", groupNo);
				   	query.put("OTHBC_YN", othbc_yn);
				   	query.put("LAYERS", layerList);
				   	query.put("THEME_NO", themeService.insertThemeInfo(query));
				   	query.put("LAYER_INFO", (layerList != null && layerList.size() > 0 ? themeService.insertThemeLayerMapng(query) : ""));

				   	ModelAndView modelAndView = new ModelAndView();
				   	modelAndView.addObject("fileInfo", groupNo);
				   	modelAndView.addObject("themeInfo", query.get("THEME_NO"));
				   	modelAndView.addObject("layerInfo", query.get("LAYER_INFO"));
				   	modelAndView.addObject("result", "Y");
				   	modelAndView.setViewName("jsonView");

				   	 이력 
				   	try
					{
				       	HashMap<String, Object> param = new HashMap<String, Object>();
				       	param.put("KEY", RequestMappingConstants.KEY);
				       	param.put("PREFIX", "LOG");
				       	param.put("USER_ID", userId);
				       	param.put("PROGRM_URL", request.getRequestURI());

			   			 프로그램 사용 이력 등록 
						logsService.insertUserProgrmLogs(param);
					}
					catch (Exception e)
					{
						logger.error("이력 등록 실패" + e.getMessage());
					}

				   	return modelAndView;
				}
				else
				{
					jsHelper.Alert("권한이 없습니다.\\n\\n관리자에게 문의하시길 바랍니다.");
					jsHelper.RedirectUrl(invalidUrl);
				}
			}
			else
			{
				jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
				jsHelper.RedirectUrl(invalidUrl);
			}
		}
		else
		{
			jsHelper.Alert("비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			jsHelper.RedirectUrl(invalidUrl);
		}

		return null;
	}
*/
}
