package egovframework.zaol.common.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.zaol.common.DefaultSearchVO;
import javax.servlet.http.HttpServletRequest;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface CommonService {

        
    public void saveFile(String pnu, String type, final MultipartHttpServletRequest multiRequest) throws Exception;
    
    public List selectUserShare(HashMap vo) throws SQLException; 

}