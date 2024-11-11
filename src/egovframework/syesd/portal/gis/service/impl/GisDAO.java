package egovframework.syesd.portal.gis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;

@Repository("gisDAO")
public final class GisDAO extends OracleDAO {

	public List selectBuildLandSiteDataList(Map vo) throws SQLException { return list("portal.gis.selectBuildLandSiteDataList", vo); }
	public List selectSiteBsnsNm() throws SQLException { return list("portal.gis.selectSiteBsnsNm", null); }
	public List selectSitePrposNm() throws SQLException { return list("portal.gis.selectSitePrposNm", null); }
	public List selectSiteSttus() throws SQLException { return list("portal.gis.selectSiteSttus", null); }
	public List selectSiteSpfc() throws SQLException { return list("portal.gis.selectSiteSpfc", null); }
	public List selectSiteLndcgr() throws SQLException { return list("portal.gis.selectSiteLndcgr", null); }

	public List selectBuildLandLicensList(Map vo) throws SQLException { return list("portal.gis.selectBuildLandLicensList", vo); }
	public List selectLicensBsnsNm() throws SQLException { return list("portal.gis.selectLicensBsnsNm", null); }
	public List selectLicensSuplyTy() throws SQLException { return list("portal.gis.selectLicensSuplyTy", null); }
	public List selectLicensPrpos() throws SQLException { return list("portal.gis.selectLicensPrpos", null); }

	public List selectBuildLandUnSalePaprList(Map vo) throws SQLException { return list("portal.gis.selectBuildLandUnSalePaprList", vo); }
	public List selectUnSalePaprDstrcNm() throws SQLException { return list("portal.gis.selectUnSalePaprDstrcNm", null); }
	public List selectUnSalePaprSleMth() throws SQLException { return list("portal.gis.selectUnSalePaprSleMth", null); }
	public List selectUnSalePaprPcStdr() throws SQLException { return list("portal.gis.selectUnSalePaprPcStdr", null); }
	public List selectUnSalePaprSuplyTrgetStdr() throws SQLException { return list("portal.gis.selectUnSalePaprSuplyTrgetStdr", null); }
	public List selectUnSalePaprSpfc() throws SQLException { return list("portal.gis.selectUnSalePaprSpfc", null); }

	public List selectBuildLandRemndrPaprList(Map vo) throws SQLException { return list("portal.gis.selectBuildLandRemndrPaprList", vo); }
	public List selectRemndrPaprCmptncGu() throws SQLException { return list("portal.gis.selectRemndrPaprCmptncGu", null); }
	public List selectRemndrPaprLndcgr() throws SQLException { return list("portal.gis.selectRemndrPaprLndcgr", null); }
	public List selectRemndrPaprCmptncCnter() throws SQLException { return list("portal.gis.selectRemndrPaprCmptncCnter", null); }

	public List selectRentalAptList(Map vo) throws SQLException { return list("portal.gis.selectRentalAptList", vo); }
	public List selectRentAptHsmpNm() throws SQLException { return list("portal.gis.selectRentAptHsmpNm", null); }
	public List selectRentAptRentTy(Map vo) throws SQLException { return list("portal.gis.selectRentAptRentTy", vo); }
	public List selectRentAptRentSe() throws SQLException { return list("portal.gis.selectRentAptRentSe", null); }
	public List selectRentAptSe() throws SQLException { return list("portal.gis.selectRentAptSe", null); }
	public List selectRentAptAtdrc() throws SQLException { return list("portal.gis.selectRentAptAtdrc", null); }
	public List selectRentAptCnter() throws SQLException { return list("portal.gis.selectRentAptCnter", null); }

	public List selectRentalMltdwlList(Map vo) throws SQLException { return list("portal.gis.selectRentalMltdwlList", vo); }
	public List selectMltdwBsnsNm() throws SQLException { return list("portal.gis.selectMltdwBsnsNm", null); }
	public List selectMltdwlBsnsCode() throws SQLException { return list("portal.gis.selectMltdwlBsnsCode", null); }
	public List selectMltdwlDong() throws SQLException { return list("portal.gis.selectMltdwlDong", null); }
	public List selectMltdwlAtdrc() throws SQLException { return list("portal.gis.selectMltdwlAtdrc", null); }
	public List selectMltdwlCnter() throws SQLException { return list("portal.gis.selectMltdwlCnter", null); }
	public List selectMltdwlBuldStrct() throws SQLException { return list("portal.gis.selectMltdwlBuldStrct", null); }

	public List selectRentalCityLvlhList(Map vo) throws SQLException { return list("portal.gis.selectRentalCityLvlhList", vo); }
	public List selectCityLvlhBsnsNm() throws SQLException { return list("portal.gis.selectCityLvlhBsnsNm", null); }
	public List selectCityLvlhBsnsCode() throws SQLException { return list("portal.gis.selectCityLvlhBsnsCode", null); }
	public List selectCityLvlhDong() throws SQLException { return list("portal.gis.selectCityLvlhDong", null); }
	public List selectCityLvlhAtdrc() throws SQLException { return list("portal.gis.selectCityLvlhAtdrc", null); }
	public List selectCityLvlhCnter() throws SQLException { return list("portal.gis.selectCityLvlhCnter", null); }

	public List selectRentalLfstsRentList(Map vo) throws SQLException { return list("portal.gis.selectRentalLfstsRentList", vo); }
	public List selectLfstsBsnsCode() throws SQLException { return list("portal.gis.selectLfstsBsnsCode", null); }
	public List selectLfstsDong() throws SQLException { return list("portal.gis.selectLfstsDong", null); }
	public List selectLfstsAtdrc() throws SQLException { return list("portal.gis.selectLfstsAtdrc", null); }
	public List selectLfstsCnter() throws SQLException { return list("portal.gis.selectLfstsCnter", null); }

	public List selectRentalLngtrSafetyList(Map vo) throws SQLException { return list("portal.gis.selectRentalLngtrSafetyList", vo); }
	public List selectLngtrSafetyBsnsCode() throws SQLException { return list("portal.gis.selectLngtrSafetyBsnsCode", null); }
	public List selectLngtrSafetyDong() throws SQLException { return list("portal.gis.selectLngtrSafetyDong", null); }
	public List selectLngtrSafetyAtdrc() throws SQLException { return list("portal.gis.selectLngtrSafetyAtdrc", null); }
	public List selectLngtrSafetyCnter() throws SQLException { return list("portal.gis.selectLngtrSafetyCnter", null); }

	public String selectBsnsNmByCode(Map vo) throws SQLException { return (String) selectByPk("portal.gis.selectBsnsNmByCode", vo); }

	public List selectRentalAptkList(Map vo) throws SQLException { return list("portal.gis.selectRentalAptkList", vo); }

	public List selectRentalDongHoList(Map vo) throws SQLException { return list("portal.gis.selectRentalDongHoList", vo); }

	public List selectRentalAptDongHoList(Map vo) throws SQLException { return list("portal.gis.selectRentalAptDongHoList", vo); }
	public List selectRentalMltdwlDongHoList(Map vo) throws SQLException { return list("portal.gis.selectRentalMltdwlDongHoList", vo); }
	public List selectRentalCtyLvlhDongHoList(Map vo) throws SQLException { return list("portal.gis.selectRentalCtyLvlhDongHoList", vo); }

	public Map selectRentalAptStat() throws SQLException { return (Map)selectByPk("portal.gis.selectRentalAptStat", null); }
	public Map selectRentalMltdwlStat() throws SQLException { return (Map)selectByPk("portal.gis.selectRentalMltdwlStat", null); }
	public Map selectRentalCityLvlhStat() throws SQLException { return (Map)selectByPk("portal.gis.selectRentalCityLvlhStat", null); }
	public Map selectRentalLfstsRentStat() throws SQLException { return (Map)selectByPk("portal.gis.selectRentalLfstsRentStat", null); }
	public Map selectRentalLngtrSafetyStat() throws SQLException { return (Map)selectByPk("portal.gis.selectRentalLngtrSafetyStat", null); }

	public List selectAssetApt(Map vo) throws SQLException { return list("portal.gis.selectAssetApt", vo); }
	public List selectAssetAptAssetsClass() throws SQLException { return list("portal.gis.selectAssetAptAssetsClass", null); }
	public List selectAssetAptPrdlstClass(Map vo) throws SQLException { return list("portal.gis.selectAssetAptPrdlstClass", vo); }
	public List selectAssetAptBsnsCode() throws SQLException { return list("portal.gis.selectAssetAptBsnsCode", null); }
	public List selectAssetAptStndrd() throws SQLException { return list("portal.gis.selectAssetAptStndrd", null); }
	public List selectAssetAptAssetsChange() throws SQLException { return list("portal.gis.selectAssetAptAssetsChange", null); }
	public List selectAssetAptChangeDcsn() throws SQLException { return list("portal.gis.selectAssetAptChangeDcsn", null); }
	public List selectAssetAptAcqsDe() throws SQLException { return list("portal.gis.selectAssetAptAcqsDe", null); }

	public List selectAssetMltdwl(Map vo) throws SQLException { return list("portal.gis.selectAssetMltdwl", vo); }
	public List selectAssetMltdwlAssetsClass() throws SQLException { return list("portal.gis.selectAssetMltdwlAssetsClass", null); }
	public List selectAssetMltdwlPrdlstClass(Map vo) throws SQLException { return list("portal.gis.selectAssetMltdwlPrdlstClass", vo); }
	public List selectAssetMltdwlBsnsCode() throws SQLException { return list("portal.gis.selectAssetMltdwlBsnsCode", null); }
	public List selectAssetMltdwlStndrd() throws SQLException { return list("portal.gis.selectAssetMltdwlStndrd", null); }
	public List selectAssetMltdwlAssetsChange() throws SQLException { return list("portal.gis.selectAssetMltdwlAssetsChange", null); }
	public List selectAssetMltdwlChangeDcsn() throws SQLException { return list("portal.gis.selectAssetMltdwlChangeDcsn", null); }
	public List selectAssetMltdwlAcqsDe() throws SQLException { return list("portal.gis.selectAssetMltdwlAcqsDe", null); }
	
	public List selectAssetEtc(Map vo) throws SQLException { return list("portal.gis.selectAssetEtc", vo); }
	public List selectAssetEtcAssetsClass() throws SQLException { return list("portal.gis.selectAssetEtcAssetsClass", null); }
	public List selectAssetEtcPrdlstClass(Map vo) throws SQLException { return list("portal.gis.selectAssetEtcPrdlstClass", vo); }
	public List selectAssetEtcBsnsCode() throws SQLException { return list("portal.gis.selectAssetEtcBsnsCode", null); }
	public List selectAssetEtcStndrd() throws SQLException { return list("portal.gis.selectAssetEtcStndrd", null); }
	public List selectAssetEtcAssetsChange() throws SQLException { return list("portal.gis.selectAssetEtcAssetsChange", null); }
	public List selectAssetEtcChangeDcsn() throws SQLException { return list("portal.gis.selectAssetEtcChangeDcsn", null); }
	public List selectAssetEtcAcqsDe() throws SQLException { return list("portal.gis.selectAssetEtcAcqsDe", null); }


	public List selectTableBuildLandSiteGeometry(Map vo) throws SQLException { return list("portal.gis.selectTableBuildLandSiteGeometry", vo); }
	public List selectTableBuildLandLicensGeometry(Map vo) throws SQLException { return list("portal.gis.selectTableBuildLandLicensGeometry", vo); }
	public List selectTableBuildLandUnSalePaprGeometry(Map vo) throws SQLException { return list("portal.gis.selectTableBuildLandUnSalePaprGeometry", vo); }
	public List selectTableBuildLandRemndrPaprGeometry(Map vo) throws SQLException { return list("portal.gis.selectTableBuildLandRemndrPaprGeometry", vo); }
	public List selectTableRentalAptGeometry(Map vo) throws SQLException { return list("portal.gis.selectTableRentalAptGeometry", vo); }
	public List selectTableRentalMltdwlGeometry(Map vo) throws SQLException { return list("portal.gis.selectTableRentalMltdwlGeometry", vo); }
	public List selectTableRentalCtyLvlhGeometry(Map vo) throws SQLException { return list("portal.gis.selectTableRentalCtyLvlhGeometry", vo); }
	public List selectTableRentalLfstsGeometry(Map vo) throws SQLException { return list("portal.gis.selectTableRentalLfstsGeometry", vo); }
	public List selectTableRentalLngtrSafetyGeometry(Map vo) throws SQLException { return list("portal.gis.selectTableRentalLngtrSafetyGeometry", vo); }
	public List selectTableAssetAptGeometry(Map vo) throws SQLException { return list("portal.gis.selectTableAssetAptGeometry", vo); }
	public List selectTableAssetMltdwlGeometry(Map vo) throws SQLException { return list("portal.gis.selectTableAssetMltdwlGeometry", vo); }
	public List selectTableAssetEtcGeometry(Map vo) throws SQLException { return list("portal.gis.selectTableAssetEtcGeometry", vo); }
	
	public Map selectLayerDesc(Map vo) throws SQLException { return (Map)selectByPk("portal.gis.selectLayerDesc", vo); }
	public List selectLayerDescList(Map vo) throws SQLException { return list("portal.gis.selectLayerDescList", vo); }
	public List selectLayerAuthList(Map vo) throws SQLException { return list("portal.gis.selectLayerAuthList", vo); }
	public List selectExLayerAuthList(Map vo) throws SQLException { return list("portal.gis.selectExLayerAuthList", vo); }
	public List selectLayerAdditionalByNo(Map vo) throws SQLException { return list("portal.gis.selectLayerAdditionalByNo", vo); }
	public List selectLayerByApikey(Map vo) throws SQLException { return list("portal.gis.selectLayerByApikey", vo); }

	public String selectTableAttrEditAuth(Map vo) throws SQLException { return (String) selectByPk("portal.gis.selectTableAttrEditAuth", vo); }
	public String selectTablePkColumn(Map vo) throws SQLException { return (String) selectByPk("portal.gis.selectTablePkColumn", vo); }
	public List selectColumnCommentList(Map vo) throws SQLException { return list("portal.gis.selectColumnCommentList", vo); }
	public List selectCntcColumnCommentList(Map vo) throws SQLException { return list("portal.gis.selectCntcColumnCommentList", vo); }
	public List selectViewColumnCommentList(Map vo) throws SQLException { return list("portal.gis.selectViewColumnCommentList", vo); }
	public String selectTableGeomTypeInfo(Map vo) throws SQLException { return (String) selectByPk("portal.gis.selectTableGeomTypeInfo", vo); }

	public List selectGeocoingEpsgList() throws SQLException { return list("portal.gis.selectGeocoingEpsgList", null); }
	public String selectGeocoingEpsgToProj4(Map vo) throws SQLException { return (String) selectByPk("portal.gis.selectGeocoingEpsgToProj4", vo); }
	public List selectShapeUploadEpsgList() throws SQLException { return list("portal.gis.selectShapeUploadEpsgList", null); }

	public List selectLayerMyDataList(Map vo) throws SQLException { return list("portal.gis.selectLayerMyDataList", vo); }
	public List selectLayerMyDataCommentList(Map vo) throws SQLException { return list("portal.gis.selectLayerMyDataCommentList", vo); }

}
