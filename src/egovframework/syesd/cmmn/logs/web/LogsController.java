package egovframework.syesd.cmmn.logs.web;

import java.io.IOException;
import java.sql.SQLException;

/**
 * 사용자 컨트롤러 클래스
 *
 * @author  유창범
 * @since   2020.07.22
 * @version 1.0
 * @see
 * <pre>
 *   == 개정이력(Modification Information) ==
 *
 *         수정일                        수정자                                수정내용
 *   ----------------    ------------    ---------------------------
 *   2020.07.22          유창범                           최초 생성
 *
 * </pre>
 */

import java.util.HashMap;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.syesd.cmmn.logs.service.LogsService;
import egovframework.zaol.common.service.CommonSessionVO;
import egovframework.zaol.common.web.BaseController;

@Controller
public class LogsController extends BaseController  {

	private static Logger logger = LogManager.getLogger(LogsController.class);

	private ObjectMapper mapper;

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "logsService")
	private LogsService logsService;

    @PostConstruct
	public void initIt() throws SQLException {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}

	// API LOGS - 메뉴 이용 기록
    @RequestMapping(value = RequestMappingConstants.API_LOG_PROGRM,
					method = RequestMethod.POST)
	public ModelAndView useHistProgrm(HttpServletRequest request,
							   		 	HttpServletResponse response,
								   		@RequestParam(value="progrm_url", required=true) String progrm_url) throws SQLException
	{
		response.setCharacterEncoding("UTF-8");

		ModelAndView modelAndView = new ModelAndView();

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
				String userId = commonSessionVO.getUser_id();

		    	HashMap<String, Object> query = new HashMap<String, Object>();
		    	query.put("KEY", RequestMappingConstants.KEY);
		    	query.put("USER_ID", userId);
		    	query.put("PREFIX", "LOG");
		    	query.put("PROGRM_URL", progrm_url);

				modelAndView.addObject("logInfo", logsService.insertUserProgrmLogs(query));
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");
			}
			else
			{
		    	try {
					jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
				} catch (IOException e) {
					// TODO Auto-generated catch block
					logger.info("에러입니다.");
				}
		    }
		}
		else
		{
			modelAndView.addObject("logInfo", "비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			modelAndView.addObject("result", "N");
			modelAndView.setViewName("jsonView");
		}

    	return modelAndView;
	}

	// API LOGS - 레이어 이용 기록
    @RequestMapping(value = RequestMappingConstants.API_LOG_LAYER,
					method = RequestMethod.POST)
	public ModelAndView useHistLayer(HttpServletRequest request,
							   		   HttpServletResponse response,
								   	   @RequestParam(value="layer_no", required=true) String layerNo) throws SQLException, NullPointerException, IOException
	{
    	logger.info("useLayer 레이어 이용기록!!>>>>>>"+request.getSession().getId());
		response.setCharacterEncoding("UTF-8");

		ModelAndView modelAndView = new ModelAndView();

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
				String userId = commonSessionVO.getUser_id();

				HashMap<String, Object> query = new HashMap<String, Object>();
		    	query.put("KEY", RequestMappingConstants.KEY);
		    	query.put("USER_ID", userId);
		    	query.put("PREFIX", "LOG");
		    	query.put("LAYER_NO", layerNo);

				modelAndView.addObject("logInfo", logsService.insertUserLayerLogs(query));
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");
			}
			else
			{
				jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    }

		}
		else
		{
			modelAndView.addObject("logInfo", "비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			modelAndView.addObject("result", "N");
			modelAndView.setViewName("jsonView");
		}

    	return modelAndView;
	}

	// API LOGS - 데이터 이용 기록
    @RequestMapping(value = RequestMappingConstants.API_LOG_DATA,
					method = RequestMethod.POST)
	public ModelAndView useHistData(HttpServletRequest request,
						   		  HttpServletResponse response,
							   	  @RequestParam(value="layer_no", required=true) String layerNo) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");

		ModelAndView modelAndView = new ModelAndView();

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
				String userId = commonSessionVO.getUser_id();

		    	HashMap<String, Object> query = new HashMap<String, Object>();
		    	query.put("KEY", RequestMappingConstants.KEY);
		    	query.put("USER_ID", userId);
		    	query.put("PREFIX", "LOG");
		    	query.put("LAYER_NO", layerNo);

				modelAndView.addObject("logInfo", logsService.insertUserDataLogs(query));
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");
			}
			else
			{
				jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    }
		}
		else
		{
			modelAndView.addObject("logInfo", "비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			modelAndView.addObject("result", "N");
			modelAndView.setViewName("jsonView");
		}

    	return modelAndView;
	}

	// API LOGS - 데이터 다운로드 기록
    @RequestMapping(value = RequestMappingConstants.API_LOG_DOWNLOAD,
					method = RequestMethod.POST)
	public ModelAndView useHistDownload(HttpServletRequest request,
						   		  HttpServletResponse response,
							   	  @RequestParam(value="layer_no", required=true) String layerNo) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");

		ModelAndView modelAndView = new ModelAndView();

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
				String userId = commonSessionVO.getUser_id();

		    	HashMap<String, Object> query = new HashMap<String, Object>();
		    	query.put("KEY", RequestMappingConstants.KEY);
		    	query.put("USER_ID", userId);
		    	query.put("PREFIX", "LOG");
		    	query.put("LAYER_NO", layerNo);

				modelAndView.addObject("logInfo", logsService.insertUserDownloadLogs(query));
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");
			}
			else
			{
				jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    }
		}
		else
		{
			modelAndView.addObject("logInfo", "비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			modelAndView.addObject("result", "N");
			modelAndView.setViewName("jsonView");
		}

    	return modelAndView;
	}

	// API LOGS - 코멘트 이용 기록
    @RequestMapping(value = RequestMappingConstants.API_LOG_COMMENT,
					method = RequestMethod.POST)
	public ModelAndView useHistCommnet(HttpServletRequest request,
							   		 	 HttpServletResponse response,
								   		 @RequestParam(value="TABLE_NM", required=true) String tableNm,
								   		 @RequestParam(value="COLUMN_NM", required=true) String columnNm,
								   		 @RequestParam(value="COMMENT", required=true) String comment) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");

		ModelAndView modelAndView = new ModelAndView();

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
				String userId = commonSessionVO.getUser_id();

		    	HashMap<String, Object> query = new HashMap<String, Object>();
		    	query.put("KEY", RequestMappingConstants.KEY);
		    	query.put("USER_ID", userId);
		    	query.put("PREFIX", "LOG");
		    	query.put("TRGET_TABLE_NM", tableNm);
		    	query.put("TRGET_COLUMN_NM", columnNm);
		    	query.put("COMMENT", comment);

				modelAndView.addObject("logInfo", logsService.insertUserCommentLogs(query));
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");
			}
			else
			{
				jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    }
		}
		else
		{
			modelAndView.addObject("logInfo", "비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			modelAndView.addObject("result", "N");
			modelAndView.setViewName("jsonView");
		}

		return modelAndView;
	}

	// API LOGS - 감사 이용 기록
    @RequestMapping(value = RequestMappingConstants.API_LOG_AUDIT,
					method = RequestMethod.POST)
	public ModelAndView useHistAudit(HttpServletRequest request,
							   		   HttpServletResponse response,
								   	   @RequestParam(value="audit_cd", required=true) String auditCd,
								   	   @RequestParam(value="target_user_id", required=true) String targetUserId) throws SQLException, NullPointerException, IOException
	{
		response.setCharacterEncoding("UTF-8");

		ModelAndView modelAndView = new ModelAndView();

		String referer = request.getHeader("referer");
		if(referer != null && "".equals(referer) == false)
		{
			HttpSession session = getSession();
			if(session != null)
			{
				CommonSessionVO commonSessionVO = (CommonSessionVO)session.getAttribute("SessionVO");
				String userId = commonSessionVO.getUser_id();

		    	HashMap<String, Object> query = new HashMap<String, Object>();
		    	query.put("KEY", RequestMappingConstants.KEY);
		    	query.put("USER_ID", userId);
		    	query.put("PREFIX", "LOG");
		    	query.put("AUDIT_CD", auditCd);
		    	query.put("TRGET_USER_ID", targetUserId);

				modelAndView.addObject("logInfo", logsService.insertUserAuditLogs(query));
				modelAndView.addObject("result", "Y");
				modelAndView.setViewName("jsonView");
			}
			else
			{
				jsHelper.Alert("세션이 만료되었습니다.\\n\\n로그인 후 이용해주세요.");
		    }
		}
		else
		{
			modelAndView.addObject("logInfo", "비정상 접근 입니다.\\n\\n관리자에게 문의하시길 바랍니다.");
			modelAndView.addObject("result", "N");
			modelAndView.setViewName("jsonView");
		}

		return modelAndView;
	}

}
