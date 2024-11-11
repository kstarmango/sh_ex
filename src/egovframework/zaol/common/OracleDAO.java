package egovframework.zaol.common;

import javax.annotation.Resource;


import com.ibatis.sqlmap.client.SqlMapClient;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

public class OracleDAO extends EgovAbstractDAO {

	/**
	 * Oracle sqlMapClient
	 */
    @Resource(name = "SqlMapClientPOSTGRESQL")
    public void setSuperSqlMapClient(SqlMapClient sqlMapClient) {
        super.setSuperSqlMapClient(sqlMapClient);
    }
    


}
