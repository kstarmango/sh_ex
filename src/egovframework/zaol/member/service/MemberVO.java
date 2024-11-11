package egovframework.zaol.member.service;

import egovframework.zaol.ad.boardmaster.service.BoardMDefaultVO;

public class MemberVO extends BoardMDefaultVO {

	/**
	 *
	 */
	private static final long serialVersionUID = 1379735709352836821L;

	// master
	private String mem_id;
	private String mem_user_id;
	private String mem_user_id_chkd;
	private String mem_name;
	private String mem_pw;
	private String mem_user_id_type;
	private String mem_using_state;
	private String mem_reg_date;
	private String mem_last_login_date;
	private String mem_nick_name;
	private String mem_nick_name_chkd;
	private String mem_level;
	private String mem_contact;
	private String mem_using_news_check;
	private String mem_detail_id;
	private String mem_ti_no;
	private String mem_email_key;
	private String mem_news_send_flag;
	private String mem_using_sigong_check;
	private String mem_using_sms_check;
	private String mem_email_send_flag;

	// detail
	private String mem_home_address;
	private String mem_company;
	private String mem_company_address;
	private String mem_sex;
	private String mem_age;
	private String mem_anniversary;
	private String mem_wedding_check;
	private String mem_homepage;
	private String mem_twitter;
	private String mem_facebook;
	private String mem_me2day;
	private String mem_contact2;
	private String mem_intro;
	private String mem_extra_1;
	private String mem_extra_2;
	private String mem_extra_3;
	private String mem_extra_4;
	private String mem_extra_5;
	private String mem_extra_6;
	private String mem_extra_7;
	private String mem_extra_8;
	private String mem_extra_9;
	private String mem_extra_10;
	private String mem_edu_info_agree_check;
	private String mem_id_number1;
	private String mem_id_number2;
	private String mem_email;
	private String mem_dept;
	private String mem_position;
	private String mem_tel;
	private String mem_cellphone;
	private String mem_edu_name;
	private String mem_company_tel;
	private String mem_company_zipcode;

	// leave info
	private String mem_leave_id;
	private String mem_leave_reason;
	private String mem_leave_date;


	public MemberVO() {
		mem_id = "";
		mem_user_id = "";
		mem_name = "";
		mem_pw = "";
		mem_user_id_type = "";
		mem_using_state = "";
		mem_reg_date = "";
		mem_last_login_date = "";
		mem_nick_name = "";
		mem_level = "";
		mem_contact = "";
		mem_using_news_check = "";
		mem_detail_id = "";
		mem_ti_no = "";
		mem_email_key = "";
		mem_home_address = "";
		mem_company = "";
		mem_company_address = "";
		mem_sex = "";
		mem_age = "";
		mem_anniversary = "";
		mem_wedding_check = "";
		mem_homepage = "";
		mem_twitter = "";
		mem_facebook = "";
		mem_me2day = "";
		mem_contact2 = "";
		mem_intro = "";
		mem_extra_1 = "";
		mem_extra_2 = "";
		mem_extra_3 = "";
		mem_extra_4 = "";
		mem_extra_5 = "";
		mem_extra_6 = "";
		mem_extra_7 = "";
		mem_extra_8 = "";
		mem_extra_9 = "";
		mem_extra_10 = "";
		mem_edu_info_agree_check = "";
		mem_id_number1 = "";
		mem_id_number2 = "";
		mem_email = "";
		mem_dept = "";
		mem_position = "";
		mem_tel = "";
		mem_cellphone = "";
		mem_edu_name = "";
		mem_company_tel = "";
		mem_company_zipcode = "";
		mem_leave_reason = "";
		mem_leave_date = "";
		mem_leave_id = "";
		mem_news_send_flag = "";
		mem_using_sigong_check = "";
		mem_using_sms_check = "";
		mem_email_send_flag = "";
	}

	public String getMem_email_send_flag() {
		return mem_email_send_flag;
	}

	public void setMem_email_send_flag(String mem_email_send_flag) {
		this.mem_email_send_flag = mem_email_send_flag;
	}

	public String getMem_using_sms_check() {
		return mem_using_sms_check;
	}

	public void setMem_using_sms_check(String mem_using_sms_check) {
		this.mem_using_sms_check = mem_using_sms_check;
	}

	public String getMem_news_send_flag() {
		return mem_news_send_flag;
	}

	public void setMem_news_send_flag(String mem_news_send_flag) {
		this.mem_news_send_flag = mem_news_send_flag;
	}

	public String getMem_using_sigong_check() {
		return mem_using_sigong_check;
	}

	public void setMem_using_sigong_check(String mem_using_sigong_check) {
		this.mem_using_sigong_check = mem_using_sigong_check;
	}

	public String getMem_leave_date() {
		return mem_leave_date;
	}

	public void setMem_leave_date(String mem_leave_date) {
		this.mem_leave_date = mem_leave_date;
	}

	public String getMem_leave_id() {
		return mem_leave_id;
	}

	public void setMem_leave_id(String mem_leave_id) {
		this.mem_leave_id = mem_leave_id;
	}

	public String getMem_leave_reason() {
		return mem_leave_reason;
	}

	public void setMem_leave_reason(String mem_leave_reason) {
		this.mem_leave_reason = mem_leave_reason;
	}

	public String getMem_email_key() {
		return mem_email_key;
	}

	public void setMem_email_key(String mem_email_key) {
		this.mem_email_key = mem_email_key;
	}

	public String getMem_company_zipcode() {
		return mem_company_zipcode;
	}

	public void setMem_company_zipcode(String mem_company_zipcode) {
		this.mem_company_zipcode = mem_company_zipcode;
	}

	public String getMem_company_tel() {
		return mem_company_tel;
	}

	public void setMem_company_tel(String mem_company_tel) {
		this.mem_company_tel = mem_company_tel;
	}

	public String getMem_user_id_chkd() {
		return mem_user_id_chkd;
	}

	public void setMem_user_id_chkd(String mem_user_id_chkd) {
		this.mem_user_id_chkd = mem_user_id_chkd;
	}

	public String getMem_nick_name_chkd() {
		return mem_nick_name_chkd;
	}

	public void setMem_nick_name_chkd(String mem_nick_name_chkd) {
		this.mem_nick_name_chkd = mem_nick_name_chkd;
	}

	public String getMem_ti_no() {
		return mem_ti_no;
	}

	public void setMem_ti_no(String mem_ti_no) {
		this.mem_ti_no = mem_ti_no;
	}

	public String getMem_id() {
		return mem_id;
	}

	public void setMem_id(String mem_id) {
		this.mem_id = mem_id;
	}

	public String getMem_user_id() {
		return mem_user_id;
	}

	public void setMem_user_id(String mem_user_id) {
		this.mem_user_id = mem_user_id;
	}

	public String getMem_name() {
		return mem_name;
	}

	public void setMem_name(String mem_name) {
		this.mem_name = mem_name;
	}

	public String getMem_pw() {
		return mem_pw;
	}

	public void setMem_pw(String mem_pw) {
		this.mem_pw = mem_pw;
	}

	public String getMem_user_id_type() {
		return mem_user_id_type;
	}

	public void setMem_user_id_type(String mem_user_id_type) {
		this.mem_user_id_type = mem_user_id_type;
	}

	public String getMem_using_state() {
		return mem_using_state;
	}

	public void setMem_using_state(String mem_using_state) {
		this.mem_using_state = mem_using_state;
	}

	public String getMem_reg_date() {
		return mem_reg_date;
	}

	public void setMem_reg_date(String mem_reg_date) {
		this.mem_reg_date = mem_reg_date;
	}

	public String getMem_last_login_date() {
		return mem_last_login_date;
	}

	public void setMem_last_login_date(String mem_last_login_date) {
		this.mem_last_login_date = mem_last_login_date;
	}

	public String getMem_nick_name() {
		return mem_nick_name;
	}

	public void setMem_nick_name(String mem_nick_name) {
		this.mem_nick_name = mem_nick_name;
	}

	public String getMem_level() {
		return mem_level;
	}

	public void setMem_level(String mem_level) {
		this.mem_level = mem_level;
	}

	public String getMem_contact() {
		return mem_contact;
	}

	public void setMem_contact(String mem_contact) {
		this.mem_contact = mem_contact;
	}

	public String getMem_using_news_check() {
		return mem_using_news_check;
	}

	public void setMem_using_news_check(String mem_using_news_check) {
		this.mem_using_news_check = mem_using_news_check;
	}

	public String getMem_detail_id() {
		return mem_detail_id;
	}

	public void setMem_detail_id(String mem_detail_id) {
		this.mem_detail_id = mem_detail_id;
	}

	public String getMem_home_address() {
		return mem_home_address;
	}

	public void setMem_home_address(String mem_home_address) {
		this.mem_home_address = mem_home_address;
	}

	public String getMem_company() {
		return mem_company;
	}

	public void setMem_company(String mem_company) {
		this.mem_company = mem_company;
	}

	public String getMem_company_address() {
		return mem_company_address;
	}

	public void setMem_company_address(String mem_company_address) {
		this.mem_company_address = mem_company_address;
	}

	public String getMem_sex() {
		return mem_sex;
	}

	public void setMem_sex(String mem_sex) {
		this.mem_sex = mem_sex;
	}

	public String getMem_age() {
		return mem_age;
	}

	public void setMem_age(String mem_age) {
		this.mem_age = mem_age;
	}

	public String getMem_anniversary() {
		return mem_anniversary;
	}

	public void setMem_anniversary(String mem_anniversary) {
		this.mem_anniversary = mem_anniversary;
	}

	public String getMem_wedding_check() {
		return mem_wedding_check;
	}

	public void setMem_wedding_check(String mem_wedding_check) {
		this.mem_wedding_check = mem_wedding_check;
	}

	public String getMem_homepage() {
		return mem_homepage;
	}

	public void setMem_homepage(String mem_homepage) {
		this.mem_homepage = mem_homepage;
	}

	public String getMem_twitter() {
		return mem_twitter;
	}

	public void setMem_twitter(String mem_twitter) {
		this.mem_twitter = mem_twitter;
	}

	public String getMem_facebook() {
		return mem_facebook;
	}

	public void setMem_facebook(String mem_facebook) {
		this.mem_facebook = mem_facebook;
	}

	public String getMem_me2day() {
		return mem_me2day;
	}

	public void setMem_me2day(String mem_me2day) {
		this.mem_me2day = mem_me2day;
	}

	public String getMem_contact2() {
		return mem_contact2;
	}

	public void setMem_contact2(String mem_contact2) {
		this.mem_contact2 = mem_contact2;
	}

	public String getMem_intro() {
		return mem_intro;
	}

	public void setMem_intro(String mem_intro) {
		this.mem_intro = mem_intro;
	}

	public String getMem_extra_1() {
		return mem_extra_1;
	}

	public void setMem_extra_1(String mem_extra_1) {
		this.mem_extra_1 = mem_extra_1;
	}

	public String getMem_extra_2() {
		return mem_extra_2;
	}

	public void setMem_extra_2(String mem_extra_2) {
		this.mem_extra_2 = mem_extra_2;
	}

	public String getMem_extra_3() {
		return mem_extra_3;
	}

	public void setMem_extra_3(String mem_extra_3) {
		this.mem_extra_3 = mem_extra_3;
	}

	public String getMem_extra_4() {
		return mem_extra_4;
	}

	public void setMem_extra_4(String mem_extra_4) {
		this.mem_extra_4 = mem_extra_4;
	}

	public String getMem_extra_5() {
		return mem_extra_5;
	}

	public void setMem_extra_5(String mem_extra_5) {
		this.mem_extra_5 = mem_extra_5;
	}

	public String getMem_extra_6() {
		return mem_extra_6;
	}

	public void setMem_extra_6(String mem_extra_6) {
		this.mem_extra_6 = mem_extra_6;
	}

	public String getMem_extra_7() {
		return mem_extra_7;
	}

	public void setMem_extra_7(String mem_extra_7) {
		this.mem_extra_7 = mem_extra_7;
	}

	public String getMem_extra_8() {
		return mem_extra_8;
	}

	public void setMem_extra_8(String mem_extra_8) {
		this.mem_extra_8 = mem_extra_8;
	}

	public String getMem_extra_9() {
		return mem_extra_9;
	}

	public void setMem_extra_9(String mem_extra_9) {
		this.mem_extra_9 = mem_extra_9;
	}

	public String getMem_extra_10() {
		return mem_extra_10;
	}

	public void setMem_extra_10(String mem_extra_10) {
		this.mem_extra_10 = mem_extra_10;
	}

	public String getMem_edu_info_agree_check() {
		return mem_edu_info_agree_check;
	}

	public void setMem_edu_info_agree_check(String mem_edu_info_agree_check) {
		this.mem_edu_info_agree_check = mem_edu_info_agree_check;
	}

	public String getMem_id_number1() {
		return mem_id_number1;
	}

	public void setMem_id_number1(String mem_id_number1) {
		this.mem_id_number1 = mem_id_number1;
	}

	public String getMem_id_number2() {
		return mem_id_number2;
	}

	public void setMem_id_number2(String mem_id_number2) {
		this.mem_id_number2 = mem_id_number2;
	}

	public String getMem_email() {
		return mem_email;
	}

	public void setMem_email(String mem_email) {
		this.mem_email = mem_email;
	}

	public String getMem_dept() {
		return mem_dept;
	}

	public void setMem_dept(String mem_dept) {
		this.mem_dept = mem_dept;
	}

	public String getMem_position() {
		return mem_position;
	}

	public void setMem_position(String mem_position) {
		this.mem_position = mem_position;
	}

	public String getMem_tel() {
		return mem_tel;
	}

	public void setMem_tel(String mem_tel) {
		this.mem_tel = mem_tel;
	}

	public String getMem_cellphone() {
		return mem_cellphone;
	}

	public void setMem_cellphone(String mem_cellphone) {
		this.mem_cellphone = mem_cellphone;
	}

	public String getMem_edu_name() {
		return mem_edu_name;
	}

	public void setMem_edu_name(String mem_edu_name) {
		this.mem_edu_name = mem_edu_name;
	}


}
