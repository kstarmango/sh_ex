package egovframework.zaol.common.web;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 컨트롤러에서 경고 메시지 출력 등의 처리를 하기 위한 클래스
 *
 * @author pathos
 *
 */
public class JavaScriptHelper {

	private HttpServletResponse	_response		= null;
	private HttpServletRequest	_request		= null;
	private String				_encodingType	= "utf-8";


	/**
	 * getter/setter 정의
	 */


	public void SetResponse(HttpServletResponse _response) {
		this._response = _response;
	}
	public void SetRequest(HttpServletRequest _request) {
		this._request = _request;
	}
	public void SetEncodingType(String _encodingType) {
		this._encodingType = _encodingType;
	}

	public HttpServletResponse GetResponse() {
		return _response;
	}
	public HttpServletRequest GetRequest() {
		return _request;
	}
	public String GetEncodingType() {
		return _encodingType;
	}


	/**
	 * 경고메시지를 보여준 후 지정된 값만큼 history.go 한다.
	 * @param msg 경고 메시지
	 * @param historyGo go value
	 * @throws IOException 
	 * @throws Exception
	 */
	public void AlertAndHistoryGo(String msg, int historyGo) throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>alert('" + msg + "');history.go(" + historyGo + ");</script>");
	}

	/**
	 * 경고메시지를 보여준 후 지정된 url 로 이동한다.
	 * @param msg 경고 메시지
	 * @param url 리턴 url
	 * @throws Exception
	 */
	public void AlertAndUrlGo(String msg, String url) throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>alert('" + msg + "');location.href='" + url + "';</script>");
	}

	/**
	 * 경고메시지를 보여준다.
	 * @param msg 경고 메시지
	 * @throws Exception
	 */
	public void Alert(String msg) throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>alert('" + msg + "');</script>");
	}

	/**
	 * 경고메시지를 보여주고 현재 창을 닫는다.
	 * @param msg 경고 메시지
	 * @throws Exception
	 */
	public void AlertAndClose(String msg) throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>alert('" + msg + "'); window.close();</script>");
	}

	/**
	 * 경고메시지를 보여주고 부모창 새로고침 후 창 닫기( 부모창이 없으면 자기 자신 새로고침 됨 ) ( 2011-08-08 양중목 추가 )
	 * @param msg 경고 메시지
	 * @throws Exception
	 */
	public void AlertPopupDone(String msg) throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>" +
				"alert('" + msg + "');if( opener != null) { opener.location.reload(); window.close(); } else { location.reload(); }</script>");
	}
	/**
	 * 부모창 새로고침 후 창 닫기( 부모창이 없으면 자기 자신 새로고침 됨 ) ( 2011-12-05 양중목 추가 )
	 * @param msg 경고 메시지
	 * @throws Exception
	 */
	public void OpenerReloadAndPopupDone() throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>" +
				"if( opener != null) { opener.location.reload(); window.close(); } else { location.reload(); }</script>");
	}

	/**
	 * 메세지 출력 후 부모창 이동 후 창 닫기( 부모창이 없으면 메세지 출력 후 자기 자신이 이동 ) (2011-08-30 원영훈 추가)
	 * @param url 이동할 url
	 * @throws Exception
	 */
	public void AlertReturnUrlOpenerPopupClose(String msg, String url) throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script> alert('" + msg + "'); " +
				"if( opener != null) { opener.location='" + url + "'; window.close(); } else { location.href='" + url + "'; }</script>");
	}

	/**
	 * 메세지 출력 후 부모창 이동 후 창 닫기( 부모창이 없으면 메세지 출력 후 자기 자신이 이동 ) (2011-08-30 원영훈 추가)
	 * @param url 이동할 url
	 * @throws Exception
	 */
	public void AlertReturnUrlOpenerPopup(String msg, String url, String selfurl) throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script> alert('" + msg + "'); " +
				"if( opener != null) { opener.location='" + url + "'; location.href='" + selfurl + "'; } else { location.href='" + url + "'; }</script>");
	}

	/**
	 * 현재 창을 닫는다.
	 * @throws Exception
	 */
	public void WindowClose() throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>window.close();</script>");
	}

	public void WindowTopClose() throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>window.top.close();</script>");
	}

	/**
	 * 권한 메시지 처리
	 * @throws Exception
	 */
	public void AuthAlert(String msg) throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>" +
				"if( opener != null) { alert('" + msg + "'); window.close(); } else { alert('" + msg + "'); history.go(-1); }</script>");
	}

	/**
	 * 현재 창을 일정시간 지연시켜 닫는다.
	 * @throws Exception
	 */
	public void WindowCloseDelay() throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>setTimeout(\"window.top.close()\",500);</script>");
	}

	/**
	 * 새창으로 지정된 url를 표시한다.
	 * @param url 페이지 URL
	 * @param id 창ID
	 * @param width 창넓이
	 * @param height 창높이
	 * @param left 창위치(왼쪽)
	 * @param top 창위치(위쪽)
	 * @throws Exception
	 */
	public void WindowOpen(String url, String id, String width, String height, String left, String top) throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>var wnd = window.open('" + url + "', '" + id + "', " +
				"'width=" + width + ", height=" + height + ", " +
				"left=" + left + ", top=" + top + ", " +
				"scrollbars=0, resizable=0  " +
				"');" +
				"if( wnd == null ) { alert('팝업이 차단되었습니다. 로그인 하시려면 현재사이트의 팝업을 항상허용 설정을  해주세요'); }" +
		"</script>");

	}

	/**
	 * 새창으로 지정된 url를 표시한후 history.go 처리 한다.
	 * @param url 페이지 URL
	 * @param id 창ID
	 * @param width 창넓이
	 * @param height 창높이
	 * @param left 창위치(왼쪽)
	 * @param top 창위치(위쪽)
	 * @param go history.go
	 * @throws Exception
	 */
	public void WindowOpenGo(String url, String id, String width, String height, String left, String top, int go) throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>var wnd = window.open('" + url + "', '" + id + "', " +
				"'width=" + width + ", height=" + height + ", " +
				"left=" + left + ", top=" + top + ", " +
				"scrollbars=0, resizable=0  " +
				"');" +
				"if( wnd == null ) { alert('팝업이 차단되었습니다. 로그인 하시려면 현재사이트의 팝업을 항상허용 설정을  해주세요'); }" +
				"history.go(" + go + ");" +
		"</script>");

	}

	/**
	 * 로그인 완료 후 처리( 새창이면 부모창 새로고침 후 닫기 / 메인창에서 열렸으면 메인페이지로 이동 )
	 * @throws Exception
	 */
	public void LoginDone() throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>" +
				"if( opener != null) { opener.location.reload(); window.close(); } else { location.href='/main.do'; }</script>");
	}
	/**
	 * 부모창 새로고침 후 창 닫기( 부모창이 없으면 자기 자신 새로고침 됨 )
	 * @throws Exception
	 */
	public void PopupDone() throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>" +
				"if( opener != null) { opener.location.reload(); window.close(); } else { location.reload(); }</script>");
	}

	/**
	 * 부모창 이동 후 창 닫기( 부모창이 없으면 자기 자신이 이동 )
	 * @param url 이동할 url
	 * @throws Exception
	 */
	public void ReturnUrlPopupClose(String url) throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>" +
				"if( opener != null) { opener.location='" + url + "'; window.close(); } else { location.href='" + url + "'; }</script>");
	}

	/**
	 * 페이지 이동
	 *
	 * @param url 이동할 url
	 * @throws Exception
	 */
	public void RedirectUrl(String url) throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>" +
				"location.href='" + url + "';</script>");
	}

	/**
	 * 페이지 이동
	 *
	 * @param url 이동할 url
	 * @throws Exception
	 */
	public void TopRedirectUrl(String url) throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>" +
				"top.location.href='" + url + "';</script>");
	}


	/**
	 * 페이지 이동(약간의 delay를,,)
	 *
	 * @param url 이동할 url
	 * @throws Exception
	 */
	public void TopRedirectUrlDelay(String url) throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>function redirect(){ top.location.href='"+ url +"'; }  setTimeout(\"redirect()\",1000);</script>");
	}


	/**
	 * SSO 전용 함수 - 부모창 redirect
	 * @param url redirect 할 URL
	 * @param parameters 전달 파라미터( param1=value1&param2=value2... )
	 */
	public void SSOOpenerRedirect(String url, String parameters) throws NullPointerException, IOException
	{
		String fullUrl = url + ((parameters != null) ? "?" + parameters : "");

		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<script>" +
				"window.top.opener.location='" + fullUrl + "';</script>");
	}

	/**
	 * SSO 전횽 함수 - 나머지 사이트 인증요청
	 * @param iframeId 사이트id
	 * @param url redirect 할 URL
	 * @param parameters 전달 파라미터( param1=value1&param2=value2... )
	 * @throws Exception
	 */
	public void SSOIFrameRequst(String iframeId, String url, String parameters) throws NullPointerException, IOException
	{
		_response.setContentType("text/html;charset="+GetEncodingType());
		_response.getWriter().println("<iframe id=\"" + iframeId + "\" src=\"\" style=\"display:none;\"></iframe>" +
				"<script>document.getElementById(\"" + iframeId + "\").src=\""+url+"?"+parameters+"\";</script>");

	}

}
