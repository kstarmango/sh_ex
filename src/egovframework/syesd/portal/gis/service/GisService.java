package egovframework.syesd.portal.gis.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface GisService {

	/* 택지 */
	public List selectBuildLandSiteDataList(Map vo) throws SQLException;
	public List selectSiteBsnsNm() throws SQLException;
	public List selectSitePrposNm() throws SQLException;
	public List selectSiteSttus() throws SQLException;
	public List selectSiteSpfc() throws SQLException;
	public List selectSiteLndcgr() throws SQLException;

	public List selectBuildLandLicensList(Map vo) throws SQLException;
	public List selectLicensBsnsNm() throws SQLException;
	public List selectLicensSuplyTy() throws SQLException;
	public List selectLicensPrpos() throws SQLException;

	public List selectBuildLandUnSalePaprList(Map vo) throws SQLException;
	public List selectUnSalePaprDstrcNm() throws SQLException;
	public List selectUnSalePaprSleMth() throws SQLException;
	public List selectUnSalePaprPcStdr() throws SQLException;
	public List selectUnSalePaprSuplyTrgetStdr() throws SQLException;
	public List selectUnSalePaprSpfc() throws SQLException;

	public List selectBuildLandRemndrPaprList(Map vo) throws SQLException;
	public List selectRemndrPaprCmptncGu() throws SQLException;
	public List selectRemndrPaprLndcgr() throws SQLException;
	public List selectRemndrPaprCmptncCnter() throws SQLException;

	/* 임대 */
	public List selectRentalAptList(Map vo) throws SQLException;
	public List selectRentAptHsmpNm() throws SQLException;
	public List selectRentAptRentTy(Map vo) throws SQLException;
	public List selectRentAptRentSe() throws SQLException;
	public List selectRentAptSe() throws SQLException;
	public List selectRentAptAtdrc() throws SQLException;
	public List selectRentAptCnter() throws SQLException;

	public List selectRentalMltdwlList(Map vo) throws SQLException;
	public List selectMltdwBsnsNm() throws SQLException;
	public List selectMltdwlBsnsCode() throws SQLException;
	public List selectMltdwlDong() throws SQLException;
	public List selectMltdwlAtdrc() throws SQLException;
	public List selectMltdwlCnter() throws SQLException;
	public List selectMltdwlBuldStrct() throws SQLException;

	public List selectRentalCityLvlhList(Map vo) throws SQLException;
	public List selectCityLvlhBsnsNm() throws SQLException;
	public List selectCityLvlhBsnsCode() throws SQLException;
	public List selectCityLvlhDong() throws SQLException;
	public List selectCityLvlhAtdrc() throws SQLException;
	public List selectCityLvlhCnter() throws SQLException;

	public List selectRentalLfstsRentList(Map vo) throws SQLException;
	public List selectLfstsBsnsCode() throws SQLException;
	public List selectLfstsDong() throws SQLException;
	public List selectLfstsAtdrc() throws SQLException;
	public List selectLfstsCnter() throws SQLException;

	public List selectRentalLngtrSafetyList(Map vo) throws SQLException;
	public List selectLngtrSafetyBsnsCode() throws SQLException;
	public List selectLngtrSafetyDong() throws SQLException;
	public List selectLngtrSafetyAtdrc() throws SQLException;
	public List selectLngtrSafetyCnter() throws SQLException;

	public String selectBsnsNmByCode(Map vo) throws SQLException;

	public List selectRentalAptkList(Map vo) throws SQLException;

	public List selectRentalDongHoList(Map vo) throws SQLException;

	public List selectRentalAptDongHoList(Map vo) throws SQLException;
	public List selectRentalMltdwlDongHoList(Map vo) throws SQLException;
	public List selectRentalCtyLvlhDongHoList(Map vo) throws SQLException;

	/* 암대 통계 */
	public Map selectRentalAptStat() throws SQLException;						// 아파트
	public Map selectRentalMltdwlStat() throws SQLException;					// 다가구
	public Map selectRentalCityLvlhStat() throws SQLException;					// 도시형생활주택
	public Map selectRentalLfstsRentStat() throws SQLException;				// 전세임대
	public Map selectRentalLngtrSafetyStat() throws SQLException;				// 장기안심

	/* 자산 */
	public List selectAssetApt(Map vo) throws SQLException;

	public List selectAssetAptAssetsClass() throws SQLException;
	public List selectAssetAptPrdlstClass(Map vo) throws SQLException;
	public List selectAssetAptBsnsCode() throws SQLException;
	public List selectAssetAptStndrd() throws SQLException;
	public List selectAssetAptAssetsChange() throws SQLException;
	public List selectAssetAptChangeDcsn() throws SQLException;
	public List selectAssetAptAcqsDe() throws SQLException;

	public List selectAssetMltdwl(Map vo) throws SQLException;

	public List selectAssetMltdwlAssetsClass() throws SQLException;
	public List selectAssetMltdwlPrdlstClass(Map vo) throws SQLException;
	public List selectAssetMltdwlBsnsCode() throws SQLException;
	public List selectAssetMltdwlStndrd() throws SQLException;
	public List selectAssetMltdwlAssetsChange() throws SQLException;
	public List selectAssetMltdwlChangeDcsn() throws SQLException;
	public List selectAssetMltdwlAcqsDe() throws SQLException;
	
	public List selectAssetEtc(Map vo) throws SQLException;

	public List selectAssetEtcAssetsClass() throws SQLException;
	public List selectAssetEtcPrdlstClass(Map vo) throws SQLException;
	public List selectAssetEtcBsnsCode() throws SQLException;
	public List selectAssetEtcStndrd() throws SQLException;
	public List selectAssetEtcAssetsChange() throws SQLException;
	public List selectAssetEtcChangeDcsn() throws SQLException;
	public List selectAssetEtcAcqsDe() throws SQLException;

	/* 테이블 도형 조회 */
	public List selectTableBuildLandSiteGeometry(Map vo) throws SQLException;
	public List selectTableBuildLandLicensGeometry(Map vo) throws SQLException;
	public List selectTableBuildLandUnSalePaprGeometry(Map vo) throws SQLException;
	public List selectTableBuildLandRemndrPaprGeometry(Map vo) throws SQLException;
	public List selectTableRentalAptGeometry(Map vo) throws SQLException;
	public List selectTableRentalMltdwlGeometry(Map vo) throws SQLException;
	public List selectTableRentalCtyLvlhGeometry(Map vo) throws SQLException;
	public List selectTableRentalLfstsGeometry(Map vo) throws SQLException;
	public List selectTableRentalLngtrSafetyGeometry(Map vo) throws SQLException;
	public List selectTableAssetAptGeometry(Map vo) throws SQLException;
	public List selectTableAssetMltdwlGeometry(Map vo) throws SQLException;
	public List selectTableAssetEtcGeometry(Map vo) throws SQLException;

	/* 레이어 검색 */
	public List selectLayerDescList(Map vo) throws SQLException;

	/* 레이어 목록 */
	public List selectLayerAuthList(Map vo) throws SQLException;

	/* 연계 레이어 목록 */
	public List selectExLayerAuthList(Map vo) throws SQLException;

	/* 레이어 추가 목록 */
	public List selectLayerAdditionalByNo(Map vo) throws SQLException;

	/* 레이어 목록 */
	public List selectLayerByApikey(Map vo) throws SQLException;

	/* 레이어 설명 */
	public Map selectLayerDesc(Map vo) throws SQLException;

	/* 테이블 수정 권한 조회 */
	public String selectTableAttrEditAuth(Map vo) throws SQLException;

	/* 테이블 PK 컬럼명 */
	public String selectTablePkColumn(Map vo) throws SQLException;

	/* 내부 테이블 컬럼 및 설명 목록 */
	public List selectColumnCommentList(Map vo) throws SQLException;

	/* 외부 테이블 컬럼 및 설명 목록 */
	public List selectCntcColumnCommentList(Map vo) throws SQLException;
	
	/* 내부 테이블 컬럼 및 설명 목록 */
	public List selectViewColumnCommentList(Map vo) throws SQLException;

	/* GIS 유형 조회 */
	public String selectTableGeomTypeInfo(Map vo) throws SQLException;

	/* 지오코딩 EPSG 목록 */
	public List selectGeocoingEpsgList() throws SQLException;

	/* 지오코딩 EPSG TO PROJ4 */
	public String selectGeocoingEpsgToProj4(Map vo) throws SQLException;

	/* MY DATA 목록 */
	public List selectLayerMyDataList(Map vo) throws SQLException;

	/* MY DATA 선택 테이블의 컬럼 및 설명 목록 */
	public List selectLayerMyDataCommentList(Map vo) throws SQLException;

	/* SHAPE 변환 EPSG 목록 */
	public List selectShapeUploadEpsgList() throws SQLException;

}