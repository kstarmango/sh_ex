package egovframework.zaol.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.AddressZipcodeVO;
import egovframework.zaol.common.DefaultSearchVO;
import egovframework.zaol.common.OracleDAO;
import egovframework.zaol.factual.service.FactualVO;

@Repository( "CommonDAO" )
public class CommonDAO extends OracleDAO {
    @SuppressWarnings("unchecked")
    
    public int  MaxFileGID      (FactualVO factualVO) throws Exception{ return (Integer)selectByPk("commonDAO.MaxFileGID"       , factualVO); } 
    public List fileList  (FactualVO factualVO) throws Exception { return list  ("commonDAO.fileList"  , factualVO   ); }
    
    public List selectUserShare(HashMap vo) throws SQLException { return list("commonDAO.selectUserShare" , vo); }
    
    
}