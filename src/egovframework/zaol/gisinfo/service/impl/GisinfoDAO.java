package egovframework.zaol.gisinfo.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import org.springframework.stereotype.Repository;
import egovframework.zaol.common.OracleDAO;
import egovframework.zaol.gisinfo.service.GisBasicVO;

@Repository("gisinfoDAO")
public class GisinfoDAO extends OracleDAO {

	public List pCode_list(HashMap vo) throws SQLException{ return list("gisinfoDAO.pCode_list" , vo); } 	/* 공통 - 부모 코드 조회 */
	public List sCode_list(HashMap vo) throws SQLException{ return list("gisinfoDAO.sCode_list" , vo); }	/* 공통 - 자식 코드 조회 */
	public List sido_list(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.sido_list" , vo); } //시도 리스트 조회

    public List sig_list(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.sig_list" , vo); }
    public List emd_list(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.emd_list" , vo); }
    public List jibun_list(HashMap vo) throws SQLException{ return list("gisinfoDAO.jibun_list" , vo); }

    public List gb02_list(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gb02_list" , vo); }
    public List gb03_list(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gb03_list" , vo); }

    public List gis_code_list(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_code_list" , vo); }

    public List gis_search_bookmark		(GisBasicVO vo) throws SQLException { return 	list("gisinfoDAO.gis_search_bookmark" , vo); }
    public void gis_insert_bookmark     (GisBasicVO vo) throws SQLException { 			insert("gisinfoDAO.gis_insert_bookmark", vo); }
    public int gis_update_bookmark		(GisBasicVO vo) throws SQLException { return	update("gisinfoDAO.gis_update_bookmark", vo); }
    public void gis_delete_bookmark		(GisBasicVO vo) throws SQLException { 			delete("gisinfoDAO.gis_delete_bookmark", vo); }

    public List search_coordnate_land		(GisBasicVO vo) throws SQLException { return 	list("gisinfoDAO.search_coordnate_land" , vo); }
    public List search_coordnate_buld		(GisBasicVO vo) throws SQLException { return 	list("gisinfoDAO.search_coordnate_buld" , vo); }

    public List gis_search_land_list					(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list" , vo);    }
    public List gis_search_land_list_guk_land			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list_guk_land" , vo);    }
    public List gis_search_land_list_tmseq_land			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list_tmseq_land" , vo);    }
    public List gis_search_land_list_region_land		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list_region_land" , vo);    }
    public List gis_search_land_list_owned_city			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list_owned_city" , vo);    }
    public List gis_search_land_list_owned_guyu			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list_owned_guyu" , vo);    }
    public List gis_search_land_list_residual_land		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list_residual_land" , vo);    }
    public List gis_search_land_list_unsold_land		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list_unsold_land" , vo);    }
    public List gis_search_land_list_invest				(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list_invest" , vo);    }
    public List gis_search_land_list_public_site		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list_public_site" , vo);    }
    public List gis_search_land_list_public_parking		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list_public_parking" , vo);    }
    public List gis_search_land_list_generations		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list_generations" , vo);    }
    public List gis_search_land_list_council_land		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list_council_land" , vo);    }
    public List gis_search_land_list_minuse				(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list_minuse" , vo);    }
    public List gis_search_land_list_industry			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list_industry" , vo);    }
    public List gis_search_land_list_priority			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_land_list_priority" , vo);    }

    public List gis_search_buld_list					(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_buld_list" , vo);    }
    public List gis_search_buld_list_guk_buld			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_buld_list_guk_buld" , vo);    }
    public List gis_search_buld_list_tmseq_buld			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_buld_list_tmseq_buld" , vo);    }
    public List gis_search_buld_list_region_buld		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_buld_list_region_buld" , vo);    }
    public List gis_search_buld_list_owned_region		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_buld_list_owned_region" , vo);    }
    public List gis_search_buld_list_owned_seoul		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_buld_list_owned_seoul" , vo);    }
    public List gis_search_buld_list_cynlst				(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_buld_list_cynlst" , vo);    }
    public List gis_search_buld_list_public_buld_a		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_buld_list_public_buld_a" , vo);    }
    public List gis_search_buld_list_public_buld_b		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_buld_list_public_buld_b" , vo);    }
    public List gis_search_buld_list_public_buld_c		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_buld_list_public_buld_c" , vo);    }
    public List gis_search_buld_list_public_asbu		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_buld_list_public_asbu" , vo);    }
    public List gis_search_buld_list_purchase			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_buld_list_purchase" , vo);    }
    public List gis_search_buld_list_declining			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_buld_list_declining" , vo);    }

    public List gis_search_dist_list					(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_dist_list" , vo);    }
    public List gis_search_dist_list_residual			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_dist_list_residual" , vo);    }
    public List gis_search_dist_list_unsold				(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_search_dist_list_unsold" , vo);    }

    public List gis_land_detail_1(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_land_detail_1" , vo); }
    public List gis_land_detail_2(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_land_detail_2" , vo); }
    public List gis_land_detail_3(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_land_detail_3" , vo); }
    public List gis_land_detail_4(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_land_detail_4" , vo); }

    public List gis_buld_detail_1(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_buld_detail_1" , vo); }
    public List gis_buld_detail_2(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_buld_detail_2" , vo); }
    public List gis_buld_detail_3(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_buld_detail_3" , vo); }

    public List gis_dist_detail_1(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_dist_detail_1" , vo); }
    public List gis_dist_detail_2(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_dist_detail_2" , vo); }
    public List gis_dist_detail_3(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_dist_detail_3" , vo); }

    public List gis_sh_detail_guk_land			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_guk_land" , vo);    }
    public List gis_sh_detail_tmseq_land		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_tmseq_land" , vo);    }
    public List gis_sh_detail_region_land		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_region_land" , vo);    }
    public List gis_sh_detail_owned_city		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_owned_city" , vo);    }
    public List gis_sh_detail_owned_guyu		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_owned_guyu" , vo);    }
    public List gis_sh_detail_residual_land		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_residual_land" , vo);    }
    public List gis_sh_detail_unsold_land		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_unsold_land" , vo);    }
    public List gis_sh_detail_invest			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_invest" , vo);    }
    public List gis_sh_detail_public_site		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_public_site" , vo);    }
    public List gis_sh_detail_public_parking	(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_public_parking" , vo);    }
    public List gis_sh_detail_generations		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_generations" , vo);    }
    public List gis_sh_detail_council_land		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_council_land" , vo);    }
    public List gis_sh_detail_minuse			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_minuse" , vo);    }
    public List gis_sh_detail_industry			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_industry" , vo);    }
    public List gis_sh_detail_priority			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_priority" , vo);    }
    public List gis_sh_detail_guk_buld			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_guk_buld" , vo);    }
    public List gis_sh_detail_tmseq_buld		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_tmseq_buld" , vo);    }
    public List gis_sh_detail_region_buld		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_region_buld" , vo);    }
    public List gis_sh_detail_owned_region		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_owned_region" , vo);    }
    public List gis_sh_detail_owned_seoul		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_owned_seoul" , vo);    }
    public List gis_sh_detail_cynlst			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_cynlst" , vo);    }
    public List gis_sh_detail_public_buld_a		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_public_buld_a" , vo);    }
    public List gis_sh_detail_public_buld_b		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_public_buld_b" , vo);    }
    public List gis_sh_detail_public_buld_c		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_public_buld_c" , vo);    }
    public List gis_sh_detail_public_asbu		(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_public_asbu" , vo);    }
    public List gis_sh_detail_purchase			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_purchase" , vo);    }
    public List gis_sh_detail_declining			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_declining" , vo);    }
    public List gis_sh_detail_residual			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_residual" , vo);    }
    public List gis_sh_detail_unsold			(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_unsold" , vo);    }
    public List gis_data_detail_1(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_data_detail_1" , vo); }
    public List gis_data_detail_2(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_data_detail_2" , vo); }
    public List gis_data_detail_3(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_data_detail_3" , vo); }
    public List gis_data_detail_4(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_data_detail_4" , vo); }
    public List gis_data_detail_5(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_data_detail_5" , vo); }
    public List gis_data_detail_6(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_data_detail_6" , vo); }



    public List gis_data_comment(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_data_comment" , vo); }
    public List gis_data_attr_land(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_data_attr_land" , vo); }
    public List gis_data_attr_build(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_data_attr_build" , vo); }

    public List gis_data_word1(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_data_word1" , vo); }
    public List gis_data_word2(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_data_word2" , vo); }
    public List gis_data_word3(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_data_word3" , vo); }





    // 저장
    public void gis_insert_guk_land	(GisBasicVO vo) throws SQLException{insert("gisinfoDAO.gis_insert_guk_land", vo);}
    public void gis_city_activation(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_city_activation", vo);}
    public void gis_council_land(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_council_land", vo);}
    public void gis_insert_cynlst(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_cynlst", vo);}
    public void gis_insert_declining(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_declining", vo);}
    public void gis_insert_generations(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_generations", vo);}
    public void gis_insert_hope_land(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_hope_land", vo);}
    public void gis_insert_house_envment(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_house_envment", vo);}
    public void gis_insert_industry(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_industry", vo);}
    public void gis_insert_minuse(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_minuse", vo);}
    public void gis_insert_owned_city(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_owned_city", vo);}
    public void gis_insert_owned_consult(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_owned_consult", vo);}
    public void gis_insert_owned_guyu(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_owned_guyu", vo);}
    public void gis_insert_priority(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_priority", vo);}
    public void gis_insert_buld_c(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_buld_c", vo);}
    public void gis_insert_parking(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_parking", vo);}
    public void gis_insert_public_site(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_public_site", vo);}
    public void gis_insert_transport(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_transport", vo);}
    public void gis_insert_purchase(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_purchase", vo);}
    public void gis_insert_region_land(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_region_land", vo);}
    public void gis_insert_release_area(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_release_area", vo);}
    public void gis_insert_tmseq_land(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_tmseq_land", vo);}

    // 이력저장
    public void gis_insert_guk_land_hist	(GisBasicVO vo) throws SQLException{insert("gisinfoDAO.gis_insert_guk_land_hist", vo);}
    public void gis_city_activation_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_city_activation_hist", vo);}
    public void gis_council_land_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_council_land_hist", vo);}
    public void gis_insert_cynlst_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_cynlst_hist", vo);}
    public void gis_insert_declining_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_declining_hist", vo);}
    public void gis_insert_generations_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_generations_hist", vo);}
    public void gis_insert_hope_land_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_hope_land_hist", vo);}
    public void gis_insert_house_envment_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_house_envment_hist", vo);}
    public void gis_insert_industry_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_industry_hist", vo);}
    public void gis_insert_minuse_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_minuse_hist", vo);}
    public void gis_insert_owned_city_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_owned_city_hist", vo);}
    public void gis_insert_owned_consult_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_owned_consult_hist", vo);}
    public void gis_insert_owned_guyu_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_owned_guyu_hist", vo);}
    public void gis_insert_priority_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_priority_hist", vo);}
    public void gis_insert_buld_c_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_buld_c_hist", vo);}
    public void gis_insert_parking_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_parking_hist", vo);}
    public void gis_insert_public_site_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_public_site_hist", vo);}
    public void gis_insert_transport_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_transport_hist", vo);}
    public void gis_insert_purchase_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_purchase_hist", vo);}
    public void gis_insert_region_land_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_region_land_hist", vo);}
    public void gis_insert_release_area_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_release_area_hist", vo);}
    public void gis_insert_tmseq_land_hist(GisBasicVO vo) throws SQLException {insert("gisinfoDAO.gis_insert_tmseq_land_hist", vo);}

    // 삭제
    public int gis_delete_guk_land(GisBasicVO vo) throws SQLException{ return 	update("gisinfoDAO.gis_delete_guk_land" , vo); }
    public GisBasicVO selectShData(GisBasicVO vo) throws SQLException{ return (GisBasicVO) selectByPk("gisinfoDAO.selectShData", vo);}

    //상세
	public List selectSHhist(GisBasicVO vo) throws SQLException{  return list("gisinfoDAO.selectSHhist", vo);}

	// 이력보기
	public List gis_sh_detail_comment_hist(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.gis_sh_detail_comment_hist" , vo); }
	
	//pnu를 통한 geom조회
	 public String search_coordnate		(GisBasicVO vo) throws SQLException { return 	(String) selectByPk("gisinfoDAO.search_coordnate" , vo); }
	//속성검색 > 건축물검색 리스트 조회
	public List search_build_list(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.search_build_list" , vo); }  
	
	//속성검색 > 건축물검색 상세정보 조회 - 개별공시지가
	public List search_price_pnilp(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.search_price_pnilp" , vo); }   
	//속성검색 > 건축물검색 상세정보 조회 - 개별주택가격
	public List search_price_indvdlz_house(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.search_price_indvdlz_house" , vo); }   
	//속성검색 > 건축물검색 상세정보 조회 - 공동주택가격
	public List search_price_copertn_house(GisBasicVO vo) throws SQLException{ return list("gisinfoDAO.search_price_copertn_house" , vo); }   
}