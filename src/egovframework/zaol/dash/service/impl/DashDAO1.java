package egovframework.zaol.dash.service.impl;

import java.util.List;
import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;
import egovframework.zaol.dash.service.DashVO;
import egovframework.zaol.home.service.HomeVO;

@Repository("dashDAO1")
public class DashDAO1 extends OracleDAO {

	
    public List   dashBoard_List  (DashVO vo) throws Exception { return list("dashDAO.dashBoard_List", vo); }
    
    public List   dashBoard_data1 (DashVO vo) throws Exception { return list("dashDAO.dashBoard_data1", vo); }
    public List   dashBoard_data2 (DashVO vo) throws Exception { return list("dashDAO.dashBoard_data2", vo); }
    public List   dashBoard_data3 (DashVO vo) throws Exception { return list("dashDAO.dashBoard_data3", vo); }
    public List   dashBoard_data4 (DashVO vo) throws Exception { return list("dashDAO.dashBoard_data4", vo); }
    
    
}
