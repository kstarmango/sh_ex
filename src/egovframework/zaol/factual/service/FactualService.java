package egovframework.zaol.factual.service;

import java.util.List;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.zaol.factual.service.FactualVO;
import egovframework.zaol.home.service.HomeVO;

public interface FactualService {

	public List	factualListPage			(FactualVO factualVO) throws Exception;
	public int	factualListPageCnt		(FactualVO factualVO) throws Exception;
	
	public List	factualcodeList			(FactualVO factualVO) throws Exception; //코드 리스트 조회
	
	public List	factualsigList			(FactualVO factualVO) throws Exception; //시군구 리스트 조회
	public List	factualemdList			(FactualVO factualVO) throws Exception; //읍면동 리스트 조회
	public List	factualliList			(FactualVO factualVO) throws Exception; //리 리스트 조회
	
	public int  MaxFileGID(FactualVO factualVO) throws Exception;	//실태조사 저장 후 GID값 가져오기
	
	public void factualInserteStart		(FactualVO factualVO) throws Exception; //실태조사 입력
	public FactualVO factualselectData	(FactualVO factualVO) throws Exception; //상세보기
	public List	factualdata				(FactualVO factualVO) throws Exception; //첨부파일 조회
	public int   factualupdate			(FactualVO factualVO, final MultipartHttpServletRequest multiRequest) throws Exception; //실태조사 수정
	public int	deletefactualData		(FactualVO vo) throws Exception; //실태조사 삭제
	
	public List	factualSearchList			(FactualVO factualVO) throws Exception; //실태조사 검색
	public List	factualSearchList_doc			(FactualVO factualVO) throws Exception; //실태조사 검색
    

}