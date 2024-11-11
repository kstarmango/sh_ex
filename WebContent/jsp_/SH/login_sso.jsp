<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="com.dreamsecurity.sso.agent.api.*,com.dreamsecurity.sso.lib.jsn.JSONObject,com.dreamsecurity.sso.agent.util.Util"
%>
<%! 
	// 선택된 겸직정보 추출
	public org.json.simple.JSONObject getADJB_INFO(org.json.simple.JSONObject joEtcInfo) {
		org.json.simple.JSONObject returnJO = null;
		try {
			String strCHC_ADJB_SN = (String) joEtcInfo.get("CHC_ADJB_SN");
			org.json.simple.JSONArray jaADJB_LST = (org.json.simple.JSONArray) joEtcInfo.get("ADJB_LST");
			if(jaADJB_LST!=null) {
				for(int i = 0; i < jaADJB_LST.size(); i++) {
					org.json.simple.JSONObject tmpJo = (org.json.simple.JSONObject) jaADJB_LST.get(i);
					if(strCHC_ADJB_SN.equals((String) tmpJo.get("ADJB_SN"))) {
							
						returnJO = tmpJo;
						break;
					}
				}
			}
		} catch(Exception e) {
			// Exception 처리	
			throw e;
		}
		return returnJO;
	}
	
	// 특정 시스템 정보 추출
	public org.json.simple.JSONObject getLINK_SYS_INFO(org.json.simple.JSONObject joAdjbInfo, String strLINK_SYS_SE_CD) {
		org.json.simple.JSONObject returnJO = null;
		try {
			org.json.simple.JSONArray jaLINK_SYS_SE_LST = (org.json.simple.JSONArray) joAdjbInfo.get("LINK_SYS_SE_LST");
			if(jaLINK_SYS_SE_LST!=null) {
				for(int i = 0; i < jaLINK_SYS_SE_LST.size(); i++) {
					org.json.simple.JSONObject tmpJo = (org.json.simple.JSONObject) jaLINK_SYS_SE_LST.get(i);
					if(strLINK_SYS_SE_CD.equals((String) tmpJo.get("LINK_SYS_SE_CD"))) {
						returnJO = tmpJo;
						break;
					}
				}
			}
		} catch(Exception e) {
			// Exception 처리	
			throw e;
		}
		return returnJO;
	}
%>


<%
String jsonStr = "";
String errStr = "";

String LINK_SYS_SE_CD = "63"; // 각 시스템에 할당된 코드값 셋팅   ===============================>업체별 소스 수정 영역<========================
//시스템 코드
//10	전자문서
//20	BSC성과
//86	New Shine
//90	AS-IS 샤인(운영)
//87	AS-IS 샤인(개발)
//88	AS-IS 샤인(테스트)
//89	AS-IS 샤인(임시개발)
//91	개인정보
//92	웹하드
//93	외부메일
//94	전자책
//95	대량메일
//96	홈페이지
//98	메신저
//61	전세임대
//62	기록물
//63	토지자원
//64	개인정보파기
//65	테스트데이터변환









// 변수 초기화
String USER_ID = "";	// 사용자 ID
String DPT_CD = "";		// 부서코드
String DPT_NM = "";		// 부서명
String DTY_CD = "";		// 직책코드
String DTY_NM = "";		// 직책명
String JBPS_CD = "";	// 직위코드
String JBPS_NM = "";	// 직위명
String LINK_SYS_USER_ID = "";	// 연계시스템ID
// 변수 초기화

try {

	// 세션에서 SSO 연동 아이디 추출
	String strSsoId = (String) session.getAttribute("SSO_ID");
	
	if(strSsoId == null) { // SSO 연계가 정상적이지 않은 경우 or SSO 로그인을 하지 않은 경우
		
		//===============================>업체별 소스 수정 영역<========================
		// 오류메시지 후 (SSO 로그인을 하지 않음)
		// 기존 로그인 정보 초기화 및 통합 로그인 페이지 이동 등의 업무 처리 : https://login.i-sh.co.kr
		// 기타 오류처리
		
		// 토지자원관리
		// https://login.i-sh.co.kr/login/portal/loginSample.jsp
		response.sendRedirect("https://login.i-sh.co.kr/login/portal/loginSample.jsp");
	
	} else { // SSO 정보가 정상인 경우 and SSO 로그인 처리 된 경우
		
		// SSO에서 제공하는 API로 SSO 정보 데이터 조회
		JSONObject joSSO_USER_DATA = UserService.getUserData(strSsoId);
		// userService에 getUserData가 없음
	
		if(joSSO_USER_DATA != null) {	// SSO 정보 데이터가 정상적인 경우
			jsonStr = joSSO_USER_DATA.toJSONString(); // Debug용 (조회데이터 확인)
			
			// SSO 정보 데이터에서 data 항목 추출
			JSONObject joSSO_DATA = (JSONObject)joSSO_USER_DATA.get("data");
			
			if(joSSO_DATA != null) {	// SSO 정보 데이터에서 추출한 data 항목이 정상인 경우
				
				// data 항목에서 ETC_INFO 정보 추출
				String strEtcInfo = (String) joSSO_DATA.get("ETC_INFO");
				if(strEtcInfo == null || strEtcInfo.length() == 0) {	// data 항목에서 추출한 ETC_INFO 정보가 비정상인 경우
					//===============================>업체별 소스 수정 영역<========================
					// 오류메시지 후 (data 항목에서 추출한 ETC_INFO 정보가 비정상)
					// 창 닫음
					// 기타 오류처리
					
					throw new Exception("\"ETC_INFO\" NODE IS NULL");	
				
				} else {	// data 항목에서 추출한 ETC_INFO 정보가 정상인 경우
				
					// String으로 들어있는 JSON 데이터를 Simple.JSON을 통해 JSONObject 로 파싱
					org.json.simple.parser.JSONParser jp = new org.json.simple.parser.JSONParser();
					org.json.simple.JSONObject joEtcInfo = (org.json.simple.JSONObject) jp.parse(strEtcInfo);
					
					// ETC_INFO 에서 USER_ID 항목 추출
					USER_ID = (String) joEtcInfo.get("USER_ID");
					
					// ETC_INFO 에서 선택된 겸직에 맞는 겸직 정보 추출
					org.json.simple.JSONObject joAdjbInfo = getADJB_INFO(joEtcInfo);
					
					if(joAdjbInfo == null) {	// 선택된 겸직 정보가 비어있는 경우(지정된 겸직 정보 오류)
						
					//===============================>업체별 소스 수정 영역<========================
					// 오류메시지 후 (선택된 겸직 정보가 비어있는 경우(지정된 겸직 정보 오류))
					// 창 닫음
					// 기타 오류처리
						throw new Exception("ADJB INFO is NULL");
					
					} else {
						
						// 선택된 겸직 정보 추출 : 필요시 사용
						DPT_CD = (String) joAdjbInfo.get("DPT_CD");//부서코드
						DPT_NM = (String) joAdjbInfo.get("DPT_NM");//부서명
						DTY_CD = (String) joAdjbInfo.get("DTY_CD");//직책코드
						DTY_NM = (String) joAdjbInfo.get("DTY_NM");//직책코드
						JBPS_CD = (String) joAdjbInfo.get("JBPS_CD");//직위코드
						JBPS_NM = (String) joAdjbInfo.get("JBPS_NM");//직위명
						// 선택된 겸직 정보 추출
						
						// 연계 시스템 구분 목록에서 시스템 지정 값 추출
						org.json.simple.JSONObject joLinkSysInfo = getLINK_SYS_INFO(joAdjbInfo, LINK_SYS_SE_CD);
						
						if(joLinkSysInfo == null) {	// 시스템 접속 권한이 없는 경우
						 //===============================>업체별 소스 수정 영역<========================
					     // 오류메시지 후 (시스템 접속권한이 없음)
					     // 창 닫음
					     // 기타 오류처리
							throw new Exception("System Auth Check Fail");	// 해당 시스템 사용 권한이 없음
						
						} else {
							
							//전자문서의 경우 겸직아이디 추출 후 로그인 처리
							if(LINK_SYS_SE_CD.equals("10")){
								// 전자문서 아이디 추출
								//LINK_SYS_USER_ID = (String) joLinkSysInfo.get("LINK_SYS_USER_ID");  //예 : A2322, B3222
								
						
								//LINK_SYS_USER_ID로 로그인 처리
							}else { //그 외 시스템
								//위 104줄의 USER_ID로 로그인 처리 2322 (신규sso부터 A+사번(A2222)을 널겨주지 않음, 기존 아이디가 A사번 4자리인경우 A붙여서 로그인 처리해야함)
								response.sendRedirect("http://192.168.110.154:38091/web/cmmn/ssoLogin.do?user_id="+USER_ID);
							
								
							}
								
							
						}
						
					}
				}
				
			} else {	// SSO 정보 데이터에서 추출한 data 항목이 비정상인 경우
			    //===============================>업체별 소스 수정 영역<========================
					// 오류메시지 후 (SSO 정보 데이터에서 추출한 data 항목이 비정상)
					// 창 닫음
					// 기타 오류처리
				throw new Exception("\"data\" NODE IS NULL");
			}
			
		} else {	// SSO 정보 데이터가 비정상적인 경우
		             //===============================>업체별 소스 수정 영역<========================
					// 오류메시지 후 (SSO 정보 데이터가 비정상적인 경우)
					// 창 닫음
					// 기타 오류처리
			throw new Exception("SSO USER DATA IS NULL");
		}

	}
	
} catch(Exception e) {
   //===============================>업체별 소스 수정 영역<========================
	// 오류메시지 후 (SSO 오류)
	// 창 닫음
	// 기타 오류처리
	// Exception 처리
	errStr = e.getMessage();
}

%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SSO ETC_INFO SAMPLE</title>
</head>
<body>

	LINK_SYS_SE_CD = <%=LINK_SYS_SE_CD %><br/><br/>
	jsonStr = <%=jsonStr %><br/>
	errStr = <%=errStr %><br/><br/>
	USER_ID = <%=USER_ID %><br/>
	DPT_CD = <%=DPT_CD %><br/>
	DPT_NM = <%=DPT_NM %><br/>
	DTY_CD = <%=DTY_CD %><br/>
	DTY_NM = <%=DTY_NM %><br/>
	JBPS_CD = <%=JBPS_CD %><br/>
	JBPS_NM = <%=JBPS_NM %><br/>
	LINK_SYS_USER_ID = <%=LINK_SYS_USER_ID %><br/>
	
</body>
</html>

