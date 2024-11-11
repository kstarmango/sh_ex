package egovframework.zaol.dash.service;

import java.io.Serializable;
import org.apache.commons.lang.builder.ToStringBuilder;
import egovframework.zaol.ad.boardmaster.service.BoardMDefaultVO;

@SuppressWarnings("serial")
public class DashVO extends BoardMDefaultVO implements Serializable{

	public String agent_no = ""; /* 수립대행자번호 2012-10-30 양중목 추가 */
	private String login_id       = ""; /* 로그인ID  2011-12-09 양중목 추가 */
 	private String user_id        = ""; /*  사용자ID */
 	private String grc_cd         = ""; /*  권역구분코드명 */
 	private String grc_cd_nm      = ""; /*  권역구분코드명 2011-11-05 양중목 추가 */
 	private String user_nm        = ""; /*  사용자명 */
 	private String user_password  = ""; /*  비밀번호 */
 	private String new_user_password  = ""; /*  신규_비밀번호 2011-12-19 양중목 추가 */
 	private String user_ihidnum   = ""; /*  사용자 주민번호 */
 	private String user_telno     = ""; /*  사용자 연락처 */
 	private String user_mbtlnum   = ""; /*  휴대폰번호 */
 	private String user_fax       = ""; /*  FAX번호 */
 	private String user_email     = ""; /*  E-MAIL ADDRESS */
 	private String email_rcv      = ""; /*  이메일 수신여부 (Y: 사용함, N: 사용 안함) */
 	private String user_ty        = ""; /*  사용자 구분 */
 	private String regist_date    = ""; /*  등록일시 */
 	private String regist_id      = ""; /*  등록한 사용자ID */
 	private String updt_date      = ""; /*  변경일시 */
 	private String updt_id        = ""; /*  수정한 사용자ID */
 	private String conect_ip      = ""; /*  접속자IP */
 	private String use_at         = ""; /*  사용여부 (Y: 사용함, N: 사용 안함) */
 	private String appr_at        = ""; /*  승인여부 (Y: 승인  , N: 미승인   ) */
 	private String user_ty_nm     = ""; /*  사용자 구분명  2011-08-30 양중목 추가*/
 	private String conect_id      = ""; /* 이력정보 ID */
 	private String agent_jurirno  = ""; /* 법인 또는 사업자등록번호 2011-12-19 양중목 추가 */
 	private String dn_info        = ""; /* DN정보  2012-01-16 양중목 추가 */
 	private String user_pass = "";
    public String qestna_res_cn         = ""; /* 설문조사 결과 내용 */ 
    public String qestna_sj_no          = ""; /* 설문조사 제목 번호 */
    public String qestna_res_no         = ""; /* 설문조사 결과 번호 */
    public String qestna_partcptn_no    = ""; /* 설문조사 참여 번호 */
    public String qestna_qesitm_no      = ""; /* 설문조사 문항 번호 */
    public String qestna_cn_no          = ""; /* 설문조사 내용 번호 */
    public String qestna_cn_ty		    = ""; /* 설문조사 내용 타입 */
    public String qestna_cn_nm			= ""; /* 설문조사 내용 명   */
    public String qestna_qesitm_ty      = ""; /* 설문조사 문항 타입 */
    public String qestna_qesitm_nm      = ""; /* 설문조사 문항명    */
    public String rno = "";
    
    // user_info
    private String sh_user_id = "";
    private String sh_user_pw = "";
    private String user_name = "";
    private String user_dept = "";
    private String user_position = "";
    private String user_hp = "";
    private String user_mail = "";
    private String user_auth = "";
  
	private String reg_date = "";
    private String in_out = "";
    private String del_yn = "";
    
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
    public String topDept_name = "";
    public String midDept_name = "";
    public String subDept_name = "";
    
    public String board_gubun = "";
    public String reg_name  = "";
    public String user_dept_all  = "";
    public String open_gb  = "";
    public String board_sjt = "";
    public String content = "";
    public String board_cnt  = "";
    public String refer_no  = "";
    public String board_step = "";
    public String level_ling  = "";
    public String regest_id  = "";
    public String regest_date  = "";
    public String udpate_date = "";
    public String seq = "";
    public int seq_int = 0;
    public String bg_gb = "";
    
    
    
	public String getRno() {
		return rno;
	}
	public void setRno(String rno) {
		this.rno = rno;
	}
	public String getBg_gb() {
		return bg_gb;
	}
	public void setBg_gb(String bg_gb) {
		this.bg_gb = bg_gb;
	}
	public int getSeq_int() {
		return seq_int;
	}
	public void setSeq_int(int seq_int) {
		this.seq_int = seq_int;
	}
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getBoard_gubun() {
		return board_gubun;
	}
	public void setBoard_gubun(String board_gubun) {
		this.board_gubun = board_gubun;
	}
	public String getReg_name() {
		return reg_name;
	}
	public void setReg_name(String reg_name) {
		this.reg_name = reg_name;
	}
	public String getUser_dept_all() {
		return user_dept_all;
	}
	public void setUser_dept_all(String user_dept_all) {
		this.user_dept_all = user_dept_all;
	}
	public String getOpen_gb() {
		return open_gb;
	}
	public void setOpen_gb(String open_gb) {
		this.open_gb = open_gb;
	}
	public String getBoard_sjt() {
		return board_sjt;
	}
	public void setBoard_sjt(String board_sjt) {
		this.board_sjt = board_sjt;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getBoard_cnt() {
		return board_cnt;
	}
	public void setBoard_cnt(String board_cnt) {
		this.board_cnt = board_cnt;
	}
	public String getRefer_no() {
		return refer_no;
	}
	public void setRefer_no(String refer_no) {
		this.refer_no = refer_no;
	}
	public String getBoard_step() {
		return board_step;
	}
	public void setBoard_step(String board_step) {
		this.board_step = board_step;
	}
	public String getLevel_ling() {
		return level_ling;
	}
	public void setLevel_ling(String level_ling) {
		this.level_ling = level_ling;
	}
	public String getRegest_id() {
		return regest_id;
	}
	public void setRegest_id(String regest_id) {
		this.regest_id = regest_id;
	}
	public String getRegest_date() {
		return regest_date;
	}
	public void setRegest_date(String regest_date) {
		this.regest_date = regest_date;
	}
	public String getUdpate_date() {
		return udpate_date;
	}
	public void setUdpate_date(String udpate_date) {
		this.udpate_date = udpate_date;
	}
	public String getTopDept_name() {
		return topDept_name;
	}
	public void setTopDept_name(String topDept_name) {
		this.topDept_name = topDept_name;
	}
	public String getMidDept_name() {
		return midDept_name;
	}
	public void setMidDept_name(String midDept_name) {
		this.midDept_name = midDept_name;
	}
	public String getSubDept_name() {
		return subDept_name;
	}
	public void setSubDept_name(String subDept_name) {
		this.subDept_name = subDept_name;
	}
	public String getEptoncat() {
		return eptoncat;
	}
	public void setEptoncat(String eptoncat) {
		this.eptoncat = eptoncat;
	}
	public String getUser_phone() {
		return user_phone;
	}
	public void setUser_phone(String user_phone) {
		this.user_phone = user_phone;
	}
	public String getDept_top() {
		return dept_top;
	}
	public void setDept_top(String dept_top) {
		this.dept_top = dept_top;
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
	public String getDept_sub() {
		return dept_sub;
	}
	public void setDept_sub(String dept_sub) {
		this.dept_sub = dept_sub;
	}
	public String getDept_middle() {
		return dept_middle;
	}
	public void setDept_middle(String dept_middle) {
		this.dept_middle = dept_middle;
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
	public String getIn_out() {
		return in_out;
	}
	public void setIn_out(String in_out) {
		this.in_out = in_out;
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
	public String getUser_pass() {
		return user_pass;
	}
	public void setUser_pass(String user_pass) {
		this.user_pass = user_pass;
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
	public String[] getQestna_cn_qesitm_nocheck() {
		return qestna_cn_qesitm_nocheck;
	}
	public void setQestna_cn_qesitm_nocheck(String[] qestna_cn_qesitm_nocheck) {
		this.qestna_cn_qesitm_nocheck = qestna_cn_qesitm_nocheck;
	}
	public String []qestna_cn_qesitm_nocheck;      

	public String getQestna_cn_nm() {
		return qestna_cn_nm;
	}
	public void setQestna_cn_nm(String qestna_cn_nm) {
		this.qestna_cn_nm = qestna_cn_nm;
	}
	public String getQestna_qesitm_ty() {
		return qestna_qesitm_ty;
	}
	public void setQestna_qesitm_ty(String qestna_qesitm_ty) {
		this.qestna_qesitm_ty = qestna_qesitm_ty;
	}
	public String getQestna_qesitm_nm() {
		return qestna_qesitm_nm;
	}
	public void setQestna_qesitm_nm(String qestna_qesitm_nm) {
		this.qestna_qesitm_nm = qestna_qesitm_nm;
	}
	public String getQestna_cn_ty() {
		return qestna_cn_ty;
	}
	public void setQestna_cn_ty(String qestna_cn_ty) {
		this.qestna_cn_ty = qestna_cn_ty;
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
	public String getAppr_at() {
		return appr_at;
	}
	public void setAppr_at(String appr_at) {
		this.appr_at = appr_at;
	}
	public String getGrc_cd_nm() {
		return grc_cd_nm;
	}
	public void setGrc_cd_nm(String grc_cd_nm) {
		this.grc_cd_nm = grc_cd_nm;
	}
	public String getConect_id() {
		return conect_id;
	}
	public void setConect_id(String conect_id) {
		this.conect_id = conect_id;
	}
	public String getLogin_id() {
		return login_id;
	}
	public void setLogin_id(String login_id) {
		this.login_id = login_id;
	}
	public String getNew_user_password() {
		return new_user_password;
	}
	public void setNew_user_password(String new_user_password) {
		this.new_user_password = new_user_password;
	}
	public String getAgent_jurirno() {
		return agent_jurirno;
	}
	public void setAgent_jurirno(String agent_jurirno) {
		this.agent_jurirno = agent_jurirno;
	}
	public String getDn_info() {
		return dn_info;
	}
	public void setDn_info(String dn_info) {
		this.dn_info = dn_info;
	}
	public String getAgent_no() {
		return agent_no;
	}
	public void setAgent_no(String agent_no) {
		this.agent_no = agent_no;
	}
	public String getQestna_res_cn() {
		return qestna_res_cn;
	}
	public void setQestna_res_cn(String qestna_res_cn) {
		this.qestna_res_cn = qestna_res_cn;
	}
	public String getQestna_sj_no() {
		return qestna_sj_no;
	}
	public void setQestna_sj_no(String qestna_sj_no) {
		this.qestna_sj_no = qestna_sj_no;
	}
	public String getQestna_res_no() {
		return qestna_res_no;
	}
	public void setQestna_res_no(String qestna_res_no) {
		this.qestna_res_no = qestna_res_no;
	}
	public String getQestna_partcptn_no() {
		return qestna_partcptn_no;
	}
	public void setQestna_partcptn_no(String qestna_partcptn_no) {
		this.qestna_partcptn_no = qestna_partcptn_no;
	}
	public String getQestna_qesitm_no() {
		return qestna_qesitm_no;
	}
	public void setQestna_qesitm_no(String qestna_qesitm_no) {
		this.qestna_qesitm_no = qestna_qesitm_no;
	}
	public String getQestna_cn_no() {
		return qestna_cn_no;
	}
	public void setQestna_cn_no(String qestna_cn_no) {
		this.qestna_cn_no = qestna_cn_no;
	}
	

}
