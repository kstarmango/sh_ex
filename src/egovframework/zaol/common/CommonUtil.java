/**
 * Class Name  : CommonUtil.java
 * Description : 각종 유틸 함수
 * Modification Information
 *
 * 수정일        수정자  수정내용
 * ----------    ------  ---------------
 * 2004.12.06    노명석  최초생성
 * 2011-11-03    양중목  엑셀업로드관련 함수 생성
 *
 * @author  노명석
 * @since 2004.12.06
 * @version 1.0
 * @see
 */

package egovframework.zaol.common;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;


import egovframework.zaol.fclty.service.FcltyVO;
import egovframework.zaol.rdscvmtc.service.RdscvmtcVO;
import egovframework.zaol.strctuinfo.service.StrctuinfoVO;


public class CommonUtil {

    public static final int UNIX = 0;

    public static final int WINDOW = 1;

	private static final String String = null;

	/**
	 * request parameters를 Map에 담아 처리한다.
	 */
	public static Map getRequestMap(HttpServletRequest request) {

		if(request == null)
			return null;

		Map pMap = new HashMap();
		Enumeration params = request.getParameterNames();
		while (params.hasMoreElements()) {
			String paramName = (String) params.nextElement();
			String paramValue = request.getParameter(paramName);
			if(paramValue != null && !"".equals(paramValue)) {
				pMap.put(paramName, request.getParameter(paramName));
			}
		}
		return pMap;
	}


//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////// 숫자관련함수 /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * 문자열을 정수로 변환
     * @param str
     * @return
     */
    public static final int parseInt( String str )
    {
        if(isNull(str)) return 0;
        else{
            try{
                return Integer.parseInt(str);
            }catch(NumberFormatException e){
                return 0;
            }
        }
    }
    /**
     * 문자열을 long형으로 변환
     * @param str
     * @return
     */
    public static final long parseLong( String str )
    {
        if(isNull(str)) return 0L;
        else{
            try{
                return Long.parseLong(str);
            }catch(NumberFormatException e){
                return 0L;
            }
        }
    }
    /**
     * 문자열을 float로 변환
     * @param str
     * @return
     */
    public static final float parseFloat( String str )
    {
        if(isNull(str)) return 0f;
        else{
            try{
                return Float.parseFloat(str);
            }catch(NumberFormatException e){
                return 0f;
            }
        }
    }
    /**
     * 문자열을 double로 변환
     * @param str
     * @return
     */
    public static final double parseDouble( String str )
    {
        if(isNull(str)) return 0;
        else{
            try{
                return Double.parseDouble(str);
            }catch(NumberFormatException e){
                return 0;
            }
        }
    }
    /**
     * 입력 char가 숫자형인지 아닌지를 리턴. "0"~"9"이면 true, 아니면 false.
     *
     * @param c 문자(Char)
     * @return "0"~"9"이면 true, 아니면 false
     */
    public static final boolean isDigitChar(char c)
    {
        char x = '0';
        char y = '9';
        return c >= x && c <= y;
    }
    /**
     * 숫자인지 체크
     * 2006/01/12 최범석
     * @return boolean
     */
    public static final boolean isNumeric(String str) {
        for(int i = 0; i < str.length(); i++) {
            if(!isDigitChar(str.charAt(i)))
                return false;
        }
        return true;
    }
    /**
     * 문자열을 받아서 '0'으로 구성된 문자이면 true로 리턴
     *
     * @param str
     * @return boolean
     */
    public static final boolean isZero(String str) {
        if(str.length() < 1) return false;

        for(int i = 0; i < str.length(); i++) {
            if(str.charAt(i) != '0')
                return false;
        }
        return true;
    }
    /**
     *   문자열에서 숫자만을 추출하여 리턴한다.
     *   ex) "012345-00-678900" -> "01234500678900"

     *   @param str 숫자String
     *   @return String
     */
    public static final String makeDigit(String str)
    {
        int n = str.length();
        String temp = "";
        for(int i = 0; i < n; i++)
            if(isDigitChar(str.charAt(i)))
                temp = temp + str.charAt(i);

        return temp;
    }
    /**
     * double형을 문자열로 바꾸는 함수 "#,###.##"
     * param d
     * @return "#,###.##"형으로 리턴
     */
    public static final String getNumberFormat(double d){
        NumberFormat nf = new DecimalFormat("#,###.##");
        return nf.format(d);
    }
    /**
     * float형을 문자열로 바꾸는 함수
     * param f
     * @return "#,###.##"형으로 리턴
     */
    public static final String getNumberFormat(float f){
        NumberFormat nf = new DecimalFormat("#,###.##");
        return nf.format(f);
    }
    /**
     * int형을 문자열로 바꾸는 함수
     * param i
     * @return "#,###,###,###"형으로 리턴
     */
    public static final String getNumberFormat(int i){
        NumberFormat nf = new DecimalFormat("#,###,###,###");
        return nf.format(i);
    }

    /**
     * String형 문자열을 #,###,###으로 바꾸는 함수
     * 입력되는 문자열은 모두 숫자여야 한다.
     * 최범석 2006-01-17
     * param str
     * @return "#,###,###,###"형으로 리턴
     */
    public static final String getNumberFormat(String str)
    {
        if (isNull(str)) return null;

        String []num = str.split("\\.");

        if(num.length > 2) return str;
        if (!isNumeric(num[0])) return str;

        String retnum = getNumberFormat(Double.parseDouble(num[0]));
        String dotnum = "";

        if(num.length > 1){
            if (!isNumeric(num[1])) return str;
            dotnum = ".".concat(num[1]);
        }
        return retnum.concat(dotnum);
    }

    /**
     * 면적 m2 -> ha로 변환하여 반환한다.
     * param str    숫자 문자열
     * @return "#,###,###,###"형으로 리턴
     * @author 노명석
     */
    public static final String getHectareFormat(String str)
    {
        return getRoundFormat(str, 4, 1);
    }

    public static final double getHectareFormat(double dou)
    {
        return getRoundFormat(dou, 4, 1);
    }
    /**
     * 금액을 원 -> 천원으로 변환하여 반환한다.
     * param str    숫자 문자열
     * @return "#,###,###,###"형으로 리턴
     * @author 노명석
     */
    public static final String getThousandFormat(String str)
    {
        return getRoundFormat(str, 3, 0);
    }

    public static final double getThousandFormat(double dou)
    {
        return getRoundFormat(dou, 3, 0);
    }
    /**
     * 금액을 원 -> 백만원으로 변환하여 반환한다.
     * param str    숫자 문자열
     * @return "#,###,###,###"형으로 리턴
     * @author 노명석
     */
    public static final String getMillionFormat(String str)
    {
        return getRoundFormat(str, 6, 0);
    }

    public static final double getMillionFormat(double dou)
    {
        return getRoundFormat(dou, 6, 0);
    }

    /**
     * String형 문자열을 divide자리수 만큼 절삭하고 #,###,###으로 바꾸는 함수
     * param str    숫자 문자열
     * param divide 절삭 자릿수
     * param dot    소숫점 아래 자릿수
     * @return "#,###,###,###"형으로 리턴
     * @author 노명석
     */
    public static final String getFloorFormat(String str, int divide, int dot)
    {
        if (isNull(str)) return null;
        if(divide < 0) divide = 0;
        if(dot < 0) dot = 0;
        if(divide < dot) return str;

        double dou = Double.parseDouble(str);

        if(divide >= 0) dou = dou/Math.pow(10, divide-dot);
        if(dot >= 0) dou = Math.floor(dou)/Math.pow(10, dot);

        return getNumberFormat(dou);
    }

    public static final double getFloorFormat(double dou, int divide, int dot)
    {
        if(divide < 0) divide = 0;
        if(dot < 0) dot = 0;
        if(divide < dot) return dou;

        if(divide >= 0) dou = dou/Math.pow(10, divide-dot);
        if(dot >= 0) dou = Math.floor(dou)/Math.pow(10, dot);

        return dou;
    }
    /**
     * String형 문자열을 divide자리수 만큼 절상하고 #,###,###으로 바꾸는 함수
     * param str    숫자 문자열
     * param divide 절상 자릿수
     * param dot    소숫점 아래 자릿수
     * @return "#,###,###,###"형으로 리턴
     * @author 노명석
     */
    public static final String getCeilFormat(String str, int divide, int dot)
    {
        if (isNull(str)) return null;
        if(divide < 0) divide = 0;
        if(dot < 0) dot = 0;
        if(divide < dot) return str;

        double dou = Double.parseDouble(str);

        if(divide >= 0) dou = dou/Math.pow(10, divide-dot);
        if(dot >= 0) dou = Math.ceil(dou)/Math.pow(10, dot);

        return getNumberFormat(dou);
    }

    public static final double getCeilFormat(double dou, int divide, int dot)
    {
        if(divide < 0) divide = 0;
        if(dot < 0) dot = 0;
        if(divide < dot) return dou;

        if(divide >= 0) dou = dou/Math.pow(10, divide-dot);
        if(dot >= 0) dou = Math.ceil(dou)/Math.pow(10, dot);

        return dou;
    }

    /**
     * String형 문자열을 divide자리수 만큼 반올림하고 #,###,###으로 바꾸는 함수
     * param str    숫자 문자열
     * param divide 반올림 자릿수
     * param dot    소숫점 아래 자릿수
     * @return "#,###,###,###"형으로 리턴
     * @author 노명석
     */
    public static final String getRoundFormat(String str, int divide, int dot)
    {
        if (isNull(str)) return null;
        if(divide < 0) divide = 0;
        if(dot < 0) dot = 0;
        if(divide < dot) return str;

        double dou = Double.parseDouble(str);

        if(divide >= 0) dou = dou/Math.pow(10, divide-dot);
        if(dot >= 0) dou = Math.round(dou)/Math.pow(10, dot);

        return getNumberFormat(dou);
    }

    public static final double getRoundFormat(double dou, int divide, int dot)
    {
        if(divide < 0) divide = 0;
        if(dot < 0) dot = 0;
        if(divide < dot) return dou;

        if(divide >= 0) dou = dou/Math.pow(10, divide-dot);
        if(dot >= 0) dou = Math.round(dou)/Math.pow(10, dot);

        return dou;
    }

    /**
     *   String을 int값으로 형변환한다.
     *
     *   @param str 숫자형 문자열
     *   @return String 숫자형이 아니명 '0'을 반환하고 숫자형이면 int로 변화하여 반환한다.
     */
    public static final int stoi(String str)
    {
        if(isNull(str))
            return 0;

        for(int i = 0; i < str.length(); i++) {
            if(!isDigitChar(str.charAt(i)))
                return 0;
        }

        return Integer.valueOf(str).intValue();
    }
    /**
     *   int를 String으로 형변환한다.
     *
     *   @param i 숫자
     *   @return 숫자형 문자열
     */
    public static final String itos(int i)
    {
        return (new Integer(i)).toString();
    }

    /**
     * 금액데이타 123,345,567 형식으로 보여주기
     * @param n 금액 문자열
     * @return String ###,###.##형식의 금액
     */
    public static final String moneyFormValue(String n)
    {
        if(isNull(n)) return "";

        boolean nFlag=true;

        String o     = "";
        String p     = "";
        String minus = "";

        if ( n.substring(0,1).equals("-") ) {
            minus = n.substring(0,1);
            n     = n.substring(1);
        }

        if ( n.indexOf(".")>0 ) {
            o = n.substring(0, n.indexOf("."));
            p = n.substring(n.indexOf(".")+1, n.length());
        }
        else    {
            o = n;
        }

        o = replace(o," ","");
        o = replace(o,",","");
        o = replace(o,"+","");

        int tLen = o.length();
        String tMoney = "";
        for(int i=0;i<tLen;i++){
            if (i!=0 && ( i % 3 == tLen % 3) ) tMoney += ",";
            if(i < tLen ) tMoney += o.charAt(i);
        }

        if ( p.length()>0 )     tMoney += "."+p;
        if ( nFlag == false )   tMoney = "-"+tMoney;

        if ( minus.equals("-") ) {
            tMoney = minus + tMoney;
        }

        return tMoney;
    }
    /**
     * 돈을 지칭하는 int형 문자열값을 넣어주면 한글 표기로 금액을 표시하여 return한다.
     * @param monStr
     * @return 한글 표기 금액
     */
    public static final String getMoneyKor(String monStr)
    {
        //String monStr = mon+"";           //  숫자를 문자형으로 변환
        String monKor = "";             //  return될 한글숫자
        String monTok = "";             //  문자형숫자를 substring하기위한 변수
        int monLen = monStr.length();   //  문자형숫자의 길이

        for (int i=monLen; i>0; i-- )   {

            monTok = monStr.substring(i-1,i);

            if ( monTok.equals("0") )   {       //  돈표기할때 0은 표기하지 않는다.
                if ( (monLen+1-i) > 3 )             //  하지만 자리수가 넘어가면 단위를 표기한다( 만,억,조,.... )
                    monKor = getUnit( monLen+1-i ) + monKor;
            }
            else    {                           //  한글숫자 + 단위 조합
                if ( monTok.equals("1") )           //  숫자가 1일때는 표기하지 않는다(단위만 표기한다.
                    monKor = getUnit( monLen+1-i ) + monKor;
                else
                    monKor = getNumKor( monTok ) + getUnit( monLen+1-i ) + monKor;

            }

            if ( i==1 && monTok.equals("1") )   //  표기하는 과정에서 제일 앞자리가 1일때는 "일"이란것을 추가해준다.
                monKor = getNumKor( monTok ) + monKor;
        }

        return monKor;
    }
    /**
     * 숫자문자를 한글문자형으로 변환하여 return한다.
     * @param m
     * @return String
     */
    public static final String getNumKor(String m)
    {
        String rtnStr = "";

        if ( m.equals("1") )        rtnStr = "일";
        else if ( m.equals("2") )   rtnStr = "이";
        else if ( m.equals("3") )   rtnStr = "삼";
        else if ( m.equals("4") )   rtnStr = "사";
        else if ( m.equals("5") )   rtnStr = "오";
        else if ( m.equals("6") )   rtnStr = "육";
        else if ( m.equals("7") )   rtnStr = "칠";
        else if ( m.equals("8") )   rtnStr = "팔";
        else if ( m.equals("9") )   rtnStr = "구";
        else if ( m.equals("0") )   rtnStr = "영";

        return rtnStr;
    }
    /**
     * 자리수에 대한 돈의 단위를 return한다.
     * @param cnt
     * @return String
     */
    public static final String getUnit(int cnt)
    {
        String rtnStr = "";

        if ( cnt==2 )           rtnStr = "십";
        else if ( cnt==3 )      rtnStr = "백";
        else if ( cnt==4 )      rtnStr = "천";
        else if ( cnt==5 )      rtnStr = "만";
        else if ( cnt==6 )      rtnStr = "십";
        else if ( cnt==7 )      rtnStr = "백";
        else if ( cnt==8 )      rtnStr = "천";
        else if ( cnt==9 )      rtnStr = "억";
        else if ( cnt==10 )     rtnStr = "십";
        else if ( cnt==11 )     rtnStr = "백";
        else if ( cnt==12 )     rtnStr = "천";
        else if ( cnt==13 )     rtnStr = "조";
        else if ( cnt==14 )     rtnStr = "십";
        else if ( cnt==15 )     rtnStr = "백";
        else if ( cnt==16 )     rtnStr = "천";

        return rtnStr;
    }

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////// null 관련 함수 ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * 문자열을 받아서 null이면 false로 리턴
     *
     * @param str
     * @return boolean
     */
    public static final boolean isNull(String str) {
        if (str == null || str.trim().equals("") || str.trim().equals("null"))
            return true;
        else
            return false;
    }
    /**
     * 문자열이 널이면 공백 문자열로 리턴
     *
     * @param str
     * @return String
     */
    public static final String NVL(String str) {
        if (isNull(str))
            return "";
        else
            return str;
    }

    /**
     * 문자열이 널이면 공백 문자열로 리턴 & 홑따옴표 입력시 '' 처리
     * 2006/01/12 최범석
     * @param str
     * @return String
     */
    public static final String NVLQuote(String str) {
        return text2sql(NVL(str));
    }

    /**
     * 문자열이 널이면 공백 문자열로 리턴 & 하이픈 "-" 제거 (전화번호등)
     * 2006/01/12 최범석
     * @param str
     * @return String
     */
    public static final String NVLHypen(String str) {
        //return rplc(NVL(str), "-", "");
        return (NVL(str)).replaceAll("-", "");
    }

    /**
     * 문자열이 널이면 대체할 문자열을 리턴
     *
     * @param str
     * @param NVLString
     * @return String
     */
    public static final String NVL(String str, String NVLString) {
        if (isNull(str))
            return NVLString;
        else
            return str;
    }

    /**
     * 문자열이 널이면 대체할 문자열을 리턴
     *
     * @param str
     * @param NVLString
     * @return String
     */
    public static final String NVL(Object str, String NVLString) {
        if (str == null)
            return NVLString;
        else
            return str.toString();
    }

    /**
     * 문자열이 널이면 대체할 정수를 리턴
     *
     * @param str
     * @param NVLInt
     * @return int
     */
    public static final int NVL(String str, int NVLInt) {
        if (isNull(str))
            return NVLInt;
        else
            return Integer.parseInt(str);
    }

    /**
     * 문자열이 널이면 대체할 double를 리턴
     *
     * @param str
     * @param NVLDouble
     * @return double
     */
    public static final double NVL(String str, double NVLDouble) {
        if (isNull(str))
            return NVLDouble;
        else
            return Double.parseDouble(str);
    }


//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////// 문자열관련 함수 //////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
    /**
     * 문자열대 문자열로 바꿔준다.
     * @param line
     * @param targetstr
     * @param replacestr
     * @return String
     */
    public static final String replace(String line, String targetstr, String replacestr)
    {
        line = NVL(line);
        for(int index = 0; (index = line.indexOf(targetstr, index)) >= 0; index += replacestr.length())
            line = line.substring(0, index) + replacestr + line.substring(index + targetstr.length());

        return line;
    }

    /**
     * 대상문자열(strTarget)에서 지정문자열(strSearch)이 검색된 횟수를,
     * 지정문자열이 없으면 0 을 반환한다.
     *
     * @param strTarget 대상문자열
     * @param strSearch 검색할 문자열
     * @return 지정문자열이 검색되었으면 검색된 횟수를, 검색되지 않았으면 0 을 반환한다.
     */
    public static final int search(String strTarget, String strSearch){
        int result=0;
        String strCheck = new String(strTarget);
        for(int i = 0; i < strTarget.length(); ){
            int loc = strCheck.indexOf(strSearch);
            if(loc == -1) {
                break;
            } else {
                result++;
                i = loc + strSearch.length();
                strCheck = strCheck.substring(i);
            }
        }
        return result;
    }
    /**
    *       한글 문자열 자르기
    *<br><br>
    *       @param  kor          한글문자열
    *       @param  first        시작문자열
    *       @param  end          종료문자열
    *       @return String
    */
    public static final String cutKorStr(String kor, int first, int end){

        int strlen = 0;
        char c;
        StringBuffer rtnStrBuf = new StringBuffer();
        for(int j = 0; j < kor.length(); j++)
        {
                c = kor.charAt(j);
            if( (c  <  0xac00 || 0xd7a3 < c )&&( c  <  0xb0a1    || 0xc8fe    < c) ){
                strlen++;
            }else
                 strlen+=2;

        if(strlen>first){
                    rtnStrBuf.append(c);
        }

            if (strlen>end-1){
                break;
            }
        }
        return rtnStrBuf.toString();
    }
    /**
    *       한글 문자열 자르기
    *<br><br>
    *       @param  str       한글문자열
    *       @param  len2      길이
    *       @return String    자른 문자열
    */
     public static final String cutKorStr(String str, int len2) {  //잘라서 보여주기..
        int len1 ,i;
        char ch ;
        boolean isFirst=true;
        String newStr=null;

        len1 = str.length();
        len2 = len2 -2; //".."를 위한 자리수
        if (len1 <= len2) return str;
        ch = str.charAt(len2);
        if (ch >= 0xa1 && ch <= 0xfe) {
                for (i=0 ; i<len2 ; i++) {
                        ch = str.charAt(i);
                        if (ch >= 0xa1 && ch <= 0xfe) {
                                if (!isFirst) {
                                        isFirst=true;
                                } else isFirst=false;
                        }
                }

        }
        if (isFirst)
                newStr = str.substring(0, len2)+"..";
        else
                newStr = str.substring(0, len2-1)+"..";
        return new String(newStr);
     }
     /**
      * 영문, 한글 혼용 문자열을 일정한 길이에서 잘라주는 함수
      * @param str 문자열
      * @param limit 길이
      * @return String    자른 문자열
      */
     public static final String shortCutString(String str, int limit) {
         if (isNull(str) || limit < 4) return str;

         int len = str.length();
         int cnt=0, index=0;

         while (index < len && cnt < limit) {
             if (str.charAt(index++) < 256) // 1바이트 문자라면...
                 cnt++;     // 길이 1 증가
             else {         // 2바이트 문자라면...
                 if(cnt < limit-3) {
                     cnt += 2;  // 길이 2 증가
                 } else {
                     break;
                 }
             }
         }

         if (index < len)
             str = str.substring(0, index);
             //str = str.substring(0, index).concat("...");

         return str;
     }

    /**
     * Java에서 OutOfIndexException발생방지를위한 substring
     * 예) CommonUtil.substring("1234567890", 1,5) => 2345
     * @param str
     * @param startIndex
     * @param endIndex
     * @return String
     */
    public static final String substring(String str, int startIndex , int endIndex)
    {
        String returnString = "";

        if( str == null || str == "" || startIndex < 0 || startIndex > endIndex) return returnString;

        int lastIndex = str.length();

        if( lastIndex < startIndex ) return returnString;

        if( (lastIndex+1) < endIndex )
            returnString = str.substring(startIndex , lastIndex);
        else
            returnString = str.substring(startIndex , endIndex);

        return returnString;
    }

    /**
     *   String의 left trim.
     *   <br>
     *   예) CommonUtil.LTrim( "   가나다" )
     *   @param str
     *   @return String
     */
    public static final String LTrim( String str )
    {
        if(str == null) {
            return "";
        } else {
            int start;
            for( start=0; start<str.length(); start++ )
            {
                if( str.charAt(start)!=' ' ) break;
            }
            return str.substring( start );
        }
    }
    /**
     *   String의 right trim
     *   <br>
     *   예) CommonUtil.RTrim( "가나다  " )
     *   @param str
     *   @return String
     */
    public static final String RTrim( String str )
    {
        if(str == null) {
            return "";
        } else {
            int end;
            for( end=str.length()-1; end>=0; end-- )
            {
                if( str.charAt(end)!=' ' ) break;
            }
            return str.substring( 0,end+1 );
        }
    }
    /**
     * 문자열 앞에 주어진 문자를 붙여 고정길이 문자열을 리턴한다.
     * @param   src     source string
     * @param   filler  덧불일 문자열
     * @param   size    늘리고 난 후의 size
     */
    public static final String LPad(String src, String filler, int size)
    {
        StringBuffer sb = new StringBuffer();

        if(src == null)
            src = "";

        if(src.getBytes().length > size)
            return src.substring(0,size);

        for(int i= 0; i < (size - src.length()); i++)
        {
            sb.append(filler);
        }

        String fillstr = substring((sb.toString()), 0, size-src.length());

        sb.append(src);

        return fillstr + src;
    }
    /**
     * 문자열 뒤에 주어진 문자를 붙여 고정길이 문자열을 리턴한다.
     * @param   src     source string
     * @param   filler  덧불일 문자열
     * @param   size    늘리고 난 후의 size
     */
    public static final String RPad(String src, String filler, int size)
    {
        StringBuffer sb = new StringBuffer();

        if(src == null)
            src = "";

        if(src.getBytes().length > size)
            return src.substring(0,size);

        sb.append(src);

        for(int i= 0; i < (size - src.length()); i++)
        {
            sb.append(filler);
        }

        return substring((sb.toString()), 0, size);
    }
    /**
     * 문자열 앞에 주어진 문자를 붙여 고정길이(byte) 문자열을 리턴한다.
     * @param   src     source string
     * @param   filler  덧불일 문자열
     * @param   size    늘리고 난 후의 size
     */
    public static final String LPadByte(String src, String filler, int size)
    {
        StringBuffer sb = new StringBuffer();

        if(src == null)
            src = "";

        if(src.getBytes().length > size)
            return shortCutString(src, size);

        for(int i= 0; i < (size - src.getBytes().length); i++)
        {
            sb.append(filler);
        }

        String fillstr = shortCutString((sb.toString()), size-src.getBytes().length);

        sb.append(src);

        return fillstr.concat(src);
    }
    /**
     * 문자열 뒤에 주어진 문자를 붙여 고정길이(byte) 문자열을 리턴한다.
     * @param   src     source string
     * @param   filler  덧불일 문자열
     * @param   size    늘리고 난 후의 size
     */
    public static final String RPadByte(String src, String filler, int size)
    {
        StringBuffer sb = new StringBuffer();

        if(src == null)
            src = "";

        if(src.getBytes().length > size)
            return shortCutString(src, size);

        sb.append(src);

        for(int i= 0; i < (size - src.getBytes().length); i++)
        {
            sb.append(filler);
        }

        return shortCutString((sb.toString()), size);
    }

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////// Encoding 함수 ////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

    /**
    * unicode를 ksc5601code로 변환해 준다.
    * @param uniCodeStr Unicode String
    * @return KSC5601 String
    */
    public static final String uni2ksc(String uniCodeStr) throws IOException {
        try{
            if (uniCodeStr != null)
                return new String(uniCodeStr.getBytes("ISO8859_1"), "KSC5601");
            else
                return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
    * ksc5601code를 unicode로 변환해 준다.
    * @param kscStr KSC5601 String
    * @return unicode String
    */
    public static final String ksc2uni(String kscStr) throws IOException {
        try{
            if (kscStr != null)
                return new String(kscStr.getBytes("KSC5601"), "ISO8859_1");
            else
                return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
    * db에 데이터를 저장하기 전에 한글코드를 변환해주어야 한다.
    * <br>
    * Parameter로 한글을 넘겨받았을때 변환해주어야 한다.
    * @param str Parameter 로 넘겨받은 String
    * @return unicode String
    */
    public static final String toUS(String str) throws IOException {
        try{
            if (str != null)
                return new String(str.getBytes("ISO8859_1"));
            else
                return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////// query 함수 ////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * sql 쿼리를 위해서 '를 ''로 바꾸는 함수 param str
     *
     * @return String
     */
    public static final String wordQuote(String word) {
        int start = 0;
        int hit = 0;
        String result = new String("");

        try {
            while ((hit = word.indexOf("'", start)) != -1) {
                result += word.substring(start, hit) + "''";

                start = hit + 1;
            }
            result += word.substring(start);

        } catch (NullPointerException e) {
            return word("");
        }
        return word(result);
    }

    /**
     * sql 쿼리를 위해서 문자를 ''로 감싸는 함수 param str
     *
     * @return String
     */
    public static final String word(String str) {
        String string = str;
        if (string == null)
            string = "";
        return "'" + string + "'";
    }
    /**
     * sql LIKE 쿼리를 위해서 문자를 '% %'로 감싸는 함수 param str
     *
     * @return String
     */
    public static final String wordLike(String str) {
        String string = str;
        if (string == null)
            string = "";
        return "'%" + string + "%'";
    }
    /**
     * HTML TEXT -> SQL (디비에 집어넣을때 값을 바꾸는거)
     * 디비에 값입력할때 처리
     * 2006/01/11 최범석
     * @param str
     * @return String
     */
    public static final String text2sql(String str) {
        if (str == null) return null;
        return str.replaceAll("'", "''");
    }
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// HTML용 함수 /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
    /**
     * TEXT -> HTML (HTML 태그를 안먹게 하는거..)
     * 디비에서 뽑아온거 태그 안먹게 하기.
     * 2006/01/11 최범석
     * @param str
     * @return String
     */
    public static final String sql2text(String str) {
        String rStr = null;
        if (str == null) return null;
        rStr = str.replaceAll("&", "&amp;");
        rStr = rStr.replaceAll("<", "&lt;");
        rStr = rStr.replaceAll(">", "&gt;");
        rStr = rStr.replaceAll("\n", "<br>");
        return rStr;
    }
    /**
     * 자바스크립트에서 처리되는 문자열의 따옴표 쌍따옴표 처리
     * 디비에서 뽑아온값 -> 자바스크립로 보낼때 따옴표 에러막지요.
     * 2006/01/11 최범석
     * @param str
     * @return String
     */
    public static final String sql2script(String str) {
        String rStr = null;
        if (str == null) return null;
        rStr = str.replaceAll("'", "\\\\'");
        rStr = rStr.replaceAll("\"", "&quot;");
        return rStr;
    }
    /**
     * 텍스트상자에서 따옴표 쌍따옴표 처리 (단, 텍스트상자 값을 둘러싸는 기호는 쌍따옴표"..." 이다)
     * 디비에서 뽑아온값 -> 텍스트 박스로 보낼때.  2006/01/11 최범석
     * @param str
     * @return String
     */
    public static final String sql2textbox(String str) {
        String rStr = null;
        if (str == null) return null;
        rStr = str.replaceAll("\"", "&quot;");
        return rStr;
    }

    /**
      * 특수 문자열 받아서 HTML 코드로 변환하는 메소드
      * <xmp>
      * <  : &lt;
      * >  : &gt;
      * &  : &amp;
      * '  : &#39;
      * "  : &quot;
      * white space : &nbsp;
      * \r\n : <BR>
      * </xmp>
      * @param  text 특수 문자열
      * @return String 치환된 문자열
      */
    public static final String formatHTMLCode(String text) {
        if( text == null || text.equals("") )
            return "";

        StringBuffer sb = new StringBuffer(text);
        char ch;

        for (int i = 0; i < sb.length(); i++) {
            ch = sb.charAt(i);
            if (ch == '<') {
                sb.replace(i,i+1,"&lt;");
                i += 3;
            } else if (ch == '>') {
                sb.replace(i,i+1,"&gt;");
                i += 3;
            } else if (ch == '&') {
                sb.replace(i,i+1,"&amp;");
                i += 4;
            } else if (ch == '\'') {
                sb.replace(i,i+1,"&#39;");
                i += 4;
            } else if (ch == '"') {
                sb.replace(i,i+1,"&quot;");
                i += 5;
            } else if (ch == ' ') {
                sb.replace(i,i+1,"&nbsp;");
                i += 5;
            } else if (ch == '\r' && sb.charAt(i+1) == '\n' ){
                sb.replace(i,i+2,"<BR>");
                i += 3;
            }
        }
        return sb.toString();
    }
    /**
     * HashMap있는 key,code를 이용해서 URL String을 만들어 리턴해준다.
     * @param linkHash
     * @return URL String
     */

    public static final String getHashLink(HashMap linkHash)  {

        StringBuffer sb = new StringBuffer();

        if ( linkHash!=null )   {
            Set set = linkHash.keySet();
            Iterator e = set.iterator();
            while (e.hasNext()){
                String key = (String)e.next();
                String value = (String)linkHash.get(key);

                sb.append("&"+key+"="+value);
            }
        }

        return sb.toString();
    }
    /**
     * 입력 문자열을 Java Script의 alert창에 사용가능한 메시지로 변환한다.
     * @param stText 입력 문자열
     * @return 변환된 문자열을 리턴한다.
     */
    public static final String getAlertMsg(String stText){
        String stResult = NVL(stText,"");
        int inLen = stResult.length();
        StringBuffer sbufText = new StringBuffer();
        for(int i = 0; i < inLen; i++){
            if(stResult.charAt(i) == '\r' || stResult.charAt(i) == '\n'){
                sbufText.append("\\n");
            }else if(stResult.charAt(i) == '"'){
                sbufText.append("'");
            }else{
                sbufText.append(stResult.charAt(i));
            }
        }
        stResult = sbufText.toString();
        return stResult;
    }
    /**
     * br 처리하기
     * <br>
     * html에서 "\n"을 <br>로 변환한다.
     *
     * @param p_str
     * @return String
     */
    public static final String replaceBR(String p_str)
    {
        if ( p_str == null ) {
            p_str = "";
        }
        else {
            p_str = p_str.trim();
            p_str = replace(p_str,"\n","<br>");
        }

        return p_str;
    }
    /**
     * 입력값인 두문자열이 동일하면 "selected"를 리턴한다.(SelectBox에서 사용)
     * @param stVal1 입력 문자열1
     * @param stVal2 입력 문자열2
     * @return "" 또는 "selected"
     */
    public static final String isSelected (String stVal1, String stVal2) {
        String stSelect = "";
        if(stVal1 != null && stVal2 != null && stVal1.equals(stVal2)){
        	stSelect = "selected";
        }
        return stSelect;
    }
    /**
     * 입력값인 두문자열이 동일하면 "checked"를 리턴한다.(CheckBox에서 사용)
     * @param stVal1 입력 문자열1
     * @param stVal2 입력 문자열2
     * @return "" 또는 "checked"
     */
    public static final String isChecked(String stVal1, String stVal2){
        String stCheck = "";
        if(stVal1 != null && stVal2 != null && stVal1.equals(stVal2)){
            stCheck = "checked";
        }
        return stCheck;
    }
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////// FORMAT 함수 ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
    /**
     * 전화번호에 하이픈등 기호 넣기
     * 2006/01/12 최범석
     * @param inStr 전화번호 문자열
     * @param delim 전화번호 사이에 들어갈 문자
     * @return String
     */
    public static final String telFormat(String inStr, char delim) {
        StringBuffer sb = new StringBuffer("");
        String str   = null;

        if (inStr == null) return "";
        str   = inStr.trim();

        if (str.length() < 9) return str;
        if (!isNumeric(str)) return str;

        if (str.substring(0,2).equals("02")) {    //지역번호  2자리
            if (str.length() == 9) {
                sb.append(str.substring(0, 2));
                sb.append(delim);
                sb.append(str.substring(2, 5));
                sb.append(delim);
                sb.append(str.substring(5, 9));
            } else if (str.length() == 10) {
                sb.append(str.substring(0, 2));
                sb.append(delim);
                sb.append(str.substring(2, 6));
                sb.append(delim);
                sb.append(str.substring(6, 10));
            } else {
                sb.append(str);
            }
        }
        else // 이통사 및 지역번호 3자리
        {
            if (str.length() == 10) {
                sb.append(str.substring(0, 3));
                sb.append(delim);
                sb.append(str.substring(3, 6));
                sb.append(delim);
                sb.append(str.substring(6, 10));
            } else if (str.length() == 11) {
                sb.append(str.substring(0, 3));
                sb.append(delim);
                sb.append(str.substring(3, 7));
                sb.append(delim);
                sb.append(str.substring(7, 11));
            } else { // 식별번호가 없는것
                sb.append(str);
            }
        }
        return sb.toString();
    }
    /**
     * 우편번호에 하이픈등 기호 넣기
     * 2006/01/12 최범석
     * @param inStr 우편번호 문자열
     * @param delim 우편번호 사이에 들어갈 문자
     * @return String
     */
    public static final String postFormat(String inStr, char delim) {
        StringBuffer sb = new StringBuffer("");
        String str   = null;

        if (inStr == null) return "";
        str   = inStr.trim();

        if (str.length() != 6) return str;
        if (!isNumeric(str)) return str;

        sb.append(str.substring(0, 3));
        sb.append(delim);
        sb.append(str.substring(3, 6));

        return sb.toString();
    }

    /**
     * 주민번호/사업자번호 하이픈등 기호 넣기
     * 2006/04/18 하윤철
     * @param inStr 주민번호 / 사업자번호 문자열
     * @param delim 주민번호 / 사업자번호 사이에 들어갈 문자
     * @return String
     */
    public static final String reqerFormat(String inStr, char delim) {
        StringBuffer sb = new StringBuffer("");
        String str   = null;

        if (inStr == null) return "";
        str   = inStr.trim();

        if (str.length() != 10 && str.length() != 13) return str;
        if (!isNumeric(str)) return str;

        if (str.length() == 10) {        //사업자번호
            sb.append(str.substring(0, 3));
            sb.append(delim);
            sb.append(str.substring(3, 5));
            sb.append(delim);
            sb.append(str.substring(5, 10));
        } else if (str.length() == 13) { //주민번호
            sb.append(str.substring(0, 6));
            sb.append(delim);
            sb.append(str.substring(6, 7));
            sb.append("XXXXXX");
        }

        return sb.toString();
    }

    /**
     * 날짜에 하이픈등 기호 넣기
     * 2006/04/18 하윤철
     * @param inStr 날짜 문자열
     * @param delim 날짜 사이에 들어갈 문자
     * @return String
     */
    public static final String dateFormat(String inStr, char delim) {
        StringBuffer sb = new StringBuffer("");
        String str   = null;

        if (inStr == null) return "";
        str   = inStr.trim();

        if (str.length() != 8) return str;
        if (!isNumeric(str)) return str;

        if (str.length() == 8) {        //날짜
            sb.append(str.substring(0, 4));
            sb.append(delim);
            sb.append(str.substring(4, 6));
            sb.append(delim);
            sb.append(str.substring(6, 8));
        }

        return sb.toString();
    }

    /**
     * 문자열이 하이픈용 날짜인지 체크
     * 2011/11/03 양중목
     * @param str
     * @return String
     */
    public static final boolean HypenDateCk(String str) {

        if (str == null || str.length() == 0) return true;
        String strval = str.replace(" ", "")  //공백제거
                           .replace(".", "")  //테스트서버의 경우 (11. 10. 09) 이런식으로 데이터가 들어옴
                           .replace("/", "")  //실서버의     경우 (11/10/09)   이런식으로 데이터가 들어옴
                           .replace("-", ""); //텍스트인경우

        if(isNumeric(strval))
        {
        	return true;
        }else{
    		return false;
        }//end if
    }

    /**
     * 파일명의 확장자 가져오기
     * @param p_file_name
     * @return 파일명의 확장자
     */
    public static final String getFileNameExt(String p_file_name)
    {
        String right = "";
        int vb_strFlag = 0;

        vb_strFlag = p_file_name.lastIndexOf(".");
        if (vb_strFlag != -1 )  {
            right = p_file_name.substring(vb_strFlag+1, p_file_name.length());
        }
        return right;
    }

    /**
     * path + "\\" 또는 "/" + filename을 합치기
     * @param path
     * @param filename
     * @return 파일명의 확장자
     * @author 노명석
     */
    public static final String getPathName(String path, String filename)
    {
        char delim = 0x00;
        String retPath = "";
        if(isNull(filename)) return retPath;

        delim = File.separatorChar;

        if(path.charAt(path.length()-1) != delim)
            retPath = path + delim + filename;
        else
            retPath = path + filename;

        return retPath;
    }

    /**
     * path에 해당하는 Directory 만들기
     * @param path
     * @return Directory 생성에 실패하면 false
     * @author 노명석
     */
    public static final boolean createPath(String path)
    {
        boolean ret = false;

        if(isNull(path)) return ret;

        File file = new File(path);

        if(file.isDirectory()) {
            ret = true;
        }
        else {
            if(file.mkdir()) ret = true;
        }
        return ret;
    }

    /**
     * 문자 사이에 있는 공백을 모두 없앤다.
     * @param str
     * @return 넘긴 문자열의공백을 모두 없애고 넘긴다.
     */
    public static final String ReplaceSpace(String str){
    	String result = "";
    	return NVL(str).replaceAll(" ", "");
    }

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////엑셀업로드 ////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * 엑셀업로드체크 : 널체크
     * 2011-11-03 양중목
     * @return String
     */
    public static final String exclupldck_null(String str,String title,int errorline)
    {
        String rtn_msg = "";
        if(str == null || ("").equals(str))
        {
            rtn_msg = errorline + "번째 라인에 오류가 발견되었습니다."
                    + "\\n\\n해당 항목이 존재하지 않습니다."
                    + "\\n\\n항목명 : "+title  ;
        }
        return rtn_msg;
    }

    /**
     * 엑셀업로드체크 : 널체크(에러라인 String으로 수정 ( 열과 행까지 알아야 하므로 ) )
     * 2012-06-14 양중목
     * @return String
     */
    public static final String exclupldck_null2(String str,String title,String errorline)
    {
        String rtn_msg = "";
        if(str == null || ("").equals(str))
        {
            rtn_msg = errorline + "에 오류가 발견되었습니다."
                    + "\\n\\n해당 항목이 존재하지 않습니다."
                    + "\\n\\n항목명 : "+title  ;
        }
        return rtn_msg;
    }

    /**
     * 엑셀업로드체크 : 코드변환시 널체크(에러라인 String으로 수정 ( 열과 행까지 알아야 하므로 ) )
     * 2012-06-20 양중목
     * @return String
     */
    public static final String exclupldck_code_null(String str,String title,String errorline)
    {
        String rtn_msg = "";
        if(str == null || ("").equals(str))
        {
            rtn_msg = errorline + "에 오류가 발견되었습니다."
                                + "\\n\\n해당 항목을 코드로 변환하는 과정에서 에러가 발생하였습니다."
                                + "\\n\\n샘플항목과 확인하여 보시기바랍니다."
                                + "\\n\\n항목명 : "+title
                                + "\\n\\n입력값 : "+str  ;
        }
        return rtn_msg;
    }

    /**
     * 엑셀업로드체크 : 총길이체크
     * 2011-11-03 양중목
     * @return String
     */
    public static final String exclupldck_maxlength(String str,int maxlength,String title,int errorline)
    {
        String rtn_msg = "";
        if(str.length() > maxlength)
        {
            rtn_msg = errorline+"번째 라인에 오류가 발견되었습니다."
                    + "\\n\\n해당 항목의 사이즈가 너무 큽니다."
                    + "\\n\\n항목명 : "       + title
                    + "\\n\\n제한사이즈 : "   + maxlength
                    + "\\n\\n현재값사이즈 : " + str.length()
                    + "\\n\\n현재값 : "       + str;

        }
        return rtn_msg;
    }

    /**
     * 엑셀업로드체크 : 숫자인지체크
     * 2011-11-03 양중목
     * @return String
     */
    public static final String exclupldck_isNum(String str,String title,int errorline)
    {
        String rtn_msg = "";
        if(str == null || ("").equals(str)){ return rtn_msg; }
        if(!isNumeric(str.replace(".", "")))
        {
            rtn_msg = errorline+"번째 라인에 오류가 발견되었습니다."
                    + "\\n\\n해당 항목의 유형이 숫자가 아닙니다."
                    + "\\n\\n항목명 : "       + title
                    + "\\n\\n현재값 : "       + str;
        }
        return rtn_msg;
    }

    /**
     * 엑셀업로드체크 : 숫자인지체크(에러라인 String으로 수정 ( 열과 행까지 알아야 하므로 ) )
     * 2012-06-14 양중목
     * @return String
     */
    public static final String exclupldck_isNum2(String str,String title,String errorline)
    {
        String rtn_msg = "";
        if(str == null || ("").equals(str)){ return rtn_msg; }
        if(!isNumeric(str.replace(".", "")))
        {
            rtn_msg = errorline+"에 오류가 발견되었습니다."
                    + "\\n\\n해당 항목의 유형이 숫자가 아닙니다."
                    + "\\n\\n항목명 : "       + title
                    + "\\n\\n현재값 : "       + str;
        }
        return rtn_msg;
    }


    /**
     * 엑셀업로드체크 : 날짜여부체크
     * 2011-11-03 양중목
     * @return String
     */
    public static final String exclupldck_inDate(String str,String title,int errorline)
    {
        String rtn_msg = "";
        if(!HypenDateCk(str))
        {
            rtn_msg = errorline+"번째 라인에 오류가 발견되었습니다."
                    + "\\n\\n해당 항목의 유형이 하이픈이 들어간 날짜형식이 아닙니다."
                    + "\\n\\n항목명 : " + title
                    + "\\n\\n현재값 : " + str
            + "\\n\\n현재사이즈 : " + str.length()
            ;
        }
        return rtn_msg;
    }


    /**
     * 엑셀업로드체크 : 공통 리스트
     * 2011-11-03 양중목
     * @return String
     */
    public static final String exclupldck_CommList(String str,List codeList,String title,int errorline)
    {

        String rtn_msg = "";
        boolean code_ck = false;
        DefaultSearchVO vo = new DefaultSearchVO();

    	for(int i = 0 ; i < codeList.size() ; i++)
    	{
    		vo = (DefaultSearchVO)codeList.get(i);
    		if(str.equals(vo.getCd()))
    		{
    			code_ck = true;
    		}//end if
        }//end for

        if(!code_ck)
        {
            rtn_msg = errorline+"번째 라인에 오류가 발견되었습니다."
                    + "\\n\\n해당 항목의 유형이 정해진 코드형식과 일치하지 않습니다."
                    + "\\n\\n항목명 : " + title
                    + "\\n\\n현재값 : " + str;
        }//end if
        return rtn_msg;
    }

    /**
     * 엑셀업로드체크 : 기하구조 리스트
     * 2011-11-03 양중목
     * @return String
     */
    public static final String exclupldck_StrctuList(String str,List codeList,int errorline)
    {

        String rtn_msg = "";
        boolean code_ck = false;
        StrctuinfoVO vo = new StrctuinfoVO();
    	for(int i = 0 ; i < codeList.size() ; i++)
    	{
    		vo = (StrctuinfoVO)codeList.get(i);
    		if(str.equals(vo.getStrctu_id()))
    		{
    			code_ck = true;
    		}//end if
        }//end for

        if(!code_ck)
        {
            rtn_msg = errorline+"번째 라인에 오류가 발견되었습니다."
                    + "\\n\\n해당 항목의 유형이 정해진 교차로코드형식과 일치하지 않습니다."
                    + "\\n\\n현재값 : " + str;
        }//end if
        return rtn_msg;
    }


    /**
     * 엑셀업로드체크 : 교차로 리스트
     * 2011-11-03 양중목
     * @return String
     */
    public static final String exclupldck_CrsrdvmtcList(String str,List codeList,int errorline)
    {

        String rtn_msg = "";
        boolean code_ck = false;
        StrctuinfoVO vo = new StrctuinfoVO();

    	for(int i = 0 ; i < codeList.size() ; i++)
    	{
    		vo = (StrctuinfoVO)codeList.get(i);
    		if(str.equals(vo.getStrctu_id()))
    		{
    			code_ck = true;
    		}//end if
        }//end for

        if(!code_ck)
        {
            rtn_msg = errorline+"번째 라인에 오류가 발견되었습니다."
                    + "\\n\\n해당 항목의 유형이 정해진 교차로코드형식과 일치하지 않습니다."
                    + "\\n\\n현재값 : " + str;
        }//end if
        return rtn_msg;
    }

    /**
     * 엑셀업로드체크 : 가로 리스트
     * 2011-11-03 양중목
     * @return String
     */
    public static final String exclupldck_RdscvmtcList(String str,List codeList,int errorline)
    {

        String rtn_msg = "";
        boolean code_ck = false;
        RdscvmtcVO vo = new RdscvmtcVO();

    	for(int i = 0 ; i < codeList.size() ; i++)
    	{
    		vo = (RdscvmtcVO)codeList.get(i);
    		if(str.equals(vo.getRdsc_id()))
    		{
    			code_ck = true;
    		}//end if
        }//end for

        if(!code_ck)
        {
            rtn_msg = errorline+"번째 라인에 오류가 발견되었습니다."
                    + "\\n\\n해당 항목의 유형이 정해진 가로코드형식과 일치하지 않습니다."
                    + "\\n\\n현재값 : " + str;
        }//end if
        return rtn_msg;
    }

    /**
     * 엑셀업로드체크 : 유사시설 리스트
     * 2011-11-03 양중목
     * @return String
     */
    public static final String exclupldck_fcltyList(String str,List codeList,int errorline)
    {

        String rtn_msg = "";
        boolean code_ck = false;
        FcltyVO vo = new FcltyVO();

    	for(int i = 0 ; i < codeList.size() ; i++)
    	{
    		vo = (FcltyVO)codeList.get(i);
    		if(str.equals(vo.getFclty_id()))
    		{
    			code_ck = true;
    		}//end if
        }//end for

        if(!code_ck)
        {
            rtn_msg = errorline+"번째 라인에 오류가 발견되었습니다."
                    + "\\n\\n해당 항목의 유형이 정해진 유사시설코드형식과 일치하지 않습니다."
                    + "\\n\\n현재값 : " + str;
        }//end if
        return rtn_msg;
    }

    /**
     * 엑셀업로드체크 : 사업구분 리스트
     * 2011-11-14 양중목
     * @return String
     */
    public static final String exclupldck_btyp_bsnsList(String str,List codeList,int errorline)
    {

        String rtn_msg = "";
        boolean code_ck = false;
        FcltyVO vo = new FcltyVO();

    	for(int i = 0 ; i < codeList.size() ; i++)
    	{
    		vo = (FcltyVO)codeList.get(i);
    		if(str.equals(vo.getFclty_id()))
    		{
    			code_ck = true;
    		}//end if
        }//end for

        if(!code_ck)
        {
            rtn_msg = errorline+"번째 라인에 오류가 발견되었습니다."
                    + "\\n\\n해당 항목의 유형이 정해진 유사시설코드형식과 일치하지 않습니다."
                    + "\\n\\n현재값 : " + str;
        }//end if
        return rtn_msg;
    }


    /**
     * 해당숫자를 입력시 엑셀의 열명을 가져온다
     * 2012-06-19 양중목
     * @return String
     */
    public static final String excl_col_name(int s_num)
    {

        String rtn_msg = "";

              if(s_num == 0  ){ rtn_msg = "A";  }else if(s_num == 52  ){ rtn_msg = "BA"; }else if(s_num == 104 ){ rtn_msg = "DA"; }else if(s_num == 156 ){ rtn_msg = "FA"; }else if(s_num == 208 ){ rtn_msg = "HA";
        }else if(s_num == 1  ){ rtn_msg = "B";  }else if(s_num == 53  ){ rtn_msg = "BB"; }else if(s_num == 105 ){ rtn_msg = "DB"; }else if(s_num == 157 ){ rtn_msg = "FB"; }else if(s_num == 209 ){ rtn_msg = "HB";
        }else if(s_num == 2  ){ rtn_msg = "C";  }else if(s_num == 54  ){ rtn_msg = "BC"; }else if(s_num == 106 ){ rtn_msg = "DC"; }else if(s_num == 158 ){ rtn_msg = "FC"; }else if(s_num == 210 ){ rtn_msg = "HC";
        }else if(s_num == 3  ){ rtn_msg = "D";  }else if(s_num == 55  ){ rtn_msg = "BD"; }else if(s_num == 107 ){ rtn_msg = "DD"; }else if(s_num == 159 ){ rtn_msg = "FD"; }else if(s_num == 211 ){ rtn_msg = "HD";
        }else if(s_num == 4  ){ rtn_msg = "E";  }else if(s_num == 56  ){ rtn_msg = "BE"; }else if(s_num == 108 ){ rtn_msg = "DE"; }else if(s_num == 160 ){ rtn_msg = "FE"; }else if(s_num == 212 ){ rtn_msg = "HE";
        }else if(s_num == 5  ){ rtn_msg = "F";  }else if(s_num == 57  ){ rtn_msg = "BF"; }else if(s_num == 109 ){ rtn_msg = "DF"; }else if(s_num == 161 ){ rtn_msg = "FF"; }else if(s_num == 213 ){ rtn_msg = "HF";
        }else if(s_num == 6  ){ rtn_msg = "G";  }else if(s_num == 58  ){ rtn_msg = "BG"; }else if(s_num == 110 ){ rtn_msg = "DG"; }else if(s_num == 162 ){ rtn_msg = "FG"; }else if(s_num == 214 ){ rtn_msg = "HG";
        }else if(s_num == 7  ){ rtn_msg = "H";  }else if(s_num == 59  ){ rtn_msg = "BH"; }else if(s_num == 111 ){ rtn_msg = "DH"; }else if(s_num == 163 ){ rtn_msg = "FH"; }else if(s_num == 215 ){ rtn_msg = "HH";
        }else if(s_num == 8  ){ rtn_msg = "I";  }else if(s_num == 60  ){ rtn_msg = "BI"; }else if(s_num == 112 ){ rtn_msg = "DI"; }else if(s_num == 164 ){ rtn_msg = "FI"; }else if(s_num == 216 ){ rtn_msg = "HI";
        }else if(s_num == 9  ){ rtn_msg = "J";  }else if(s_num == 61  ){ rtn_msg = "BJ"; }else if(s_num == 113 ){ rtn_msg = "DJ"; }else if(s_num == 165 ){ rtn_msg = "FJ"; }else if(s_num == 217 ){ rtn_msg = "HJ";
        }else if(s_num == 10 ){ rtn_msg = "K";  }else if(s_num == 62  ){ rtn_msg = "BK"; }else if(s_num == 114 ){ rtn_msg = "DK"; }else if(s_num == 166 ){ rtn_msg = "FK"; }else if(s_num == 218 ){ rtn_msg = "HK";
        }else if(s_num == 11 ){ rtn_msg = "L";  }else if(s_num == 63  ){ rtn_msg = "BL"; }else if(s_num == 115 ){ rtn_msg = "DL"; }else if(s_num == 167 ){ rtn_msg = "FL"; }else if(s_num == 219 ){ rtn_msg = "HL";
        }else if(s_num == 12 ){ rtn_msg = "M";  }else if(s_num == 64  ){ rtn_msg = "BM"; }else if(s_num == 116 ){ rtn_msg = "DM"; }else if(s_num == 168 ){ rtn_msg = "FM"; }else if(s_num == 220 ){ rtn_msg = "HM";
        }else if(s_num == 13 ){ rtn_msg = "N";  }else if(s_num == 65  ){ rtn_msg = "BN"; }else if(s_num == 117 ){ rtn_msg = "DN"; }else if(s_num == 169 ){ rtn_msg = "FN"; }else if(s_num == 221 ){ rtn_msg = "HN";
        }else if(s_num == 14 ){ rtn_msg = "O";  }else if(s_num == 66  ){ rtn_msg = "BO"; }else if(s_num == 118 ){ rtn_msg = "DO"; }else if(s_num == 170 ){ rtn_msg = "FO"; }else if(s_num == 222 ){ rtn_msg = "HO";
        }else if(s_num == 15 ){ rtn_msg = "P";  }else if(s_num == 67  ){ rtn_msg = "BP"; }else if(s_num == 119 ){ rtn_msg = "DP"; }else if(s_num == 171 ){ rtn_msg = "FP"; }else if(s_num == 223 ){ rtn_msg = "HP";
        }else if(s_num == 16 ){ rtn_msg = "Q";  }else if(s_num == 68  ){ rtn_msg = "BQ"; }else if(s_num == 120 ){ rtn_msg = "DQ"; }else if(s_num == 172 ){ rtn_msg = "FQ"; }else if(s_num == 224 ){ rtn_msg = "HQ";
        }else if(s_num == 17 ){ rtn_msg = "R";  }else if(s_num == 69  ){ rtn_msg = "BR"; }else if(s_num == 121 ){ rtn_msg = "DR"; }else if(s_num == 173 ){ rtn_msg = "FR"; }else if(s_num == 225 ){ rtn_msg = "HR";
        }else if(s_num == 18 ){ rtn_msg = "S";  }else if(s_num == 70  ){ rtn_msg = "BS"; }else if(s_num == 122 ){ rtn_msg = "DS"; }else if(s_num == 174 ){ rtn_msg = "FS"; }else if(s_num == 226 ){ rtn_msg = "HS";
        }else if(s_num == 19 ){ rtn_msg = "T";  }else if(s_num == 71  ){ rtn_msg = "BT"; }else if(s_num == 123 ){ rtn_msg = "DT"; }else if(s_num == 175 ){ rtn_msg = "FT"; }else if(s_num == 227 ){ rtn_msg = "HT";
        }else if(s_num == 20 ){ rtn_msg = "U";  }else if(s_num == 72  ){ rtn_msg = "BU"; }else if(s_num == 124 ){ rtn_msg = "DU"; }else if(s_num == 176 ){ rtn_msg = "FU"; }else if(s_num == 228 ){ rtn_msg = "HU";
        }else if(s_num == 21 ){ rtn_msg = "V";  }else if(s_num == 73  ){ rtn_msg = "BV"; }else if(s_num == 125 ){ rtn_msg = "DV"; }else if(s_num == 177 ){ rtn_msg = "FV"; }else if(s_num == 229 ){ rtn_msg = "HV";
        }else if(s_num == 22 ){ rtn_msg = "W";  }else if(s_num == 74  ){ rtn_msg = "BW"; }else if(s_num == 126 ){ rtn_msg = "DW"; }else if(s_num == 178 ){ rtn_msg = "FW"; }else if(s_num == 230 ){ rtn_msg = "HW";
        }else if(s_num == 23 ){ rtn_msg = "X";  }else if(s_num == 75  ){ rtn_msg = "BX"; }else if(s_num == 127 ){ rtn_msg = "DX"; }else if(s_num == 179 ){ rtn_msg = "FX"; }else if(s_num == 231 ){ rtn_msg = "HX";
        }else if(s_num == 24 ){ rtn_msg = "Y";  }else if(s_num == 76  ){ rtn_msg = "BY"; }else if(s_num == 128 ){ rtn_msg = "DY"; }else if(s_num == 180 ){ rtn_msg = "FY"; }else if(s_num == 232 ){ rtn_msg = "HY";
        }else if(s_num == 25 ){ rtn_msg = "Z";  }else if(s_num == 77  ){ rtn_msg = "BZ"; }else if(s_num == 129 ){ rtn_msg = "DZ"; }else if(s_num == 181 ){ rtn_msg = "FZ"; }else if(s_num == 233 ){ rtn_msg = "HZ";
        }else if(s_num == 26 ){ rtn_msg = "AA"; }else if(s_num == 78  ){ rtn_msg = "CA"; }else if(s_num == 130 ){ rtn_msg = "EA"; }else if(s_num == 182 ){ rtn_msg = "GA"; }else if(s_num == 234 ){ rtn_msg = "IA";
        }else if(s_num == 27 ){ rtn_msg = "AB"; }else if(s_num == 79  ){ rtn_msg = "CB"; }else if(s_num == 131 ){ rtn_msg = "EB"; }else if(s_num == 183 ){ rtn_msg = "GB"; }else if(s_num == 235 ){ rtn_msg = "IB";
        }else if(s_num == 28 ){ rtn_msg = "AC"; }else if(s_num == 80  ){ rtn_msg = "CC"; }else if(s_num == 132 ){ rtn_msg = "EC"; }else if(s_num == 184 ){ rtn_msg = "GC"; }else if(s_num == 236 ){ rtn_msg = "IC";
        }else if(s_num == 29 ){ rtn_msg = "AD"; }else if(s_num == 81  ){ rtn_msg = "CD"; }else if(s_num == 133 ){ rtn_msg = "ED"; }else if(s_num == 185 ){ rtn_msg = "GD"; }else if(s_num == 237 ){ rtn_msg = "ID";
        }else if(s_num == 30 ){ rtn_msg = "AE"; }else if(s_num == 82  ){ rtn_msg = "CE"; }else if(s_num == 134 ){ rtn_msg = "EE"; }else if(s_num == 186 ){ rtn_msg = "GE"; }else if(s_num == 238 ){ rtn_msg = "IE";
        }else if(s_num == 31 ){ rtn_msg = "AF"; }else if(s_num == 83  ){ rtn_msg = "CF"; }else if(s_num == 135 ){ rtn_msg = "EF"; }else if(s_num == 187 ){ rtn_msg = "GF"; }else if(s_num == 239 ){ rtn_msg = "IF";
        }else if(s_num == 32 ){ rtn_msg = "AG"; }else if(s_num == 84  ){ rtn_msg = "CG"; }else if(s_num == 136 ){ rtn_msg = "EG"; }else if(s_num == 188 ){ rtn_msg = "GG"; }else if(s_num == 240 ){ rtn_msg = "IG";
        }else if(s_num == 33 ){ rtn_msg = "AH"; }else if(s_num == 85  ){ rtn_msg = "CH"; }else if(s_num == 137 ){ rtn_msg = "EH"; }else if(s_num == 189 ){ rtn_msg = "GH"; }else if(s_num == 241 ){ rtn_msg = "IH";
        }else if(s_num == 34 ){ rtn_msg = "AI"; }else if(s_num == 86  ){ rtn_msg = "CI"; }else if(s_num == 138 ){ rtn_msg = "EI"; }else if(s_num == 190 ){ rtn_msg = "GI"; }else if(s_num == 242 ){ rtn_msg = "II";
        }else if(s_num == 35 ){ rtn_msg = "AJ"; }else if(s_num == 87  ){ rtn_msg = "CJ"; }else if(s_num == 139 ){ rtn_msg = "EJ"; }else if(s_num == 191 ){ rtn_msg = "GJ"; }else if(s_num == 243 ){ rtn_msg = "IJ";
        }else if(s_num == 36 ){ rtn_msg = "AK"; }else if(s_num == 88  ){ rtn_msg = "CK"; }else if(s_num == 140 ){ rtn_msg = "EK"; }else if(s_num == 192 ){ rtn_msg = "GK"; }else if(s_num == 244 ){ rtn_msg = "IK";
        }else if(s_num == 37 ){ rtn_msg = "AL"; }else if(s_num == 89  ){ rtn_msg = "CL"; }else if(s_num == 141 ){ rtn_msg = "EL"; }else if(s_num == 193 ){ rtn_msg = "GL"; }else if(s_num == 245 ){ rtn_msg = "IL";
        }else if(s_num == 38 ){ rtn_msg = "AM"; }else if(s_num == 90  ){ rtn_msg = "CM"; }else if(s_num == 142 ){ rtn_msg = "EM"; }else if(s_num == 194 ){ rtn_msg = "GM"; }else if(s_num == 246 ){ rtn_msg = "IM";
        }else if(s_num == 39 ){ rtn_msg = "AN"; }else if(s_num == 91  ){ rtn_msg = "CN"; }else if(s_num == 143 ){ rtn_msg = "EN"; }else if(s_num == 195 ){ rtn_msg = "GN"; }else if(s_num == 247 ){ rtn_msg = "IN";
        }else if(s_num == 40 ){ rtn_msg = "AO"; }else if(s_num == 92  ){ rtn_msg = "CO"; }else if(s_num == 144 ){ rtn_msg = "EO"; }else if(s_num == 196 ){ rtn_msg = "GO"; }else if(s_num == 248 ){ rtn_msg = "IO";
        }else if(s_num == 41 ){ rtn_msg = "AP"; }else if(s_num == 93  ){ rtn_msg = "CP"; }else if(s_num == 145 ){ rtn_msg = "EP"; }else if(s_num == 197 ){ rtn_msg = "GP"; }else if(s_num == 249 ){ rtn_msg = "IP";
        }else if(s_num == 42 ){ rtn_msg = "AQ"; }else if(s_num == 94  ){ rtn_msg = "CQ"; }else if(s_num == 146 ){ rtn_msg = "EQ"; }else if(s_num == 198 ){ rtn_msg = "GQ"; }else if(s_num == 250 ){ rtn_msg = "IQ";
        }else if(s_num == 43 ){ rtn_msg = "AR"; }else if(s_num == 95  ){ rtn_msg = "CR"; }else if(s_num == 147 ){ rtn_msg = "ER"; }else if(s_num == 199 ){ rtn_msg = "GR"; }else if(s_num == 251 ){ rtn_msg = "IR";
        }else if(s_num == 44 ){ rtn_msg = "AS"; }else if(s_num == 96  ){ rtn_msg = "CS"; }else if(s_num == 148 ){ rtn_msg = "ES"; }else if(s_num == 200 ){ rtn_msg = "GS"; }else if(s_num == 252 ){ rtn_msg = "IS";
        }else if(s_num == 45 ){ rtn_msg = "AT"; }else if(s_num == 97  ){ rtn_msg = "CT"; }else if(s_num == 149 ){ rtn_msg = "ET"; }else if(s_num == 201 ){ rtn_msg = "GT"; }else if(s_num == 253 ){ rtn_msg = "IT";
        }else if(s_num == 46 ){ rtn_msg = "AU"; }else if(s_num == 98  ){ rtn_msg = "CU"; }else if(s_num == 150 ){ rtn_msg = "EU"; }else if(s_num == 202 ){ rtn_msg = "GU"; }else if(s_num == 254 ){ rtn_msg = "IU";
        }else if(s_num == 47 ){ rtn_msg = "AV"; }else if(s_num == 99  ){ rtn_msg = "CV"; }else if(s_num == 151 ){ rtn_msg = "EV"; }else if(s_num == 203 ){ rtn_msg = "GV"; }else if(s_num == 255 ){ rtn_msg = "IV";
        }else if(s_num == 48 ){ rtn_msg = "AW"; }else if(s_num == 100 ){ rtn_msg = "CW"; }else if(s_num == 152 ){ rtn_msg = "EW"; }else if(s_num == 204 ){ rtn_msg = "GW";
        }else if(s_num == 49 ){ rtn_msg = "AX"; }else if(s_num == 101 ){ rtn_msg = "CX"; }else if(s_num == 153 ){ rtn_msg = "EX"; }else if(s_num == 205 ){ rtn_msg = "GX";
        }else if(s_num == 50 ){ rtn_msg = "AY"; }else if(s_num == 102 ){ rtn_msg = "CY"; }else if(s_num == 154 ){ rtn_msg = "EY"; }else if(s_num == 206 ){ rtn_msg = "GY";
        }else if(s_num == 51 ){ rtn_msg = "AZ"; }else if(s_num == 103 ){ rtn_msg = "CZ"; }else if(s_num == 155 ){ rtn_msg = "EZ"; }else if(s_num == 207 ){ rtn_msg = "GZ";
        }else{ rtn_msg = "";
        }//end if

        return rtn_msg;
    }

    static Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기

    /* 현재 년도를 가져온다.         2013-05-16 양중목 @return String */ public static final String getYear  (){ return "" +  oCalendar.get(Calendar.YEAR        );      }
    /* 현재   월을 가져온다.         2013-05-16 양중목 @return String */ public static final String getMonth (){ return "" + (oCalendar.get(Calendar.MONTH       ) + 1); }
    /* 현재   일을 가져온다.         2013-05-16 양중목 @return String */ public static final String getDay   (){ return "" +  oCalendar.get(Calendar.DAY_OF_MONTH);      }
    /* 현재 시간(24시간용) 가져온다. 2013-05-16 양중목 @return String */ public static final String getHour24(){ return "" +  oCalendar.get(Calendar.HOUR_OF_DAY );      }
    /* 현재 시간을 가져온다.         2013-05-16 양중목 @return String */ public static final String getHour()
    {
        String retrn_str = "";
        if (oCalendar.get(Calendar.AM_PM) == 0) retrn_str = "AM:";
        else                                    retrn_str = "PM:";
        // 12시간제로 현재 시
        retrn_str = ""+oCalendar.get(Calendar.HOUR);
        return  retrn_str;
    }

}// End of CommonUtils.java

