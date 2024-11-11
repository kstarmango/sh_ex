package egovframework.zaol.home.service.impl;

import java.util.List;
import org.springframework.stereotype.Repository;

import egovframework.zaol.common.OracleDAO;
import egovframework.zaol.home.service.HomeVO;

@Repository("homeDAO")
public class HomeDAO extends OracleDAO {

    public HomeVO selectHomeLogin01             (HomeVO homeVO) throws Exception { return (HomeVO)selectByPk("homeDAO.selectHomeLogin01"             , homeVO); }/* 로그인 액션후 세션정보를 위한 셀렉트  */
    public void   selectHomeLogin02             (HomeVO homeVO) throws Exception {        insert            ("homeDAO.selectHomeLogin02"             , homeVO); }/* 로그인 액션후 사용자접속이력정보 등록 */
    public void   insertHomeLogincolctins01     (HomeVO homeVO) throws Exception {        insert            ("homeDAO.insertHomeLogincolctins01"     , homeVO); }/* 로그인정보수집 등록액션 */  //2011-12-05 양중목 추가
    public void   updateHomeLoginpswnoupt01     (HomeVO homeVO) throws Exception {        update            ("homeDAO.updateHomeLoginpswnoupt01"     , homeVO); }/* 비밀번호변경   변경액션 */  //2011-12-19 양중목 추가
    public void   updateHomeLoginsaupnoupt01    (HomeVO homeVO) throws Exception {        update            ("homeDAO.updateHomeLoginsaupnoupt01"    , homeVO); }/* 사업자번호수집 변경액션 */  //2011-12-19 양중목 추가
    public HomeVO selectHomeOgcr_Vrify01        (HomeVO homeVO) throws Exception { return (HomeVO)selectByPk("homeDAO.selectHomeOgcr_Vrify01"        , homeVO); }/* 공인인증서검증액션 */
    public HomeVO selectHomeqestna_partcptn01   (HomeVO homeVO) throws Exception { return (HomeVO)selectByPk("homeDAO.selectHomeqestna_partcptn01"   , homeVO); }/* 설문조사 참여 정보 가져오기 */ //2013-09-24 허진관추가
    public HomeVO selectQestnaSjno01            (HomeVO homeVO) throws Exception { return (HomeVO)selectByPk("homeDAO.selectQestnaSjno01"            , homeVO); }/* 설문조사관리 설문제목 키값  */
    public void   insertHomeQstresins01         (HomeVO homeVO) throws Exception {        insert            ("homeDAO.insertHomeQstresins01"         , homeVO); }/* 설문조사 참여 정보등록액션  */ //2013-09-24 허진관추가
    public void   insertHomeQstresins02         (HomeVO homeVO) throws Exception {        insert            ("homeDAO.insertHomeQstresins02"         , homeVO); }/* 설문조사 참여 정보등록액션  */ //2013-09-24 허진관추가
    public List   deptTopList01                 (HomeVO homeVO) throws Exception { return list("homeDAO.deptTopList01"             , homeVO); } 
    public List   selectMidleList               (String parent_dept_top)   throws Exception { return list("homeDAO.selectMidleList"             , parent_dept_top); }
    public List   selectSubList                 (HomeVO homeVO) throws Exception { return list("homeDAO.selectSubList"             , homeVO); }
    public HomeVO userIdDplctAjax01             (HomeVO homeVO) throws Exception { return (HomeVO)selectByPk("homeDAO.userIdDplctAjax01", homeVO); }
    public void   shMemberInsert                (HomeVO homeVO) throws Exception {        insert              ("homeDAO.shMemberInsert"             , homeVO); }
    public HomeVO selectMebersinfo              (HomeVO homeVO) throws Exception{ return (HomeVO) selectByPk( "homeDAO.selectMebersinfo", homeVO); }
    public HomeVO selectBoardData              (HomeVO homeVO) throws Exception{ return (HomeVO) selectByPk( "homeDAO.selectBoardData", homeVO); }
    public void   updateMemberupt    		    (HomeVO homeVO) throws Exception {        update            ("homeDAO.updateMemberupt"    , homeVO); }
    public void   resetPass    		    (HomeVO homeVO) throws Exception {        update            ("homeDAO.resetPass"    , homeVO); }
    public int    userListCnt                   (HomeVO homeVO) throws Exception {return    (Integer)selectByPk("homeDAO.userListCnt"          , homeVO); } /* 사용자목록 리스트건수 */
    public List   userListPage                  (HomeVO homeVO) throws Exception { return list("homeDAO.userListPage"             , homeVO); }
    public int    noticeListPageCnt                   (HomeVO homeVO) throws Exception {return    (Integer)selectByPk("homeDAO.noticeListPageCnt"          , homeVO); } /* 사용자목록 리스트건수 */
    public List   noticeListPage                  (HomeVO homeVO) throws Exception { return list("homeDAO.noticeListPage"             , homeVO); }
    public int    qListPageCnt                   (HomeVO homeVO) throws Exception {return    (Integer)selectByPk("homeDAO.qListPageCnt"          , homeVO); } /* 사용자목록 리스트건수 */
    public List   qListPage                  (HomeVO homeVO) throws Exception { return list("homeDAO.qListPage"             , homeVO); }
    public void   memAuthudp01    		        (HomeVO homeVO) throws Exception {        update            ("homeDAO.memAuthudp01"    , homeVO); }
    public void   updateNoticeupt    		    (HomeVO homeVO) throws Exception {        update            ("homeDAO.updateNoticeupt"    , homeVO); }
    public void   noticeInserteStart         (HomeVO homeVO) throws Exception {        insert            ("homeDAO.noticeInserteStart"         , homeVO); }
    public void   updateQeupt    		    (HomeVO homeVO) throws Exception {        update            ("homeDAO.updateQeupt"    , homeVO); }
    public void   qDelStar    		    (HomeVO homeVO) throws Exception {        update            ("homeDAO.qDelStar"    , homeVO); }
    public void   qInserteStart         (HomeVO homeVO) throws Exception {        insert            ("homeDAO.qInserteStart"         , homeVO); }
    public int    authCnts                   (String authCnts) throws Exception {return    (Integer)selectByPk("homeDAO.authCnts"          , authCnts); } /* 사용자목록 리스트건수 */
    public int    memAccessListCnt                   (HomeVO homeVO) throws Exception {return    (Integer)selectByPk("homeDAO.memAccessListCnt"          , homeVO); } /* 사용자목록 리스트건수 */
    public List   memAccessList                  (HomeVO homeVO) throws Exception { return list("homeDAO.memAccessList"             , homeVO); }
    
    public List   noticePopup                  (HomeVO homeVO) throws Exception { return list("homeDAO.noticePopup"             , homeVO); }
}
