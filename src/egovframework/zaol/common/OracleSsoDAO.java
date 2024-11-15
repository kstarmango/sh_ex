package egovframework.zaol.common;

import javax.annotation.Resource;

import com.ibatis.sqlmap.client.SqlMapClient;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

public class OracleSsoDAO  extends EgovAbstractDAO {

	/**
	 * Oracle sqlMapClient
	 */
    @Resource(name = "SqlMapClientORACLE")
    public void setSuperSqlMapClient(SqlMapClient sqlMapClient) {
        super.setSuperSqlMapClient(sqlMapClient);
    }
}