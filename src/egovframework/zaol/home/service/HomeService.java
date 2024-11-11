package egovframework.zaol.home.service;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import egovframework.zaol.home.service.HomeVO;

public interface HomeService {

    public HomeVO selectHomeLogin01             (HomeVO homeVO) throws Exception; /* 일반 로그인을 처리한다 */
    public void   selectHomeLogin02             (HomeVO homeVO) throws Exception; /* 로그인 액션후 사용자접속이력정보 등록 */
    public void   insertHomeLogincolctins01     (HomeVO homeVO) throws Exception; /* 로그인정보수집 등록액션 */ //2011-12-05 양중목 추가
    public void   updateHomeLoginpswnoupt01     (HomeVO homeVO) throws Exception; /* 비밀번호변경   변경액션 */ //2011-12-19 양중목 추가
    public void   updateHomeLoginsaupnoupt01    (HomeVO homeVO) throws Exception; /* 사업자번호수집 변경액션 */ //2011-12-19 양중목 추가
    public HomeVO selectHomeOgcr_Vrify01        (HomeVO homeVO) throws Exception; /* 공인인증서검증액션 */
    public HomeVO selectHomeqestna_partcptn01   (HomeVO homeVO) throws Exception; /* 설문조사 참여 정보 가져오기 */ //2013-09-24 허진관추가
    public HomeVO selectQestnaSjno01            (HomeVO homeVO) throws Exception; /* 설문조사관리 제목정보 키값   */
    public void   insertHomeQstresins01         (HomeVO homeVO) throws Exception; /* 설문조사 참여 정보등록액션  */ //2013-09-24 허진관추가selectMidleList
    @Transactional(readOnly=true)
    public List   deptTopList01                 (HomeVO homeVO) throws Exception;   /* 부서 대분류 리스트     */
    @Transactional(readOnly=true)
    public List   selectMidleList               (String parent_dept_top) throws Exception; /* 부서 중분류 리스트     */
    @Transactional(readOnly=true)
    public List   selectSubList                 (HomeVO homeVO) throws Exception; /* 부서 소분류 리스트     */ 
    public HomeVO userIdDplctAjax01             (HomeVO homeVO) throws Exception;
    public void   shMemberInsert                (HomeVO homeVO) throws Exception; 
    public HomeVO selectMebersinfo              (HomeVO homeVO) throws Exception;
    public HomeVO selectBoardData              (HomeVO homeVO) throws Exception;
    public void   updateQeupt              (HomeVO homeVO) throws Exception;
    public void   updateMemberupt              (HomeVO homeVO) throws Exception;
    public void   resetPass              (HomeVO homeVO) throws Exception;
    public void   updateNoticeupt              (HomeVO homeVO) throws Exception;
    public void   memAuthudp01                 (HomeVO homeVO) throws Exception;
    public int    userListCnt				   (HomeVO homeVO) throws Exception;
    public int   authCnts				       (String userS_id) throws Exception;
    public List   userListPage                 (HomeVO homeVO) throws Exception; 
    public int    noticeListPageCnt			   (HomeVO homeVO) throws Exception;
    public void   noticeInserteStart           (HomeVO homeVO) throws Exception;
    public List   noticeListPage                (HomeVO homeVO) throws Exception;
    public int    qListPageCnt				   (HomeVO homeVO) throws Exception;
    public void   qInserteStart           (HomeVO homeVO) throws Exception;
    public List   qListPage                 (HomeVO homeVO) throws Exception;
    public void   qDelStar              (HomeVO homeVO) throws Exception;
    public int    memAccessListCnt			   (HomeVO homeVO) throws Exception; /* 사용자 접속 기록 건수 */
    public List   memAccessList                (HomeVO homeVO) throws Exception; /* 사용자 접속 기록 리스트 */
    public List   noticePopup                 (HomeVO homeVO) throws Exception;
}
