package egovframework.zaol.home.service.impl;

import java.util.List;
import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.zaol.home.service.HomeService;
import egovframework.zaol.home.service.HomeVO;
import org.apache.commons.codec.binary.Base64;

@Service("homeService")
public class HomeServiceImpl extends AbstractServiceImpl implements HomeService {

    @Resource(name="homeDAO")
    private HomeDAO homeDAO;
    
    public HomeVO selectHomeLogin01             (HomeVO vo) throws Exception { return homeDAO.selectHomeLogin01             (vo); } /* 사용자 로그인 액션  */
    public void   selectHomeLogin02             (HomeVO vo) throws Exception {        homeDAO.selectHomeLogin02             (vo); } /* 로그인 액션후 사용자접속이력정보 등록 */
    public void   insertHomeLogincolctins01     (HomeVO vo) throws Exception {        homeDAO.insertHomeLogincolctins01     (vo); } /* 로그인정보수집 등록액션 */ //2011-12-05 양중목 추가
    public void   updateHomeLoginpswnoupt01     (HomeVO vo) throws Exception {        homeDAO.updateHomeLoginpswnoupt01     (vo); } /* 비밀번호변경   변경액션 */ //2011-12-19 양중목 추가
    public void   updateHomeLoginsaupnoupt01    (HomeVO vo) throws Exception {        homeDAO.updateHomeLoginsaupnoupt01    (vo); } /* 사업자번호수집 변경액션 */ //2011-12-19 양중목 추가
    public HomeVO selectHomeOgcr_Vrify01        (HomeVO vo) throws Exception { return homeDAO.selectHomeOgcr_Vrify01        (vo); } /* 공인인증서검증액션 */
    public HomeVO selectHomeqestna_partcptn01   (HomeVO vo) throws Exception { return homeDAO.selectHomeqestna_partcptn01   (vo); } /* 설문조사 참여 정보 가져오기 */ //2013-09-24 허진관추가
    public List   deptTopList01                 (HomeVO vo) throws Exception { return homeDAO.deptTopList01   (vo); } 
    public List   selectMidleList               (String parent_dept_top) throws Exception { return homeDAO.selectMidleList   (parent_dept_top); }
    public List   selectSubList                 (HomeVO vo) throws Exception { return homeDAO.selectSubList   (vo); }
    public HomeVO userIdDplctAjax01             (HomeVO vo) throws Exception { return homeDAO.userIdDplctAjax01   (vo); }
    public HomeVO selectMebersinfo              (HomeVO vo) throws Exception { return homeDAO.selectMebersinfo(vo); }
    public void   updateNoticeupt     (HomeVO vo) throws Exception {homeDAO.updateNoticeupt     (vo);}
    public void   updateQeupt     (HomeVO vo) throws Exception {homeDAO.updateQeupt     (vo);}
    public HomeVO selectBoardData              (HomeVO vo) throws Exception { 
    	
    	vo.setSeq_int(Integer.parseInt(vo.getSeq()));
    	return homeDAO.selectBoardData(vo); 
    }
    public void   noticeInserteStart     (HomeVO vo) throws Exception {        homeDAO.noticeInserteStart     (vo); }
    public void   qInserteStart     (HomeVO vo) throws Exception {        homeDAO.qInserteStart     (vo); }
    
    public void   qDelStar     (HomeVO vo) throws Exception {homeDAO.qDelStar     (vo);}
    public int    userListCnt                   (HomeVO vo) throws Exception { return homeDAO.userListCnt(vo); } /* 사용자목록 리스트건수 */
    public int    authCnts                   (String userS_id) throws Exception { return homeDAO.authCnts(userS_id); } /* 사용자목록 리스트건수 */
    public List   userListPage                  (HomeVO vo) throws Exception { return homeDAO.userListPage   (vo); }
    public int    qListPageCnt                   (HomeVO vo) throws Exception { return homeDAO.qListPageCnt(vo); } /* 사용자목록 리스트건수 */
    public List   qListPage                  (HomeVO vo) throws Exception { return homeDAO.qListPage   (vo); }
    public int    memAccessListCnt                   (HomeVO vo) throws Exception { return homeDAO.memAccessListCnt(vo); } /* 사용자 접속 기록 건수 */
    public List   memAccessList                  (HomeVO vo) throws Exception { return homeDAO.memAccessList   (vo); }     /* 사용자 접속 기록 리스트 */
    public int    noticeListPageCnt                   (HomeVO vo) throws Exception { return homeDAO.noticeListPageCnt(vo); } /* 사용자목록 리스트건수 */
    public List   noticeListPage                  (HomeVO vo) throws Exception { return homeDAO.noticeListPage   (vo); }
    public void   memAuthudp01    		         (HomeVO vo) throws Exception { homeDAO.memAuthudp01    (vo);}
    public static Base64 enBase64 = new Base64();
    public void   updateMemberupt    (HomeVO vo) throws Exception {  
    	
    	String password = vo.getUser_password();
    	String result = encrypt(password);
    	vo.setUser_password(result);
    	
    	homeDAO.updateMemberupt    (vo);
    } 
    public void   resetPass    (HomeVO vo) throws Exception {  
    	
    	String password = "SH1234";
    	String result = encrypt(password);
    	vo.setUser_password(result);
    	
    	homeDAO.resetPass    (vo);
    } 
   
    public void shMemberInsert(HomeVO vo) throws Exception { 
    
    	String password = vo.getUser_password();
    	String result = encrypt(password);
    	vo.setUser_password(result);
    	
    	homeDAO.shMemberInsert(vo); 
    	
    }
       
	private String encrypt(String password) {
		
		return new String(Base64.encodeBase64(password.getBytes()));
	}
	/* 설문조사 참여 정보등록액션  */ //2013-09-24 허진관추가 멀티로 변경
    public void insertHomeQstresins01(HomeVO vo) throws Exception
    {
        homeDAO.insertHomeQstresins01(vo);  //설문조사 참여 정보등록액션

        String[] qestna_cn_qesitm_nocheck = vo.getQestna_cn_qesitm_nocheck();        /* 쉼표로 담길용 사용자ID */
        for(int i = 0 ; i < qestna_cn_qesitm_nocheck.length ; i++)
        {
        	String s_qestna_cn_qesitm_nocheck = qestna_cn_qesitm_nocheck[i];
        	System.out.println(i+" s_qestna_cn_qesitm_nocheck = "+s_qestna_cn_qesitm_nocheck);
        	System.out.println(i+" qestna_cn_qesitm_nocheck[i].split(@!@).length = "+qestna_cn_qesitm_nocheck[i].split("@!@").length);
        	String qestna_cn_no     = "";
            String qestna_qesitm_no = "";
            String qestna_res_cn    = "";
            if(qestna_cn_qesitm_nocheck[i].split("@!@").length > 1)
            {
            	qestna_cn_no     = qestna_cn_qesitm_nocheck[i].split("@!@")[0];  /* 설문조사 내용 번호 */
                qestna_qesitm_no = qestna_cn_qesitm_nocheck[i].split("@!@")[1];  /* 설문조사 문항 번호 */
                if(qestna_cn_qesitm_nocheck[i].split("@!@").length > 2)
                {
                	qestna_res_cn = qestna_cn_qesitm_nocheck[i].split("@!@")[2]; /* 설문조사 결과 내용 */
                }//end if
	        	vo.setQestna_cn_no    (qestna_cn_no    );
	        	vo.setQestna_qesitm_no(qestna_qesitm_no);
	        	vo.setQestna_res_cn   (qestna_res_cn   );
	        	homeDAO.insertHomeQstresins02(vo); //설문조사 결과 정보등록액션
            }//end if
        }
    }

    public HomeVO     selectQestnaSjno01                (HomeVO vo) throws Exception { return homeDAO.selectQestnaSjno01            (vo); } /* 설문조사관리 설문조사 키값    */
    
    
    public List     noticePopup                (HomeVO vo) throws Exception { return homeDAO.noticePopup            (vo); } 
}
