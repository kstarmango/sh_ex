package egovframework.zaol.common;

import java.io.Serializable;

import org.apache.commons.lang.builder.ToStringBuilder;

/**
 * 기본 VO
 * 페이징 관련 정보와 검색관련 항목 정의
 *
 * @author pathos
 *
 */
public class DefaultSearchVO implements Serializable {

	/**
	 *
	 */
	private static final long serialVersionUID = 4924995697162654113L;

	private String s_gu       = "";
	private String sido       = ""; /* 시도 */
 	private String gu         = ""; /* 시군구 */
 	private String dong       = ""; /* 읍면동 */
 	private String dong_code  = ""; /* 읍면동코드 */
 	private String gu_code  = "";

    private String  s_dong_code             = "";
    private String  k_sido             = "";
    private String  k_gu             = "";
    private String  k_dong_code             = "";


	/** menuID */
	private String menuid = "";

	//2012-08-31 양중목 추가 시작
	private String user_id = "";
	private String bsns_id = "";
	private String conect_ip = "";
	private String dta_inqire_ty = "";
	private String strctu_id = ""; /* 기하구조 id */
	private String rdsc_id = ""; /* 가로정보 id */
	private String fclty_id = ""; /* 유사시설 id */
	private String examin_date = ""; /* 조사일자 */
	//2012-08-31 양중목 추가 끝


	/** 검색조건 */
    private String searchCondition = "";

    /** 검색Keyword */
    private String searchKeyword = "";

    /** 검색사용여부 */
    private String searchUseYn = "";

    /** 현재페이지 */
    private int pageIndex = 1;

    /** 페이지갯수 */
    private int pageUnit = 10;

    /** 페이지사이즈 */
    private int pageSize = 10;

    /** firstIndex */
    private int firstIndex = 1;

    /** lastIndex */
    private int lastIndex = 1;

    /** recordCountPerPage */
    private int recordCountPerPage = 10;

	/** 공통코드값 */
    private String cd = "";

    /** 공통코드명 */
    private String cdnm = "";

    /** 분류1 */
    private String cdnm1 = "";

    /** 분류2 */
    private String cdnm2 = "";

    /** 분류3 */
    private String cdnm3 = "";

    /** 분류4 */
    private String cdnm4 = "";

    /** 분류5 */
    private String cdnm5 = "";

	/** x좌표 */
    private String crdnt_x = "";

    /** y좌표 */
    private String crdnt_y = "";

    /** 반경 */
    private String s_base_radius = "";

    /** 교차로 위치 */
    private String node_lc = "";


	public String getMenuid() {
		return menuid;
	}

	public void setMenuid(String menuid) {
		this.menuid = menuid;
	}

	public int getFirstIndex() {
		return firstIndex;
	}

	public void setFirstIndex(int firstIndex) {
		this.firstIndex = firstIndex;
	}

	public int getLastIndex() {
		return lastIndex;
	}

	public void setLastIndex(int lastIndex) {
		this.lastIndex = lastIndex;
	}

	public int getRecordCountPerPage() {
		return recordCountPerPage;
	}

	public void setRecordCountPerPage(int recordCountPerPage) {
		this.recordCountPerPage = recordCountPerPage;
	}

	public String getSearchCondition() {
        return searchCondition;
    }

    public void setSearchCondition(String searchCondition) {
        this.searchCondition = searchCondition;
    }

    public String getSearchKeyword() {
        return searchKeyword;
    }

    public void setSearchKeyword(String searchKeyword) {
        this.searchKeyword = searchKeyword;
    }

    public String getSearchUseYn() {
        return searchUseYn;
    }

    public void setSearchUseYn(String searchUseYn) {
        this.searchUseYn = searchUseYn;
    }

    public int getPageIndex() {
        return pageIndex;
    }

    public void setPageIndex(int pageIndex) {
        this.pageIndex = pageIndex;
    }

    public int getPageUnit() {
        return pageUnit;
    }

    public void setPageUnit(int pageUnit) {
        this.pageUnit = pageUnit;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }

	public String getCd() {
		return cd;
	}

	public void setCd(String cd) {
		this.cd = cd;
	}

	public String getCdnm() {
		return cdnm;
	}

	public void setCdnm(String cdnm) {
		this.cdnm = cdnm;
	}

	public String getCdnm1() {
		return cdnm1;
	}

	public void setCdnm1(String cdnm1) {
		this.cdnm1 = cdnm1;
	}

	public String getCdnm2() {
		return cdnm2;
	}

	public void setCdnm2(String cdnm2) {
		this.cdnm2 = cdnm2;
	}

	public String getCdnm3() {
		return cdnm3;
	}

	public void setCdnm3(String cdnm3) {
		this.cdnm3 = cdnm3;
	}

	public String getCdnm4() {
		return cdnm4;
	}

	public void setCdnm4(String cdnm4) {
		this.cdnm4 = cdnm4;
	}

	public String getCdnm5() {
		return cdnm5;
	}

	public void setCdnm5(String cdnm5) {
		this.cdnm5 = cdnm5;
	}

	public String getCrdnt_x() {
		return crdnt_x;
	}

	public void setCrdnt_x(String crdnt_x) {
		this.crdnt_x = crdnt_x;
	}

	public String getCrdnt_y() {
		return crdnt_y;
	}

	public void setCrdnt_y(String crdnt_y) {
		this.crdnt_y = crdnt_y;
	}

	public String getNode_lc() {
		return node_lc;
	}

	public void setNode_lc(String node_lc) {
		this.node_lc = node_lc;
	}

	public String getS_base_radius() {
		return s_base_radius;
	}

	public void setS_base_radius(String s_base_radius) {
		this.s_base_radius = s_base_radius;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public String getBsns_id() {
		return bsns_id;
	}

	public void setBsns_id(String bsns_id) {
		this.bsns_id = bsns_id;
	}

	public String getConect_ip() {
		return conect_ip;
	}

	public void setConect_ip(String conect_ip) {
		this.conect_ip = conect_ip;
	}

	public String getDta_inqire_ty() {
		return dta_inqire_ty;
	}

	public void setDta_inqire_ty(String dta_inqire_ty) {
		this.dta_inqire_ty = dta_inqire_ty;
	}

	public String getStrctu_id() {
		return strctu_id;
	}

	public void setStrctu_id(String strctu_id) {
		this.strctu_id = strctu_id;
	}

	public String getRdsc_id() {
		return rdsc_id;
	}

	public void setRdsc_id(String rdsc_id) {
		this.rdsc_id = rdsc_id;
	}

	public String getFclty_id() {
		return fclty_id;
	}

	public void setFclty_id(String fclty_id) {
		this.fclty_id = fclty_id;
	}

	public String getExamin_date() {
		return examin_date;
	}

	public void setExamin_date(String examin_date) {
		this.examin_date = examin_date;
	}

	public String getSido() {
		return sido;
	}

	public void setSido(String sido) {
		this.sido = sido;
	}

	public String getGu() {
		return gu;
	}

	public void setGu(String gu) {
		this.gu = gu;
	}

	public String getDong() {
		return dong;
	}

	public void setDong(String dong) {
		this.dong = dong;
	}

	public String getDong_code() {
		return dong_code;
	}

	public void setDong_code(String dong_code) {
		this.dong_code = dong_code;
	}

	public static long getSerialVersionUID() {
		return serialVersionUID;
	}

	public String getGu_code() {
		return gu_code;
	}

	public void setGu_code(String gu_code) {
		this.gu_code = gu_code;
	}

	public String getS_dong_code() {
		return s_dong_code;
	}

	public void setS_dong_code(String s_dong_code) {
		this.s_dong_code = s_dong_code;
	}

	public String getK_sido() {
		return k_sido;
	}

	public void setK_sido(String k_sido) {
		this.k_sido = k_sido;
	}

	public String getK_gu() {
		return k_gu;
	}

	public void setK_gu(String k_gu) {
		this.k_gu = k_gu;
	}

	public String getK_dong_code() {
		return k_dong_code;
	}

	public void setK_dong_code(String k_dong_code) {
		this.k_dong_code = k_dong_code;
	}

	public String getS_gu() {
		return s_gu;
	}

	public void setS_gu(String s_gu) {
		this.s_gu = s_gu;
	}
}
