package egovframework.zaol.gisinfo.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

public interface GisinfoService {

	public List pCode_list(HashMap vo) throws SQLException;			/* 공통 - 부모 코드 조회 */
	public List sCode_list(HashMap vo) throws SQLException;			/* 공통 - 자식 코드 조회 */ 
		
	public List sido_list(GisBasicVO vo) throws SQLException;			/* 시도 리스트 조회 */
    public List sig_list(GisBasicVO vo) throws SQLException;			/* 시군구 리스트 조회 */
    public List emd_list(GisBasicVO vo) throws SQLException;			/* 읍면동 리스트 조회 */

    public List gb02_list(GisBasicVO vo) throws SQLException;			/* 중분류 리스트 조회 */
    public List gb03_list(GisBasicVO vo) throws SQLException;			/* 소분류 리스트 조회 */

    public List gis_code_list(GisBasicVO vo) throws SQLException;		/* GIS코드 리스트 조회 */

    public List gis_search_bookmark(GisBasicVO vo) throws SQLException;		/* GIS즐겨찾기 조회 */
    public void gis_insert_bookmark(GisBasicVO vo) throws SQLException;		/* GIS즐겨찾기 등록 */
    public int gis_update_bookmark(GisBasicVO vo) throws SQLException;			/* GIS검색항목 수정 */
    public void gis_delete_bookmark(GisBasicVO vo) throws SQLException;		/* GIS즐겨찾기 삭제 */

    public List search_coordnate_land(GisBasicVO vo) throws SQLException;		/* click정보조회 - 토지 */
    public List search_coordnate_buld(GisBasicVO vo) throws SQLException;		/* click정보조회 - 건물 */

    public List gis_search_land_list					(GisBasicVO vo) throws SQLException;	/* 자산검색 - 토지 */
    public List gis_search_land_list_guk_land			(GisBasicVO vo) throws SQLException;
    public List gis_search_land_list_tmseq_land			(GisBasicVO vo) throws SQLException;
    public List gis_search_land_list_region_land		(GisBasicVO vo) throws SQLException;
    public List gis_search_land_list_owned_city			(GisBasicVO vo) throws SQLException;
    public List gis_search_land_list_owned_guyu			(GisBasicVO vo) throws SQLException;
    public List gis_search_land_list_residual_land		(GisBasicVO vo) throws SQLException;
    public List gis_search_land_list_unsold_land		(GisBasicVO vo) throws SQLException;
    public List gis_search_land_list_invest				(GisBasicVO vo) throws SQLException;
    public List gis_search_land_list_public_site		(GisBasicVO vo) throws SQLException;
    public List gis_search_land_list_public_parking		(GisBasicVO vo) throws SQLException;
    public List gis_search_land_list_generations		(GisBasicVO vo) throws SQLException;
    public List gis_search_land_list_council_land		(GisBasicVO vo) throws SQLException;
    public List gis_search_land_list_minuse				(GisBasicVO vo) throws SQLException;
    public List gis_search_land_list_industry			(GisBasicVO vo) throws SQLException;
    public List gis_search_land_list_priority			(GisBasicVO vo) throws SQLException;

    public List gis_search_buld_list					(GisBasicVO vo) throws SQLException;	/* 자산검색 - 건물 */
    public List gis_search_buld_list_guk_buld			(GisBasicVO vo) throws SQLException;
    public List gis_search_buld_list_tmseq_buld			(GisBasicVO vo) throws SQLException;
    public List gis_search_buld_list_region_buld		(GisBasicVO vo) throws SQLException;
    public List gis_search_buld_list_owned_region		(GisBasicVO vo) throws SQLException;
    public List gis_search_buld_list_owned_seoul		(GisBasicVO vo) throws SQLException;
    public List gis_search_buld_list_cynlst				(GisBasicVO vo) throws SQLException;
    public List gis_search_buld_list_public_buld_a		(GisBasicVO vo) throws SQLException;
    public List gis_search_buld_list_public_buld_b		(GisBasicVO vo) throws SQLException;
    public List gis_search_buld_list_public_buld_c		(GisBasicVO vo) throws SQLException;
    public List gis_search_buld_list_public_asbu		(GisBasicVO vo) throws SQLException;
    public List gis_search_buld_list_purchase			(GisBasicVO vo) throws SQLException;
    public List gis_search_buld_list_declining			(GisBasicVO vo) throws SQLException;

    public List gis_search_dist_list					(GisBasicVO vo) throws SQLException;	/* 자산검색 - 사업지구 */
    public List gis_search_dist_list_residual			(GisBasicVO vo) throws SQLException;
    public List gis_search_dist_list_unsold				(GisBasicVO vo) throws SQLException;

    /* 자산검색 상세정보 -토지  */
    public List gis_land_detail_1(GisBasicVO vo) throws SQLException;
    public List gis_land_detail_2(GisBasicVO vo) throws SQLException;
    public List gis_land_detail_3(GisBasicVO vo) throws SQLException;
    public List gis_land_detail_4(GisBasicVO vo) throws SQLException;

    /* 자산검색 상세정보 -건물  */
    public List gis_buld_detail_1(GisBasicVO vo) throws SQLException;
    public List gis_buld_detail_2(GisBasicVO vo) throws SQLException;
    public List gis_buld_detail_3(GisBasicVO vo) throws SQLException;

    /* 자산검색 상세정보 -사업지구 */
    public List gis_dist_detail_1(GisBasicVO vo) throws SQLException;
    public List gis_dist_detail_2(GisBasicVO vo) throws SQLException;
    public List gis_dist_detail_3(GisBasicVO vo) throws SQLException;

    /* 자산검색 상세정보 -자산정보  */
    public List gis_sh_detail_guk_land			(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_tmseq_land		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_region_land		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_owned_city		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_owned_guyu		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_residual_land		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_unsold_land		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_invest			(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_public_site		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_public_parking	(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_generations		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_council_land		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_minuse			(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_industry			(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_priority			(GisBasicVO vo) throws SQLException;

    public List gis_sh_detail_guk_buld			(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_tmseq_buld		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_region_buld		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_owned_region		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_owned_seoul		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_cynlst			(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_public_buld_a		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_public_buld_b		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_public_buld_c		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_public_asbu		(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_purchase			(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_declining			(GisBasicVO vo) throws SQLException;

    public List gis_sh_detail_residual			(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_unsold				(GisBasicVO vo) throws SQLException;

    /* 자산검색 상세정보 -관련사업정보  */
    public List gis_data_detail_1(GisBasicVO vo) throws SQLException;	 //도시재생활정화지역
    public List gis_data_detail_2(GisBasicVO vo) throws SQLException;   //주거환경관리사업
    public List gis_data_detail_3(GisBasicVO vo) throws SQLException;   //희망지
    public List gis_data_detail_4(GisBasicVO vo) throws SQLException;   //해제구역
    public List gis_data_detail_5(GisBasicVO vo) throws SQLException;   //도시재생쇠퇴지역
    public List gis_data_detail_6(GisBasicVO vo) throws SQLException;   //대중교통역세권


    /* 데이터추출  */
    public List gis_data_comment(GisBasicVO vo) throws SQLException; //컬럼정보
    public List gis_data_attr_land(GisBasicVO vo) throws SQLException; //데이터정보
    public List gis_data_attr_build(GisBasicVO vo) throws SQLException; //데이터정보


    /* 워드만들기  */
    public List gis_data_word1(GisBasicVO vo) throws SQLException;
    public List gis_data_word2(GisBasicVO vo) throws SQLException;
    public List gis_data_word3(GisBasicVO vo) throws SQLException;








    /* 자산검색 상세정보 -국유 일반재산(캠코) 등록 */
    public void gis_insert_guk_land(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -도시재생활정화지역 등록 */
    public void gis_city_activation(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -임대주택일반관리현황 등록 */
    public void gis_council_land(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -재난위험건축물 등록 */
    public void gis_insert_cynlst(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -노후매입임대 등록 */
    public void gis_insert_declining(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -역세권사업 후보지 등록 */
    public void gis_insert_generations(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -희망지 등록 */
    public void gis_insert_hope_land(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -주거환경관리사업 등록 */
    public void gis_insert_house_envment(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -공공부지 혼재지역 등록 */
    public void gis_insert_industry(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -저이용 공공시설 등록 */
    public void gis_insert_minuse(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -자치구 보유관리토지(시유지) 등록 */
    public void gis_insert_owned_city(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -자치구 홈페이지 (현황참고) 등록 */
    public void gis_insert_owned_consult(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -자치구 구유지 등록 */
    public void gis_insert_owned_guyu(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -중점활용 시유지 등록 */
    public void gis_insert_priority(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -공공건축물 등록 */
    public void gis_insert_buld_c(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -공영주차장전체 등록 */
    public void gis_insert_parking(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -공공기관 이전부지 등록 */
    public void gis_insert_public_site(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -대중교통역세권 등록 */
    public void gis_insert_transport(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -매입임대 등록 */
    public void gis_insert_purchase(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -자치구위임관리 시유지 */
    public void gis_insert_region_land(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -해제구역 등록 */
    public void gis_insert_release_area(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -위탁관리 시유지 등록 */
    public void gis_insert_tmseq_land(GisBasicVO vo) throws SQLException;

    /* 자산검색 상세정보 -국유 일반재산(캠코) 이력 등록 */
    public void gis_insert_guk_land_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -도시재생활정화지역 이력 등록 */
    public void gis_city_activation_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -임대주택일반관리현황 이력 등록 */
    public void gis_council_land_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -재난위험건축물 이력 등록 */
    public void gis_insert_cynlst_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -노후매입임대 이력 등록 */
    public void gis_insert_declining_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -역세권사업 후보지 이력 등록 */
    public void gis_insert_generations_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -희망지 이력 등록 */
    public void gis_insert_hope_land_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -주거환경관리사업 이력 등록 */
    public void gis_insert_house_envment_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -공공부지 혼재지역 이력 등록 */
    public void gis_insert_industry_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -저이용 공공시설 이력 등록 */
    public void gis_insert_minuse_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -자치구 보유관리토지(시유지) 이력 등록 */
    public void gis_insert_owned_city_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -자치구 홈페이지 (현황참고) 이력 등록 */
    public void gis_insert_owned_consult_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -자치구 구유지 이력 등록 */
    public void gis_insert_owned_guyu_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -중점활용 시유지 이력 등록 */
    public void gis_insert_priority_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -공공건축물 이력 등록 */
    public void gis_insert_buld_c_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -공영주차장전체 이력 등록 */
    public void gis_insert_parking_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -공공기관 이전부지 이력 등록 */
    public void gis_insert_public_site_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -대중교통역세권 이력 등록 */
    public void gis_insert_transport_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -매입임대 이력 등록 */
    public void gis_insert_purchase_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -자치구위임관리 시유지 */
    public void gis_insert_region_land_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -해제구역 이력 등록 */
    public void gis_insert_release_area_hist(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -위탁관리 시유지 이력 등록 */
    public void gis_insert_tmseq_land_hist(GisBasicVO vo) throws SQLException;


    /* 자산검색 상세정보 -국유 일반재산(캠코) 삭제 */
    public int gis_delete_guk_land(GisBasicVO vo) throws SQLException;
    public GisBasicVO selectShData(GisBasicVO vo) throws SQLException;
    /* 자산검색 상세정보 -이력조회*/
    public List selectSHhist(GisBasicVO vo) throws SQLException;
    public List gis_sh_detail_comment_hist(GisBasicVO vo) throws SQLException;
    public List jibun_list(HashMap vo) throws SQLException;			/* 지번 리스트 조회 */
    
    public String search_coordnate(GisBasicVO vo) throws SQLException;		/* pnu를 통한 geom 조회 */
    
    //속성검색 > 건축물검색 리스트 조회
    public List search_build_list(GisBasicVO vo) throws SQLException;
    
    //속성검색 > 건축물검색 상세정보 조회 - 가격정보(공시지가/개별주택가격/공동주택가격)
    public HashMap search_price_detail(GisBasicVO vo) throws SQLException;
    
    //속성검색 > 건축물검색 상세정보 조회 - 개별공시지가
    public List search_price_pnilp(GisBasicVO vo) throws SQLException;
    //속성검색 > 건축물검색 상세정보 조회 - 개별주택가격
    public List search_price_indvdlz_house(GisBasicVO vo) throws SQLException;
}