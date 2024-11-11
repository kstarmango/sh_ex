package egovframework.zaol.common.service;

import java.io.Serializable;
import org.apache.commons.lang.builder.ToStringBuilder;
import egovframework.zaol.ad.boardmaster.service.BoardMDefaultVO;

@SuppressWarnings("serial")
public class CommonSessionVO extends BoardMDefaultVO implements Serializable{

 	private String user_id       ; /* 사용자ID */
 	private String grc_cd        ; /* 권역구분코드 */
 	private String grc_cd_nm     ; /* 권역구분코드명 2011-11-05 양중목 추가 */
 	private String user_nm       ; /* 사용자명 */
 	private String user_password ; /* 비밀번호 */
 	private String user_ihidnum  ; /* 사용자 주민번호 */
 	private String user_telno    ; /* 사용자 연락처 */
 	private String user_mbtlnum  ; /* 휴대폰번호 */
 	private String user_fax      ; /* FAX번호 */
 	private String user_email    ; /* E-MAIL ADDRESS */
 	private String email_rcv     ; /* 이메일 수신여부 (Y: 사용함, N: 사용 안함) */
 	private String user_ty       ; /* 사용자 구분 */
 	private String regist_date   ; /* 등록일시 */
 	private String regist_id     ; /* 등록한 사용자ID */
 	private String updt_date     ; /* 변경일시 */
 	private String updt_id       ; /* 수정한 사용자ID */
 	private String conect_ip     ; /* 접속자IP */
 	private String use_at        ; /* 사용여부 (Y: 사용함, N: 사용 안함) */
 	private String user_ty_nm    ; /* 사용자 구분명  2011-08-30 양중목 추가*/
 	
 	 // user_info
    private String sh_user_id = "";			
    private String sh_user_pw = "";
    private String user_name = "";        // 사용자 이름
    private String user_dept = "";        // 사용자 부서
    private String user_position = "";    // 사용자 직급
    private String user_hp = "";     	  // 사용자 휴대전화 번호
    private String user_mail = "";        // 사용자 메일
    private String user_auth = "";        // 사용자 권한
    private String user_auth_desc = "";   // 사용자 권한 설명
    private String user_admin_yn = "";	  // 사용자 관리자 여부
    private String user_lauth = "";       // 사용자 레이어 권한
    private String user_lauth_desc = "";  // 사용자 레이어 권한 설명
    private String reg_date = "";         // 등록일자
    private String del_yn = "";           // 삭제 여부
        
    private String dept_gubun = "";
    private String top_cd = "";
    private String middle_cd = "";
    private String sub_cd = "";
    private String dept_name = "";
    private String dept_middle = "";
    private String dept_sub = "";
    private String parent_dept_top2 = "";
    private String parent_dept_sub = "";
    public String dept_top = "";
    public String user_phone = "";
    public String eptoncat = "";
    
    
    
	public String getEptoncat() {
		return eptoncat;
	}
	public void setEptoncat(String eptoncat) {
		this.eptoncat = eptoncat;
	}
	public String getDept_gubun() {
		return dept_gubun;
	}
	public void setDept_gubun(String dept_gubun) {
		this.dept_gubun = dept_gubun;
	}
	public String getTop_cd() {
		return top_cd;
	}
	public void setTop_cd(String top_cd) {
		this.top_cd = top_cd;
	}
	public String getMiddle_cd() {
		return middle_cd;
	}
	public void setMiddle_cd(String middle_cd) {
		this.middle_cd = middle_cd;
	}
	public String getSub_cd() {
		return sub_cd;
	}
	public void setSub_cd(String sub_cd) {
		this.sub_cd = sub_cd;
	}
	public String getDept_name() {
		return dept_name;
	}
	public void setDept_name(String dept_name) {
		this.dept_name = dept_name;
	}
	public String getDept_middle() {
		return dept_middle;
	}
	public void setDept_middle(String dept_middle) {
		this.dept_middle = dept_middle;
	}
	public String getDept_sub() {
		return dept_sub;
	}
	public void setDept_sub(String dept_sub) {
		this.dept_sub = dept_sub;
	}
	public String getParent_dept_top2() {
		return parent_dept_top2;
	}
	public void setParent_dept_top2(String parent_dept_top2) {
		this.parent_dept_top2 = parent_dept_top2;
	}
	public String getParent_dept_sub() {
		return parent_dept_sub;
	}
	public void setParent_dept_sub(String parent_dept_sub) {
		this.parent_dept_sub = parent_dept_sub;
	}
	public String getDept_top() {
		return dept_top;
	}
	public void setDept_top(String dept_top) {
		this.dept_top = dept_top;
	}
	public String getUser_phone() {
		return user_phone;
	}
	public void setUser_phone(String user_phone) {
		this.user_phone = user_phone;
	}
	public String getSh_user_id() {
		return sh_user_id;
	}
	public void setSh_user_id(String sh_user_id) {
		this.sh_user_id = sh_user_id;
	}
	public String getSh_user_pw() {
		return sh_user_pw;
	}
	public void setSh_user_pw(String sh_user_pw) {
		this.sh_user_pw = sh_user_pw;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getUser_dept() {
		return user_dept;
	}
	public void setUser_dept(String user_dept) {
		this.user_dept = user_dept;
	}
	public String getUser_position() {
		return user_position;
	}
	public void setUser_position(String user_position) {
		this.user_position = user_position;
	}
	public String getUser_hp() {
		return user_hp;
	}
	public void setUser_hp(String user_hp) {
		this.user_hp = user_hp;
	}
	public String getUser_mail() {
		return user_mail;
	}
	public void setUser_mail(String user_mail) {
		this.user_mail = user_mail;
	}
	public String getUser_auth() {
		return user_auth;
	}
	public void setUser_auth(String user_auth) {
		this.user_auth = user_auth;
	}
	public String getUser_auth_desc() {
		return user_auth_desc;
	}
	public void setUser_auth_desc(String user_auth_desc) {
		this.user_auth_desc = user_auth_desc;
	}
	public String getUser_admin_yn() {
		return user_admin_yn;
	}
	public void setUser_admin_yn(String user_admin_yn) {
		this.user_admin_yn = user_admin_yn;
	}
	public String getUser_lauth() {
		return user_lauth;
	}
	public void setUser_lauth(String user_lauth) {
		this.user_lauth = user_lauth;
	}
	public String getUser_lauth_desc() {
		return user_lauth_desc;
	}
	public void setUser_lauth_desc(String user_lauth_desc) {
		this.user_lauth_desc = user_lauth_desc;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getDel_yn() {
		return del_yn;
	}
	public void setDel_yn(String del_yn) {
		this.del_yn = del_yn;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getGrc_cd() {
		return grc_cd;
	}
	public void setGrc_cd(String grc_cd) {
		this.grc_cd = grc_cd;
	}
	public String getUser_nm() {
		return user_nm;
	}
	public void setUser_nm(String user_nm) {
		this.user_nm = user_nm;
	}
	public String getUser_password() {
		return user_password;
	}
	public void setUser_password(String user_password) {
		this.user_password = user_password;
	}
	public String getUser_ihidnum() {
		return user_ihidnum;
	}
	public void setUser_ihidnum(String user_ihidnum) {
		this.user_ihidnum = user_ihidnum;
	}
	public String getUser_telno() {
		return user_telno;
	}
	public void setUser_telno(String user_telno) {
		this.user_telno = user_telno;
	}
	public String getUser_mbtlnum() {
		return user_mbtlnum;
	}
	public void setUser_mbtlnum(String user_mbtlnum) {
		this.user_mbtlnum = user_mbtlnum;
	}
	public String getUser_fax() {
		return user_fax;
	}
	public void setUser_fax(String user_fax) {
		this.user_fax = user_fax;
	}
	public String getUser_email() {
		return user_email;
	}
	public void setUser_email(String user_email) {
		this.user_email = user_email;
	}
	public String getEmail_rcv() {
		return email_rcv;
	}
	public void setEmail_rcv(String email_rcv) {
		this.email_rcv = email_rcv;
	}
	public String getUser_ty() {
		return user_ty;
	}
	public void setUser_ty(String user_ty) {
		this.user_ty = user_ty;
	}
	public String getRegist_date() {
		return regist_date;
	}
	public void setRegist_date(String regist_date) {
		this.regist_date = regist_date;
	}
	public String getRegist_id() {
		return regist_id;
	}
	public void setRegist_id(String regist_id) {
		this.regist_id = regist_id;
	}
	public String getUpdt_date() {
		return updt_date;
	}
	public void setUpdt_date(String updt_date) {
		this.updt_date = updt_date;
	}
	public String getUpdt_id() {
		return updt_id;
	}
	public void setUpdt_id(String updt_id) {
		this.updt_id = updt_id;
	}
	public String getConect_ip() {
		return conect_ip;
	}
	public void setConect_ip(String conect_ip) {
		this.conect_ip = conect_ip;
	}
	public String getUse_at() {
		return use_at;
	}
	public void setUse_at(String use_at) {
		this.use_at = use_at;
	}
	public String getUser_ty_nm() {
		return user_ty_nm;
	}
	public void setUser_ty_nm(String user_ty_nm) {
		this.user_ty_nm = user_ty_nm;
	}
	public String getGrc_cd_nm() {
		return grc_cd_nm;
	}
	public void setGrc_cd_nm(String grc_cd_nm) {
		this.grc_cd_nm = grc_cd_nm;
	}

}
