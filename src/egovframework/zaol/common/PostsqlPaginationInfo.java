package egovframework.zaol.common;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

public class PostsqlPaginationInfo extends PaginationInfo {

	/**
	 * 페이징 SQL의 조건절에 사용되는 시작 rownum
	 * 기존 클래스가 0 부터 시작하는 관계로  재정의 해서 사용
	 */
	@Override
	public int getFirstRecordIndex() {

		int firstRecordIndex =0;//= getFirstRecordIndex();
		int currentPageNo = this.getCurrentPageNo();
		int recordCountPerPage = this.getRecordCountPerPage();
		
		firstRecordIndex = (currentPageNo - 1) * recordCountPerPage + 1;
		return firstRecordIndex;
	}

	
}
