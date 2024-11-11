package egovframework.zaol.dash.service.impl;

import java.util.List;
import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.zaol.dash.service.DashService1;
import egovframework.zaol.dash.service.DashVO;
import egovframework.zaol.home.service.HomeService;
import egovframework.zaol.home.service.HomeVO;
import org.apache.commons.codec.binary.Base64;

@Service("dashService1")
public class DashServiceImpl1 extends AbstractServiceImpl implements DashService1 {

    @Resource(name="dashDAO1")
    private DashDAO1 dashDAO;
    
    public List     dashBoard_List (DashVO vo) throws Exception { return dashDAO.dashBoard_List (vo); }

    public List     dashBoard_data1 (DashVO vo) throws Exception { return dashDAO.dashBoard_data1 (vo); }
    public List     dashBoard_data2 (DashVO vo) throws Exception { return dashDAO.dashBoard_data2 (vo); }
    public List     dashBoard_data3 (DashVO vo) throws Exception { return dashDAO.dashBoard_data3 (vo); }
    public List     dashBoard_data4 (DashVO vo) throws Exception { return dashDAO.dashBoard_data4 (vo); }



    
    
}
