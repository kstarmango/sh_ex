package egovframework.zaol.common.service;

import java.util.HashMap;
import java.util.List;

public interface ZipCodeService {

	/**
	 * 시 / 구 / 동 중에 하나를 입력하여 우편번호 검색
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public List< ZipCodeVO >  selectZipCode( String name ) throws Exception;
	
	/**
	 * 우편번호 검색 결과 개수
	 * @param name
	 * @return
	 * @throws Exception
	 */
	public int selectZipCodeCnt( String name ) throws Exception;
	
	
	/**
	 * 동을 입력하여 지역 검색
	 * @param dong
	 * @return
	 * @throws Exception
	 */
	public List< ZipCodeVO >  selectArea( String dong ) throws Exception;
}
