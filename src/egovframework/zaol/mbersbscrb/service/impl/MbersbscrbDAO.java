package egovframework.zaol.mbersbscrb.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;
import egovframework.zaol.common.OracleDAO;
import egovframework.zaol.mbersbscrb.service.MbersbscrbVO;

@Repository("mbersbscrbDAO")
public class MbersbscrbDAO extends OracleDAO {

	public MbersbscrbVO userIdDplctAjax01 (MbersbscrbVO mbersbscrbVO) throws Exception 
	{ 
		return (MbersbscrbVO)selectByPk("mbersbscrbDAO.userIdDplctAjax01", mbersbscrbVO); 
	}
	
	public void userInfoInsert  (MbersbscrbVO mbersbscrbVO) throws Exception 
	{ 
		insert ("mbersbscrbDAO.userInfoInsert", mbersbscrbVO);
	}
	
	public List selectUserIdList (MbersbscrbVO mbersbscrbVO) throws Exception 
	{ 
		return list("mbersbscrbDAO.selectUserIdList" , mbersbscrbVO); 
	}
	
	public void selectLoginOutHist (MbersbscrbVO mbersbscrbVO) throws Exception 
	{        
		insert   ("mbersbscrbDAO.selectLoginOutHist" , mbersbscrbVO); 
	}
}
