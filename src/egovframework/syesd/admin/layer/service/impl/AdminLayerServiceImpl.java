package egovframework.syesd.admin.layer.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.admin.layer.service.AdminLayerService;

@Service("adminLayerService")
public class AdminLayerServiceImpl  extends AbstractServiceImpl implements AdminLayerService {

	@Resource(name="adminLayerDAO")
	private AdminLayerDAO adminLayerDAO;

	public List selectLayerAuthList(HashMap vo) throws SQLException {
		return adminLayerDAO.selectLayerAuthList(vo);
	}

	public List selectLayerAuthPagingList(HashMap vo) throws SQLException {
		return adminLayerDAO.selectLayerAuthPagingList(vo);
	}

	public int selectLayerAuthPagingListCount(HashMap vo) throws SQLException {
		return adminLayerDAO.selectLayerAuthPagingListCount(vo);
	}

	public int updateLayerAuth(HashMap vo) throws SQLException {
		return adminLayerDAO.updateLayerAuth(vo);
	}

	public String insertLayerAuth(HashMap vo) throws SQLException {
		return adminLayerDAO.insertLayerAuth(vo);
	}

	public List selectLayerListByAuthNo(HashMap vo) throws SQLException {
		return adminLayerDAO.selectLayerListByAuthNo(vo);
	}

	public int insertLayerListByAuthNo(HashMap vo) throws SQLException {
		adminLayerDAO.insertLayerListBackupByAuthNo(vo);
		adminLayerDAO.deleteLayerListByAuthNo(vo);
		return adminLayerDAO.insertLayerListByAuthNo(vo);
	}


	public List selectLayerList(HashMap vo) throws SQLException {
		return adminLayerDAO.selectLayerList(vo);
	}

	public List selectLayerGroupList(HashMap vo) throws SQLException {
		return adminLayerDAO.selectLayerGroupList(vo);
	}

	public List selectMapngList(HashMap vo) throws SQLException {
		return adminLayerDAO.selectMapngList(vo);
	}

	public List selectServerList(HashMap vo) throws SQLException {
		return adminLayerDAO.selectServerList(vo);
	}


	public int updateLayerInfoByNo(HashMap vo) throws SQLException {
		adminLayerDAO.insertLayerBackupByNo(vo);
		return adminLayerDAO.updateLayerInfoByNo(vo);
	}

	public int updateLayerInfographicByNo(HashMap vo) throws SQLException {
		adminLayerDAO.insertLayerBackupByNo(vo);
		return adminLayerDAO.updateLayerInfographicByNo(vo);
	}


	public Map selectLayerDesc(HashMap vo) throws SQLException {
		return adminLayerDAO.selectLayerDesc(vo);
	}

	public String insertLayerDesc(HashMap vo) throws SQLException {
		return adminLayerDAO.insertLayerDesc(vo);
	}

	public int insertLayerDescByNo(HashMap vo) throws SQLException {
		adminLayerDAO.insertLayerDescBackupByNo(vo);
		adminLayerDAO.deleteLayerDescByNo(vo);
		return adminLayerDAO.insertLayerDescByNo(vo);
	}


	public String insertServer(HashMap vo) throws SQLException {
		return adminLayerDAO.insertServer(vo);
	}

	public int insertServerByNo(HashMap vo) throws SQLException {
		//adminLayerDAO.insertServerBackupByNo(vo);
		//adminLayerDAO.deleteServerByNo(vo);
		//return adminLayerDAO.insertServerByNo(vo);

		adminLayerDAO.insertServerBackupByNo(vo);
		return adminLayerDAO.updateServerByNo(vo);
	}

	@Override
	public int updateLayerGroupInfoByNo(HashMap vo) throws SQLException {
		//adminLayerDAO.insertLayerBackupByNo(vo);
		return adminLayerDAO.updateLayerGroupInfoByNo(vo);
	}

	@Override
	public void delete_File(HashMap vo) throws SQLException {
		adminLayerDAO.deleteFile(vo);
	}

	@Override
	public void layeradd(HashMap vo) throws SQLException {
		adminLayerDAO.layeradd(vo);
		
	}

	@Override
	public List layerTypeSet(HashMap vo) throws SQLException {
		return adminLayerDAO.layerTypeSet(vo);
	}

	@Override
	public void layerDel(HashMap vo) throws SQLException {
		adminLayerDAO.layerDel(vo);
	}

	@Override
	public String maxLayerGroupNo(HashMap vo) throws SQLException {
		
		return adminLayerDAO.maxLayerGroupNo(vo);
	}

	@Override
	public List layerGroupOrderList(HashMap vo) throws SQLException {
		return adminLayerDAO.layerGroupOrderList(vo);
		
	}
	/* 레이어-그룹 매핑 관리 */
	public List MapngLayerList(HashMap vo) throws SQLException {
		return adminLayerDAO.MapngLayerList(vo);
	}
	
	public List NonMapngLayerList() throws SQLException {
		return adminLayerDAO.NonMapngLayerList();
	}
	
	/*public List MapngLayerAdd(HashMap vo) throws Exception {
		return adminLayerDAO.MapngLayerAdd(vo);
	}*/
	public void updateLayerInfo(HashMap vo) throws SQLException {
		adminLayerDAO.updateLayerInfo(vo);
	}
	
	public int checkLayerExists(HashMap vo) throws SQLException {
		return adminLayerDAO.checkLayerExists(vo);
	}
	
	public void updateLayer(HashMap vo) throws SQLException {
		adminLayerDAO.updateLayer(vo);
	}
	
	public String insertLayer(HashMap vo) throws SQLException {
		return adminLayerDAO.insertLayer(vo);
	}
	
	public void MapngLayerDel(HashMap vo) throws SQLException {
		adminLayerDAO.MapngLayerDel(vo);
	}
	

}
