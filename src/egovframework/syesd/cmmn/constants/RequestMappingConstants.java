package egovframework.syesd.cmmn.constants;

import java.io.File;
import java.text.MessageFormat;

import egovframework.syesd.cmmn.util.KeyGenerateUtil;

/**
 * 상수 정의 클래스
 *
 * @author  유창범
 * @since   2020.07.22
 * @version 1.0
 * @see
 * <pre>
 *   == 개정이력(Modification Information) ==
 *
 *         수정일                        수정자                                수정내용
 *   ----------------    ------------    ---------------------------
 *   2020.07.22          유창범                           최초 생성
 *
 * </pre>
 */

public class RequestMappingConstants {

	/**
	 * 상수 - 암복호화 KEY
	 */

	public static final String KEY_ENC   	= "SHLM";

	public static final String KEY_HEX   	= "1353a953f7af8689962c785487528e55";
	public static final String KEY       	= new String(KeyGenerateUtil.decrypt(KeyGenerateUtil.decodeHex(KEY_HEX), KEY_ENC));

	public static final String KEY_HEX_P 	= "c7f1c5376dd325294d5a93e35977a502";
	public static final String KEY_P     	= new String(KeyGenerateUtil.decrypt(KeyGenerateUtil.decodeHex(KEY_HEX_P), KEY_ENC));
	
	
	/**
     * 상수 - WEB DELEMETER
     */
	public static final String DELEMETER 				= "/";

	/**
     * 상수 - FILE SEPERATOR
     */
	public static final String SEPERATOR  				= File.separator;

	/**
     * 상수 - APPLICATION PATH
     */
	public static final String TOMCAT_PATH         		= System.getProperty("catalina.home") + SEPERATOR;

	/**
     * 상수 - UPLOAD FOLDER 명
     */
	public static final String UPLOAD_FOLDER    		= "upload" + SEPERATOR;
	public static final String UPLOAD_FOLDER_FOR_WEB	= DELEMETER + "upload" + DELEMETER;

	/**
     * 상수 - TEMPORARY FOLDER 명
     */
	public static final String TEMPORARY_FOLDER    		= UPLOAD_FOLDER + "temp" + SEPERATOR;


	/**
	 * 상수 - 세션 타임아웃
	 */
	public static final int    MAX_SESSION_TIMEOUT 		=  60 * 24 * 60;

	/**
     * 상수 - SUBFIX
     */
	public static final String REQUEST_SUBFIX_A 		= ".xml";
	public static final String REQUEST_SUBFIX_B 		= ".json";
	public static final String REQUEST_SUBFIX_C 		= ".do";
	public static final String REQUEST_SUBFIX_D 		= ".csv";
	public static final String REQUEST_SUBFIX_E 		= ".shp";
	public static final String REQUEST_SUBFIX_F 		= ".shx";
	public static final String REQUEST_SUBFIX_G 		= ".dbf";
	public static final String REQUEST_SUBFIX_H 		= ".cpg";
	public static final String REQUEST_SUBFIX_I 		= ".prj";
	public static final String[] REQUEST_SUBFIX_SHP		= {REQUEST_SUBFIX_E, REQUEST_SUBFIX_F, REQUEST_SUBFIX_G, REQUEST_SUBFIX_H, REQUEST_SUBFIX_I};
	public static final String REQUEST_SUBFIX_J 		= ".zip";


	/**
	 * 상수 - LOGIN MAX ATTEMPT
	 */
	public static final int    CONST_LOGIN_ATTEMPT  	= 5;

	/**
     * API ROOT
     */
	public static final String API_ROOT 				= DELEMETER + "api";

	/**
     * API VERSION
     */
	public static final String API_VERSION_V1 			= DELEMETER + "{version:v[1]?}";


	/**
     * WEB ROOT
     */
	public static final String WEB_ROOT    				= DELEMETER + "web";

	/**
     * WEB COMMON ROOT
     */
	public static final String COMMN_ROOT  				= DELEMETER + "cmmn";

	/**
     * WEB ADMIN ROOT
     */
	public static final String ADMIN_ROOT  				= DELEMETER + "admin";

	/**
     * WEB PORTAL ROOT
     */
	public static final String PORTAL_ROOT 				= DELEMETER + "portal";
	
	/**
	 * WEB LINK ROOT
	 */
	public static final String LINK_ROOT 			= DELEMETER + "link";
	
	/**
	 * WEB ANALYSIS ROOT
	 */
	public static final String ANALYSIS_ROOT 			= DELEMETER + "analysis";
	
	/**
	 * WEB ANALYSIS ROOT
	 */
	public static final String ANALYSIS_DEV_ROOT 			= DELEMETER + "dev";

	/**
	 * WEB ANALYSIS ROOT
	 */
	public static final String ANALYSIS_BIZ_ROOT 			= DELEMETER + "biz";
	
	/**
	 * WEB ANALYSIS ROOT
	 */
	public static final String ANALYSIS_LIFE_ROOT 			= DELEMETER + "life";
	
	/**
	 * WEB ANALYSIS ROOT
	 */
	public static final String ANALYSIS_DESTINATION_ROOT 			= DELEMETER + "destination";

	/**
	 * WEB ANALYSIS ROOT
	 */
	public static final String ANALYSIS_QUEST_ROOT 			= DELEMETER + "quest";
	
	
	/**
     * API 기능 목록
     */

	// API PROXY
	public static final String API_PROXY					= API_ROOT + COMMN_ROOT + DELEMETER + "proxy"					+ REQUEST_SUBFIX_C;

	// API UPLOAD
	public static final String API_UPLOAD					= API_ROOT + COMMN_ROOT + DELEMETER + "upload"					+ REQUEST_SUBFIX_C;

	// API UPLOAD
	public static final String API_UPLOAD_CSV				= API_ROOT + COMMN_ROOT + DELEMETER + "uploadCsv"				+ REQUEST_SUBFIX_C;

	// API UPLOAD
	public static final String API_UPLOAD_PRJ				= API_ROOT + COMMN_ROOT + DELEMETER + "uploadPrj"				+ REQUEST_SUBFIX_C;

	// API UPLOAD
	public static final String API_UPLOAD_SHP				= API_ROOT + COMMN_ROOT + DELEMETER + "uploadShp"				+ REQUEST_SUBFIX_C;

	// API VIEWLIST
	public static final String API_VIEWLIST					= API_ROOT + COMMN_ROOT + DELEMETER + "viewlist"				+ REQUEST_SUBFIX_C;

	// API DOWNLOAD - 미사용
	public static final String API_DOWNLOAD					= API_ROOT + COMMN_ROOT + DELEMETER + "download"				+ REQUEST_SUBFIX_C;

	// API DELETE
	public static final String API_UPDATELIST				= API_ROOT + COMMN_ROOT + DELEMETER + "updatelist"				+ REQUEST_SUBFIX_C;

	// API OneTime Download
	public static final String API_ONETIMEDOWN				= API_ROOT + COMMN_ROOT + DELEMETER + "oneTimeDown"				+ REQUEST_SUBFIX_C;

	// API MENU AUTH CHECK
	public static final String API_MENU_AUTH				= API_ROOT + COMMN_ROOT + DELEMETER + "menuCheckAuth"			+ REQUEST_SUBFIX_C;

	// ADMIN - API TOPMENU - 미사용
	public static final String API_MENU_TOP   				= API_ROOT + COMMN_ROOT + DELEMETER + "menuTop"					+ REQUEST_SUBFIX_C;

	// ADMIN - API SUBMENU - 미사용
	public static final String API_MENU_SUB  				= API_ROOT + COMMN_ROOT + DELEMETER + "menuSub"					+ REQUEST_SUBFIX_C;


	// API LOGS - 메뉴 이용 기록
	public static final String API_LOG_PROGRM 				= API_ROOT + COMMN_ROOT + DELEMETER + "useProgrm"				+ REQUEST_SUBFIX_C;

	// API LOGS - 레이어 이용 기록
	public static final String API_LOG_LAYER  				= API_ROOT + COMMN_ROOT + DELEMETER + "useLayer"				+ REQUEST_SUBFIX_C;

	// API LOGS - 데이터 이용 기록
	public static final String API_LOG_DATA  				= API_ROOT + COMMN_ROOT + DELEMETER + "useData"					+ REQUEST_SUBFIX_C;

	// API LOGS - 데이터 다운로드 기록
	public static final String API_LOG_DOWNLOAD				= API_ROOT + COMMN_ROOT + DELEMETER + "useDownload"				+ REQUEST_SUBFIX_C;

	// API LOGS - 테이블 이용 기록 - 미사용
	public static final String API_LOG_COMMENT				= API_ROOT + COMMN_ROOT + DELEMETER + "useComment"				+ REQUEST_SUBFIX_C;

	// API LOGS - 감사 이용 기록 - 미사용
	public static final String API_LOG_AUDIT  				= API_ROOT + COMMN_ROOT + DELEMETER + "useAudit"				+ REQUEST_SUBFIX_C;


	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/**
     * WEB 기능 목록
     */

	// WEB COMMON 로그인
	public static final String WEB_MEM_LOGIN      			= WEB_ROOT + COMMN_ROOT + DELEMETER + "webLogin"      			+ REQUEST_SUBFIX_C;

	// WEB SSO LOGIN
	public static final String WEB_SSO_LOGIN      			= WEB_ROOT + COMMN_ROOT + DELEMETER + "ssoLogin"				+ REQUEST_SUBFIX_C;

	// WEB KEY LOGIN
	public static final String WEB_KEY_LOGIN      			= WEB_ROOT + COMMN_ROOT + DELEMETER + "keyLogin"				+ REQUEST_SUBFIX_C;

	// WEB COMMON 로그아웃
	public static final String WEB_LOGOUT     				= WEB_ROOT + COMMN_ROOT + DELEMETER + "logout"    				+ REQUEST_SUBFIX_C;

	// WEB PORTAL 로그인
	public static final String WEB_LOGIN					= WEB_ROOT + DELEMETER 	 + "login" 								+ REQUEST_SUBFIX_C;

	// WEB PORTAL 홈
	public static final String WEB_MAIN 					= WEB_ROOT + DELEMETER 	 + "main"  								+ REQUEST_SUBFIX_C;
	public static final String WEB_MAIN_HEADER				= WEB_ROOT + DELEMETER 	 + "header"								+ REQUEST_SUBFIX_C;
	public static final String WEB_MAIN_LEFT				= WEB_ROOT + DELEMETER 	 + "left"								+ REQUEST_SUBFIX_C;
	public static final String WEB_MAIN_FOOTER				= WEB_ROOT + DELEMETER 	 + "footer"								+ REQUEST_SUBFIX_C;

	// WEB PORTAL 사용자 가입
	public static final String WEB_SIGNUP_FORM				= WEB_ROOT + DELEMETER 	 + "signup/form"						+ REQUEST_SUBFIX_C;
	public static final String WEB_SIGNUP_SUBMIT			= WEB_ROOT + DELEMETER 	 + "signup/submit"						+ REQUEST_SUBFIX_C;

	// WEB PORTAL 사용자 찾기
	public static final String WEB_FIND_USER_FORM			= WEB_ROOT + DELEMETER 	 + "find/form"							+ REQUEST_SUBFIX_C;
	public static final String WEB_FIND_USER_SUBMIT			= WEB_ROOT + DELEMETER 	 + "find/submit"						+ REQUEST_SUBFIX_C;

	// WEB PORTAL 대시보드
	public static final String WEB_DASHBOARD  				= WEB_ROOT + PORTAL_ROOT + DELEMETER + "dashboard"  			+ REQUEST_SUBFIX_C;
	public static final String WEB_DASHBOARD_LIST			= WEB_ROOT + COMMN_ROOT  + DELEMETER + "dashboardList" 			+ REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색
	public static final String WEB_GIS        				= WEB_ROOT + PORTAL_ROOT + DELEMETER + "gis"        			+ REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - 택지
	public static final String WEB_GIS_DATA_BUILD_LAND		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataBuildLandList"   + REQUEST_SUBFIX_C;

	public static final String WEB_GIS_DATA_SITE_COND		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataBuildSiteCond"   + REQUEST_SUBFIX_C;
	public static final String WEB_GIS_DATA_LICENS_COND		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataBuildLicensCond" + REQUEST_SUBFIX_C;
	public static final String WEB_GIS_DATA_UNSALE_COND		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataBuildUnsaleCond" + REQUEST_SUBFIX_C;
	public static final String WEB_GIS_DATA_REMNDR_COND		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataBuildRemndrCond" + REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - 임대
	public static final String WEB_GIS_DATA_RENTAL			= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataRentalList"   	+ REQUEST_SUBFIX_C;

	public static final String WEB_GIS_DATA_APT_COND		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataRentalAptCond"  	+ REQUEST_SUBFIX_C;
	public static final String WEB_GIS_DATA_APT_RENTTY		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataRentalAptRentTy" + REQUEST_SUBFIX_C;

	public static final String WEB_GIS_DATA_MLTDWL_COND		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataRentalMltdwlCond"+ REQUEST_SUBFIX_C;
	public static final String WEB_GIS_DATA_CTY_COND		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataRentalCtyCond"	+ REQUEST_SUBFIX_C;
	public static final String WEB_GIS_DATA_LFSTS_COND		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataRentalLfstsCond" + REQUEST_SUBFIX_C;
	public static final String WEB_GIS_DATA_LNGTR_COND		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataRentalLngtrCond" + REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - 임대 통계
	public static final String WEB_GIS_DATA_RENTAL_STATS	= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataRentalStats"   	+ REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - 임대 종합검색
	public static final String WEB_GIS_DATA_RENTAL_TOTAL	= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataRentalTotalInfo" + REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - 임대 아파트 K
	public static final String WEB_GIS_DATA_RENTAL_APT_K	= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataRentalAptkInfo"  + REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - 자산
	public static final String WEB_GIS_DATA_ASSET			= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataAssetList"   	+ REQUEST_SUBFIX_C;

	public static final String WEB_GIS_DATA_ASSET_APT_COND	= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataAssetAptCond"  	+ REQUEST_SUBFIX_C;
	public static final String WEB_GIS_DATA_ASSET_APT_PRD	= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataAssetAptPrdCond"	+ REQUEST_SUBFIX_C;

	public static final String WEB_GIS_DATA_ASSET_MLT_COND	= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataAssetMltCond"  	+ REQUEST_SUBFIX_C;
	public static final String WEB_GIS_DATA_ASSET_MLT_PRD	= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataAssetMltPrdCond"	+ REQUEST_SUBFIX_C;
	
	public static final String WEB_GIS_DATA_ASSET_ETC_COND	= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataAssetEtcCond"  	+ REQUEST_SUBFIX_C;
	public static final String WEB_GIS_DATA_ASSET_ETC_PRD	= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataAssetEtcPrdCond"	+ REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - 도형 검색
	public static final String WEB_GIS_DATA_GEOMETRY		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisDataGeometry"  		+ REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - 레이어 검색
	public static final String WEB_GIS_LAYER_LIST			= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisLayerList"  			+ REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - 레이어 검색
	public static final String WEB_GIS_LAYER_SEARCH_FEATURES= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisLayerSearchFeatures" + REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - 연계 레이어 검색
	public static final String WEB_GIS_EX_LAYER_LIST			= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisExLayerList"  			+ REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - MY Data 검색, 컬럼 정보
	public static final String WEB_GIS_LAYER_SEARCH_MY_DATA= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisLayerSearchMyData" + REQUEST_SUBFIX_C;
	public static final String WEB_GIS_LAYER_SEARCH_MY_DATA_COLUMN_INFO = WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisLayerSearchMyDataColumnInfo" + REQUEST_SUBFIX_C;
	
	// WEB PORTAL 지도검색 - 레이어 설명 조회
	public static final String WEB_GIS_LAYER_DESC			= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisLayerDesc"  			+ REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - 레이어 설명 저장
	public static final String WEB_GIS_LAYER_DESC_EDIT		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisLayerDescEdit"		+ REQUEST_SUBFIX_C;
	public static final String WEB_GIS_LAYER_DESC_ADD		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisLayerDescAdd"		+ REQUEST_SUBFIX_C;
	
	// WEB PORTAL 지도검색 - 레이어 사용자 권한 목록
	public static final String WEB_GIS_LAYER_BY_AUTH		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisLayerByAuth"  		+ REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - 레이어별 추가 ON 목록
	public static final String WEB_GIS_LAYER_ADDITIONAL		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisLayerAdditionalByNo" + REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - 레이어 스타일
	public static final String WEB_GIS_LAYER_STYLE			= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisLayerStyle"  		+ REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - 레이어 컬럼 목록 조회 ( 내부 )
	public static final String WEB_GIS_LAYER_HEAD_INFO		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisLayerHeadInfo" 		+ REQUEST_SUBFIX_C;

	// WEB PORTAL 지도검색 - 레이어 컬럼 목록 조회 ( 연계 )
	public static final String WEB_GIS_LAYER_CNTC_HEAD_INFO	= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisLayerCntcHeadInfo" 	+ REQUEST_SUBFIX_C;

	// API 레이어 목록
	public static final String WEB_GIS_LAYER_BY_APIKEY		= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisLayerByApiKey"   	+ REQUEST_SUBFIX_C;

	// EPSG 목록 - 지오코딩
	public static final String WEB_GIS_GEOCODING_EPSG_LIST	= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisGeocodingEpsgList"   + REQUEST_SUBFIX_C;

	// EPSG 목록 - SHAPE UPLOAD
	public static final String WEB_GIS_SHAPEUPLOAD_EPSG_LIST= WEB_ROOT + COMMN_ROOT  + DELEMETER + "gisShapeUploadEpsgList" + REQUEST_SUBFIX_C;

	// WEB PORTAL 주제도면
	public static final String WEB_THEME      				= WEB_ROOT + PORTAL_ROOT + DELEMETER + "theme"      			+ REQUEST_SUBFIX_C;

	public static final String WEB_THEME_LIST				= WEB_ROOT + COMMN_ROOT  + DELEMETER + "themeList" 				+ REQUEST_SUBFIX_C;
	public static final String WEB_THEME_DETAIL				= WEB_ROOT + COMMN_ROOT  + DELEMETER + "themeDetail" 			+ REQUEST_SUBFIX_C;
	public static final String WEB_THEME_LAYER_LIST			= WEB_ROOT + COMMN_ROOT  + DELEMETER + "themeLayerList"			+ REQUEST_SUBFIX_C;
	public static final String WEB_THEME_EDIT				= WEB_ROOT + COMMN_ROOT  + DELEMETER + "themeEdit" 				+ REQUEST_SUBFIX_C;
	public static final String WEB_THEME_ADD				= WEB_ROOT + COMMN_ROOT  + DELEMETER + "themeAdd" 				+ REQUEST_SUBFIX_C;

	public static final String WEB_THEME_SHAPE_LIST			= WEB_ROOT + COMMN_ROOT  + DELEMETER + "themeShapeList"			+ REQUEST_SUBFIX_C;
	public static final String WEB_THEME_SHAPE_EDIT			= WEB_ROOT + COMMN_ROOT  + DELEMETER + "themeShapeEdit"			+ REQUEST_SUBFIX_C;
	public static final String WEB_THEME_SHAPE_ADD			= WEB_ROOT + COMMN_ROOT  + DELEMETER + "themeShapeAdd"			+ REQUEST_SUBFIX_C;

	// WEB PORTAL 지오코딩
	//public static final String WEB_GEOCODE     				= WEB_ROOT + PORTAL_ROOT + DELEMETER + "geocode"      			+ REQUEST_SUBFIX_C;
	// Data 지오코딩 24.08.08 추가
	public static final String WEB_GEOCODE     				= "data" + DELEMETER + "geocode"      							+ REQUEST_SUBFIX_C;
	
	// WEB BOARD 왼쪽메뉴 24.05.20 추가
	public static final String WEB_BOARD_LEFT 				= WEB_ROOT + PORTAL_ROOT + DELEMETER + "board" + DELEMETER + "left" + REQUEST_SUBFIX_C;
	// WEB PORTAL 공지사항
	public static final String WEB_NOTICE     				= WEB_ROOT + PORTAL_ROOT + DELEMETER + "notice"      			+ REQUEST_SUBFIX_C;
	public static final String WEB_NOTICE_CHECK_NEW			= WEB_ROOT + COMMN_ROOT  + DELEMETER + "noticeCheckNew"			+ REQUEST_SUBFIX_C;

	// WEB PORTAL 질의응답
	public static final String WEB_QNA        				= WEB_ROOT + PORTAL_ROOT + DELEMETER + "qna"      				+ REQUEST_SUBFIX_C;
	public static final String WEB_QNA_CHECK_NEW 			= WEB_ROOT + COMMN_ROOT  + DELEMETER + "qnaCheckNew"			+ REQUEST_SUBFIX_C;

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// WEB ADMIN 헤더/풋터
	public static final String WEB_ADMIN_HEADER				= WEB_ROOT + DELEMETER 				+ "admin_header"			+ REQUEST_SUBFIX_C;
	public static final String WEB_ADMIN_LEFT				= WEB_ROOT + DELEMETER 				+ "admin_left"			+ REQUEST_SUBFIX_C;
	public static final String WEB_ADMIN_FOOTER				= WEB_ROOT + DELEMETER 				+ "admin_footer"			+ REQUEST_SUBFIX_C;

	// WEB ADMIN 코드관리
	public static final String WEB_MNG_CODE   				= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngCode"    				+ REQUEST_SUBFIX_C;
	
	public static final String WEB_MNG_CODE_EDIT 			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngCodeEdit"    			+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_CODE_ADD_SETTING 	= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngCodeAddSetting"    	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_P_CODE_SET 			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngPcodeSet"  		  	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_CODE_ORDER_SET 		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngCodeOrderSet"  		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_CODE_ORDER_CHANGE 	= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngCodeOrderChange"    	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_CODE_ADD 			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngCodeAdd"  		  	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_CODE_DELETE 			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngCodeDelete"  		  	+ REQUEST_SUBFIX_C;
	
	// WEB ADMIN 사용자관리
	public static final String WEB_MNG_USER   				= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngUser"    				+ REQUEST_SUBFIX_C;

	public static final String WEB_MNG_USER_DETAIL			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngUserDetail" 			+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_USER_CONFM   		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngUserConfmChange"		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_USER_USE     		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngUserUseChange"		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_USER_LOCK   			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngUserLockChange"		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_USER_PWD     		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngUserPwdChange"		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_USER_PAUTH   		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngUserPrgAuthChange"	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_USER_LAUTH   		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngUserLyrAuthChange"	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_USER_ID_DUP			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngUserCheckIdDup"		+ REQUEST_SUBFIX_C;			// WEB 사용자 가입시  ID 중복 체크
	public static final String WEB_MNG_USER_PWD_DUP 		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngUserCheckPwdDup"		+ REQUEST_SUBFIX_C;			// WEB 사용자 패스워드 업데이트시 동일  여부 체크
	public static final String WEB_MNG_USER_PWD_NUM      	= "1";																						// WEB 사용자 패스워드  리셋 업데이트 필요 여부 체크
	public static final String WEB_MNG_USER_PWD_UNIT_ENG 	= "MIN";
	public static final String WEB_MNG_USER_PWD_UNIT_KOR 	= "분";
	public static final String WEB_MNG_USER_PWD_RST      	= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngUserCheckPwdRst"  + REQUEST_SUBFIX_C;

	// WEB ADMIN 사용자이력
	public static final String WEB_MNG_USER_LOGIN_HISTORY 	= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngUserLoginHistory" + REQUEST_SUBFIX_C;

	// WEB ADMIN 감사이력
	public static final String WEB_MNG_USER_AUDIT_HISTORY 	= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngUserAuditHistory" + REQUEST_SUBFIX_C;

	// WEB ADMIN 공자사항관리
	public static final String WEB_MNG_NOTICE 				= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngNotice"   			+ REQUEST_SUBFIX_C;

	public static final String WEB_MNG_NOTICE_DETAIL		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngNoticeDetail" 		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_NOTICE_EDIT  		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngNoticeEdit" 			+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_NOTICE_USEYN 		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngNoticeUseYn" 			+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_NOTICE_ADD   		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngNoticeAdd" 			+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_NOTICE_VIEW_CNT 		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngNoticeViewCnt"		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_NOTICE_DELETE 		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngNoticeDelete"			+ REQUEST_SUBFIX_C;  		// 2022-10-17  공지사항 게시물 삭제    
	
	// WEB ADMIN 질의응답관리
	public static final String WEB_MNG_QNA    				= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngQna"     				+ REQUEST_SUBFIX_C;

	public static final String WEB_MNG_QNA_DETAIL			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngQnaDetail"  			+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_QNA_EDIT				= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngQnaEdit"  			+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_QNA_USEYN			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngQnaUseYn"  			+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_QNA_ADD				= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngQnaAdd"	  			+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_QNA_READD			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngQnaReplyAdd"	  		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_QNA_VIEW_CNT 		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngQnaViewCnt"			+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_QNA_DELETE 		    = WEB_ROOT + COMMN_ROOT + DELEMETER + "mngQnaDelete"			+ REQUEST_SUBFIX_C;		    // 2022-10-18  공지사항 게시물 삭제    

	// WEB ADMIN 메뉴관리
	public static final String WEB_MNG_PROGRM   			= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngProgrm"   	 		+ REQUEST_SUBFIX_C;

	public static final String WEB_MNG_PROGRM_DETAIL		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngProgrmDetail"  	 	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_PROGRM_EDIT			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngProgrmEdit"  	 		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_PROGRM_ADD			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngProgrmAdd"  	 		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_PROGRM_NUM_BYID		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngProgrmNumById" 		+ REQUEST_SUBFIX_C;

	// WEB ADMIN 메뉴권한관리
	public static final String WEB_MNG_PROGRM_AUTH 			= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngProgrmAuth"   		+ REQUEST_SUBFIX_C;

	public static final String WEB_MNG_PROGRM_AUTH_DETAIL	= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngProgrmAuthDetail"  	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_PROGRM_AUTH_EDIT		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngProgrmAuthEdit"		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_PROGRM_AUTH_ADD		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngProgrmAuthAdd" 		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_PROGRM_AUTH_PROGRMS	= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngProgrmAuthProgrms"	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_PROGRM_AUTH_PROGRMS_EDIT	= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngProgrmAuthProgrmsEdit"+ REQUEST_SUBFIX_C;

	// WEB ADMIN 레이어관리
	public static final String WEB_MNG_LAYER   				= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngLayer"   	 			+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_GROUP   		= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngLayerGroup"   	 	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_MAPNG   		= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngLayerMapng"   	 	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_SERVER   		= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngLayerServer"   	 	+ REQUEST_SUBFIX_C;

	public static final String WEB_MNG_LAYER_LIST			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerList"	  	 	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_EDIT			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerEdit"  	 		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_ADD			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerAdd"  	 		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_TYPE_SET		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerTypeSet"  	 	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_DELETE			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerDelete"  	 	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_FILE_DELETE	= WEB_ROOT + COMMN_ROOT + DELEMETER + "fileDelete"  	 		+ REQUEST_SUBFIX_C;
	
	
	
	public static final String WEB_MNG_LAYER_INFOG_EDIT		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerInforaphicEdit" 	+ REQUEST_SUBFIX_C;

	public static final String WEB_MNG_LAYER_DESC			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerDesc"  	 		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_DESC_EDIT		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerDescEdit"  	 	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_DESC_ADD		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerDescAdd"  	 	+ REQUEST_SUBFIX_C;

	public static final String WEB_MNG_LAYER_GROUP_LIST		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerGroupList"  	 	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_GROUP_EDIT		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerGroupEdit"  	 	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_GROUP_ADD      = WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerGroupAdd"  	 	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_GROUP_ADD_SETTING	= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerGroupAddSetting" + REQUEST_SUBFIX_C;
	
	public static final String WEB_MNG_MAPNG_LIST			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngMapngList"  	 		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_MAPNG_EDIT			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngMapngEdit"  	 		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_MAPNG_ADD			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngMapngAdd"  	 		+ REQUEST_SUBFIX_C;

	public static final String WEB_MNG_SERVER_LIST			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngServerList" 			+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_SERVER_EDIT			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngServerEdit"  	 		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_SERVER_ADD			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngServerAdd"  	 		+ REQUEST_SUBFIX_C;
	
	
	// WEB ADMIN 레이어권한관리
	public static final String WEB_MNG_LAYER_AUTH			= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngLayerAuth" 			+ REQUEST_SUBFIX_C;

	public static final String WEB_MNG_LAYER_AUTH_DETAIL	= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerAuthDetail"  	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_AUTH_EDIT		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerAuthEdit"		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_AUTH_ADD		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngLayerAuthAdd" 		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_AUTH_LAYERS	= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngProgrmAuthLayers"		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_LAYER_AUTH_LAYERS_EDIT	= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngProgrmAuthLayersEdit"+ REQUEST_SUBFIX_C;

	// WEB ADMIN 테이블 관리
	public static final String WEB_MNG_TABLE_COMMENT		= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngTableComment"			+ REQUEST_SUBFIX_C;

	public static final String WEB_MNG_TABLE_SPACE_LIST		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngTableSpaceList"		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_TABLE_COMMENT_LIST	= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngTableCommentList"		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_TABLE_COMMENT_EDIT	= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngTableCommentEdit"		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_COLUMN_COMMENT_LIST  = WEB_ROOT + COMMN_ROOT + DELEMETER + "mngColumnCommentList"	+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_COLUMN_COMMENT_EDIT  = WEB_ROOT + COMMN_ROOT + DELEMETER + "mngColumnCommentEdit"	+ REQUEST_SUBFIX_C;

	// WEB ADMIN 데이터 관리
	public static final String WEB_MNG_TABLE_DATA			= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngTableData"			+ REQUEST_SUBFIX_C;

	public static final String WEB_MNG_TABLE_DATA_DETAIL	= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngTableDataDetail"		+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_TABLE_DATA_EDIT		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngTableDataEdit"		+ REQUEST_SUBFIX_C;

	// WEB ADMIN APIKEY 관리
	public static final String WEB_MNG_APIKEY				= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngApiKey" 				+ REQUEST_SUBFIX_C;

	public static final String WEB_MNG_APIKEY_DETAIL		= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngApiKeyDetail"			+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_APIKEY_EDIT			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngApiKeyEdit"			+ REQUEST_SUBFIX_C;
	public static final String WEB_MNG_APIKEY_ADD			= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngApiKeyAdd"			+ REQUEST_SUBFIX_C;

	// WEB ADMIN 통계:사용자
	public static final String WEB_STATS_USER				= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngStatUser" 			+ REQUEST_SUBFIX_C;
	
	// WEB ADMIN 통계:메뉴
	public static final String WEB_STATS_MENU 				= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngStatMenu" 			+ REQUEST_SUBFIX_C;
	
	// WEB ADMIN 통계:레이어
	public static final String WEB_STATS_LAYER				= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngStatLayer" 			+ REQUEST_SUBFIX_C;
	
	// WEB ADMIN 누계통계:사용자
	public static final String WEB_SUM_STATS_USER				= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngSumStatUser" 		+ REQUEST_SUBFIX_C;
	
	// WEB ADMIN 누계통계:메뉴
	public static final String WEB_SUM_STATS_MENU				= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngSumStatMenu" 		+ REQUEST_SUBFIX_C;
	
	// WEB ADMIN 누계통계:레이어
	public static final String WEB_SUM_STATS_LAYER				= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngSumStatLayer" 	+ REQUEST_SUBFIX_C;
	
	// WEB ADMIN 통계:부서	<------ 추가된 부분
	//public static final String WEB_STATS_DEPT				= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngStatDept" 			+ REQUEST_SUBFIX_C;

	// WEB ADMIN 통계:데이터
	//public static final String WEB_STATS_DATA 				= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngStatData" 			+ REQUEST_SUBFIX_C;

	// WEB ADMIN 통계:다운로드
	//public static final String WEB_STATS_DOWN 				= WEB_ROOT + ADMIN_ROOT + DELEMETER + "mngStatDown" 			+ REQUEST_SUBFIX_C;

	// WEB ADMIN 통계:상세
	//public static final String WEB_STATS_DETAIL				= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngStatDetail" 			+ REQUEST_SUBFIX_C;

	// WEB ADMIN 통계:해당월의 마지막 일자
	//public static final String WEB_STATS_END_OF_MONTH   	= WEB_ROOT + COMMN_ROOT + DELEMETER + "mngStatEndOfMonth" 		+ REQUEST_SUBFIX_C;
	
	// WEB LINK 사업기획
	public static final String WEB_LINK_BIZ 				= WEB_ROOT + LINK_ROOT + DELEMETER + "biz"	+ REQUEST_SUBFIX_C;
	
	// 패턴
	// WEB ANALYSIS 공통분석:버퍼
	public static final String WEB_ANAL_CMMN_BUFFER 		= WEB_ROOT + ANALYSIS_ROOT + COMMN_ROOT + DELEMETER + "buffer"	+ REQUEST_SUBFIX_C;
	public static final String WEB_ANAL_CMMN_BUFFER_CONTENT 		=  ANALYSIS_ROOT + COMMN_ROOT + DELEMETER + "bufferContent"	+ REQUEST_SUBFIX_C;
	// WEB ANALYSIS 공통분석:밀도
	public static final String WEB_ANAL_CMMN_DENSITY		= WEB_ROOT + ANALYSIS_ROOT + COMMN_ROOT + DELEMETER + "density"	+ REQUEST_SUBFIX_C;
	public static final String WEB_ANAL_CMMN_DENSITY_CONTENT		=  ANALYSIS_ROOT + COMMN_ROOT + DELEMETER + "densityContent"	+ REQUEST_SUBFIX_C;
	// WEB ANALYSIS 공통분석:포인트 집계
	public static final String WEB_ANAL_CMMN_POINT		= WEB_ROOT + ANALYSIS_ROOT + COMMN_ROOT + DELEMETER + "statistics"	+ REQUEST_SUBFIX_C;
	public static final String WEB_ANAL_CMMN_SHP_DN		= WEB_ROOT + ANALYSIS_ROOT + COMMN_ROOT + DELEMETER + "shpDownload"	+ REQUEST_SUBFIX_C;
	public static final String WEB_ANAL_CMMN_POINT_CONTENT		=  ANALYSIS_ROOT + COMMN_ROOT + DELEMETER + "statisticsContent"	+ REQUEST_SUBFIX_C;
	
	// 입지
	// WEB ANALYSIS 관련사업 분석 : 기본입지 분석(중첩)
	public static final String WEB_ANAL_BIZ_BASIC_LOCATION = WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_BIZ_ROOT + DELEMETER + "basicLocOverlap" + REQUEST_SUBFIX_C;
	public static final String WEB_ANAL_BIZ_BASIC_LOCATION_CONTENT = WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_BIZ_ROOT + DELEMETER + "basicLocOverlapContent" + REQUEST_SUBFIX_C;
	// WEB ANALYSIS 기초생활 인프라 : 기본 입지분석(거리)
	public static final String WEB_ANAL_DISTANCE_LIFE = WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_LIFE_ROOT + DELEMETER + "basicLocDistance" + REQUEST_SUBFIX_C;
	public static final String WEB_ANAL_DISTANCE_LIFE_CONTENT = WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_LIFE_ROOT + DELEMETER + "basicLocDistanceContent" + REQUEST_SUBFIX_C;
	// WEB ANALYSIS 기초생활 인프라 : 네트워크 입지분석(거리)
	public static final String WEB_ANAL_NETWORK_LIFE = WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_LIFE_ROOT + DELEMETER + "network" + REQUEST_SUBFIX_C;
	public static final String WEB_ANAL_NETWORK_LIFE_CONTENT = WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_LIFE_ROOT + DELEMETER + "networkContent" + REQUEST_SUBFIX_C;
	// WEB ANALYSIS 기초생활 인프라 : WKT 지적 데이터 불러오
	public static final String WEB_GIS_LG_STR = WEB_ROOT + ANALYSIS_ROOT + DELEMETER + "getLgStr" + REQUEST_SUBFIX_C;

	// 공간
	// WEB ANALYSIS 버퍼(중첩) : 반경거리 중첩 분석 
	public static final String WEB_ANAL_QUEST_DISTANCE_CONTENT = WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_QUEST_ROOT + DELEMETER + "distanceContent" + REQUEST_SUBFIX_C;
	// WEB ANALYSIS 관련사업 분석 : 주변 유사사업 
	public static final String WEB_ANAL_SIMILAR_BIZ = WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_BIZ_ROOT + DELEMETER + "similarBiz" + REQUEST_SUBFIX_C;
	public static final String WEB_ANAL_SIMILAR_BIZ_CONTENT = WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_BIZ_ROOT + DELEMETER + "similarBizContent" + REQUEST_SUBFIX_C;
	// WEB ANALYSIS 관련사업 분석 : 관련사업 입지분석
	public static final String WEB_ANAL_RELATED_BIZ = WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_BIZ_ROOT + DELEMETER + "relatedBiz" + REQUEST_SUBFIX_C;
	public static final String WEB_ANAL_RELATED_BIZ_CONTENT = WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_BIZ_ROOT + DELEMETER + "relatedBizContent" + REQUEST_SUBFIX_C;
	// WEB ANALYSIS 관련사업 분석 : 버퍼 중첩 분석WEB_ANAL_QUEST_STAT
	public static final String WEB_ANAL_BUFFER_BIZ = WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_BIZ_ROOT + DELEMETER + "bufferInter" + REQUEST_SUBFIX_C;
	// WEB ANALYSIS 관련사업 분석 : 네트워크 중첩 분석
	public static final String WEB_ANAL_NETWORK_BIZ =  WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_BIZ_ROOT + DELEMETER + "network" + REQUEST_SUBFIX_C;
	// WEB ANALYSIS 관련사업 분석 : 네트워크 중첩 분석 (화면?)
	public static final String WEB_ANAL_NETWORK_BIZ_CONTENT =  WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_BIZ_ROOT + DELEMETER + "networkOverlapContent" + REQUEST_SUBFIX_C;

	// 대상지
	// WEB ANALYSIS 대상지 탐색(통계)
	public static final String WEB_ANAL_QUEST_STAT = WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_QUEST_ROOT + DELEMETER + "statistics" + REQUEST_SUBFIX_C;
	public static final String WEB_ANAL_DESTINATION_CONTENT = WEB_ROOT + ANALYSIS_ROOT + DELEMETER + "destinationContent" + REQUEST_SUBFIX_C;

	// 개발 행위 제한
	// WEB ANALYSIS 개발행위 가능 분석 : 경사도 분석
	public static final String WEB_ANAL_DEV_SLOPE		= WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_DEV_ROOT + DELEMETER + "slope" + REQUEST_SUBFIX_C;
	public static final String WEB_ANAL_DEV_SLOPE_CONTENT		= WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_DEV_ROOT + DELEMETER + "slopeContent" + REQUEST_SUBFIX_C;
	// WEB ANALYSIS 개발행위 가능 분석 : 경사도 분석 결과
	public static final String WEB_ANAL_DEV_SLOPE_RESULT		= WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_DEV_ROOT + DELEMETER + "slopeResult" + REQUEST_SUBFIX_C;
	public static final String WEB_ANAL_DEV_SLOPE_RESULT_CONTENT		= WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_DEV_ROOT + DELEMETER + "slopeResultContent" + REQUEST_SUBFIX_C;
	// WEB ANALYSIS 개발행위 가능 분석 : 개발행위 가능지역
	public static final String WEB_ANAL_DEV_AVAIL_RESULT		= WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_DEV_ROOT + DELEMETER + "availResult" + REQUEST_SUBFIX_C;
	public static final String WEB_ANAL_DEV_ANAL_CONTENT		= WEB_ROOT + ANALYSIS_ROOT + ANALYSIS_DEV_ROOT + DELEMETER + "analContent" + REQUEST_SUBFIX_C;
	
}
