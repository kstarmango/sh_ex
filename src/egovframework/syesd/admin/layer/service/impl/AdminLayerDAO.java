package egovframework.syesd.admin.layer.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

//import com.sun.org.apache.bcel.internal.generic.Select;

import egovframework.zaol.common.OracleDAO;

@Repository("adminLayerDAO")
public class AdminLayerDAO  extends OracleDAO {

	public List selectLayerAuthList(HashMap vo) throws SQLException { return list("admin.layer.selectLayerAuthList" , vo); }
	public List selectLayerAuthPagingList(HashMap vo) throws SQLException { return list("admin.layer.selectLayerAuthPagingList" , vo); }
	public int selectLayerAuthPagingListCount(HashMap vo) throws SQLException { return (Integer)selectByPk("admin.layer.selectLayerAuthPagingListCount" , vo); }

	public int updateLayerAuth(HashMap vo) throws SQLException { return (Integer)update("admin.layer.updateLayerAuth" , vo); }
	public String insertLayerAuth(HashMap vo) throws SQLException { return (String)insert("admin.layer.insertLayerAuth" , vo); }

	public List selectLayerListByAuthNo(HashMap vo) throws SQLException { return list("admin.layer.selectLayerListByAuthNo" , vo); }
	public int insertLayerListByAuthNo(HashMap vo) throws SQLException { return (Integer)update("admin.layer.insertLayerListByAuthNo" , vo); }
	public int deleteLayerListByAuthNo(HashMap vo) throws SQLException { return (Integer)delete("admin.layer.deleteLayerListByAuthNo" , vo); }
	public String insertLayerListBackupByAuthNo(HashMap vo) throws SQLException { return (String)insert("admin.layer.insertLayerListBackupByAuthNo" , vo); }

	public List selectLayerList(HashMap vo) throws SQLException { return list("admin.layer.selectLayerList" , vo); }
	public List selectLayerGroupList(HashMap vo) throws SQLException { return list("admin.layer.selectLayerGroupList" , vo); }
	public List selectMapngList(HashMap vo) throws SQLException { return list("admin.layer.selectMapngList" , vo); }
	public List selectServerList(HashMap vo) throws SQLException { return list("admin.layer.selectServerList" , vo); }


	public int updateLayerInfoByNo(HashMap vo) throws SQLException { return (Integer)update("admin.layer.updateLayerInfoByNo" , vo); }
	public int updateLayerInfographicByNo(HashMap vo) throws SQLException { return (Integer)update("admin.layer.updateLayerInfographicByNo" , vo); }
	public int updateLayerGroupInfoByNo(HashMap vo) throws SQLException { return (Integer)update("admin.layer.updateLayerGroupInfoByNo" , vo); }
	public String insertLayerBackupByNo(HashMap vo) throws SQLException { return (String)insert("admin.layer.insertLayerBackupByNo" , vo); }

	public Map selectLayerDesc(HashMap vo) throws SQLException { return (Map)selectByPk("admin.layer.selectLayerDesc" , vo); }
	public String insertLayerDesc(HashMap vo) throws SQLException { return (String)insert("admin.layer.insertLayerDesc" , vo); }
	public int insertLayerDescByNo(HashMap vo) throws SQLException { return (Integer)update("admin.layer.insertLayerDescByNo" , vo); }
	public int deleteLayerDescByNo(HashMap vo) throws SQLException { return (Integer)delete("admin.layer.deleteLayerDescByNo" , vo); }
	public String insertLayerDescBackupByNo(HashMap vo) throws SQLException { return (String)insert("admin.layer.insertLayerDescBackupByNo" , vo); }


	public String insertServer(HashMap vo) throws SQLException { return (String)insert("admin.layer.insertServer" , vo); }
	public int insertServerByNo(HashMap vo) throws SQLException { return (Integer)update("admin.layer.insertServerByNo" , vo); }
	public int deleteServerByNo(HashMap vo) throws SQLException { return (Integer)delete("admin.layer.deleteServerByNo" , vo); }
	public int updateServerByNo(HashMap vo) throws SQLException { return (Integer)delete("admin.layer.updateServerByNo" , vo); }
	public String insertServerBackupByNo(HashMap vo) throws SQLException { return (String)insert("admin.layer.insertServerBackupByNo" , vo); }
	
	public void deleteFile(HashMap vo) throws SQLException {delete("admin.layer.filedelete",vo);}
	public void layeradd(HashMap vo) throws SQLException {insert("admin.layer.layeradd",vo);}
	
	public List layerTypeSet(HashMap vo) throws SQLException { return list("admin.layer.layerTypeSet" , vo); }
	
	public void layerDel(HashMap vo) throws SQLException {delete("admin.layer.layerdel",vo);}
	
	public String maxLayerGroupNo(HashMap vo) throws SQLException { return (String) selectByPk("admin.layer.maxLayerGroupNo", vo); }
	
	public List layerGroupOrderList(HashMap vo) throws SQLException { return list("admin.layer.layerGroupOrderList" , vo); }
	
	/* 레이어-그룹 매핑 관리 */
	public List MapngLayerList(HashMap vo) throws SQLException { return list("admin.layer.MapngLayerList" , vo); }
	public List NonMapngLayerList() throws SQLException { return list("admin.layer.NonMapngLayerList" , null); }
	
	//public List MapngLayerAdd(HashMap vo) throws Exception { return list("admin.layer.MapngLayerAdd" , vo); }
	public void updateLayerInfo(HashMap vo) throws SQLException { update("admin.layer.updateLayerInfo" , vo); }
	public int checkLayerExists(HashMap vo) throws SQLException { return (Integer)selectByPk("admin.layer.checkLayerExists" , vo); }
	public void updateLayer(HashMap vo) throws SQLException { update("admin.layer.updateLayer" , vo); }
	public String insertLayer(HashMap vo) throws SQLException { return (String)insert("admin.layer.insertLayer" , vo); }
	
	public void MapngLayerDel(HashMap vo) throws SQLException { update("admin.layer.MapngLayerDel" , vo); }
	

}
