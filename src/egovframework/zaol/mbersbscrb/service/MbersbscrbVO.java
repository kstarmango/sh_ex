package egovframework.zaol.mbersbscrb.service;

import java.io.Serializable;

@SuppressWarnings("serial")
public class MbersbscrbVO implements Serializable{

	private String seq;              // 일렬번호
	private String user_id;          // 사용자ID
	private String user_name;	     // 사용자이름
	private String user_pass;        // 사용자패스워드 
	private String user_position;    // 사용자부서
	private String user_phone;       // 사용자전화번호
	private String user_auth;        // 사용자권한
	private String updt_id;          // 사용자수정ID
	private String reg_date;         // 사용자등록일자
	private String updt_date;        // 사용자수정일자 
	private String mode;			 // 모드
    private String In_out;
    
	public String getIn_out() {
		return In_out;
	}
	public void setIn_out(String in_out) {
		In_out = in_out;
	}
	
	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	public String getUser_id() {
		return user_id;
	}
	
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	
	public String getUser_name() {
		
		return user_name;
	}
	
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	
	public String getUser_pass() {
		return user_pass;
	}
	
	public void setUser_pass(String user_pass) {
		this.user_pass = user_pass;
	}
	
	public String getUser_position() {
		return user_position;
	}
	
	public void setUser_position(String user_position) {
		this.user_position = user_position;
	}
	
	public String getUser_phone() {
		return user_phone;
	}
	
	public void setUser_phone(String user_phone) {
		this.user_phone = user_phone;
	}
	
	public String getUser_auth() {
		return user_auth;
	}
	
	public void setUser_auth(String user_auth) {
		this.user_auth = user_auth;
	}
	
	public String getUpdt_id() {
		return updt_id;
	}
	
	public void setUpdt_id(String updt_id) {
		this.updt_id = updt_id;
	}
	
	public String getReg_date() {
		return reg_date;
	}
	
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	
	public String getUpdt_date() {
		return updt_date;
	}
	
	public void setUpdt_date(String updt_date) {
		this.updt_date = updt_date;
	}

	public String getMode() {
		return mode;
	}

	public void setMode(String mode) {
		this.mode = mode;
	}
	
}
