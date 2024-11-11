/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package egovframework.zaol.common.web;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;

/**
 * @Class Name : ImagePaginationRenderer.java
 * @Description : ImagePaginationRenderer Class
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2009.03.16           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *  Copyright (C) by MOPAS All right reserved.
 */
public class UserPaginationRenderer extends AbstractPaginationRenderer {

    /**
    * PaginationRenderer
	*
    * @see 개발프레임웍크 실행환경 개발팀
    */
	public UserPaginationRenderer() {
//		firstPageLabel = "<img src='/jsp/SH/img/btn_eprev.gif' class='csh' alt='첫&#160;페이지' onclick=\"{0}({1});\">&#160;";
//        previousPageLabel = "<img src='/jsp/SH/img/btn_prev.gif' class='csh' alt='이전&#160;페이지' onclick=\"{0}({1});\">&#160;";
//        currentPageLabel = "<span><strong>{0}</strong></span>&#160;";
//        otherPageLabel = "<span><a class='csh' onclick=\"{0}({1});\" >{2}</a></span>&#160;";
//        nextPageLabel = "<img src='/jsp/SH/img/btn_next.gif' class='csh' alt='다음&#160;페이지' onclick=\"{0}({1});\">&#160;";
//        lastPageLabel = "<img src='/jsp/SH/img/btn_enext.gif' class='csh' alt='끝&#160;페이지' onclick=\"{0}({1});\">&#160;";
		firstPageLabel = "";
        previousPageLabel = "<li><a href=\"javascript:{0}({1});\">&lt;</a></li>";
        currentPageLabel = "<li class=\"active\"><a href=\"#\">{0}</a></li>"; 
        otherPageLabel = "<li><a href=\"javascript:{0}({1});\">{2}</a></li>"; 
        nextPageLabel = "<li><a href=\"javascript:{0}({1});\">></a></li>";
        lastPageLabel = ""; 
	}
}
