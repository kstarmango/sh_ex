package egovframework.zaol.common.web;

import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.zaol.common.CommonUtil;
import egovframework.zaol.common.DefaultSearchVO;
import egovframework.zaol.common.Globals;
import egovframework.zaol.common.service.CommonService;
import egovframework.zaol.gisinfo.service.GisinfoVO;
import egovframework.zaol.util.service.StringUtil;

@Controller
public class CommonController extends BaseController {

	/** service 구하기 */
	@Resource(name = "CommonService")
	private CommonService commonservice;

	

}