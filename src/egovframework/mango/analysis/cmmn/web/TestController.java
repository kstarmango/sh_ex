package egovframework.mango.analysis.cmmn.web;

import java.io.IOException;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import egovframework.mango.analysis.cmmn.service.AnalysisCmmnService;
import egovframework.syesd.cmmn.constants.RequestMappingConstants;
import egovframework.zaol.common.web.BaseController;

@Controller
public class TestController extends BaseController {

	private static Logger logger = LogManager.getLogger(AnalysisCmmnController.class);
	
	private ObjectMapper mapper;
	
	@Autowired
	private AnalysisCmmnService anCmmnService;
	
	@PostConstruct
	public void initIt() throws NullPointerException, Exception {
		mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	}
	

	@RequestMapping(value ="/stream", method = {RequestMethod.POST})
	public void streamJson(HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

//        DATAS;
//        JsonFactory jsonFactory = new JsonFactory();
//        try (JsonGenerator jsonGenerator = jsonFactory.createGenerator(response.getOutputStream())) {
//            ObjectMapper objectMapper = new ObjectMapper();
//            jsonGenerator.writeStartArray();
//            
//            for (DATA data : DATAS) {
//                objectMapper.writeValue(jsonGenerator, data);
//                jsonGenerator.flush(); // 데이터를 강제로 플러시하여 전송
//            }
//            
//            jsonGenerator.writeEndArray();
//        }
    }

	
        
	
}
