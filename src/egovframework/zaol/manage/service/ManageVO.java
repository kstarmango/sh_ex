package egovframework.zaol.manage.service;

import java.io.Serializable;
import org.apache.commons.lang.builder.ToStringBuilder;
import egovframework.zaol.ad.boardmaster.service.BoardMDefaultVO;

@SuppressWarnings("serial")
public class ManageVO extends BoardMDefaultVO implements Serializable{

	public  String rno;
	private String seq ;                                         
	private String user_id ;                                    
	private String user_pass ;                                  
	private String user_name ;                                  
	private String user_position ;                              
	private String user_phone ;                                 
	private String user_auth ;                                  
	private String updt_id ;                                     
	private String reg_date ;                                    
	private String updt_date ;
	private String del_yn;
	private String s_sjt;
	private String s_ctn;
	private String s_all;
	private String startDate;
    private String endDate;
    private String adminYn;
	private String In_out;
	
	private String file_seq;
	private String boad_seq;
	private String atchmfl_nm;
	private String lgclfl_nm;
	private String flpth_dc;
	private String extsn_nm;
	private String file_mg;
	
	private String board_gubun;
	private String reg_name;
	private String open_gb;
	private String board_sjt;
	private String board_contents;
	private String board_cnt;
	private String regest_id;
	private String regest_date;
	
	private String udpate_date;
	private String use_at;
	
	private String s_serch_gb;
	private String s_serch_nm;

	private String open_start_date;
	private String close_end_date;
	private String  post_open;
	private String asnew_flg;
	private String re_lev;
	private String re_group;
	
	
	public String getRe_lev() {
		return re_lev;
	}
	public void setRe_lev(String re_lev) {
		this.re_lev = re_lev;
	}
	public String getRe_group() {
		return re_group;
	}
	public void setRe_group(String re_group) {
		this.re_group = re_group;
	}
	    
	public String getAsnew_flg() {
		return asnew_flg;
	}
	public void setAsnew_flg(String asnew_flg) {
		this.asnew_flg = asnew_flg;
	}
	public String getPost_open() {
		return post_open;
	}
	public void setPost_open(String post_open) {
		this.post_open = post_open;
	}
	public String getOpen_start_date() {
		return open_start_date;
	}
	public void setOpen_start_date(String open_start_date) {
		this.open_start_date = open_start_date;
	}
	public String getClose_end_date() {
		return close_end_date;
	}
	public void setClose_end_date(String close_end_date) {
		this.close_end_date = close_end_date;
	}
	public String getS_serch_gb() {
		return s_serch_gb;
	}
	public void setS_serch_gb(String s_serch_gb) {
		this.s_serch_gb = s_serch_gb;
	}
	public String getS_serch_nm() {
		return s_serch_nm;
	}
	public void setS_serch_nm(String s_serch_nm) {
		this.s_serch_nm = s_serch_nm;
	}
	public String getIn_out() {
		return In_out;
	}
	public void setIn_out(String in_out) {
		In_out = in_out;
	}
    
	public String getAdminYn() {
		return adminYn;
	}
	public void setAdminYn(String adminYn) {
		this.adminYn = adminYn;
	}
	public String getRno() {
		return rno;
	}
	public void setRno(String rno) {
		this.rno = rno;
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
	public String getUser_pass() {
		return user_pass;
	}
	public void setUser_pass(String user_pass) {
		this.user_pass = user_pass;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
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
	public String getDel_yn() {
		return del_yn;
	}
	public void setDel_yn(String del_yn) {
		this.del_yn = del_yn;
	}
	public String getS_sjt() {
		return s_sjt;
	}
	public void setS_sjt(String s_sjt) {
		this.s_sjt = s_sjt;
	}
	public String getS_ctn() {
		return s_ctn;
	}
	public void setS_ctn(String s_ctn) {
		this.s_ctn = s_ctn;
	}
	public String getS_all() {
		return s_all;
	}
	public void setS_all(String s_all) {
		this.s_all = s_all;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getFile_seq() {
		return file_seq;
	}
	public void setFile_seq(String file_seq) {
		this.file_seq = file_seq;
	}
	public String getBoad_seq() {
		return boad_seq;
	}
	public void setBoad_seq(String boad_seq) {
		this.boad_seq = boad_seq;
	}
	public String getAtchmfl_nm() {
		return atchmfl_nm;
	}
	public void setAtchmfl_nm(String atchmfl_nm) {
		this.atchmfl_nm = atchmfl_nm;
	}
	public String getLgclfl_nm() {
		return lgclfl_nm;
	}
	public void setLgclfl_nm(String lgclfl_nm) {
		this.lgclfl_nm = lgclfl_nm;
	}
	public String getFlpth_dc() {
		return flpth_dc;
	}
	public void setFlpth_dc(String flpth_dc) {
		this.flpth_dc = flpth_dc;
	}
	public String getExtsn_nm() {
		return extsn_nm;
	}
	public void setExtsn_nm(String extsn_nm) {
		this.extsn_nm = extsn_nm;
	}
	public String getFile_mg() {
		return file_mg;
	}
	public void setFile_mg(String file_mg) {
		this.file_mg = file_mg;
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
	public String getBoard_contents() {
		return board_contents;
	}
	public void setBoard_contents(String board_contents) {
		this.board_contents = board_contents;
	}
	public String getBoard_cnt() {
		return board_cnt;
	}
	public void setBoard_cnt(String board_cnt) {
		this.board_cnt = board_cnt;
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
	public String getUse_at() {
		return use_at;
	}
	public void setUse_at(String use_at) {
		this.use_at = use_at;
	}
	
}
