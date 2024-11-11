package egovframework.zaol.common.service;

import java.io.Serializable;

import egovframework.zaol.board.vo.BoardDefaultVO;

public class ZipCodeVO extends BoardDefaultVO implements Serializable {

	private String zip_no;
	private String zipcode;
	private String zipcode1;
	private String zipcode2;
	private String sido;
	private String gugun;
	private String dong;
	private String bunji;
	private String address;
	
	public ZipCodeVO() {
		zip_no = "";
		zipcode = "";
		zipcode1 = "";
		zipcode2 = "";
		sido = "";
		gugun = "";
		dong = "";
		bunji = "";
		address = "";
	}

	public String getZip_no() {
		return zip_no;
	}

	public void setZip_no(String zip_no) {
		this.zip_no = zip_no;
	}

	public String getZipcode() {
		return zipcode;
	}

	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}

	
	public String getZipcode1() {
		return zipcode1;
	}

	public void setZipcode1(String zipcode1) {
		this.zipcode1 = zipcode1;
	}

	public String getZipcode2() {
		return zipcode2;
	}

	public void setZipcode2(String zipcode2) {
		this.zipcode2 = zipcode2;
	}

	public String getSido() {
		return sido;
	}

	public void setSido(String sido) {
		this.sido = sido;
	}

	public String getGugun() {
		return gugun;
	}

	public void setGugun(String gugun) {
		this.gugun = gugun;
	}

	public String getDong() {
		return dong;
	}

	public void setDong(String dong) {
		this.dong = dong;
	}

	public String getBunji() {
		return bunji;
	}

	public void setBunji(String bunji) {
		this.bunji = bunji;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	
	
}
