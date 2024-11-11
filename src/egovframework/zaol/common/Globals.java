package egovframework.zaol.common;

import java.io.File;

import egovframework.syesd.cmmn.constants.RequestMappingConstants;

/**
 *  Class Name : Globals.java
 *  Description : 전역변수를 정의한다.
 *  Modification Information
 *
 *     수정일      수정자      수정내용
 *   -------       --------    ---------------------------
 *   2011-06-23    원영훈      최초 생성
 *   2011-11-02    양중목      법령정보, 자유게시판, 공지사항, Q&A, 보고서관리, 사업진행관리 첨부파일경로 추가
 *
 */

public class Globals {

	//도메인 주소
	public static final String ROOT_IP = "localhost"; /* 개발서버용 */
  //public static final String ROOT_IP = "116.67.32.20"; /* 실서버용 */

	//도메인 주소
	public static final String ROOT_DOMAIN = "http://" + ROOT_IP + ":8080/";

	// 관리자 E-mail 주소
	public static final String ADMIN_EMAIL = "zzangwyh@hanmail.net";

	// Context Mark
//	public static final String CONTEXT_MARK = "\\";
//	public static final String CONTEXT_MARK = "/";
	public static final String CONTEXT_MARK = java.io.File.separator;

	public static final String CONTEXT_MARK1 = "/";

	//Context Root
	//public static final String CONTEXT_ROOT = "D:\\01.SH_DEV\\SH_LM\\IC\\WebContent";	 //개발중
	//public static final String CONTEXT_ROOT = "C:\\Program Files\\Apache Software Foundation\\Tomcat 7.0\\webapps\\ROOT";

	// 2020 추가
	public static final String CONTEXT_ROOT = RequestMappingConstants.TOMCAT_PATH + "webapps" + File.separator+ "ROOT";

	//파일 업로드 원 파일명
	public static final String file_real_nm = "file_real_nm";

	//파일 확장자
	public static final String file_ext = "fileExtension";

	//파일크기
	public static final String file_size = "file_size";

	//업로드된 파일명
	public static final String file_save_nm = "file_save_nm";

	//파일경로
	public static final String file_path = "file_path";

	/* factual       첨부파일 다운 경로 */
    public static final String TMSEQ_LAND_FILE_PATH      = CONTEXT_ROOT + CONTEXT_MARK + "file" + CONTEXT_MARK + "tmseq_land";
    public static final String DECLINING_FILE_PATH      = CONTEXT_ROOT + CONTEXT_MARK + "file" + CONTEXT_MARK + "declining";

	/* factual       첨부파일 저장 경로 */
    public static final String FACTUAL_FILE_PATH      = CONTEXT_ROOT + CONTEXT_MARK + "userfile" + CONTEXT_MARK + "factual";
    public static final String DOC_FILE_PATH      = CONTEXT_ROOT + CONTEXT_MARK + "userfile" + CONTEXT_MARK + "doc";
    public static final String MOTIF_FILE_PATH      = CONTEXT_ROOT + CONTEXT_MARK + "userfile" + CONTEXT_MARK + "motif";

    public static final String HWP_FILE_PATH      = CONTEXT_ROOT + CONTEXT_MARK + "userfile" + CONTEXT_MARK + "2021_hwp";
    public static final String PDF_FILE_PATH      = CONTEXT_ROOT + CONTEXT_MARK + "userfile" + CONTEXT_MARK + "2021_pdf";
    
	//파일 업로드 원 파일명
  	public static final String ORIGIN_FILE_NM = "originalFileName";
  	//파일 확장자
  	public static final String FILE_EXT = "fileExtension";
  	//파일크기
  	public static final String FILE_SIZE = "fileSize";
  	//업로드된 파일명
  	public static final String UPLOAD_FILE_NM = "uploadFileName";
  	//파일경로
  	public static final String FILE_PATH = "filePath";


  	//파일 기본 저장 경로
  	public static final String FILE_STORE_PATH = CONTEXT_ROOT+CONTEXT_MARK+"file"+CONTEXT_MARK+"default";
  	public static final String FILE_IMAGE_PATH = CONTEXT_ROOT+CONTEXT_MARK+"jsp\\SH\\map";
  	public static final String FILE_DB_PATH = "\\file\\default";

  	public static final String KNOW_EDU_VIDEO_PATH = CONTEXT_ROOT + CONTEXT_MARK1+"file"+CONTEXT_MARK1+"eduFile"+CONTEXT_MARK1+"video";


	//파일 기본 저장 경로
//	public static final String FILE_STORE_PATH = CONTEXT_ROOT + CONTEXT_MARK + "file" + CONTEXT_MARK + "default";
//	public static final String FILE_DB_PATH = "/file/default";

    /* 교차로       첨부파일 저장 경로 */
    public static final String STRCTU_FILE_STORE_PATH      = CONTEXT_ROOT + CONTEXT_MARK + "userfile" + CONTEXT_MARK + "strctu";
    public static final String STRCTU_FILE_DB_PATH         =                  "/userfile/strctu/";

    /* 법령정보     첨부파일 저장 경로 */
    public static final String LAWORD_FILE_STORE_PATH      = CONTEXT_ROOT + CONTEXT_MARK + "userfile" + CONTEXT_MARK + "laword";
    public static final String LAWORD_FILE_DB_PATH         =                  "/userfile/laword/";

    /* 자유게시판   첨부파일 저장 경로 */
    public static final String LBRTYBBS_FILE_STORE_PATH    = CONTEXT_ROOT + CONTEXT_MARK + "userfile" + CONTEXT_MARK + "lbrtybbs";
    public static final String LBRTYBBS_FILE_DB_PATH       =                  "/userfile/lbrtybbs/";

    /* 공지사항     첨부파일 저장 경로 */
    public static final String NOTICE_FILE_STORE_PATH      = CONTEXT_ROOT + CONTEXT_MARK + "userfile" + CONTEXT_MARK + "notice";
    public static final String NOTICE_FILE_DB_PATH         =                  "/userfile/notice/";

    /* Q&A          첨부파일 저장 경로 */
    public static final String QNA_FILE_STORE_PATH         = CONTEXT_ROOT + CONTEXT_MARK + "userfile" + CONTEXT_MARK + "qna";
    public static final String QNA_FILE_DB_PATH            =                  "/userfile/qna/";

    /* 보고서관리   첨부파일 저장 경로 */
    public static final String REPRTMANAGE_FILE_STORE_PATH = CONTEXT_ROOT + CONTEXT_MARK + "userfile" + CONTEXT_MARK + "reprtmanage";
    public static final String REPRTMANAGE_FILE_DB_PATH    =                  "/userfile/reprtmanage/";

    /* 사업진행관리 첨부파일 저장 경로 */
    public static final String BSNSPRGRS_FILE_STORE_PATH   = CONTEXT_ROOT + CONTEXT_MARK + "userfile" + CONTEXT_MARK + "bsnsprgrs";
    public static final String BSNSPRGRS_FILE_DB_PATH      =                  "/userfile/bsnsprgrs/";

    /* 사업진행현황관리(간소화) 첨부파일 저장 경로 */
    public static final String PRGSMP_FILE_STORE_PATH   = CONTEXT_ROOT + CONTEXT_MARK + "userfile" + CONTEXT_MARK + "bsnsprgrs";
    public static final String PRGSMP_FILE_DB_PATH      =                  "/userfile/bsnsprgrs/";




}

