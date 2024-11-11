package egovframework.zaol.gisinfo.service;

import java.io.Serializable;

import egovframework.zaol.ad.boardmaster.service.BoardMDefaultVO;

public class GisBasicVO extends BoardMDefaultVO implements Serializable {

	//공통-------------------------------------------------------------------	
	//20240807 LEK 추가
	public String pCode; //부모코드
	public String pLabel; //부모코드명
	public String sCode; //자식코드
	public String sLabel; //자식코드명
	
	public String sido_cd;		//시도코드
	public String sido_kor_nm;	//시도코드명
	
	//속성검색 > 건축물검색에 사용
	public String compet_de;			//사용승인일
	public String fs_setBuldSe;			//집합건축물 구분
	public String fs_mainPrpos;			//주용도명
	public String[] fs_subPrpos;		//세부용도명
	public String num_parea_1;			//건물 대지면적
	public String num_parea_2;			//건물 대지면적 
	public String num_barea_1;			//건물 건축면적
	public String num_barea_2;			//건물 건축면적 
	public String num_far_1;			//용적률
	public String num_far_2;			//용적률
	public String num_bcr_1;			//건폐율
	public String num_bcr_2;			//건폐율
	
	
	public String getCompet_de() {
		return compet_de;
	}
	public void setCompet_de(String compet_de) {
		this.compet_de = compet_de;
	}
	public String getFs_setBuldSe() {
		return fs_setBuldSe;
	}
	public void setFs_setBuldSe(String fs_setBuldSe) {
		this.fs_setBuldSe = fs_setBuldSe;
	}
	public String getFs_mainPrpos() {
		return fs_mainPrpos;
	}
	public void setFs_mainPrpos(String fs_mainPrpos) {
		this.fs_mainPrpos = fs_mainPrpos;
	}
	public String[] getFs_subPrpos() {
		return fs_subPrpos;
	}
	public void setFs_subPrpos(String[] fs_subPrpos) {
		this.fs_subPrpos = fs_subPrpos;
	}
	
	public String getNum_parea_1() {
		return num_parea_1;
	}
	public void setNum_parea_1(String num_parea_1) {
		this.num_parea_1 = num_parea_1;
	}
	public String getNum_parea_2() {
		return num_parea_2;
	}
	public void setNum_parea_2(String num_parea_2) {
		this.num_parea_2 = num_parea_2;
	}
	public String getNum_barea_1() {
		return num_barea_1;
	}
	public void setNum_barea_1(String num_barea_1) {
		this.num_barea_1 = num_barea_1;
	}
	public String getNum_barea_2() {
		return num_barea_2;
	}
	public void setNum_barea_2(String num_barea_2) {
		this.num_barea_2 = num_barea_2;
	}
	public String getNum_far_1() {
		return num_far_1;
	}
	public void setNum_far_1(String num_far_1) {
		this.num_far_1 = num_far_1;
	}
	public String getNum_far_2() {
		return num_far_2;
	}
	public void setNum_far_2(String num_far_2) {
		this.num_far_2 = num_far_2;
	}
	public String getNum_bcr_1() {
		return num_bcr_1;
	}
	public void setNum_bcr_1(String num_bcr_1) {
		this.num_bcr_1 = num_bcr_1;
	}
	public String getNum_bcr_2() {
		return num_bcr_2;
	}
	public void setNum_bcr_2(String num_bcr_2) {
		this.num_bcr_2 = num_bcr_2;
	}
	public String getpCode() {
		return pCode;
	}
	public void setpCode(String pCode) {
		this.pCode = pCode;
	}
	public String getpLabel() {
		return pLabel;
	}
	public void setpLabel(String pLabel) {
		this.pLabel = pLabel;
	}
	public String getsCode() {
		return sCode;
	}
	public void setsCode(String sCode) {
		this.sCode = sCode;
	}
	public String getsLabel() {
		return sLabel;
	}
	public void setsLabel(String sLabel) {
		this.sLabel = sLabel;
	}
	
	public String getSido_cd() {
		return sido_cd;
	}
	public void setSido_cd(String sido_cd) {
		this.sido_cd = sido_cd;
	}
	public String getSido_kor_nm() {
		return sido_kor_nm;
	}
	public void setSido_kor_nm(String sido_kor_nm) {
		this.sido_kor_nm = sido_kor_nm;
	}
	
	//
	


	public String[] gb;		//자산구분 - 필수항목
	public String getSn() {
		return sn;
	}
	public void setSn(String sn) {
		this.sn = sn;
	}
	public String gbname;	//자산구분(건물-직접입력) - 필수항목
	public String pnu;
	public String pk;
	public String kind;	
	public String sh_kind;
	public String coord_x;
	public String coord_y;
	
	//즐겨찾기
	public String user_id;
	public String bookmark_nm;
	public String use_at;
	public String regist_dt;	
	public String cnt_kind;
	public String sn;
	
	public String sig;  
	public String emd;  
	public String li;
	public String bobn;
	public String bubn;
	
	public String gid;
	public String outher;
	
	public String updtid;
	public String dmlcn;
	
	
	private String pagesize;
	private String pageindex;
	
	
	//토지-------------------------------------------------------------------	
	//연속지적도형정보 - SHP (sn_ccmdi_xx)	      
	//지적도 - SHP (lp_pa_cbnd_xx)
	
	//개별공시지가 (sn_idp_xx)
	public String pnilp_1;		//개별공시지가(MIN)
	public String pnilp_2;		//개별공시지가(MAX)
	
	//개별공시지가 토지특성정보관리 (sn_apmm_nv_land_xx)
	public String[] jimok;		//지목
	public String parea_1;		//면적(MIN)
	public String parea_2;		//면적(MAX)
	public String[] spfc;		//용도지역
	public String[] land_use;	//토지이용상황
	public String[] geo_hl;		//지형고저
	public String[] geo_form;	//지형형상
	public String[] road_side;	//도로접면
	
	//토지임야정보 (sn_land_kind_xx)
	public String[] prtown;		//소유구분
	
	//표준공시지가 (sn_land_olnlp_xx)	 -- 사용안함 (14만/92만 데이터 보유)
	public String[] spcfc;		//용도지구
	public String cnflc_1;		//저촉율(MIN)
	public String cnflc_2;		//저촉율(MAX)
	
	//토지소유정보 (sn_land_use_xx)
	
	//UNION Data Table
	public String guk_land;					//국유지일반재산(캠코)토지		
	public String[] guk_land_value;			//국유지일반재산(캠코)토지 : 관리상태
	public String guk_land_01; 
	public String guk_land_02; 
	public String guk_land_03; 
	public String guk_land_04;
	public String tmseq_land;				//위탁관리 시유지
	public String[] tmseq_land_value;		//위탁관리 시유지 : 관리상태
	public String tmseq_land_01;
	public String tmseq_land_02;
	public String region_land;				//자치구위임관리 시유지	
	public String owned_consult;			//자치구 보유관리토지(현황참조)
	public String owned_city;				//자치구 보유관리토지(시유지)
	public String[] owned_city_value;		//자치구 보유관리토지(시유지) : 재산종류
	public String owned_city_01;
	public String owned_city_02;	
	public String owned_guyu;				//자치구 보유관리토지(구유지)
	public String[] owned_guyu_value;		//자치구 보유관리토지(구유지) : 재산용도코드
	public String owned_guyu_01;
	public String owned_guyu_02;
	public String residual_land;			//SH잔여지 --보류
	public String unsold_land;				//SH미매각지 --데이터 없음
	public String invest;					//SH현물출자 --보류
	public String public_site;				//공공기관 이전부지
	public String public_parking;			//공영주차장
	public String generations;				//역세권사업 후보지
	public String[] generations_value;		//역세권사업 후보지 : 사업구분
	public String council_land;				//임대주택 단지
	public String minuse;					//저이용공공시설
	public String industry;					//공공부지 혼재지역
	public String priority;					//중점활용 시유지
	
	
	
	//건물-------------------------------------------------------------------	
	//도로명주소 건물 - SHP  (tl_spbd_buld)
	//GIS건물통합정보 - SHP  (sn_gis_bims_su)
	
	//건축물대장(집합) - 총괄표제부 (sn_dboh) + 전유부 (sn_bdfc)
	public String buld_nm;		//건물명	
	public String[] prpos;		//용도
	public String bildng_ar_1;	//건축면적(MIN)
	public String bildng_ar_2;	//건축면적(MAX)
	public String totar_1;		//연면적(MIN)
	public String totar_2;		//연면적(MAX)
	public String plot_ar_1;	//대지면적(MIN)
	public String plot_ar_2;	//대지면적(MAX)
	public String bdtldr_1;		//건폐율(MIN)
	public String bdtldr_2;		//건폐율(MAX)
	public String cpcty_rt_1;	//용적률(MIN)
	public String cpcty_rt_2;	//용적률(MAX)
	public String cp_date_1;	//건축년도(MIN)
	public String cp_date_2;	//건축년도(MAX)
	
	//건축물대장(일반) - 표제부 (sn_bdhd)
	public String[] strct;		//구조  -- 사용안함
	public String ground_1;		//지상층수(MIN) -- 사용안함
	public String ground_2;		//지상층수(MAX) -- 사용안함
	public String undgrnd_1;	//지하층수(MIN) -- 사용안함
	public String undgrnd_2;	//지하층수(MAX) -- 사용안함
	public String hg_1;			//높이(MIN) -- 사용안함
	public String hg_2;			//높이(MAX) -- 사용안함
	
	//UNION Data Table
	public String guk_buld;					//국유지일반재산(캠코)건물 --토지와 동일 테이블
	public String[] guk_buld_value;			//국유지일반재산(캠코)건물 : 관리상태
	public String guk_buld_01;
	public String guk_buld_02;
	public String guk_buld_03;
	public String guk_buld_04;
	public String tmseq_buld;				//위탁관리 건물 --작업중
	public String[] tmseq_buld_value;		//위탁관리 건물 : 관리상태  --작업중
	public String tmseq_buld_01;
	public String tmseq_buld_02;
	public String region_buld;				//자치구위임관리 건물 --토지와 동일 테이블
	public String owned_region;				//자치구 보유관리건물(자치구) --토지와 동일 테이블
	public String[] owned_region_value;		//위탁관리 건물 : 관리상태  --작업중
	public String owned_region_01;
	public String owned_region_02;
	public String owned_seoul;				//자치구 보유관리건물(서울시) --토지와 동일 테이블
	public String cynlst;					//재난위험시설 
	public String[] cynlst_value;			//재난위험시설
	public String cynlst_01;
	public String cynlst_02;
	public String public_buld_a;			//공공건축물(국공립)
	public String public_buld_b;			//공공건축물(서울시)
	public String public_buld_c;			//공공건축물(자치구)
	public String[] public_buld_a_value;	//공공건축물(국공립) : 조건?
	public String[] public_buld_b_value;	//공공건축물(서울시) : 조건?
	public String[] public_buld_c_value;	//공공건축물(자치구) : 조건?
	public String public_asbu;				//공공기관이전건물 --작업중
	public String purchase;					//매입임대
	public String declining;				//노후매입임대
	
	
	
	//사업지구-----------------------------------------------------------------	
	//사업지구  - SHP (sh_district)	      
		
	//사업지구 전체 일반 정보(sh_district_all)
	//사업지구 (sh_district)	
	public String[] soldout;		//판매구분
	public String[] sector;			//지구
	public String[] spkfc;			//용도지역
	public String[] fill_gb;		//단지구분
	public String[] useu;			//용도
	public String[] uses;			//세부용도
	public String sector_nm;		//필지번호
	public String solar_1;			//고시면적(MIN)
	public String solar_2;			//고시면적(MAX)
	public String hbdtldr_1;		//건폐율(MIN)
	public String hbdtldr_2;		//건폐율(MAX)
	public String hcpcty_rt_1;		//용적률(MIN)
	public String hcpcty_rt_2;		//용적률(MAX)
	public String hg_limit;			//높이제한
	public String taruse;			//지정용도
	public String soldkind;			//판매방법
	public String[] soldgb;			//판매여부
		
	
	//UNION Data Table
	public String residual;		//잔여지 --작업중
	public String unsold;		//미매각지 --작업중
	
	
	
	//공간분석---------------------------------------------------------------------	
	public String sel;							//분석기법 선택 --즐겨찾기용
	public String tar_layer;					//레이어 대상
	public String buffer;						//버퍼 범위
	
	public String[] city_activation;			//도시재생활정화지역 - 소분류(gid)
	public String[] city_activation_val;		//도시재생활정화지역 - 중분류(nm)
	public String[] house_envment;				//주거환경관리사업 - 소분류(gid)
	public String[] house_envment_val;			//주거환경관리사업 - 중분류(nm)
	public String[] hope_land;					//희망지 - 소분류(gid)
	public String[] hope_land_val;				//희망지 - 중분류(nm)
	public String[] release_area;				//해제구역 - 소분류(gid)
	public String[] release_area_val;			//해제구역 - 중분류(nm)	
	public String[] space_gb;
	public String[] space_gb_cd02;
	public String[] space_gb_cd03;
	
	public String[] sub_p_decline;				//도시재생쇠퇴지역(행정동) = 복합쇠퇴지역 ? - 소분류(gid)
	public String[] sub_p_decline_val;			//도시재생쇠퇴지역(행정동) = 복합쇠퇴지역 ? - 중분류(nm)
	public String sub_p_decline_gb;				//도시재생쇠퇴지역(행정동) = 복합쇠퇴지역 ? - 대분류(code)
	
	public String[] public_transport;			//대중교통역세권 - 소분류(gid)
	public String public_transport_val;			//대중교통역세권 - 중분류(nm)
	
	
	//도로명주소 기본도
//	tl_sprd_manage	도로구간
//	tl_spsb_statn	지하철 역사
//	tl_spbd_buld	건물
//	tl_scco_ctprvn	
//	tl_scco_sig	
//	tl_scco_emd	
	
	//표출용
//	sub_p_decline	도시재생쇠퇴지역(행정동)
	
//	sub_t_library	도서관 위치도
//	sub_t_park		공원 위치도
//	sub_t_pubchild	국공립 어린이집 위치도
//	sub_t_allchild	전체 어린이집 위치도
//	sub_t_sports	체육시설 위치도
//	sub_t_welfare	노인복지시설 위치도
	
//	sub_g_allchild	전체 어린이집 향유도
//	sub_g_library	도서관 향유도
//	sub_g_park		공원 향유도
//	sub_g_pubchild	국공립 어린이집 향유도
//	sub_g_sports	체육시설 향유도
//	sub_g_welfare	노인복지시설 향유도
//	sub_p_allchild	전체 어린이집 수요도
//	sub_p_library	도서관 수요도
//	sub_p_park		공원 수요도
//	sub_p_pubchild	국공립 어린이집 수요도
//	sub_p_sports	체육시설 수요도
//	sub_p_welfare	노인복지시설 수요도

	
	
	
	
	
	
	
	
	
	//공간분석---------------------------------------------------------------------
	// cjh 저장용 변수......최악 시발못해먹겠네
		public String objectid_1;
		public String objectid;
		public String id;
		public String shape_leng;
		public String shape_le_1;
		public String shape_area;
		public String id_1;
		public String gubun;
		public String area_name;
		public String business_type;
		public String seoul_type;
		public String jache_gu;
		public String location;
		public String area_space;
		public String choice_howto;
		public String total_money;
		public String business_date;
		public String execution_phase;
		public String a1;
		public String a2;
		public String a3;
		public String a4;
		public String a5;
		public String a6;
		public String a7;
		public String a8;
		public String a9;
		public String a10;
		public String a11;
		public String a12;
		public String a13;
		public String a14;
		public String a15;
		public String a16;
		public String a17;
		public String a18;
		public String a19;
		public String a20;
		public String a21;
		public String a22;
		public String a23;
		public String a24;
		public String a25;
		public String a26;
		public String a27;
		public String a28;
		public String a29;
		public String a30;
		public String a31;
		public String a32;
		public String a33;
		public String a34;
		public String a35;
		public String a36;
		public String a37;
		public String a38;
		public String a39;
		public String a40;
		public String a41;
		public String a42;
		public String a43;
		public String a44;
		public String a45;
		public String a46;
		public String a47;
		public String a48;
		public String a49;
		public String a50;
		public String a51;
		public String a52;
		public String a53;
		public String a54;
		public String a55;
		public String a56;
		public String a57;
		public String a58;
		public String a59;
		public String a60;
		public String a61;
		public String a62;
		public String a63;
		public String a64;
		public String a65;
		public String a66;
		public String a67;
		public String a68;
		public String a69;
		public String a70;
		public String a71;
		public String a72;
		public String a73;
		public String a74;
		public String a75;
		public String a76;
		public String area;
		public String newtown;
		public String relrease_cause;
		public String relrease_year;
		public String decline_index;
		public String charact;
		public String charact2;
		public String charact3;
		public String index_num;
		public String area_earth;
		public String choice;	
		public String execution_date;
		public String human_group;
		public String release_date;
		public String etc;
		public String jibun;
		public String bchk;
		public String row_id;
		public String stdmt;
		public String land_seqno;
		public String nb;
		public String fid_02_ji;
		public String fid_use;
		public String bigo;
		public String no;
		public String sisul_name;
		public String bigo_1;
		public String name;
		public String jibun_2;
		public String jimok_2;
		public String build_year;
		public String land_so;
		public String surface;
		public String stat_count;
		public String court_number;
		public String additional_n;
		public String si;
		public String do_cd;
		public String dong;
		public String m;
		public String jibun_1;
		public String jimok_n;
		public String own;
		public String pnu_1;
		public String focus_co;
		public String junglim;
		public String final_strok;
		public String pnu_12;
		public String use_stat;
		public String use_co;
		public String rn_cd;
		public String sig_cd;
		public String n_nb;
		public String gu;
		public String data_s;
		public String p_n;
		public String juso;
		public String note;
		public String l_juso;
		public String l_pnu;
		public String op;
		public String p_nb;
		public String l_gb;
		public String p_form;
		public String update;
		public String p_code;
		public String o_gb;
		public String o_gb_kor;
		public String t_nb;
		public String p_if;
		public String p_if_kor;
		public String pr_p_nb;
		public String pr_update;
		public String f_gb;
		public String f_gb_kor;
		public String nfo_gb;
		public String nfo_gb_k;
		public String wd_o_t;
		public String wd_c_t;
		public String we_o_t;
		public String we_c_t;
		public String hd_o_t;
		public String hd_c_t;
		public String f_d_syn;
		public String sat_f_gb;
		public String sat_f_kor;
		public String hd_f_gb;
		public String hd_f_kor;
		public String month_f;
		public String p_ad_nb;
		public String un_f;
		public String un_t;
		public String add_f;
		public String add_t;
		public String bus_un_f;
		public String bus_un_t;
		public String bus_add_t;
		public String b_add_f;
		public String d_max_f;
		public String kor_sub_nm;
		public String represen_num;
		public String subway;
		public String area_circle;
		public String represen_route;
		public String public_transpo;
		public String history;
		public String intersection;
		public String intersection_r;
		public String bus_jun;
		public String near_load;
		public String upis;
		public String load_size;
		public String bigo_release;
		public String gosi_num;	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
		
		
	
		public String getSh_kind() {
			return sh_kind;
		}
		public void setSh_kind(String sh_kind) {
			this.sh_kind = sh_kind;
		}
		public String getGid() {
			return gid;
		}
		public void setGid(String gid) {
			this.gid = gid;
		}
		public String getUpdtid() {
			return updtid;
		}
		public void setUpdtid(String updtid) {
			this.updtid = updtid;
		}
		public String getDmlcn() {
			return dmlcn;
		}
		public void setDmlcn(String dmlcn) {
			this.dmlcn = dmlcn;
		}
		public String getObjectid_1() {
			return objectid_1;
		}
		public void setObjectid_1(String objectid_1) {
			this.objectid_1 = objectid_1;
		}
		public String getObjectid() {
			return objectid;
		}
		public void setObjectid(String objectid) {
			this.objectid = objectid;
		}
		public String getId() {
			return id;
		}
		public void setId(String id) {
			this.id = id;
		}
		public String getShape_leng() {
			return shape_leng;
		}
		public void setShape_leng(String shape_leng) {
			this.shape_leng = shape_leng;
		}
		public String getShape_le_1() {
			return shape_le_1;
		}
		public void setShape_le_1(String shape_le_1) {
			this.shape_le_1 = shape_le_1;
		}
		public String getShape_area() {
			return shape_area;
		}
		public void setShape_area(String shape_area) {
			this.shape_area = shape_area;
		}
		public String getId_1() {
			return id_1;
		}
		public void setId_1(String id_1) {
			this.id_1 = id_1;
		}
		public String getGubun() {
			return gubun;
		}
		public void setGubun(String gubun) {
			this.gubun = gubun;
		}
		public String getArea_name() {
			return area_name;
		}
		public void setArea_name(String area_name) {
			this.area_name = area_name;
		}
		public String getBusiness_type() {
			return business_type;
		}
		public void setBusiness_type(String business_type) {
			this.business_type = business_type;
		}
		public String getSeoul_type() {
			return seoul_type;
		}
		public void setSeoul_type(String seoul_type) {
			this.seoul_type = seoul_type;
		}
		public String getJache_gu() {
			return jache_gu;
		}
		public void setJache_gu(String jache_gu) {
			this.jache_gu = jache_gu;
		}
		public String getLocation() {
			return location;
		}
		public void setLocation(String location) {
			this.location = location;
		}
		public String getArea_space() {
			return area_space;
		}
		public void setArea_space(String area_space) {
			this.area_space = area_space;
		}
		public String getChoice_howto() {
			return choice_howto;
		}
		public void setChoice_howto(String choice_howto) {
			this.choice_howto = choice_howto;
		}
		public String getTotal_money() {
			return total_money;
		}
		public void setTotal_money(String total_money) {
			this.total_money = total_money;
		}
		public String getBusiness_date() {
			return business_date;
		}
		public void setBusiness_date(String business_date) {
			this.business_date = business_date;
		}
		public String getExecution_phase() {
			return execution_phase;
		}
		public void setExecution_phase(String execution_phase) {
			this.execution_phase = execution_phase;
		}
		public String getA1() {
			return a1;
		}
		public void setA1(String a1) {
			this.a1 = a1;
		}
		public String getA2() {
			return a2;
		}
		public void setA2(String a2) {
			this.a2 = a2;
		}
		public String getA3() {
			return a3;
		}
		public void setA3(String a3) {
			this.a3 = a3;
		}
		public String getA4() {
			return a4;
		}
		public void setA4(String a4) {
			this.a4 = a4;
		}
		public String getA5() {
			return a5;
		}
		public void setA5(String a5) {
			this.a5 = a5;
		}
		public String getA6() {
			return a6;
		}
		public void setA6(String a6) {
			this.a6 = a6;
		}
		public String getA7() {
			return a7;
		}
		public void setA7(String a7) {
			this.a7 = a7;
		}
		public String getA8() {
			return a8;
		}
		public void setA8(String a8) {
			this.a8 = a8;
		}
		public String getA9() {
			return a9;
		}
		public void setA9(String a9) {
			this.a9 = a9;
		}
		public String getA10() {
			return a10;
		}
		public void setA10(String a10) {
			this.a10 = a10;
		}
		public String getA11() {
			return a11;
		}
		public void setA11(String a11) {
			this.a11 = a11;
		}
		public String getA12() {
			return a12;
		}
		public void setA12(String a12) {
			this.a12 = a12;
		}
		public String getA13() {
			return a13;
		}
		public void setA13(String a13) {
			this.a13 = a13;
		}
		public String getA14() {
			return a14;
		}
		public void setA14(String a14) {
			this.a14 = a14;
		}
		public String getA15() {
			return a15;
		}
		public void setA15(String a15) {
			this.a15 = a15;
		}
		public String getA16() {
			return a16;
		}
		public void setA16(String a16) {
			this.a16 = a16;
		}
		public String getA17() {
			return a17;
		}
		public void setA17(String a17) {
			this.a17 = a17;
		}
		public String getA18() {
			return a18;
		}
		public void setA18(String a18) {
			this.a18 = a18;
		}
		public String getA19() {
			return a19;
		}
		public void setA19(String a19) {
			this.a19 = a19;
		}
		public String getA20() {
			return a20;
		}
		public void setA20(String a20) {
			this.a20 = a20;
		}
		public String getA21() {
			return a21;
		}
		public void setA21(String a21) {
			this.a21 = a21;
		}
		public String getA22() {
			return a22;
		}
		public void setA22(String a22) {
			this.a22 = a22;
		}
		public String getA23() {
			return a23;
		}
		public void setA23(String a23) {
			this.a23 = a23;
		}
		public String getA24() {
			return a24;
		}
		public void setA24(String a24) {
			this.a24 = a24;
		}
		public String getA25() {
			return a25;
		}
		public void setA25(String a25) {
			this.a25 = a25;
		}
		public String getA26() {
			return a26;
		}
		public void setA26(String a26) {
			this.a26 = a26;
		}
		public String getA27() {
			return a27;
		}
		public void setA27(String a27) {
			this.a27 = a27;
		}
		public String getA28() {
			return a28;
		}
		public void setA28(String a28) {
			this.a28 = a28;
		}
		public String getA29() {
			return a29;
		}
		public void setA29(String a29) {
			this.a29 = a29;
		}
		public String getA30() {
			return a30;
		}
		public void setA30(String a30) {
			this.a30 = a30;
		}
		public String getA31() {
			return a31;
		}
		public void setA31(String a31) {
			this.a31 = a31;
		}
		public String getA32() {
			return a32;
		}
		public void setA32(String a32) {
			this.a32 = a32;
		}
		public String getA33() {
			return a33;
		}
		public void setA33(String a33) {
			this.a33 = a33;
		}
		public String getA34() {
			return a34;
		}
		public void setA34(String a34) {
			this.a34 = a34;
		}
		public String getA35() {
			return a35;
		}
		public void setA35(String a35) {
			this.a35 = a35;
		}
		public String getA36() {
			return a36;
		}
		public void setA36(String a36) {
			this.a36 = a36;
		}
		public String getA37() {
			return a37;
		}
		public void setA37(String a37) {
			this.a37 = a37;
		}
		public String getA38() {
			return a38;
		}
		public void setA38(String a38) {
			this.a38 = a38;
		}
		public String getA39() {
			return a39;
		}
		public void setA39(String a39) {
			this.a39 = a39;
		}
		public String getA40() {
			return a40;
		}
		public void setA40(String a40) {
			this.a40 = a40;
		}
		public String getA41() {
			return a41;
		}
		public void setA41(String a41) {
			this.a41 = a41;
		}
		public String getA42() {
			return a42;
		}
		public void setA42(String a42) {
			this.a42 = a42;
		}
		public String getA43() {
			return a43;
		}
		public void setA43(String a43) {
			this.a43 = a43;
		}
		public String getA44() {
			return a44;
		}
		public void setA44(String a44) {
			this.a44 = a44;
		}
		public String getA45() {
			return a45;
		}
		public void setA45(String a45) {
			this.a45 = a45;
		}
		public String getA46() {
			return a46;
		}
		public void setA46(String a46) {
			this.a46 = a46;
		}
		public String getA47() {
			return a47;
		}
		public void setA47(String a47) {
			this.a47 = a47;
		}
		public String getA48() {
			return a48;
		}
		public void setA48(String a48) {
			this.a48 = a48;
		}
		public String getA49() {
			return a49;
		}
		public void setA49(String a49) {
			this.a49 = a49;
		}
		public String getA50() {
			return a50;
		}
		public void setA50(String a50) {
			this.a50 = a50;
		}
		public String getA51() {
			return a51;
		}
		public void setA51(String a51) {
			this.a51 = a51;
		}
		public String getA52() {
			return a52;
		}
		public void setA52(String a52) {
			this.a52 = a52;
		}
		public String getA53() {
			return a53;
		}
		public void setA53(String a53) {
			this.a53 = a53;
		}
		public String getA54() {
			return a54;
		}
		public void setA54(String a54) {
			this.a54 = a54;
		}
		public String getA55() {
			return a55;
		}
		public void setA55(String a55) {
			this.a55 = a55;
		}
		public String getA56() {
			return a56;
		}
		public void setA56(String a56) {
			this.a56 = a56;
		}
		public String getA57() {
			return a57;
		}
		public void setA57(String a57) {
			this.a57 = a57;
		}
		public String getA58() {
			return a58;
		}
		public void setA58(String a58) {
			this.a58 = a58;
		}
		public String getA59() {
			return a59;
		}
		public void setA59(String a59) {
			this.a59 = a59;
		}
		public String getA60() {
			return a60;
		}
		public void setA60(String a60) {
			this.a60 = a60;
		}
		public String getA61() {
			return a61;
		}
		public void setA61(String a61) {
			this.a61 = a61;
		}
		public String getA62() {
			return a62;
		}
		public void setA62(String a62) {
			this.a62 = a62;
		}
		public String getA63() {
			return a63;
		}
		public void setA63(String a63) {
			this.a63 = a63;
		}
		public String getA64() {
			return a64;
		}
		public void setA64(String a64) {
			this.a64 = a64;
		}
		public String getA65() {
			return a65;
		}
		public void setA65(String a65) {
			this.a65 = a65;
		}
		public String getA66() {
			return a66;
		}
		public void setA66(String a66) {
			this.a66 = a66;
		}
		public String getA67() {
			return a67;
		}
		public void setA67(String a67) {
			this.a67 = a67;
		}
		public String getA68() {
			return a68;
		}
		public void setA68(String a68) {
			this.a68 = a68;
		}
		public String getA69() {
			return a69;
		}
		public void setA69(String a69) {
			this.a69 = a69;
		}
		public String getA70() {
			return a70;
		}
		public void setA70(String a70) {
			this.a70 = a70;
		}
		public String getA71() {
			return a71;
		}
		public void setA71(String a71) {
			this.a71 = a71;
		}
		public String getA72() {
			return a72;
		}
		public void setA72(String a72) {
			this.a72 = a72;
		}
		public String getA73() {
			return a73;
		}
		public void setA73(String a73) {
			this.a73 = a73;
		}
		public String getA74() {
			return a74;
		}
		public void setA74(String a74) {
			this.a74 = a74;
		}
		public String getA75() {
			return a75;
		}
		public void setA75(String a75) {
			this.a75 = a75;
		}
		public String getA76() {
			return a76;
		}
		public void setA76(String a76) {
			this.a76 = a76;
		}
		public String getArea() {
			return area;
		}
		public void setArea(String area) {
			this.area = area;
		}
		public String getNewtown() {
			return newtown;
		}
		public void setNewtown(String newtown) {
			this.newtown = newtown;
		}
		public String getRelrease_cause() {
			return relrease_cause;
		}
		public void setRelrease_cause(String relrease_cause) {
			this.relrease_cause = relrease_cause;
		}
		public String getRelrease_year() {
			return relrease_year;
		}
		public void setRelrease_year(String relrease_year) {
			this.relrease_year = relrease_year;
		}
		public String getDecline_index() {
			return decline_index;
		}
		public void setDecline_index(String decline_index) {
			this.decline_index = decline_index;
		}
		public String getCharact() {
			return charact;
		}
		public void setCharact(String charact) {
			this.charact = charact;
		}
		public String getCharact2() {
			return charact2;
		}
		public void setCharact2(String charact2) {
			this.charact2 = charact2;
		}
		public String getCharact3() {
			return charact3;
		}
		public void setCharact3(String charact3) {
			this.charact3 = charact3;
		}
		public String getIndex_num() {
			return index_num;
		}
		public void setIndex_num(String index_num) {
			this.index_num = index_num;
		}
		public String getArea_earth() {
			return area_earth;
		}
		public void setArea_earth(String area_earth) {
			this.area_earth = area_earth;
		}
		public String getChoice() {
			return choice;
		}
		public void setChoice(String choice) {
			this.choice = choice;
		}
		public String getExecution_date() {
			return execution_date;
		}
		public void setExecution_date(String execution_date) {
			this.execution_date = execution_date;
		}
		public String getHuman_group() {
			return human_group;
		}
		public void setHuman_group(String human_group) {
			this.human_group = human_group;
		}
		public String getRelease_date() {
			return release_date;
		}
		public void setRelease_date(String release_date) {
			this.release_date = release_date;
		}
		public String getEtc() {
			return etc;
		}
		public void setEtc(String etc) {
			this.etc = etc;
		}
		public String getJibun() {
			return jibun;
		}
		public void setJibun(String jibun) {
			this.jibun = jibun;
		}
		public String getBchk() {
			return bchk;
		}
		public void setBchk(String bchk) {
			this.bchk = bchk;
		}
		public String getRow_id() {
			return row_id;
		}
		public void setRow_id(String row_id) {
			this.row_id = row_id;
		}
		public String getStdmt() {
			return stdmt;
		}
		public void setStdmt(String stdmt) {
			this.stdmt = stdmt;
		}
		public String getLand_seqno() {
			return land_seqno;
		}
		public void setLand_seqno(String land_seqno) {
			this.land_seqno = land_seqno;
		}
		public String getNb() {
			return nb;
		}
		public void setNb(String nb) {
			this.nb = nb;
		}
		public String getFid_02_ji() {
			return fid_02_ji;
		}
		public void setFid_02_ji(String fid_02_ji) {
			this.fid_02_ji = fid_02_ji;
		}
		public String getFid_use() {
			return fid_use;
		}
		public void setFid_use(String fid_use) {
			this.fid_use = fid_use;
		}
		public String getBigo() {
			return bigo;
		}
		public void setBigo(String bigo) {
			this.bigo = bigo;
		}
		public String getNo() {
			return no;
		}
		public void setNo(String no) {
			this.no = no;
		}
		public String getSisul_name() {
			return sisul_name;
		}
		public void setSisul_name(String sisul_name) {
			this.sisul_name = sisul_name;
		}
		public String getBigo_1() {
			return bigo_1;
		}
		public void setBigo_1(String bigo_1) {
			this.bigo_1 = bigo_1;
		}
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		public String getJibun_2() {
			return jibun_2;
		}
		public void setJibun_2(String jibun_2) {
			this.jibun_2 = jibun_2;
		}
		public String getJimok_2() {
			return jimok_2;
		}
		public void setJimok_2(String jimok_2) {
			this.jimok_2 = jimok_2;
		}
		public String getBuild_year() {
			return build_year;
		}
		public void setBuild_year(String build_year) {
			this.build_year = build_year;
		}
		public String getLand_so() {
			return land_so;
		}
		public void setLand_so(String land_so) {
			this.land_so = land_so;
		}
		public String getSurface() {
			return surface;
		}
		public void setSurface(String surface) {
			this.surface = surface;
		}
		public String getStat_count() {
			return stat_count;
		}
		public void setStat_count(String stat_count) {
			this.stat_count = stat_count;
		}
		public String getCourt_number() {
			return court_number;
		}
		public void setCourt_number(String court_number) {
			this.court_number = court_number;
		}
		public String getAdditional_n() {
			return additional_n;
		}
		public void setAdditional_n(String additional_n) {
			this.additional_n = additional_n;
		}
		public String getSi() {
			return si;
		}
		public void setSi(String si) {
			this.si = si;
		}
		public String getDo_cd() {
			return do_cd;
		}
		public void setDo_cd(String do_cd) {
			this.do_cd = do_cd;
		}
		public String getDong() {
			return dong;
		}
		public void setDong(String dong) {
			this.dong = dong;
		}
		public String getM() {
			return m;
		}
		public void setM(String m) {
			this.m = m;
		}
		public String getJibun_1() {
			return jibun_1;
		}
		public void setJibun_1(String jibun_1) {
			this.jibun_1 = jibun_1;
		}
		public String getJimok_n() {
			return jimok_n;
		}
		public void setJimok_n(String jimok_n) {
			this.jimok_n = jimok_n;
		}
		public String getOwn() {
			return own;
		}
		public void setOwn(String own) {
			this.own = own;
		}
		public String getPnu_1() {
			return pnu_1;
		}
		public void setPnu_1(String pnu_1) {
			this.pnu_1 = pnu_1;
		}
		public String getFocus_co() {
			return focus_co;
		}
		public void setFocus_co(String focus_co) {
			this.focus_co = focus_co;
		}
		public String getJunglim() {
			return junglim;
		}
		public void setJunglim(String junglim) {
			this.junglim = junglim;
		}
		public String getFinal_strok() {
			return final_strok;
		}
		public void setFinal_strok(String final_strok) {
			this.final_strok = final_strok;
		}
		public String getPnu_12() {
			return pnu_12;
		}
		public void setPnu_12(String pnu_12) {
			this.pnu_12 = pnu_12;
		}
		public String getUse_stat() {
			return use_stat;
		}
		public void setUse_stat(String use_stat) {
			this.use_stat = use_stat;
		}
		public String getUse_co() {
			return use_co;
		}
		public void setUse_co(String use_co) {
			this.use_co = use_co;
		}
		public String getRn_cd() {
			return rn_cd;
		}
		public void setRn_cd(String rn_cd) {
			this.rn_cd = rn_cd;
		}
		public String getSig_cd() {
			return sig_cd;
		}
		public void setSig_cd(String sig_cd) {
			this.sig_cd = sig_cd;
		}
		public String getN_nb() {
			return n_nb;
		}
		public void setN_nb(String n_nb) {
			this.n_nb = n_nb;
		}
		public String getGu() {
			return gu;
		}
		public void setGu(String gu) {
			this.gu = gu;
		}
		public String getData_s() {
			return data_s;
		}
		public void setData_s(String data_s) {
			this.data_s = data_s;
		}
		public String getP_n() {
			return p_n;
		}
		public void setP_n(String p_n) {
			this.p_n = p_n;
		}
		public String getJuso() {
			return juso;
		}
		public void setJuso(String juso) {
			this.juso = juso;
		}
		public String getNote() {
			return note;
		}
		public void setNote(String note) {
			this.note = note;
		}
		public String getL_juso() {
			return l_juso;
		}
		public void setL_juso(String l_juso) {
			this.l_juso = l_juso;
		}
		public String getL_pnu() {
			return l_pnu;
		}
		public void setL_pnu(String l_pnu) {
			this.l_pnu = l_pnu;
		}
		public String getOp() {
			return op;
		}
		public void setOp(String op) {
			this.op = op;
		}
		public String getP_nb() {
			return p_nb;
		}
		public void setP_nb(String p_nb) {
			this.p_nb = p_nb;
		}
		public String getL_gb() {
			return l_gb;
		}
		public void setL_gb(String l_gb) {
			this.l_gb = l_gb;
		}
		public String getP_form() {
			return p_form;
		}
		public void setP_form(String p_form) {
			this.p_form = p_form;
		}
		public String getUpdate() {
			return update;
		}
		public void setUpdate(String update) {
			this.update = update;
		}
		public String getP_code() {
			return p_code;
		}
		public void setP_code(String p_code) {
			this.p_code = p_code;
		}
		public String getO_gb() {
			return o_gb;
		}
		public void setO_gb(String o_gb) {
			this.o_gb = o_gb;
		}
		public String getO_gb_kor() {
			return o_gb_kor;
		}
		public void setO_gb_kor(String o_gb_kor) {
			this.o_gb_kor = o_gb_kor;
		}
		public String getT_nb() {
			return t_nb;
		}
		public void setT_nb(String t_nb) {
			this.t_nb = t_nb;
		}
		public String getP_if() {
			return p_if;
		}
		public void setP_if(String p_if) {
			this.p_if = p_if;
		}
		public String getP_if_kor() {
			return p_if_kor;
		}
		public void setP_if_kor(String p_if_kor) {
			this.p_if_kor = p_if_kor;
		}
		public String getPr_p_nb() {
			return pr_p_nb;
		}
		public void setPr_p_nb(String pr_p_nb) {
			this.pr_p_nb = pr_p_nb;
		}
		public String getPr_update() {
			return pr_update;
		}
		public void setPr_update(String pr_update) {
			this.pr_update = pr_update;
		}
		public String getF_gb() {
			return f_gb;
		}
		public void setF_gb(String f_gb) {
			this.f_gb = f_gb;
		}
		public String getF_gb_kor() {
			return f_gb_kor;
		}
		public void setF_gb_kor(String f_gb_kor) {
			this.f_gb_kor = f_gb_kor;
		}
		public String getNfo_gb() {
			return nfo_gb;
		}
		public void setNfo_gb(String nfo_gb) {
			this.nfo_gb = nfo_gb;
		}
		public String getNfo_gb_k() {
			return nfo_gb_k;
		}
		public void setNfo_gb_k(String nfo_gb_k) {
			this.nfo_gb_k = nfo_gb_k;
		}
		public String getWd_o_t() {
			return wd_o_t;
		}
		public void setWd_o_t(String wd_o_t) {
			this.wd_o_t = wd_o_t;
		}
		public String getWd_c_t() {
			return wd_c_t;
		}
		public void setWd_c_t(String wd_c_t) {
			this.wd_c_t = wd_c_t;
		}
		public String getWe_o_t() {
			return we_o_t;
		}
		public void setWe_o_t(String we_o_t) {
			this.we_o_t = we_o_t;
		}
		public String getWe_c_t() {
			return we_c_t;
		}
		public void setWe_c_t(String we_c_t) {
			this.we_c_t = we_c_t;
		}
		public String getHd_o_t() {
			return hd_o_t;
		}
		public void setHd_o_t(String hd_o_t) {
			this.hd_o_t = hd_o_t;
		}
		public String getHd_c_t() {
			return hd_c_t;
		}
		public void setHd_c_t(String hd_c_t) {
			this.hd_c_t = hd_c_t;
		}
		public String getF_d_syn() {
			return f_d_syn;
		}
		public void setF_d_syn(String f_d_syn) {
			this.f_d_syn = f_d_syn;
		}
		public String getSat_f_gb() {
			return sat_f_gb;
		}
		public void setSat_f_gb(String sat_f_gb) {
			this.sat_f_gb = sat_f_gb;
		}
		public String getSat_f_kor() {
			return sat_f_kor;
		}
		public void setSat_f_kor(String sat_f_kor) {
			this.sat_f_kor = sat_f_kor;
		}
		public String getHd_f_gb() {
			return hd_f_gb;
		}
		public void setHd_f_gb(String hd_f_gb) {
			this.hd_f_gb = hd_f_gb;
		}
		public String getHd_f_kor() {
			return hd_f_kor;
		}
		public void setHd_f_kor(String hd_f_kor) {
			this.hd_f_kor = hd_f_kor;
		}
		public String getMonth_f() {
			return month_f;
		}
		public void setMonth_f(String month_f) {
			this.month_f = month_f;
		}
		public String getP_ad_nb() {
			return p_ad_nb;
		}
		public void setP_ad_nb(String p_ad_nb) {
			this.p_ad_nb = p_ad_nb;
		}
		public String getUn_f() {
			return un_f;
		}
		public void setUn_f(String un_f) {
			this.un_f = un_f;
		}
		public String getUn_t() {
			return un_t;
		}
		public void setUn_t(String un_t) {
			this.un_t = un_t;
		}
		public String getAdd_f() {
			return add_f;
		}
		public void setAdd_f(String add_f) {
			this.add_f = add_f;
		}
		public String getAdd_t() {
			return add_t;
		}
		public void setAdd_t(String add_t) {
			this.add_t = add_t;
		}
		public String getBus_un_f() {
			return bus_un_f;
		}
		public void setBus_un_f(String bus_un_f) {
			this.bus_un_f = bus_un_f;
		}
		public String getBus_un_t() {
			return bus_un_t;
		}
		public void setBus_un_t(String bus_un_t) {
			this.bus_un_t = bus_un_t;
		}
		public String getBus_add_t() {
			return bus_add_t;
		}
		public void setBus_add_t(String bus_add_t) {
			this.bus_add_t = bus_add_t;
		}
		public String getB_add_f() {
			return b_add_f;
		}
		public void setB_add_f(String b_add_f) {
			this.b_add_f = b_add_f;
		}
		public String getD_max_f() {
			return d_max_f;
		}
		public void setD_max_f(String d_max_f) {
			this.d_max_f = d_max_f;
		}
		public String getKor_sub_nm() {
			return kor_sub_nm;
		}
		public void setKor_sub_nm(String kor_sub_nm) {
			this.kor_sub_nm = kor_sub_nm;
		}
		public String getRepresen_num() {
			return represen_num;
		}
		public void setRepresen_num(String represen_num) {
			this.represen_num = represen_num;
		}
		public String getSubway() {
			return subway;
		}
		public void setSubway(String subway) {
			this.subway = subway;
		}
		public String getArea_circle() {
			return area_circle;
		}
		public void setArea_circle(String area_circle) {
			this.area_circle = area_circle;
		}
		public String getRepresen_route() {
			return represen_route;
		}
		public void setRepresen_route(String represen_route) {
			this.represen_route = represen_route;
		}
		public String getPublic_transpo() {
			return public_transpo;
		}
		public void setPublic_transpo(String public_transpo) {
			this.public_transpo = public_transpo;
		}
		public String getHistory() {
			return history;
		}
		public void setHistory(String history) {
			this.history = history;
		}
		public String getIntersection() {
			return intersection;
		}
		public void setIntersection(String intersection) {
			this.intersection = intersection;
		}
		public String getIntersection_r() {
			return intersection_r;
		}
		public void setIntersection_r(String intersection_r) {
			this.intersection_r = intersection_r;
		}
		public String getBus_jun() {
			return bus_jun;
		}
		public void setBus_jun(String bus_jun) {
			this.bus_jun = bus_jun;
		}
		public String getNear_load() {
			return near_load;
		}
		public void setNear_load(String near_load) {
			this.near_load = near_load;
		}
		public String getUpis() {
			return upis;
		}
		public void setUpis(String upis) {
			this.upis = upis;
		}
		public String getLoad_size() {
			return load_size;
		}
		public void setLoad_size(String load_size) {
			this.load_size = load_size;
		}
		public String getBigo_release() {
			return bigo_release;
		}
		public void setBigo_release(String bigo_release) {
			this.bigo_release = bigo_release;
		}
		public String getGosi_num() {
			return gosi_num;
		}
		public void setGosi_num(String gosi_num) {
			this.gosi_num = gosi_num;
		}
	public String getCp_date_1() {
		return cp_date_1;
	}
	public String getPk() {
		return pk;
	}
	public void setPk(String pk) {
		this.pk = pk;
	}
	public String getPublic_buld_a() {
		return public_buld_a;
	}
	public void setPublic_buld_a(String public_buld_a) {
		this.public_buld_a = public_buld_a;
	}
	public String getPublic_buld_b() {
		return public_buld_b;
	}
	public void setPublic_buld_b(String public_buld_b) {
		this.public_buld_b = public_buld_b;
	}
	public String getPublic_buld_c() {
		return public_buld_c;
	}
	public void setPublic_buld_c(String public_buld_c) {
		this.public_buld_c = public_buld_c;
	}
	public String[] getPublic_buld_a_value() {
		return public_buld_a_value;
	}
	public void setPublic_buld_a_value(String[] public_buld_a_value) {
		this.public_buld_a_value = public_buld_a_value;
	}
	public String[] getPublic_buld_b_value() {
		return public_buld_b_value;
	}
	public void setPublic_buld_b_value(String[] public_buld_b_value) {
		this.public_buld_b_value = public_buld_b_value;
	}
	public String[] getPublic_buld_c_value() {
		return public_buld_c_value;
	}
	public void setPublic_buld_c_value(String[] public_buld_c_value) {
		this.public_buld_c_value = public_buld_c_value;
	}
	public void setCp_date_1(String cp_date_1) {
		this.cp_date_1 = cp_date_1;
	}
	public String getCp_date_2() {
		return cp_date_2;
	}
	public void setCp_date_2(String cp_date_2) {
		this.cp_date_2 = cp_date_2;
	}
	public String getHg_limit() {
		return hg_limit;
	}
	public void setHg_limit(String hg_limit) {
		this.hg_limit = hg_limit;
	}
	public String getTaruse() {
		return taruse;
	}
	public void setTaruse(String taruse) {
		this.taruse = taruse;
	}
	public String getSoldkind() {
		return soldkind;
	}
	public void setSoldkind(String soldkind) {
		this.soldkind = soldkind;
	}
	public String[] getSoldout() {
		return soldout;
	}
	public void setSoldout(String[] soldout) {
		this.soldout = soldout;
	}
	public String[] getSector() {
		return sector;
	}
	public void setSector(String[] sector) {
		this.sector = sector;
	}
	public String[] getFill_gb() {
		return fill_gb;
	}
	public void setFill_gb(String[] fill_gb) {
		this.fill_gb = fill_gb;
	}
	public String[] getUseu() {
		return useu;
	}
	public void setUseu(String[] useu) {
		this.useu = useu;
	}
	public String[] getUses() {
		return uses;
	}
	public void setUses(String[] uses) {
		this.uses = uses;
	}
	public String getSector_nm() {
		return sector_nm;
	}
	public void setSector_nm(String sector_nm) {
		this.sector_nm = sector_nm;
	}
	public String[] getSoldgb() {
		return soldgb;
	}
	public void setSoldgb(String[] soldgb) {
		this.soldgb = soldgb;
	}
	public String[] getGuk_buld_value() {
		return guk_buld_value;
	}
	public void setGuk_buld_value(String[] guk_buld_value) {
		this.guk_buld_value = guk_buld_value;
	}
	public String[] getTmseq_buld_value() {
		return tmseq_buld_value;
	}
	public void setTmseq_buld_value(String[] tmseq_buld_value) {
		this.tmseq_buld_value = tmseq_buld_value;
	}
	public String[] getCynlst_value() {
		return cynlst_value;
	}
	public void setCynlst_value(String[] cynlst_value) {
		this.cynlst_value = cynlst_value;
	}
	public String[] getOwned_city_value() {
		return owned_city_value;
	}
	public void setOwned_city_value(String[] owned_city_value) {
		this.owned_city_value = owned_city_value;
	}
	public String[] getOwned_guyu_value() {
		return owned_guyu_value;
	}
	public void setOwned_guyu_value(String[] owned_guyu_value) {
		this.owned_guyu_value = owned_guyu_value;
	}
	public String[] getGenerations_value() {
		return generations_value;
	}
	public void setGenerations_value(String[] generations_value) {
		this.generations_value = generations_value;
	}
	public String[] getTmseq_land_value() {
		return tmseq_land_value;
	}
	public void setTmseq_land_value(String[] tmseq_land_value) {
		this.tmseq_land_value = tmseq_land_value;
	}
	public String[] getGuk_land_value() {
		return guk_land_value;
	}
	public void setGuk_land_value(String[] guk_land_value) {
		this.guk_land_value = guk_land_value;
	}
	public String getGuk_land() {
		return guk_land;
	}
	public void setGuk_land(String guk_land) {
		this.guk_land = guk_land;
	}
	public String getTmseq_land() {
		return tmseq_land;
	}
	public void setTmseq_land(String tmseq_land) {
		this.tmseq_land = tmseq_land;
	}
	public String getRegion_land() {
		return region_land;
	}
	public void setRegion_land(String region_land) {
		this.region_land = region_land;
	}
	public String getOwned_consult() {
		return owned_consult;
	}
	public void setOwned_consult(String owned_consult) {
		this.owned_consult = owned_consult;
	}
	public String getOwned_city() {
		return owned_city;
	}
	public void setOwned_city(String owned_city) {
		this.owned_city = owned_city;
	}
	public String getOwned_guyu() {
		return owned_guyu;
	}
	public void setOwned_guyu(String owned_guyu) {
		this.owned_guyu = owned_guyu;
	}
	public String getResidual_land() {
		return residual_land;
	}
	public void setResidual_land(String residual_land) {
		this.residual_land = residual_land;
	}
	public String getUnsold_land() {
		return unsold_land;
	}
	public void setUnsold_land(String unsold_land) {
		this.unsold_land = unsold_land;
	}
	public String getInvest() {
		return invest;
	}
	public void setInvest(String invest) {
		this.invest = invest;
	}
	public String getPublic_site() {
		return public_site;
	}
	public void setPublic_site(String public_site) {
		this.public_site = public_site;
	}
	public String getPublic_parking() {
		return public_parking;
	}
	public void setPublic_parking(String public_parking) {
		this.public_parking = public_parking;
	}
	public String getGenerations() {
		return generations;
	}
	public void setGenerations(String generations) {
		this.generations = generations;
	}
	public String getCouncil_land() {
		return council_land;
	}
	public void setCouncil_land(String council_land) {
		this.council_land = council_land;
	}
	public String getMinuse() {
		return minuse;
	}
	public void setMinuse(String minuse) {
		this.minuse = minuse;
	}
	public String getIndustry() {
		return industry;
	}
	public void setIndustry(String industry) {
		this.industry = industry;
	}
	public String getPriority() {
		return priority;
	}
	public void setPriority(String priority) {
		this.priority = priority;
	}
	public String getGuk_buld() {
		return guk_buld;
	}
	public void setGuk_buld(String guk_buld) {
		this.guk_buld = guk_buld;
	}
	public String getTmseq_buld() {
		return tmseq_buld;
	}
	public void setTmseq_buld(String tmseq_buld) {
		this.tmseq_buld = tmseq_buld;
	}
	public String getRegion_buld() {
		return region_buld;
	}
	public void setRegion_buld(String region_buld) {
		this.region_buld = region_buld;
	}
	public String getOwned_region() {
		return owned_region;
	}
	public void setOwned_region(String owned_region) {
		this.owned_region = owned_region;
	}
	public String getOwned_seoul() {
		return owned_seoul;
	}
	public void setOwned_seoul(String owned_seoul) {
		this.owned_seoul = owned_seoul;
	}
	public String getPublic_asbu() {
		return public_asbu;
	}
	public void setPublic_asbu(String public_asbu) {
		this.public_asbu = public_asbu;
	}
	public String getDeclining() {
		return declining;
	}
	public void setDeclining(String declining) {
		this.declining = declining;
	}
	public String[] getSpkfc() {
		return spkfc;
	}
	public void setSpkfc(String[] spkfc) {
		this.spkfc = spkfc;
	}
	public String getHbdtldr_1() {
		return hbdtldr_1;
	}
	public void setHbdtldr_1(String hbdtldr_1) {
		this.hbdtldr_1 = hbdtldr_1;
	}
	public String getHbdtldr_2() {
		return hbdtldr_2;
	}
	public void setHbdtldr_2(String hbdtldr_2) {
		this.hbdtldr_2 = hbdtldr_2;
	}
	public String getHcpcty_rt_1() {
		return hcpcty_rt_1;
	}
	public void setHcpcty_rt_1(String hcpcty_rt_1) {
		this.hcpcty_rt_1 = hcpcty_rt_1;
	}
	public String getHcpcty_rt_2() {
		return hcpcty_rt_2;
	}
	public void setHcpcty_rt_2(String hcpcty_rt_2) {
		this.hcpcty_rt_2 = hcpcty_rt_2;
	}
	public String getPnu() {
		return pnu;
	}
	public String getPurchase() {
		return purchase;
	}
	public void setPurchase(String purchase) {
		this.purchase = purchase;
	}
	public String getCynlst() {
		return cynlst;
	}
	public void setCynlst(String cynlst) {
		this.cynlst = cynlst;
	}
	public String getUnsold() {
		return unsold;
	}
	public void setUnsold(String unsold) {
		this.unsold = unsold;
	}
	public String getResidual() {
		return residual;
	}
	public void setResidual(String residual) {
		this.residual = residual;
	}
	public String getKind() {
		return kind;
	}
	public void setKind(String kind) {
		this.kind = kind;
	}
	public String[] getPrtown() {
		return prtown;
	}
	public void setPrtown(String[] prtown) {
		this.prtown = prtown;
	}
	public String[] getSpcfc() {
		return spcfc;
	}
	public void setSpcfc(String[] spcfc) {
		this.spcfc = spcfc;
	}
	public String getCnflc_1() {
		return cnflc_1;
	}
	public void setCnflc_1(String cnflc_1) {
		this.cnflc_1 = cnflc_1;
	}
	public String getCnflc_2() {
		return cnflc_2;
	}
	public void setCnflc_2(String cnflc_2) {
		this.cnflc_2 = cnflc_2;
	}
	public String[] getGb() {
		return gb;
	}
	public void setGb(String[] gb) {
		this.gb = gb;
	}
	public void setPnu(String pnu) {
		this.pnu = pnu;
	}
	public String getSig() {
		return sig;
	}
	public void setSig(String sig) {
		this.sig = sig;
	}
	public String getEmd() {
		return emd;
	}
	public void setEmd(String emd) {
		this.emd = emd;
	}
	public String getLi() {
		return li;
	}
	public void setLi(String li) {
		this.li = li;
	}
	public String getBobn() {
		return bobn;
	}
	public void setBobn(String bobn) {
		this.bobn = bobn;
	}
	public String getBubn() {
		return bubn;
	}
	public void setBubn(String bubn) {
		this.bubn = bubn;
	}
	public String[] getJimok() {
		return jimok;
	}
	public void setJimok(String[] jimok) {
		this.jimok = jimok;
	}
	public String[] getSpfc() {
		return spfc;
	}
	public void setSpfc(String[] spfc) {
		this.spfc = spfc;
	}
	public String[] getLand_use() {
		return land_use;
	}
	public void setLand_use(String[] land_use) {
		this.land_use = land_use;
	}
	public String[] getGeo_hl() {
		return geo_hl;
	}
	public void setGeo_hl(String[] geo_hl) {
		this.geo_hl = geo_hl;
	}
	public String[] getGeo_form() {
		return geo_form;
	}
	public void setGeo_form(String[] geo_form) {
		this.geo_form = geo_form;
	}
	public String[] getRoad_side() {
		return road_side;
	}
	public void setRoad_side(String[] road_side) {
		this.road_side = road_side;
	}
	public String getBuld_nm() {
		return buld_nm;
	}
	public void setBuld_nm(String buld_nm) {
		this.buld_nm = buld_nm;
	}
	public String[] getPrpos() {
		return prpos;
	}
	public void setPrpos(String[] prpos) {
		this.prpos = prpos;
	}
	
	public String[] getStrct() {
		return strct;
	}
	public void setStrct(String[] strct) {
		this.strct = strct;
	}
	public String getPnilp_1() {
		return pnilp_1;
	}
	public void setPnilp_1(String pnilp_1) {
		this.pnilp_1 = pnilp_1;
	}
	public String getPnilp_2() {
		return pnilp_2;
	}
	public void setPnilp_2(String pnilp_2) {
		this.pnilp_2 = pnilp_2;
	}
	public String getParea_1() {
		return parea_1;
	}
	public void setParea_1(String parea_1) {
		this.parea_1 = parea_1;
	}
	public String getParea_2() {
		return parea_2;
	}
	public void setParea_2(String parea_2) {
		this.parea_2 = parea_2;
	}
	public String getPagesize() {
		return pagesize;
	}
	public void setPagesize(String pagesize) {
		this.pagesize = pagesize;
	}
	public String getPageindex() {
		return pageindex;
	}
	public void setPageindex(String pageindex) {
		this.pageindex = pageindex;
	}
	public String getBildng_ar_1() {
		return bildng_ar_1;
	}
	public void setBildng_ar_1(String bildng_ar_1) {
		this.bildng_ar_1 = bildng_ar_1;
	}
	public String getBildng_ar_2() {
		return bildng_ar_2;
	}
	public void setBildng_ar_2(String bildng_ar_2) {
		this.bildng_ar_2 = bildng_ar_2;
	}
	public String getTotar_1() {
		return totar_1;
	}
	public void setTotar_1(String totar_1) {
		this.totar_1 = totar_1;
	}
	public String getTotar_2() {
		return totar_2;
	}
	public void setTotar_2(String totar_2) {
		this.totar_2 = totar_2;
	}
	public String getPlot_ar_1() {
		return plot_ar_1;
	}
	public void setPlot_ar_1(String plot_ar_1) {
		this.plot_ar_1 = plot_ar_1;
	}
	public String getPlot_ar_2() {
		return plot_ar_2;
	}
	public void setPlot_ar_2(String plot_ar_2) {
		this.plot_ar_2 = plot_ar_2;
	}
	public String getBdtldr_1() {
		return bdtldr_1;
	}
	public void setBdtldr_1(String bdtldr_1) {
		this.bdtldr_1 = bdtldr_1;
	}
	public String getBdtldr_2() {
		return bdtldr_2;
	}
	public void setBdtldr_2(String bdtldr_2) {
		this.bdtldr_2 = bdtldr_2;
	}
	public String getCpcty_rt_1() {
		return cpcty_rt_1;
	}
	public void setCpcty_rt_1(String cpcty_rt_1) {
		this.cpcty_rt_1 = cpcty_rt_1;
	}
	public String getCpcty_rt_2() {
		return cpcty_rt_2;
	}
	public void setCpcty_rt_2(String cpcty_rt_2) {
		this.cpcty_rt_2 = cpcty_rt_2;
	}
	public String getGround_1() {
		return ground_1;
	}
	public void setGround_1(String ground_1) {
		this.ground_1 = ground_1;
	}
	public String getGround_2() {
		return ground_2;
	}
	public void setGround_2(String ground_2) {
		this.ground_2 = ground_2;
	}
	public String getUndgrnd_1() {
		return undgrnd_1;
	}
	public void setUndgrnd_1(String undgrnd_1) {
		this.undgrnd_1 = undgrnd_1;
	}
	public String getUndgrnd_2() {
		return undgrnd_2;
	}
	public void setUndgrnd_2(String undgrnd_2) {
		this.undgrnd_2 = undgrnd_2;
	}
	public String getHg_1() {
		return hg_1;
	}
	public void setHg_1(String hg_1) {
		this.hg_1 = hg_1;
	}
	public String getHg_2() {
		return hg_2;
	}
	public void setHg_2(String hg_2) {
		this.hg_2 = hg_2;
	}
	public String[] getCity_activation() {
		return city_activation;
	}
	public void setCity_activation(String[] city_activation) {
		this.city_activation = city_activation;
	}
	public String[] getCity_activation_val() {
		return city_activation_val;
	}
	public void setCity_activation_val(String[] city_activation_val) {
		this.city_activation_val = city_activation_val;
	}
	public String[] getHouse_envment() {
		return house_envment;
	}
	public void setHouse_envment(String[] house_envment) {
		this.house_envment = house_envment;
	}
	public String[] getHouse_envment_val() {
		return house_envment_val;
	}
	public void setHouse_envment_val(String[] house_envment_val) {
		this.house_envment_val = house_envment_val;
	}
	public String[] getHope_land() {
		return hope_land;
	}
	public void setHope_land(String[] hope_land) {
		this.hope_land = hope_land;
	}
	public String[] getHope_land_val() {
		return hope_land_val;
	}
	public void setHope_land_val(String[] hope_land_val) {
		this.hope_land_val = hope_land_val;
	}
	public String[] getRelease_area() {
		return release_area;
	}
	public void setRelease_area(String[] release_area) {
		this.release_area = release_area;
	}
	public String[] getRelease_area_val() {
		return release_area_val;
	}
	public void setRelease_area_val(String[] release_area_val) {
		this.release_area_val = release_area_val;
	}
	public String[] getSub_p_decline() {
		return sub_p_decline;
	}
	public void setSub_p_decline(String[] sub_p_decline) {
		this.sub_p_decline = sub_p_decline;
	}
	public String[] getSub_p_decline_val() {
		return sub_p_decline_val;
	}
	public void setSub_p_decline_val(String[] sub_p_decline_val) {
		this.sub_p_decline_val = sub_p_decline_val;
	}
	public String[] getPublic_transport() {
		return public_transport;
	}
	public void setPublic_transport(String[] public_transport) {
		this.public_transport = public_transport;
	}
	public String getPublic_transport_val() {
		return public_transport_val;
	}
	public void setPublic_transport_val(String public_transport_val) {
		this.public_transport_val = public_transport_val;
	}
	public String getSub_p_decline_gb() {
		return sub_p_decline_gb;
	}
	public void setSub_p_decline_gb(String sub_p_decline_gb) {
		this.sub_p_decline_gb = sub_p_decline_gb;
	}
	public String getTar_layer() {
		return tar_layer;
	}
	public void setTar_layer(String tar_layer) {
		this.tar_layer = tar_layer;
	}
	public String getBuffer() {
		return buffer;
	}
	public void setBuffer(String buffer) {
		this.buffer = buffer;
	}
	public String getOuther() {
		return outher;
	}
	public void setOuther(String outher) {
		this.outher = outher;
	}
	public String getSolar_1() {
		return solar_1;
	}
	public void setSolar_1(String solar_1) {
		this.solar_1 = solar_1;
	}
	public String getSolar_2() {
		return solar_2;
	}
	public void setSolar_2(String solar_2) {
		this.solar_2 = solar_2;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getBookmark_nm() {
		return bookmark_nm;
	}
	public void setBookmark_nm(String bookmark_nm) {
		this.bookmark_nm = bookmark_nm;
	}
	public String getUse_at() {
		return use_at;
	}
	public void setUse_at(String use_at) {
		this.use_at = use_at;
	}
	public String getRegist_dt() {
		return regist_dt;
	}
	public void setRegist_dt(String regist_dt) {
		this.regist_dt = regist_dt;
	}
	public String getCnt_kind() {
		return cnt_kind;
	}
	public void setCnt_kind(String cnt_kind) {
		this.cnt_kind = cnt_kind;
	}
	public String getCoord_x() {
		return coord_x;
	}
	public void setCoord_x(String coord_x) {
		this.coord_x = coord_x;
	}
	public String getCoord_y() {
		return coord_y;
	}
	public void setCoord_y(String coord_y) {
		this.coord_y = coord_y;
	}
	public String getGbname() {
		return gbname;
	}
	public void setGbname(String gbname) {
		this.gbname = gbname;
	}
	public String getGuk_land_01() {
		return guk_land_01;
	}
	public void setGuk_land_01(String guk_land_01) {
		this.guk_land_01 = guk_land_01;
	}
	public String getGuk_land_02() {
		return guk_land_02;
	}
	public void setGuk_land_02(String guk_land_02) {
		this.guk_land_02 = guk_land_02;
	}
	public String getGuk_land_03() {
		return guk_land_03;
	}
	public void setGuk_land_03(String guk_land_03) {
		this.guk_land_03 = guk_land_03;
	}
	public String getGuk_land_04() {
		return guk_land_04;
	}
	public void setGuk_land_04(String guk_land_04) {
		this.guk_land_04 = guk_land_04;
	}
	public String getTmseq_land_01() {
		return tmseq_land_01;
	}
	public void setTmseq_land_01(String tmseq_land_01) {
		this.tmseq_land_01 = tmseq_land_01;
	}
	public String getTmseq_land_02() {
		return tmseq_land_02;
	}
	public void setTmseq_land_02(String tmseq_land_02) {
		this.tmseq_land_02 = tmseq_land_02;
	}
	public String getOwned_city_01() {
		return owned_city_01;
	}
	public void setOwned_city_01(String owned_city_01) {
		this.owned_city_01 = owned_city_01;
	}
	public String getOwned_city_02() {
		return owned_city_02;
	}
	public void setOwned_city_02(String owned_city_02) {
		this.owned_city_02 = owned_city_02;
	}
	public String getOwned_guyu_01() {
		return owned_guyu_01;
	}
	public void setOwned_guyu_01(String owned_guyu_01) {
		this.owned_guyu_01 = owned_guyu_01;
	}
	public String getOwned_guyu_02() {
		return owned_guyu_02;
	}
	public void setOwned_guyu_02(String owned_guyu_02) {
		this.owned_guyu_02 = owned_guyu_02;
	}
	public String getGuk_buld_01() {
		return guk_buld_01;
	}
	public void setGuk_buld_01(String guk_buld_01) {
		this.guk_buld_01 = guk_buld_01;
	}
	public String getGuk_buld_02() {
		return guk_buld_02;
	}
	public void setGuk_buld_02(String guk_buld_02) {
		this.guk_buld_02 = guk_buld_02;
	}
	public String getGuk_buld_03() {
		return guk_buld_03;
	}
	public void setGuk_buld_03(String guk_buld_03) {
		this.guk_buld_03 = guk_buld_03;
	}
	public String getGuk_buld_04() {
		return guk_buld_04;
	}
	public void setGuk_buld_04(String guk_buld_04) {
		this.guk_buld_04 = guk_buld_04;
	}
	public String getTmseq_buld_01() {
		return tmseq_buld_01;
	}
	public void setTmseq_buld_01(String tmseq_buld_01) {
		this.tmseq_buld_01 = tmseq_buld_01;
	}
	public String getTmseq_buld_02() {
		return tmseq_buld_02;
	}
	public void setTmseq_buld_02(String tmseq_buld_02) {
		this.tmseq_buld_02 = tmseq_buld_02;
	}
	public String[] getOwned_region_value() {
		return owned_region_value;
	}
	public void setOwned_region_value(String[] owned_region_value) {
		this.owned_region_value = owned_region_value;
	}
	public String getOwned_region_01() {
		return owned_region_01;
	}
	public void setOwned_region_01(String owned_region_01) {
		this.owned_region_01 = owned_region_01;
	}
	public String getOwned_region_02() {
		return owned_region_02;
	}
	public void setOwned_region_02(String owned_region_02) {
		this.owned_region_02 = owned_region_02;
	}
	public String getCynlst_01() {
		return cynlst_01;
	}
	public void setCynlst_01(String cynlst_01) {
		this.cynlst_01 = cynlst_01;
	}
	public String getCynlst_02() {
		return cynlst_02;
	}
	public void setCynlst_02(String cynlst_02) {
		this.cynlst_02 = cynlst_02;
	}
	public String getSel() {
		return sel;
	}
	public void setSel(String sel) {
		this.sel = sel;
	}
	public String[] getSpace_gb() {
		return space_gb;
	}
	public void setSpace_gb(String[] space_gb) {
		this.space_gb = space_gb;
	}
	public String[] getSpace_gb_cd02() {
		return space_gb_cd02;
	}
	public void setSpace_gb_cd02(String[] space_gb_cd02) {
		this.space_gb_cd02 = space_gb_cd02;
	}
	public String[] getSpace_gb_cd03() {
		return space_gb_cd03;
	}
	public void setSpace_gb_cd03(String[] space_gb_cd03) {
		this.space_gb_cd03 = space_gb_cd03;
	}
	
	


}
