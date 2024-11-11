package egovframework.zaol.common;

import java.io.Serializable;

/**
 * 새주소 정보와 검색관련 항목 정의
 *
 * @author wongaside
 *
 */
public class AddressZipcodeVO implements Serializable {

	/**
	 *
	 */
	private static final long serialVersionUID = 7128569035058128485L;

	public String bm_code = "";
	public String zip_code = "";
	public String bjd_code = "";
	public String sido = "";
	public String gu = "";
	public String dong = "";
	public String ri = "";
	public String san = "";
	public String jibun_bon = "";
	public String jibun_bu = "";
	public String road_code = "";
	public String road_nm = "";
	public String jiha = "";
	public String bdbun_bon = "";
	public String bdbun_bu = "";
	public String bd_nm = "";
	public String bd_nm_detail = "";

	public String getBm_code() {
		return bm_code;
	}
	public void setBm_code(String bm_code) {
		this.bm_code = bm_code;
	}
	public String getZip_code() {
		return zip_code;
	}
	public void setZip_code(String zip_code) {
		this.zip_code = zip_code;
	}
	public String getBjd_code() {
		return bjd_code;
	}
	public void setBjd_code(String bjd_code) {
		this.bjd_code = bjd_code;
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
	public String getRi() {
		return ri;
	}
	public void setRi(String ri) {
		this.ri = ri;
	}
	public String getSan() {
		return san;
	}
	public void setSan(String san) {
		this.san = san;
	}
	public String getJibun_bon() {
		return jibun_bon;
	}
	public void setJibun_bon(String jibun_bon) {
		this.jibun_bon = jibun_bon;
	}
	public String getJibun_bu() {
		return jibun_bu;
	}
	public void setJibun_bu(String jibun_bu) {
		this.jibun_bu = jibun_bu;
	}
	public String getRoad_code() {
		return road_code;
	}
	public void setRoad_code(String road_code) {
		this.road_code = road_code;
	}
	public String getRoad_nm() {
		return road_nm;
	}
	public void setRoad_nm(String road_nm) {
		this.road_nm = road_nm;
	}
	public String getJiha() {
		return jiha;
	}
	public void setJiha(String jiha) {
		this.jiha = jiha;
	}
	public String getBdbun_bon() {
		return bdbun_bon;
	}
	public void setBdbun_bon(String bdbun_bon) {
		this.bdbun_bon = bdbun_bon;
	}
	public String getBdbun_bu() {
		return bdbun_bu;
	}
	public void setBdbun_bu(String bdbun_bu) {
		this.bdbun_bu = bdbun_bu;
	}
	public String getBd_nm() {
		return bd_nm;
	}
	public void setBd_nm(String bd_nm) {
		this.bd_nm = bd_nm;
	}
	public String getBd_nm_detail() {
		return bd_nm_detail;
	}
	public void setBd_nm_detail(String bd_nm_detail) {
		this.bd_nm_detail = bd_nm_detail;
	}
}
