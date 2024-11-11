package egovframework.syesd.admin.code.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

//import com.sun.org.apache.bcel.internal.generic.Select;

import egovframework.zaol.common.OracleDAO;

@Repository("adminCodeDAO")
public class AdminCodeDAO  extends OracleDAO {
	
	public List selectCodeGroupList(HashMap vo) throws SQLException { return list("admin.code.selectCodeGroupList" , vo); }
	public List selectCodeListByGroupId(String vo) throws SQLException {return list("admin.code.selectCodeListByGroupId" , vo); }
	public void updateCode(HashMap vo) throws SQLException {
		String nullcheck = (String) selectByPk("admin.code.ordervaluecheck" , vo);
		if(nullcheck != null) {
			update("admin.code.codeeditupd" , vo); 
		}
		
		update("admin.code.updateCode" , vo);   
	}
	public String topcodesearch() throws SQLException {return (String)selectByPk("admin.code.topcodesearch" , null); }
	public int ordersearch(HashMap vo) throws SQLException { return (int) selectByPk("admin.code.ordersearch" , vo); }
	public List p_code_search(HashMap vo) throws SQLException { return list("admin.code.pcodesearch" , vo); }
	public void orderAdd(HashMap vo) throws SQLException{ 
		String nullcheck = (String) selectByPk("admin.code.ordervaluecheck" , vo);
		
		if(nullcheck != null) {
			update("admin.code.codeaddupd",vo); 
		}
		insert("admin.code.codeadd",vo);
	}
	public List editcodeorder(HashMap vo) throws SQLException { return list("admin.code.editcodeorder" , vo);  }
	public int maxorder(HashMap vo) throws SQLException { return (int) selectByPk("admin.code.maxorder" , vo);  }
	public void codeorderedit(HashMap vo) throws SQLException {
		String nullcheck = (String) selectByPk("admin.code.ordervaluecheck" , vo);
		
		if(nullcheck != null) {
			update("admin.code.codeorderedit" , vo); 
		}else {
			update("admin.code.codeeditupdminuse" , vo); 
		}
		
		update("admin.code.updateCode" , vo);   
		}
	public void codeDelete(HashMap vo) throws SQLException { update("admin.code.codeDelete" , vo);  }
}
	
