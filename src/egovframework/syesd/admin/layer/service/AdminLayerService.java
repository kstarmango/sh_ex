package egovframework.syesd.admin.layer.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface AdminLayerService {

	/* 레이어 권한 관리 */
	public List selectLayerAuthList(HashMap vo) throws SQLException;
	public List selectLayerAuthPagingList(HashMap vo) throws SQLException;
	public int selectLayerAuthPagingListCount(HashMap vo) throws SQLException;
	public int updateLayerAuth(HashMap vo) throws SQLException;
	public String insertLayerAuth(HashMap vo) throws SQLException;

	public List selectLayerListByAuthNo(HashMap vo) throws SQLException;
	public int insertLayerListByAuthNo(HashMap vo) throws SQLException;

	
	/* 레이어 관리 */
	public List selectLayerList(HashMap vo) throws SQLException;
	public List selectLayerGroupList(HashMap vo) throws SQLException;
	public List selectMapngList(HashMap vo) throws SQLException;
	public List selectServerList(HashMap vo) throws SQLException;

	public int updateLayerInfoByNo(HashMap vo) throws SQLException;
	public int updateLayerInfographicByNo(HashMap vo) throws SQLException;
	public int updateLayerGroupInfoByNo(HashMap vo) throws SQLException;

	public Map selectLayerDesc(HashMap vo) throws SQLException;
	public String insertLayerDesc(HashMap vo) throws SQLException;
	public int insertLayerDescByNo(HashMap vo) throws SQLException;

	public String insertServer(HashMap vo) throws SQLException;
	public int insertServerByNo(HashMap vo) throws SQLException;
	
	public void delete_File(HashMap vo) throws SQLException;
	public void layeradd(HashMap vo) throws SQLException;
	public List layerTypeSet(HashMap vo) throws SQLException;
	
	public void layerDel(HashMap vo) throws SQLException;
	public String maxLayerGroupNo(HashMap vo) throws SQLException;
	public List layerGroupOrderList(HashMap vo) throws SQLException;
	
	
	/* 레이어-그룹 매핑 관리 */
	public List MapngLayerList(HashMap vo) throws SQLException;
	public List NonMapngLayerList() throws SQLException;
	//public List MapngLayerAdd(HashMap vo) throws Exception;
	public void updateLayerInfo(HashMap vo) throws SQLException;
	public int checkLayerExists(HashMap vo) throws SQLException;
	public void updateLayer(HashMap vo) throws SQLException;
	public String insertLayer(HashMap vo) throws SQLException;
	public void MapngLayerDel(HashMap vo) throws SQLException;
	
	
	
	
	
	

}
