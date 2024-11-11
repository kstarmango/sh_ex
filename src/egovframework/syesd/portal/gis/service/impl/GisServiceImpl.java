package egovframework.syesd.portal.gis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.syesd.cmmn.menu.service.MenuService;
import egovframework.syesd.portal.dashboard.service.DashboardService;
import egovframework.syesd.portal.gis.service.GisService;
import egovframework.syesd.portal.theme.service.ThemeService;

@Service("gisService")
public final class GisServiceImpl extends AbstractServiceImpl implements GisService {

	@Resource(name="gisDAO")
	private GisDAO gisDAO;

	/* 용지 */
	@Override
	public List selectBuildLandSiteDataList(Map vo) throws SQLException {
		return gisDAO.selectBuildLandSiteDataList(vo);
	}
	@Override
	public List selectSiteBsnsNm() throws SQLException {
		return gisDAO.selectSiteBsnsNm();
	}
	@Override
	public List selectSitePrposNm() throws SQLException {
		return gisDAO.selectSitePrposNm();
	}
	@Override
	public List selectSiteSttus() throws SQLException {
		return gisDAO.selectSiteSttus();
	}
	@Override
	public List selectSiteSpfc() throws SQLException {
		return gisDAO.selectSiteSpfc();
	}
	@Override
	public List selectSiteLndcgr() throws SQLException {
		return gisDAO.selectSiteLndcgr();
	}

	/* 인허가 */
	@Override
	public List selectBuildLandLicensList(Map vo) throws SQLException {
		return gisDAO.selectBuildLandLicensList(vo);
	}
	@Override
	public List selectLicensBsnsNm() throws SQLException {
		return gisDAO.selectLicensBsnsNm();
	}
	@Override
	public List selectLicensSuplyTy() throws SQLException {
		return gisDAO.selectLicensSuplyTy();
	}
	@Override
	public List selectLicensPrpos() throws SQLException {
		return gisDAO.selectLicensPrpos();
	}

	/* 미매각지 */
	@Override
	public List selectBuildLandUnSalePaprList(Map vo) throws SQLException {
		return gisDAO.selectBuildLandUnSalePaprList(vo);
	}
	@Override
	public List selectUnSalePaprDstrcNm() throws SQLException {
		return gisDAO.selectUnSalePaprDstrcNm();
	}
	@Override
	public List selectUnSalePaprSleMth() throws SQLException {
		return gisDAO.selectUnSalePaprSleMth();
	}
	@Override
	public List selectUnSalePaprPcStdr() throws SQLException {
		return gisDAO.selectUnSalePaprPcStdr();
	}
	@Override
	public List selectUnSalePaprSuplyTrgetStdr() throws SQLException {
		return gisDAO.selectUnSalePaprSuplyTrgetStdr();
	}
	@Override
	public List selectUnSalePaprSpfc() throws SQLException {
		return gisDAO.selectUnSalePaprSpfc();
	}

	/* 잔여지 */
	@Override
	public List selectBuildLandRemndrPaprList(Map vo) throws SQLException {
		return gisDAO.selectBuildLandRemndrPaprList(vo);
	}
	@Override
	public List selectRemndrPaprCmptncGu() throws SQLException {
		return gisDAO.selectRemndrPaprCmptncGu();
	}
	@Override
	public List selectRemndrPaprLndcgr() throws SQLException {
		return gisDAO.selectRemndrPaprLndcgr();
	}
	@Override
	public List selectRemndrPaprCmptncCnter() throws SQLException {
		return gisDAO.selectRemndrPaprCmptncCnter();
	}

	/* 임대 아파트 */
	@Override
	public List selectRentalAptList(Map vo) throws SQLException {
		return gisDAO.selectRentalAptList(vo);
	}
	@Override
	public List selectRentAptHsmpNm() throws SQLException {
		return gisDAO.selectRentAptHsmpNm();
	}
	@Override
	public List selectRentAptRentTy(Map vo) throws SQLException {
		return gisDAO.selectRentAptRentTy(vo);
	}
	@Override
	public List selectRentAptRentSe() throws SQLException {
		return gisDAO.selectRentAptRentSe();
	}
	@Override
	public List selectRentAptSe() throws SQLException {
		return gisDAO.selectRentAptSe();
	}
	@Override
	public List selectRentAptAtdrc() throws SQLException {
		return gisDAO.selectRentAptAtdrc();
	}
	@Override
	public List selectRentAptCnter() throws SQLException {
		return gisDAO.selectRentAptCnter();
	}

	/* 임대 다가구 */
	@Override
	public List selectRentalMltdwlList(Map vo) throws SQLException {
		return gisDAO.selectRentalMltdwlList(vo);
	}
	@Override
	public List selectMltdwBsnsNm() throws SQLException {
		return gisDAO.selectMltdwBsnsNm();
	}
	@Override
	public List selectMltdwlBsnsCode() throws SQLException {
		return gisDAO.selectMltdwlBsnsCode();
	}
	@Override
	public List selectMltdwlDong() throws SQLException {
		return gisDAO.selectMltdwlDong();
	}
	@Override
	public List selectMltdwlAtdrc() throws SQLException {
		return gisDAO.selectMltdwlAtdrc();
	}
	@Override
	public List selectMltdwlCnter() throws SQLException {
		return gisDAO.selectMltdwlCnter();
	}
	@Override
	public List selectMltdwlBuldStrct() throws SQLException {
		return gisDAO.selectMltdwlBuldStrct();
	}

	/* 임대 도시형 */
	@Override
	public List selectRentalCityLvlhList(Map vo) throws SQLException {
		return gisDAO.selectRentalCityLvlhList(vo);
	}
	@Override
	public List selectCityLvlhBsnsNm() throws SQLException {
		return gisDAO.selectCityLvlhBsnsNm();
	}
	@Override
	public List selectCityLvlhBsnsCode() throws SQLException {
		return gisDAO.selectCityLvlhBsnsCode();
	}
	@Override
	public List selectCityLvlhDong() throws SQLException {
		return gisDAO.selectCityLvlhDong();
	}
	@Override
	public List selectCityLvlhAtdrc() throws SQLException {
		return gisDAO.selectCityLvlhAtdrc();
	}
	@Override
	public List selectCityLvlhCnter() throws SQLException {
		return gisDAO.selectCityLvlhCnter();
	}

	/* 임대 전세임대 */
	@Override
	public List selectRentalLfstsRentList(Map vo) throws SQLException {
		return gisDAO.selectRentalLfstsRentList(vo);
	}
	@Override
	public List selectLfstsBsnsCode() throws SQLException {
		return gisDAO.selectLfstsBsnsCode();
	}
	@Override
	public List selectLfstsDong() throws SQLException {
		return gisDAO.selectLfstsDong();
	}
	@Override
	public List selectLfstsAtdrc() throws SQLException {
		return gisDAO.selectLfstsAtdrc();
	}
	@Override
	public List selectLfstsCnter() throws SQLException {
		return gisDAO.selectLfstsCnter();
	}

	/* 임대 장기안심 */
	@Override
	public List selectRentalLngtrSafetyList(Map vo) throws SQLException {
		return gisDAO.selectRentalLngtrSafetyList(vo);
	}
	public List selectLngtrSafetyBsnsCode() throws SQLException {
		return gisDAO.selectLngtrSafetyBsnsCode();
	}
	public List selectLngtrSafetyDong() throws SQLException {
		return gisDAO.selectLngtrSafetyDong();
	}
	public List selectLngtrSafetyAtdrc() throws SQLException {
		return gisDAO.selectLngtrSafetyAtdrc();
	}
	public List selectLngtrSafetyCnter() throws SQLException {
		return gisDAO.selectLngtrSafetyCnter();
	}

	/*  사업명 조회 */
	public String selectBsnsNmByCode(Map vo) throws SQLException {
		return gisDAO.selectBsnsNmByCode(vo);
	}

	/* K 아파트 */
	@Override
	public List selectRentalAptkList(Map vo) throws SQLException {
		return gisDAO.selectRentalAptkList(vo);
	}

	/* 동호 목록 조회 */
	public List selectRentalDongHoList(Map vo) throws SQLException {
		return gisDAO.selectRentalDongHoList(vo);
	}

	public List selectRentalAptDongHoList(Map vo) throws SQLException {
		return gisDAO.selectRentalAptDongHoList(vo);
	}
	public List selectRentalMltdwlDongHoList(Map vo) throws SQLException {
		return gisDAO.selectRentalMltdwlDongHoList(vo);
	}
	public List selectRentalCtyLvlhDongHoList(Map vo) throws SQLException {
		return gisDAO.selectRentalCtyLvlhDongHoList(vo);
	}


	/* 임대 통계 */
	@Override
	public Map selectRentalAptStat() throws SQLException {
		return gisDAO.selectRentalAptStat();
	}
	@Override
	public Map selectRentalMltdwlStat() throws SQLException {
		return gisDAO.selectRentalMltdwlStat();
	}
	@Override
	public Map selectRentalCityLvlhStat() throws SQLException {
		return gisDAO.selectRentalCityLvlhStat();
	}
	@Override
	public Map selectRentalLfstsRentStat() throws SQLException {
		return gisDAO.selectRentalLfstsRentStat();
	}
	@Override
	public Map selectRentalLngtrSafetyStat() throws SQLException {
		return gisDAO.selectRentalLngtrSafetyStat();
	}

	/* 자산 아파트 */
	@Override
	public List selectAssetApt(Map vo) throws SQLException {
		return gisDAO.selectAssetApt(vo);
	}
	@Override
	public List selectAssetAptAssetsClass() throws SQLException{
		return gisDAO.selectAssetAptAssetsClass();
	}
	@Override
	public List selectAssetAptPrdlstClass(Map vo) throws SQLException{
		return gisDAO.selectAssetAptPrdlstClass(vo);
	}
	@Override
	public List selectAssetAptBsnsCode() throws SQLException{
		return gisDAO.selectAssetAptBsnsCode();
	}
	@Override
	public List selectAssetAptStndrd() throws SQLException{
		return gisDAO.selectAssetAptStndrd();
	}
	@Override
	public List selectAssetAptAssetsChange() throws SQLException{
		return gisDAO.selectAssetAptAssetsChange();
	}
	@Override
	public List selectAssetAptChangeDcsn() throws SQLException{
		return gisDAO.selectAssetAptChangeDcsn();
	}
	@Override
	public List selectAssetAptAcqsDe() throws SQLException{
		return gisDAO.selectAssetAptAcqsDe();
	}

	/* 자산 다가구 */
	@Override
	public List selectAssetMltdwl(Map vo) throws SQLException {
		return gisDAO.selectAssetMltdwl(vo);
	}
	@Override
	public List selectAssetMltdwlAssetsClass() throws SQLException{
		return gisDAO.selectAssetMltdwlAssetsClass();
	}
	@Override
	public List selectAssetMltdwlPrdlstClass(Map vo) throws SQLException{
		return gisDAO.selectAssetMltdwlPrdlstClass(vo);
	}
	@Override
	public List selectAssetMltdwlBsnsCode() throws SQLException{
		return gisDAO.selectAssetMltdwlBsnsCode();
	}
	@Override
	public List selectAssetMltdwlStndrd() throws SQLException{
		return gisDAO.selectAssetMltdwlStndrd();
	}
	@Override
	public List selectAssetMltdwlAssetsChange() throws SQLException{
		return gisDAO.selectAssetMltdwlAssetsChange();
	}
	@Override
	public List selectAssetMltdwlChangeDcsn() throws SQLException{
		return gisDAO.selectAssetMltdwlChangeDcsn();
	}
	@Override
	public List selectAssetMltdwlAcqsDe() throws SQLException{
		return gisDAO.selectAssetMltdwlAcqsDe();
	}
	
	/* 자산 기타 */
	@Override
	public List selectAssetEtc(Map vo) throws SQLException {
		return gisDAO.selectAssetEtc(vo);
	}
	@Override
	public List selectAssetEtcAssetsClass() throws SQLException{
		return gisDAO.selectAssetEtcAssetsClass();
	}
	@Override
	public List selectAssetEtcPrdlstClass(Map vo) throws SQLException{
		return gisDAO.selectAssetEtcPrdlstClass(vo);
	}
	@Override
	public List selectAssetEtcBsnsCode() throws SQLException{
		return gisDAO.selectAssetEtcBsnsCode();
	}
	@Override
	public List selectAssetEtcStndrd() throws SQLException{
		return gisDAO.selectAssetEtcStndrd();
	}
	@Override
	public List selectAssetEtcAssetsChange() throws SQLException{
		return gisDAO.selectAssetEtcAssetsChange();
	}
	@Override
	public List selectAssetEtcChangeDcsn() throws SQLException{
		return gisDAO.selectAssetEtcChangeDcsn();
	}
	@Override
	public List selectAssetEtcAcqsDe() throws SQLException{
		return gisDAO.selectAssetEtcAcqsDe();
	}
	/////

	@Override
	public List selectTableBuildLandSiteGeometry(Map vo) throws SQLException {
		return gisDAO.selectTableBuildLandSiteGeometry(vo);
	}
	@Override
	public List selectTableBuildLandLicensGeometry(Map vo) throws SQLException {
		return gisDAO.selectTableBuildLandLicensGeometry(vo);
	}
	@Override
	public List selectTableBuildLandUnSalePaprGeometry(Map vo) throws SQLException {
		return gisDAO.selectTableBuildLandUnSalePaprGeometry(vo);
	}
	@Override
	public List selectTableBuildLandRemndrPaprGeometry(Map vo) throws SQLException {
		return gisDAO.selectTableBuildLandRemndrPaprGeometry(vo);
	}
	@Override
	public List selectTableRentalAptGeometry(Map vo) throws SQLException {
		return gisDAO.selectTableRentalAptGeometry(vo);
	}
	@Override
	public List selectTableRentalMltdwlGeometry(Map vo) throws SQLException {
		return gisDAO.selectTableRentalMltdwlGeometry(vo);
	}
	@Override
	public List selectTableRentalCtyLvlhGeometry(Map vo) throws SQLException {
		return gisDAO.selectTableRentalCtyLvlhGeometry(vo);
	}
	@Override
	public List selectTableRentalLfstsGeometry(Map vo) throws SQLException {
		return gisDAO.selectTableRentalLfstsGeometry(vo);
	}
	@Override
	public List selectTableRentalLngtrSafetyGeometry(Map vo) throws SQLException {
		return gisDAO.selectTableRentalLngtrSafetyGeometry(vo);
	}
	@Override
	public List selectTableAssetAptGeometry(Map vo) throws SQLException {
		return gisDAO.selectTableAssetAptGeometry(vo);
	}
	@Override
	public List selectTableAssetMltdwlGeometry(Map vo) throws SQLException {
		return gisDAO.selectTableAssetMltdwlGeometry(vo);
	}
	@Override
	public List selectTableAssetEtcGeometry(Map vo) throws SQLException {
		// TODO Auto-generated method stub
		return gisDAO.selectTableAssetEtcGeometry(vo);
	}


	@Override
	public Map selectLayerDesc(Map vo) throws SQLException {
		return gisDAO.selectLayerDesc(vo);
	}
	@Override
	public List selectLayerDescList(Map vo) throws SQLException {
		return gisDAO.selectLayerDescList(vo);
	}
	@Override
	public List selectLayerAuthList(Map vo) throws SQLException {
		return gisDAO.selectLayerAuthList(vo);
	}
	@Override
	public List selectExLayerAuthList(Map vo) throws SQLException {
		return gisDAO.selectExLayerAuthList(vo);
	}
	@Override
	public List selectLayerAdditionalByNo(Map vo) throws SQLException {
		return gisDAO.selectLayerAdditionalByNo(vo);
	}
	@Override
	public List selectLayerByApikey(Map vo) throws SQLException {
		return gisDAO.selectLayerByApikey(vo);
	}

	@Override
	public String selectTableAttrEditAuth(Map vo) throws SQLException {
		return gisDAO.selectTableAttrEditAuth(vo);
	}
	@Override
	public String selectTablePkColumn(Map vo) throws SQLException {
		return gisDAO.selectTablePkColumn(vo);
	}
	@Override
	public List selectColumnCommentList(Map vo) throws SQLException {
		return gisDAO.selectColumnCommentList(vo);
	}
	@Override
	public List selectCntcColumnCommentList(Map vo) throws SQLException {
		return gisDAO.selectCntcColumnCommentList(vo);
	}
	@Override
	public List selectViewColumnCommentList(Map vo) throws SQLException {
		return gisDAO.selectViewColumnCommentList(vo);
	}
	@Override
	public String selectTableGeomTypeInfo(Map vo)throws SQLException {
		return gisDAO.selectTableGeomTypeInfo(vo);
	}
	@Override
	public List selectGeocoingEpsgList() throws SQLException {
		return gisDAO.selectGeocoingEpsgList();
	}
	@Override
	public String selectGeocoingEpsgToProj4(Map vo) throws SQLException {
		return gisDAO.selectGeocoingEpsgToProj4(vo);
	}
	@Override
	public List selectShapeUploadEpsgList() throws SQLException {
		return gisDAO.selectShapeUploadEpsgList();
	}
	@Override
	public List selectLayerMyDataList(Map vo) throws SQLException {
		return gisDAO.selectLayerMyDataList(vo);
	}
	@Override
	public List selectLayerMyDataCommentList(Map vo) throws SQLException {
		return gisDAO.selectLayerMyDataCommentList(vo);
	}

}
