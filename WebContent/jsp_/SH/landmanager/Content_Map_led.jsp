<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

            
					<div class="btn-group btn-group-sm">
                        <button type="button" class="btn btn-gray dropdown-toggle" data-toggle="dropdown">기초현황인프라</button>
                        <ul class="dropdown-menu" role="menu" id="toggle_layersCity">
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity('sub_g_level1')">국공립유치원</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level1_led')"/>
                            		<div class="open-info hide" id="sub_g_level1_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>국공립유치원 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level1_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level1&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level1&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level1&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level1&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level1&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level1&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level1&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level1&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level1&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level1&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity('sub_g_level2')">사립유치원</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level2_led')"/>
                            		<div class="open-info hide" id="sub_g_level2_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>사립유치원 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level2_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level2&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level2&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level2&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level2&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level2&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level2&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level2&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level2&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level2&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level2&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity('sub_g_level3')">전체유치원</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level3_led')"/>
                            		<div class="open-info hide" id="sub_g_level3_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>전체유치원 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level3_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level3&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level3&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level3&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level3&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level3&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level3&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level3&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level3&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level3&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level3&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>                            
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity('sub_g_level4')">초등학교</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level4_led')"/>
                            		<div class="open-info hide" id="sub_g_level4_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>초등학교 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level4_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level4&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level4&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level4&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level4&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level4&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level4&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level4&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level4&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level4&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level4&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>                            
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity('sub_g_level5')">도서관</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level5_led')"/>
                            		<div class="open-info hide" id="sub_g_level5_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>도서관 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level5_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level5&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level5&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level5&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level5&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level5&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level5&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level5&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level5&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level5&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level5&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>                            
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity('sub_g_level6')">국공립어린이집</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level6_led')"/>
                            		<div class="open-info hide" id="sub_g_level6_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>국공립어린이집 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level6_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level6&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level6&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level6&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level6&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level6&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level6&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level6&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level6&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level6&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level6&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity('sub_g_level7')">민간어린이집</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level7_led')"/>
                            		<div class="open-info hide" id="sub_g_level7_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>민간어린이집 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level7_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level7&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level7&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level7&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level7&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level7&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level7&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level7&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level7&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level7&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level7&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity('sub_g_level8')">전체어린이집</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level8_led')"/>
                            		<div class="open-info hide" id="sub_g_level8_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>전체어린이집 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level8_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level8&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level8&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level8&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level8&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level8&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level8&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level8&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level8&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level8&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level8&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity('sub_g_level9')">경로당</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level9_led')"/>
                            		<div class="open-info hide" id="sub_g_level9_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>경로당 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level9_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level9&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level9&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level9&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level9&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level9&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level9&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level9&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level9&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level9&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level9&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>                            
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity('sub_g_level10')">노인교실</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level10_led')"/>
                            		<div class="open-info hide" id="sub_g_level10_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>노인교실 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level10_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level10&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level10&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level10&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level10&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level10&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level10&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level10&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level10&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level10&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level10&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>                            
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity('sub_g_level11')">의원</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level11_led')"/>
                            		<div class="open-info hide" id="sub_g_level11_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>의원 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level11_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level11&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level11&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level11&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level11&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level11&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level11&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level11&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level11&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level11&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level11&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>                            
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity('sub_g_level12')">약국</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level12_led')"/>
                            		<div class="open-info hide" id="sub_g_level12_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>약국 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level12_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level12&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level12&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level12&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level12&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level12&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level12&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level12&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level12&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level12&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level12&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity('sub_g_level13')">공공체육</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level13_led')"/>
                            		<div class="open-info hide" id="sub_g_level13_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>공공체육 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level13_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level13&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level13&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level13&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level13&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level13&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level13&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level13&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level13&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level13&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level13&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>                            
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity('sub_g_level14')">도시공원(묘지공원제외)</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level14_led')"/>
                            		<div class="open-info hide" id="sub_g_level14_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>도시공원(묘지공원제외) 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level14_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level14&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level14&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level14&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level14&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level14&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level14&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level14&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level14&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level14&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level14&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>                            
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layers('sub_g_level15')">소매점</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level15_led')"/>
                            		<div class="open-info hide" id="sub_g_level15_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>소매점 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level15_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level15&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level15&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level15&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level15&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level15&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level15&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level15&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level15&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level15&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level15&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>                            
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity('sub_g_level16')">공영주차장</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_g_level16_led')"/>
                            		<div class="open-info hide" id="sub_g_level16_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>공영주차장 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_g_level16_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level16&RULE=0"/>&nbsp;<label>0.0-1.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level16&RULE=1"/>&nbsp;<label>1.0-2.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level16&RULE=2"/>&nbsp;<label>2.0-3.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level16&RULE=3"/>&nbsp;<label>3.0-4.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level16&RULE=4"/>&nbsp;<label>4.0-5.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level16&RULE=5"/>&nbsp;<label>5.0-6.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level16&RULE=6"/>&nbsp;<label>6.0-7.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level16&RULE=7"/>&nbsp;<label>7.0-8.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level16&RULE=8"/>&nbsp;<label>8.0-9.0</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_g_level16&RULE=9"/>&nbsp;<label>9.0-10.0</label></td></tr>					
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                        </ul>
                    </div>
                    
                    <div class="btn-group btn-group-sm">
                        <button type="button" class="btn btn-gray dropdown-toggle" data-toggle="dropdown">도시재생관련 </button>
                        <ul class="dropdown-menu" role="menu" id="toggle_layersCity1">
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity1('data_city_activation')">도시재생활성화지역</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('data_city_activation_led')"/>
                            		<div class="open-info hide" id="data_city_activation_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<!-- <h3>도시재생활정화지역 범례</h3> --><!-- 2018-10-22수정 -->
											<h3>도시재생활성화지역 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('data_city_activation_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_city_activation&RULE=1단계"/>&nbsp;<label>1단계</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_city_activation&RULE=2단계"/>&nbsp;<label>2단계</label></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity1('data_house_envment')">주거환경관리사업</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('data_house_envment_led')"/>
                            		<div class="open-info hide" id="data_house_envment_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>주거환경관리사업 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('data_house_envment_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_house_envment&RULE=주거환경관리사업"/>&nbsp;<label>주거환경관리사업</label></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity1('data_hope_land')">희망지</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('data_hope_land_led')"/>
                            		<div class="open-info hide" id="data_hope_land_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>희망지 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('data_hope_land_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_hope_land&RULE=희망지"/>&nbsp;<label>희망지</label></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity1('data_release_area')">해제구역</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('data_release_area_led')"/>
                            		<div class="open-info hide" id="data_release_area_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>해제구역 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('data_release_area_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_release_area&RULE=해제구역"/>&nbsp;<label>해제구역</label></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                        </ul>
                    </div>
                    
                    <div class="btn-group btn-group-sm">
                        <button type="button" class="btn btn-gray dropdown-toggle" data-toggle="dropdown">복합쇠퇴지역 </button>
                        <ul class="dropdown-menu" role="menu" id="toggle_layersCity2" style="min-width:180px;">
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity2('sub_p_decline', 'sub_p_decline1')">도시재생쇠퇴지역-복합</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_p_decline1_led')"/>
                            		<div class="open-info hide" id="sub_p_decline1_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>도시재생쇠퇴지역 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_p_decline1_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&RULE=O"/>&nbsp;<label>복합지역 O</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&RULE=X"/>&nbsp;<label>복합지역 X</label></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity2('sub_p_decline', 'sub_p_decline2')">도시재생쇠퇴지역-근린</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_p_decline2_led')"/>
                            		<div class="open-info hide" id="sub_p_decline2_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>도시재생쇠퇴지역 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_p_decline2_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline2&RULE=1"/>&nbsp;<label>근린지역 1</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline2&RULE=2"/>&nbsp;<label>근린지역 2</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline2&RULE=3"/>&nbsp;<label>근린지역 3</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline2&RULE=4"/>&nbsp;<label>근린지역 4</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline2&RULE=5"/>&nbsp;<label>근린지역 5</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline2&RULE=6"/>&nbsp;<label>근린지역 6</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline2&RULE=7"/>&nbsp;<label>근린지역 7</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline2&RULE=8"/>&nbsp;<label>근린지역 8</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline2&RULE=9"/>&nbsp;<label>근린지역 9</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline2&RULE=10"/>&nbsp;<label>근린지역 10</label></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity2('sub_p_decline', 'sub_p_decline3')">도시재생쇠퇴지역-경제</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('sub_p_decline3_led')"/>
                            		<div class="open-info hide" id="sub_p_decline3_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>도시재생쇠퇴지역 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('sub_p_decline3_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline3&RULE=1"/>&nbsp;<label>경제지역 1</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline3&RULE=2"/>&nbsp;<label>경제지역 2</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline3&RULE=3"/>&nbsp;<label>경제지역 3</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline3&RULE=4"/>&nbsp;<label>경제지역 4</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline3&RULE=5"/>&nbsp;<label>경제지역 5</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline3&RULE=6"/>&nbsp;<label>경제지역 6</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline3&RULE=7"/>&nbsp;<label>경제지역 7</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline3&RULE=8"/>&nbsp;<label>경제지역 8</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline3&RULE=9"/>&nbsp;<label>경제지역 9</label></td></tr>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:sub_p_decline&STYLE=sub_p_decline3&RULE=10"/>&nbsp;<label>경제지역 10</label></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                        </ul>
                    </div>
                    
                    <div class="btn-group btn-group-sm">
                        <button type="button" class="btn btn-gray dropdown-toggle" data-toggle="dropdown">대중교통역세권 </button>
                        <ul class="dropdown-menu" role="menu" id="toggle_layersCity3">
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity3('data_public_transport250m')">대중교통역세권 250m</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('data_public_transport250m_led')"/>
                            		<div class="open-info hide" id="data_public_transport250m_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>대중교통역세권 250m 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('data_public_transport250m_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_public_transport250m&RULE=대중교통역세권250m"/>&nbsp;<label>대중교통역세권 250m</label></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity3('data_public_transport350m')">대중교통역세권 350m</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('data_public_transport350m_led')"/>
                            		<div class="open-info hide" id="data_public_transport350m_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>대중교통역세권 350m 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('data_public_transport350m_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_public_transport350m&RULE=대중교통역세권350m"/>&nbsp;<label>대중교통역세권 350m</label></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            </li>
                        </ul>
                    </div>
                                        
                    <%--                     
                    <div class="btn-group btn-group-sm">
                        <button type="button" class="btn btn-gray dropdown-toggle" data-toggle="dropdown">대중교통역세권 </button>
                        <ul class="dropdown-menu" role="menu" id="toggle_layersCity3" style="min-width:180px;">
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity3('data_public_transport')">대중교통역세권</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('data_public_transport_led')"/>
                            		<div class="open-info hide" id="data_public_transport_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>대중교통역세권 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('data_public_transport_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:data_public_transport&RULE=대중교통역세권"/>&nbsp;<label>대중교통역세권</label></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                        </ul>
                    </div>
                    --%>
                                        
                    <div class="btn-group btn-group-sm">
                        <button type="button" class="btn btn-gray dropdown-toggle" data-toggle="dropdown">용도구역도</button>
                        <ul class="dropdown-menu" role="menu" id="toggle_layers">
                            <li> 
                            	<div>
                            		<a href="javascript:toggle_layers('LT_C_UQ141', 'LT_C_UQ141')">국토계획구역</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ141_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UQ141_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>국토계획구역 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UQ141_svc_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr>
															<td><em><p style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_blue_4.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="무질서한 시가화를 방지하고 계획적·단계적인 개발을 도모하기 위하여 정하는 기간 동안 시가화를 유보할 필요가 있다고 생각되는 지역"></p></em>
																시가화조정구역</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_blue_6.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="수산자원을 보호·육성하기 위하여 필요한 공유수면이나 그에 인접한 토지에 농림수산식품부장관이 직접 또는 관계 행정기관의 장의 요청을 받아 도시관리계획으로 결정하는 구역을 말함"></p></em>
																수산자원보호구역</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #D25757; border-color: #633232; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="대규모 택지개발지구지정 등으로 인해 인접한 지역에  부동산 투기 및 난개발을 방지 등을 하기 위하여 한시적으로 개발행위제한지역을 지정함"></p></em>
																개발행위허가제한지역</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #7657D2; border-color: #352B55; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="개발밀도관리구역 외의 지역으로서 개발로 인하여 도로, 공원, 녹지 등 기반시설의 설치가 필요한 지역을 대상으로 기반시설을 설치하거나 그에 필요한 용지를 확보하게 하기 위하여 지정·고시하는 구역을 말함"></p></em>
																기반시설부담구역</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #D77453; border-color: #663D2F; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="개발행위로 기반시설(도시계획시설 포함)의 처리, 공급 또는 수용 능력이 부족할 것이 예상되는 지역 중 기반시설의 설치가 곤란한 지역"></p></em>
																개발밀도관리구역</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #64C6C6; border-color: #356060; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="국토의 이용 및 관리에 관한 계획의 원활한 수립 및 집행, 합리적 토지이용 등을 위하여 토지의 투기적인 거래가 성행하거나 지가가 급격히 상승할 우려가 있는 지역에 대하여는 5년 이내의 기간을 정하여 토지거래계약에 관한 허가를 받아야 하는 구역을 말함"></p></em>
																토지거래계약에관한허가구역</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #DFDF75; border-color: #66662F; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="광역시설을 체계적으로 정비하고 여러 도시의 기능을 상호 연계시킴으로서 도시 전체의 균형있는 발전과 효율적인 환경보전을 도모하기 위해 필요한 경우, 2개 이상의 도시계획구역을 대상으로 지정하는 구역을 말함"></p></em>
																광역계획구역</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #95D753; border-color: #557535; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 기타용지</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #E7A898; border-color: #844A3C; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 공공시설용지</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #57D257; border-color: #326332; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 녹지용지</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #EA6AEA; border-color: #8F308F; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 공업용지</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #4195E9; border-color: #224A73; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 상업용지</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ECB57D; border-color: #8F6030; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 주거용지</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #D1D1D8; border-color: #818194; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="2종 지구 단위 계획 구역은 계획관리지역으로서 대통령령으로 정하는 요건에 해당하는 지역, 개발진흥지구로서 대통령령으로 정하는 요건에 해당하는 지역 등을 지구단위계획 구역으로 지정 "></p></em>
																제2종지구단위계획구역</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #AEB5BB; border-color: #616B74; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="1종 지구단위계획구역은 용도지구, 도시개발구역, 정비구역, 택지개발예정지구, 대지조성사업지구, 산업단지, 관광특구, 개발제한구역·도시자연공원구역·시가화조정구역 또는 공원에서 해제되는 구역"></p></em>
																제1종지구단위계획구역</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #8C9D9D; border-color: #445151; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="도시계획 수립 대상지역의 일부에 대하여 토지 이용을 합리화하고 그 기능을 증진시키며 미관을 개선하고 양호한 환경을 확보하며, 그 지역을 체계적·계획적으로 관리하기 위하여 수립하는 도시관리계획으로 결정, 고시한 구역"></p></em>
																지구단위계획구역</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #E8FFBF; border-color: #62802B; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 도시계획구역</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ECE8E8; border-color: #949494; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 기타</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #FFEF80; border-color: #AD9C27; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 미분류</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layers('LT_C_UQ162', 'LT_C_UQ162')">도시자연공원구역</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ162_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UQ162_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000031">
											<h3>도시자연공원구역 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UQ162_svc_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr>
															<td><em><p
																		style="width: 22px; height: 14px; border-width: 0px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_red_3.png) repeat 0 0px; background-color: #008000; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="도시의 자연환경 및 경관을 보호하고 도시민에게 건전한 여가·휴식공간을 제공하기 위하여 도시지역 안에서 식생이 양호한 산지의 개발을 제한할 필요가 있다고 인정한 지역"></p></em>
																도시자연공원구역</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 16px; height: 8px; border-width: 3px; background-color: #ffffff; border-color: #ff0000; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 기타</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 16px; height: 8px; border-width: 3px; background-color: #ffffff; border-color: #ff0000; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 미분류</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li> 
                            	<div>
	                            	<a href="javascript:toggle_layers('LT_C_UD801', 'LT_C_UD801')">개발제한구역</a>
	                            	<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UD801_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UD801_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000032">
											<h3>개발제한구역 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UD801_svc_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr>
															<td><em><p
																		style="width: 20.4px; height: 12.4px; border-width: 0.8px; background-color: #AAFFFF; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="도시의 무질서한 확산을 방지하고 자연환경을 보전하여 도시민의 건전한 생활환경을 확보하기 위하여 도시의 개발을 제한할 필요가 있는지역"></p></em>
																개발제한구역</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20.4px; height: 12.4px; border-width: 0.8px; background-color: #AAFFFF; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 기타</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20.4px; height: 12.4px; border-width: 0.8px; background-color: #AAFFFF; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 미분류</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                        </ul>
                    </div>
                    <div class="btn-group btn-group-sm">
                        <button type="button" class="btn btn-gray dropdown-toggle" data-toggle="dropdown">용도지구도</button>
                        <ul class="dropdown-menu" role="menu" id="toggle_layers">
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layers('LT_C_UQ121', 'LT_C_UQ121')">경관지구</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ121_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UQ121_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000020">
											<h3>경관지구 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UQ121_svc_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_orange_2.png) repeat 0 0px; border-color: #008088; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="산지, 구릉지 등 자연경관의 보호 또는 도시의 자연 풍치를 유지하기 위하여 필요한 지구"></p></em>
																자연경관지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_orange_2.png) repeat 0 0px; border-color: #008088; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="한강 등 수변의 자연경관을 보호·유지하기 위하여 필요한 지구"></p></em> 수변경관지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_orange_2.png) repeat 0 0px; border-color: #008088; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="주거지역의 양호한 환경조성과 시가지 도시경관을 보호하기 위하여 필요한 지구"></p></em>
																시가지경관지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_orange_2.png) repeat 0 0px; border-color: #008088; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="경관을 보호·형성하기 위하여 필요한 지구"></p></em> 경관지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_orange_2.png) repeat 0 0px; border-color: #008088; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 기타</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_orange_2.png) repeat 0 0px; border-color: #008088; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 미분류</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layers('LT_C_UQ122', 'LT_C_UQ122')">미관지구</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ122_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UQ122_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000021">
											<h3>미관지구 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UQ122_svc_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr>
															<td><em><p
																		style="width: 20.6px; height: 12.6px; border-width: 0.7px; background: url(http://map.vworld.kr/images/symbol/pattern/dslash_green_4.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="토지의 이용도가 높은 지역의 미관을 유지, 관리하기 위해 지정된 미관지구"></p></em> 중심지미관지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20.6px; height: 12.6px; border-width: 0.7px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_green_5.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="사적지, 전통 건축물 등의 미관을 유지하기 위해 지정된 미관지구"></p></em> 역사문화미관지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20.6px; height: 12.6px; border-width: 0.7px; background: url(http://map.vworld.kr/images/symbol/pattern/dslash_green_4.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="중심지 및 역사적 문화미관지구 이외 주거지역을 중심으로 미관을 유지하기 위해 지정된 미관지구"></p></em>
																일반미관지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20.6px; height: 12.6px; border-width: 0.7px; background: url(http://map.vworld.kr/images/symbol/pattern/dslash_green_4.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="미관을 유지하기 위하여 필요한 지구"></p></em> 미관지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20.6px; height: 12.6px; border-width: 0.7px; background: url(http://map.vworld.kr/images/symbol/pattern/dslash_green_4.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 기타</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20.6px; height: 12.6px; border-width: 0.7px; background: url(http://map.vworld.kr/images/symbol/pattern/dslash_green_4.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 미분류</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>	
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layers('LT_C_UQ123', 'LT_C_UQ123')">고도지구</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ123_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UQ123_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000022">
											<h3>고도지구 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UQ123_svc_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_blue_4.png) repeat 0 0px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="높이의 최고한도를 정한 고도지구"></p></em> 최고고도지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_blue_4.png) repeat 0 0px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="높의의 최저한도를 정한 고도지구"></p></em> 최저고도지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_blue_4.png) repeat 0 0px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="쾌적한 환경 조성 및 토지의 효율적 이용을 위하여 건축물 높이의 최저한도 또는 최고한도를 규제할 필요가 있는 지구"></p></em>
																고도지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_blue_4.png) repeat 0 0px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 기타</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_blue_4.png) repeat 0 0px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 미분류</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li> 
                            	<div>
                            		<a href="javascript:toggle_layers('LT_C_UQ124', 'LT_C_UQ124')">방화지구</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ124_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UQ124_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000023">
											<h3>방화지구 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UQ124_svc_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_red_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 방화지구기타</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_red_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="화재의 위험을 예방하기 위하여 필요한 지구"></p></em> 방화지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_red_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 방화지구미분류</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>	
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layers('LT_C_UQ125', 'LT_C_UQ125')">방재지구</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ125_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UQ125_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000024">
											<h3>방재지구 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UQ125_svc_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_green_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 방재지구기타</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_green_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="풍수해, 산사태, 지반의 붕괴 등 재해를 예방히기 위해  필요한 지구"></p></em> 방재지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_green_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 방재지구미분류</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>	
                            </li>
                            <li> 
                            	<div>
                            		<a href="javascript:toggle_layers('LT_C_UQ126', 'LT_C_UQ126')">보존지구</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ126_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UQ126_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000025">
											<h3>보존지구 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UQ126_svc_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_green_3.png) repeat 0 0px; border-color: undefined; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="문화자원보존지구는 문화재, 전통사찰 등 역사, 문화적으로 보존가치가 큰 시설 및 지역의 보호와 보존을 위하여 지정하는 지구"></p></em>
																문화자원보존지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_green_3.png) repeat 0 0px; border-color: undefined; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="중요시설물보존지구는 국방상 또는 안보상 중요한 시설물의 보호와 보존을 위하여 지정하는 지구"></p></em>
																중요시설물보존지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_green_3.png) repeat 0 0px; border-color: undefined; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="생태계보존지구는 야생동식물서식처 등 생태적으로 보존가치가 큰 지역의 보호와 보존을 위하여 지정하는 지구"></p></em>
																생태계보존지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_green_3.png) repeat 0 0px; border-color: undefined; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="문화재, 중요 시설물 및 문화적·생태적으로 보존가치가 큰 지역의 보호와 보존을 위하여 필요한 지구"></p></em>
																보존지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_green_3.png) repeat 0 0px; border-color: undefined; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 기타</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_green_3.png) repeat 0 0px; border-color: undefined; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 미분류</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li> 
                            	<div>
                            		<a href="javascript:toggle_layers('LT_C_UQ127', 'LT_C_UQ127')">시설보호지구</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ127_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UQ127_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000026">
											<h3>시설보호지구 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UQ127_svc_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="공항시설의 보호와 항공기의 안전운항을 위하여 필요한 지구를 말함"></p></em> 공항시설보호지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="도시계획법상 용도지구의 하나로 교육환경을 보호·유지하기 위한 보호지구"></p></em> 학교시설보호지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="공용시설을 보호하고 공공업무기능을 효율화하기 위하여 필요한 지구를 말함"></p></em> 공용시설보호지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/soliddot_red_25.png) repeat 0 0px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="항만기능을 효율화하고 그 시설을 관리·운영하기 위해 필요한 지구"></p></em> 항만시설보호지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="학교시설·공용시설·항만 또는 공항의 보호, 업무기능의 효율화, 항공기의 안전운항 등을 위하여 필요한 지구"></p></em>
																시설보호지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 기타</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 미분류</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li> 
                            	<div>
                            		<a href="javascript:toggle_layers('LT_C_UQ128', 'LT_C_UQ128')">취락지구</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ128_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UQ128_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000027">
											<h3>취락지구 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UQ128_svc_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #FC3130; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="녹지지역ㆍ관리지역ㆍ농림지역ㆍ자연환경보전지역 안의 취락을 정비하기 위하여 지정하는 지구"></p></em>
																자연취락지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #FC3130; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="개발제한구역 안의 취락을 정비하기 위하여 지정하는 지구"></p></em> 집단취락지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #FC3130; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="녹지지역·관리지역·농림지역·자연환경보전지역·개발제한구역 또는 도시자연공원구역의 취락을 정비하기 위한 지구"></p></em>
																취락지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #FC3130; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 기타</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #FC3130; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 미분류</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layers('LT_C_UQ129', 'LT_C_UQ129')">개발진흥지구</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ129_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UQ129_svc_led">
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000028">
											<h3>개발진흥지구 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UQ129_svc_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_red_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="주거기능을 중심으로 개발·정비할 필요가 있는 지역"></p></em> 주거개발진흥지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_red_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="공업기능을 중심으로 개발·정비할 필요가 있는 지역"></p></em> 산업개발진흥지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_red_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="유통·물류기능을 중심으로 개발·정비할 필요가 있는 지역"></p></em> 유통개발진흥지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_red_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title="관광·휴양기능을 중심으로 개발·정비할 필요가 있는 지역"></p></em> 관광휴양개발진흥지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_red_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="주거기능, 공업기능, 유통·물류기능 및 관광·휴양기능 중 둘 이상의 기능을 중심으로 개발·정비할 필요가 있는 지역"></p></em>
																복합개발진흥지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_red_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="주거기능, 공업기능, 유통·물류기능 및 관광·휴양기능 외의 기능을 중심으로 개발·정비할 필요가 있는 지역"></p></em>
																특정개발진흥지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_red_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="주거기능·상업기능·공업기능·유통물류기능·관광기능·휴양기능 등을 집중적으로 개발·정비할 필요가 있는 지구"></p></em>
																개발진흥지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_red_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 기타</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/vertical_red_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 미분류</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li> 
                            	<div>
                            		<a href="javascript:toggle_layers('LT_C_UQ130', 'LT_C_UQ130')">특정용도제한지구</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ130_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UQ130_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000029">
											<h3>특정용도제한지구 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UQ130_svc_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p
																		title="주거기능 보호나 청소년 보호 등의 목적으로 청소년 유해시설 등 특정시설의 입지를 제한할 필요가 있는 지구"></p></em>
																특정용도제한지구</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 기타</td>
														</tr>
														<tr>
															<td><em><p
																		style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																	<p title=""></p></em> 미분류</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                        </ul>
                    </div>
                    <div class="btn-group btn-group-sm">
                        <button type="button" class="btn btn-gray dropdown-toggle" data-toggle="dropdown">용도지역도</button>
                        <ul class="dropdown-menu" role="menu" id="toggle_layers">
                            <li>
                            	<div>
	                            	<a href="javascript:toggle_layers('LT_C_UQ111', 'LT_C_UQ111')">도시지역</a>
	                            	<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ111_svc_led')"/>
	                            	<div class="open-info hide" id="LT_C_UQ111_svc_led">
									<img class="arrow" src="/jsp/SH/img/ico-arr-top.png"/>
									<div id="lyrCls_LYRIDE_0000000000016">
										<h3>도시지역 범례</h3>
										<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('LT_C_UQ111_svc_led')" style="cursor: pointer"></a>
										<div class="text">
											<table>
												<colgroup>
													<col width="50%">
													<col width="50%">
												</colgroup>
												<tbody>
													<tr>
														<td> <em><p style="width: 22px; height: 14px; border-width: 0px; background: url(http://map.vworld.kr/images/symbol/pattern/dot_red_52.png) repeat 0 0px; background-color: #FEFF68; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title="단독주택 중심의 양호한 주거환경을 보호하기 위해서 필요한 지역"></p></em>
															제1종전용주거지역</td>
													</tr>
													<tr>
														<td><em><p style="width: 22px; height: 14px; border-width: 0px; background: url(http://map.vworld.kr/images/symbol/pattern/dot_red_52.png) repeat 0 0px; background-color: #FEFF68; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title="공동주택 중심의 양호한 주거환경을 보호하기 위해서 필요한 지역"></p></em>
															제2종전용주거지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #FEFF68; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title=""></p></em> 전용주거지역미분류</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #FFFF66; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title="저층주택을 중심으로 편리한 주거환경을 조성하기 위해서 필요한 지역"></p></em>
															제1종일반주거지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #FDFF00; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title="중층주택을 중심으로 편리한 주거환경을 조성하기 위해서 필요한 지역"></p></em>
															제2종일반주거지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #FECC00; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title="중고층주택을 중심으로 편리한 주거환경을 조성하기 위해서 필요한 지역"></p></em>
															제3종일반주거지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #FFFF66; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title=""></p></em> 일반주거지역미분류</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_red_3.png) repeat 0 0px; background-color: #FFFF00; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p
																	title="주거기능을 위주로 이를 지원하는 일부 상업기능 및 업무기능을 보완하기 위해서 필요한 지역"></p></em>
															준주거지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #FFFF66; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title=""></p></em> 주거지역기타</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background: url(http://map.vworld.kr/images/symbol/pattern/dot_red_52.png) repeat 0 0px; background-color: #FE66CC; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title="도심, 부도심의 상업기능 및 업무기능의 확충을 위해서 필요한 지역"></p></em>
															중심상업지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #FE66CC; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title="일반적인 상업기능 및 업무기능을 담당하게 하기 위해서 필요한 지역"></p></em>
															일반상업지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_red_3.png) repeat 0 0px; background-color: #FE66CC; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title="근린지역에서의 일용품 및 서비스의 공급을 위해서 필요한 지역"></p></em> 근린상업지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #FE66CC; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title="도시내 및 지역간 유통기능의 증진을 위해서 필요한 지역"></p></em> 유통상업지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #FE66CC; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title=""></p></em> 상업지역기타</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background: url(http://map.vworld.kr/images/symbol/pattern/dot_purple_25.png) repeat 0 0px; background-color: #CC66FF; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title="주로 중화학공업, 공해성 공업 등을 수용하기 위해서 필요한 지역"></p></em>
															전용공업지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #CC66FF; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title="환경을 저해하지 않는 공업의 배치를 위해서 필요한 지역"></p></em> 일반공업지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_red_3.png) repeat 0 0px; background-color: #CC66FF; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p
																	title="경공업이나 그 밖의 공업을 수용하되, 주거기능?상업기능 및 업무기능의 보완이 필요한 지역"></p></em>
															준공업지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #CC66FF; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title=""></p></em> 공업지역기타</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background: url(http://map.vworld.kr/images/symbol/pattern/dot_green_25.png) repeat 0 0px; background-color: #CCFE66; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title="도시의 자연환경, 경관, 산림 및 녹지공간을 보전할 필요가 있는 지역"></p></em>
															보전녹지지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_green_3.png) repeat 0 0px; background-color: #CCFE66; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title="주로 농업적 생산을 위해서 개발을 유보할 필요가 있는 지역"></p></em> 생산녹지지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #CCFE66; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p
																	title="도시의 녹지공간의 확보, 도시확산의 방지, 장래 도시용지의 공급 등을 위해서 보전할 필요가 있는 지역으로서 불가피한 경우에 한해서 제한적인 개발이 허용되는 지역"></p></em>
															자연녹지지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #CCFE66; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title=""></p></em> 녹지지역기타</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #FD4758; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p
																	title="인구와 산업이 밀집되어 있거나 밀집이 예상되는 지역을 체계적으로 개발·정비·관리·보전할 지역을 말함. 주거, 상업, 공업기능 제공과 녹지 보전을 위하여 4가지로 구분하여 지정함"></p></em>
															도시지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title=""></p></em> 도시지역미지정지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #FD4758; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title=""></p></em> 도시지역기타</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 22px; height: 14px; border-width: 0px; background-color: #FD4758; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title=""></p></em> 도시지역미분류</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								</div>
								</div>
							</li>
                            <li>
                            	<div>
	                            	<a href="javascript:toggle_layers('LT_C_UQ112', 'LT_C_UQ112')">관리지역</a>
	                            	<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ112_svc_led')"/>
	                            	<div class="open-info hide" id="LT_C_UQ112_svc_led">
									<img class="arrow" src="/jsp/SH/img/ico-arr-top.png"/>
									<div id="lyrCls_LYRIDE_0000000000017">
										<h3>관리지역 범례</h3>
										<a class="close btnClose"><img
											src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
											onclick="showTooltip('LT_C_UQ112_svc_led')" style="cursor: pointer"></a>
										<div class="text">
											<table>
												<colgroup>
													<col width="50%">
													<col width="50%">
												</colgroup>
												<tbody>
													<tr>
														<td><em><p
																	style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_red_3.png) repeat 0 0px; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p
																	title="도시지역으로의 편입이 예상되는 지역이나 자연환경을 고려하여 제한적인 이용·개발을 하려는 지역으로서 계획적·체계적인 관리가 필요한 지역"></p></em>
															계획관리지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_red_3.png) repeat 0 0px; background-color: #CCFF66; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p
																	title="농업·임업·어업 생산 등을 위하여 관리가 필요하나, 주변 용도지역과의 관계 등을 고려할 때 농림지역으로 지정하여 관리하기가 곤란한 지역"></p></em>
															생산관리지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/dot_red_25.png) repeat 0 0px; background-color: #CCFF66; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p
																	title="자연환경 보호, 산림 보호, 수질오염 방지, 녹지공간 확보 및 생태계 보전 등을 위해서 보전이 필요하나, 주변 용도지역과의 관계 등을 고려할 때 자연환경보전지역으로 지정해서 관리하기가 곤란한 지역"></p></em>
															보전관리지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title="보전관리지역, 생산관리지역, 계획관리지역 중 하나로 구분하여 지정"></p></em> 관리지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title=""></p></em> 기타</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 20px; height: 12px; border-width: 1px; background-color: #ffffff; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title=""></p></em> 미분류</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
	                            	<a href="javascript:toggle_layers('LT_C_UQ113', 'LT_C_UQ113')">농림지역</a>
	                            	<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ113_svc_led')"/>
	                            	<div class="open-info hide" id="LT_C_UQ113_svc_led">
									<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
									<div id="lyrCls_LYRIDE_0000000000018">
										<h3>농림지역 범례</h3>
										<a class="close btnClose"><img
											src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
											onclick="showTooltip('LT_C_UQ113_svc_led')" style="cursor: pointer"></a>
										<div class="text">
											<table>
												<colgroup>
													<col width="50%">
													<col width="50%">
												</colgroup>
												<tbody>
													<tr>
														<td><em><p
																	style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_green_5.png) repeat 0 0px; background-color: #CDFE65; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title="현저한 자연훼손을 가져오지 아니하는 범위 안에서 건축하는 농어가 주택에 한함"></p></em> 농림지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_green_5.png) repeat 0 0px; background-color: #CDFE65; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title=""></p></em> 농림지역기타</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 20px; height: 12px; border-width: 1px; background: url(http://map.vworld.kr/images/symbol/pattern/slash_green_5.png) repeat 0 0px; background-color: #CDFE65; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title=""></p></em> 농림지역미분류</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
	                            	<a href="javascript:toggle_layers('LT_C_UQ114', 'LT_C_UQ114')">자연환경보전지역</a>
	                            	<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UQ114_svc_led')"/>
	                            	<div class="open-info hide" id="LT_C_UQ114_svc_led">
									<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
									<div id="lyrCls_LYRIDE_0000000000019">
										<h3>자연환경보전지역 범례</h3>
										<a class="close btnClose"><img
											src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
											onclick="showTooltip('LT_C_UQ114_svc_led')" style="cursor: pointer"></a>
										<div class="text">
											<table>
												<colgroup>
													<col width="50%">
													<col width="50%">
												</colgroup>
												<tbody>
													<tr>
														<td><em><p
																	style="width: 20.4px; height: 12.4px; border-width: 0.8px; background: url(http://map.vworld.kr/images/symbol/pattern/dot_green_25.png) repeat 0 0px; background-color: #B5FFFD; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p
																	title="공통주택, 공장, 관광휴게시설, 교육연구시설 등 행위 금지 기타 도시계획조례가 정하는 바에 의하여 종교시설, 제1종, 2종 근린시설 건축 가능"></p></em>
															자연환경보전지역</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 20.4px; height: 12.4px; border-width: 0.8px; background: url(http://map.vworld.kr/images/symbol/pattern/dot_green_25.png) repeat 0 0px; background-color: #B5FFFD; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title=""></p></em> 자연환경보전지역기타</td>
													</tr>
													<tr>
														<td><em><p
																	style="width: 20.4px; height: 12.4px; border-width: 0.8px; background: url(http://map.vworld.kr/images/symbol/pattern/dot_green_25.png) repeat 0 0px; background-color: #B5FFFD; border-color: #434343; float: left; margin: 2px 5px 2px 0; border-style: solid;"></p>
																<p title=""></p></em> 자연환경보전지역미분류</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								</div>
                            	</div>
                            </li>
                        </ul>
                    </div>
                    
                    <div class="btn-group btn-group-sm">
                        <button type="button" class="btn btn-gray dropdown-toggle" data-toggle="dropdown">도시계획시설도</button>
                        <ul class="dropdown-menu" role="menu" id="toggle_layers">
                            <li> 
                            	<div>
                            		<a href="javascript:toggle_layers('LT_C_UPISUQ151', 'LT_C_UPISUQ151')">도시계획(도로)</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UPISUQ151_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UPISUQ151_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>도시계획(도로) 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UPISUQ151_svc_led')" style="cursor: pointer"></a>
											<div class="text">	<table>		<colgroup>		<col width="50%">		<col width="50%">		</colgroup>		<tbody><tr><td><em><p style="width:20px;height:12px;border-width:1px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 도로</td></tr>		</tbody>	</table></div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layers('LT_C_UPISUQ154', 'LT_C_UPISUQ154')">도시계획(유통공급시설)</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UPISUQ154_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UPISUQ154_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000031">
											<h3>도시계획(유통공급시설) 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UPISUQ154_svc_led')" style="cursor: pointer"></a>
											<div class="text">	<table>		<colgroup>		<col width="50%">		<col width="50%">		</colgroup>		<tbody><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 시장</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background:url(http://map.vworld.kr/images/symbol/pattern/point_bg_pink_10.png) repeat 0 0px;background-color: #ffffff;border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 유통업무설비</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 수도공급시설</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 공동구</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 전기공급설비</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #ff2e2e; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 가스공급설비</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 열공급설비</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #2e8158; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 유류저장및송유설비</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 방송통신시설</td></tr>		</tbody>	</table></div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li> 
                            	<div>
	                            	<a href="javascript:toggle_layers('LT_C_UPISUQ155', 'LT_C_UPISUQ155')">도시계획(공공문화체육시설)</a>
	                            	<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UPISUQ155_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UPISUQ155_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000032">
											<h3>도시계획(공공문화체육시설) 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UPISUQ155_svc_led')" style="cursor: pointer"></a>
											<div class="text">	<table>		<colgroup>		<col width="50%">		<col width="50%">		</colgroup>		<tbody><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 운동장</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 공공청사</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background:url(http://map.vworld.kr/images/symbol/pattern/slash_blue_10.png) repeat 0 0px;background-color: #ffffff;border-color: #1443ff; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 학교</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 도서관</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 연구시설</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 문화시설</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 사회복지시설</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background:url(http://map.vworld.kr/images/symbol/pattern/dot_bg_green_10.png) repeat 0 0px;background-color: #ffffff;border-color: #57d47d; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 체육시설</td></tr><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 청소년수련시설</td></tr>		</tbody>	</table></div>
										</div>
									</div>
                            	</div>
                            </li>
                            
                            <li> 
                            	<div>
	                            	<a href="javascript:toggle_layers('LT_C_UPISUQ156', 'LT_C_UPISUQ156')">도시계획(방재시설)</a>
	                            	<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UPISUQ156_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UPISUQ156_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000032">
											<h3>도시계획(방재시설) 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UPISUQ156_svc_led')" style="cursor: pointer"></a>
											<div class="text">	<table>		<colgroup>		<col width="50%">		<col width="50%">		</colgroup>		<tbody><tr><td><em><p style="width:20px;height:12px;border-width:1px;background-color: #66ffff; border-color: #eb6900; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 하천</td></tr><tr><td><em><p style="width:20px;height:12px;border-width:1px;background-color: #66ffff; border-color: #eb6900; float:left; margin:5px 2px;border-style:solid;"></p><p title="농어촌용수를 확보할 목적으로 하천, 하천구역 또는 연안구역 등에 물을 가두어 두거나 관리하기 위한 시설"></p></em> 저수지</td></tr><tr><td><em><p style="width:20px;height:12px;border-width:1px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 방풍설비</td></tr><tr><td><em><p style="width:20px;height:12px;border-width:1px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 방수설비</td></tr><tr><td><em><p style="width:20px;height:12px;border-width:1px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 사방설비</td></tr><tr><td><em><p style="width:20px;height:12px;border-width:1px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 방조설비</td></tr><tr><td><em><p style="width:20px;height:12px;border-width:1px;background-color: #66ffff; border-color: #eb6900; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 유수지</td></tr>		</tbody>	</table></div>
										</div>
									</div>
                            	</div>
                            </li>
                            
                            <li> 
                            	<div>
	                            	<a href="javascript:toggle_layers('LT_C_UPISUQ157', 'LT_C_UPISUQ157')">도시계획(보건위생시설)</a>
	                            	<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UPISUQ157_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UPISUQ157_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000032">
											<h3>도시계획(보건위생시설) 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UPISUQ157_svc_led')" style="cursor: pointer"></a>
											<div class="text">	<table>		<colgroup>		<col width="50%">		<col width="50%">		</colgroup>		<tbody><tr><td><em><p style="width:20px;height:12px;border-width:1px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 보건위생시설</td></tr>		</tbody>	</table></div>
										</div>
									</div>
                            	</div>
                            </li>
                            
                            <li> 
                            	<div>
	                            	<a href="javascript:toggle_layers('LT_C_UPISUQ158', 'LT_C_UPISUQ158')">도시계획(환경기초시설)</a>
	                            	<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UPISUQ158_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UPISUQ158_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000032">
											<h3>도시계획(환경기초시설) 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UPISUQ158_svc_led')" style="cursor: pointer"></a>
											<div class="text">	<table>		<colgroup>		<col width="50%">		<col width="50%">		</colgroup>		<tbody><tr><td><em><p style="width:18px;height:10px;border-width:2px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 환경기초시설</td></tr>		</tbody>	</table></div>
										</div>
									</div>
                            	</div>
                            </li>
                            
                            <li> 
                            	<div>
	                            	<a href="javascript:toggle_layers('LT_C_UPISUQ159', 'LT_C_UPISUQ159')">도시계획(기타기반시설)</a>
	                            	<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UPISUQ159_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UPISUQ159_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000032">
											<h3>도시계획(기타기반시설) 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UPISUQ159_svc_led')" style="cursor: pointer"></a>
											<div class="text">	<table>		<colgroup>		<col width="50%">		<col width="50%">		</colgroup>		<tbody><tr><td><em><p style="width:20px;height:12px;border-width:1px;background-color: #cac9b6; border-color: #cac9b6; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 기타기반시설</td></tr>		</tbody>	</table></div>
										</div>
									</div>
                            	</div>
                            </li>
                            
                            <li> 
                            	<div>
	                            	<a href="javascript:toggle_layers('LT_C_UPISUQ152', 'LT_C_UPISUQ152')">도시계획(교통시설)</a>
	                            	<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UPISUQ152_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UPISUQ152_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000032">
											<h3>도시계획(교통시설) 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UPISUQ152_svc_led')" style="cursor: pointer"></a>
											<div class="text">	<table>		<colgroup>		<col width="50%">		<col width="50%">		</colgroup>		<tbody><tr><td><em><p style="width:20px;height:12px;border-width:1px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 교통시설</td></tr>		</tbody>	</table></div>
										</div>
									</div>
                            	</div>
                            </li>
                            
                            <li> 
                            	<div>
	                            	<a href="javascript:toggle_layers('LT_C_UPISUQ153', 'LT_C_UPISUQ153')">도시계획(공간시설)</a>
	                            	<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UPISUQ153_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UPISUQ153_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000032">
											<h3>도시계획(공간시설) 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UPISUQ153_svc_led')" style="cursor: pointer"></a>
											<div class="text">	<table>		<colgroup>		<col width="50%">		<col width="50%">		</colgroup>		<tbody><tr><td><em><p style="width:20px;height:12px;border-width:1px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 광장</td></tr><tr><td><em><p style="width:20px;height:12px;border-width:1px;background-color: #339900; border-color: #ffe5c0; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 공원</td></tr><tr><td><em><p style="width:20px;height:12px;border-width:1px;background:url(http://map.vworld.kr/images/symbol/pattern/slash_green_bg_green_10.png) repeat 0 0px;background-color: #339900;border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 녹지</td></tr><tr><td><em><p style="width:20px;height:12px;border-width:1px;background:url(http://map.vworld.kr/images/symbol/pattern/point_bg_green_10.png) repeat 0 0px;background-color: #339900;border-color: #ffe5c0; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 유원지</td></tr><tr><td><em><p style="width:20px;height:12px;border-width:1px;background-color: #ffffff; border-color: #ff3737; float:left; margin:5px 2px;border-style:solid;"></p><p title=""></p></em> 공공공지</td></tr>		</tbody>	</table></div>
										</div>
									</div>
                            	</div>
                            </li>
                            
                        </ul>
                    </div>
                    
                    <div class="btn-group btn-group-sm">
                        <button type="button" class="btn btn-gray dropdown-toggle" data-toggle="dropdown">지구단위계획도</button>
                        <ul class="dropdown-menu" role="menu" id="toggle_layers">
                            <li> 
                            	<div>
                            		<a href="javascript:toggle_layers('LT_C_UPISUQ161', 'LT_C_UPISUQ161')">지구단위계획</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('LT_C_UPISUQ161_svc_led')"/>
                            		<div class="open-info hide" id="LT_C_UPISUQ161_svc_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png" alt="">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>지구단위계획 범례</h3>
											<a class="close btnClose"><img
												src="/jsp/SH/img/btn-s-x.gif" alt="닫기"
												onclick="showTooltip('LT_C_UPISUQ161_svc_led')" style="cursor: pointer"></a>
											<div class="text">	<table>		<colgroup>		<col width="50%">		<col width="50%">		</colgroup>		<tbody><tr><td><em><p style="width:22px;height:14px;border-width:0px;background-color: #6d9dfb; border-color: #6d9dfb; float:left; margin:5px 2px;border-style:solid;"></p><p title="도시계획 수립 대상지역의 일부에 대하여 토지 이용을 합리화하고 그 기능을 증진시키며 미관을 개선하고 양호한 환경을 확보하며, 그 지역을 체계적·계획적으로 관리하기 위하여 수립하는 도시관리계획"></p></em> 지구단위계획</td></tr>		</tbody>	</table></div>
										</div>
									</div>
                            	</div>
                            </li>
                            
                        </ul>
                    </div>
                    
                    <div class="btn-group btn-group-sm">
                        <button type="button" class="btn btn-gray dropdown-toggle" data-toggle="dropdown">한양도성(4대문안)</button>
                        <ul class="dropdown-menu" role="menu" id="toggle_layersCity4">
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersCity4('hy')">한양도성(4대문안)</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('hy_led')"/>
                            		<div class="open-info hide" id="hy_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>한양도성(4대문안) 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('hy_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:hy&RULE=한양도성(4대문안)"/>&nbsp;<label>한양도성(4대문안)</label></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                        </ul>
                    </div>
                                        
                    <div class="btn-group btn-group-sm">
                        <button type="button" class="btn btn-gray dropdown-toggle" data-toggle="dropdown">행정경계 <!-- <span class="caret"></span> --></button>
                        <ul class="dropdown-menu" role="menu" id="toggle_layersLine">
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersLine('tl_scco_ctprvn')">시도경계</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('tl_scco_ctprvn_led')"/>
                            		<div class="open-info hide" id="tl_scco_ctprvn_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>시도경계 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('tl_scco_ctprvn_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:tl_scco_ctprvn&RULE=Single"/>&nbsp;<label>경계라인</label></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersLine('tl_scco_sig')">시군구경계</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('tl_scco_sig_led')"/>
                            		<div class="open-info hide" id="tl_scco_sig_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>시군구경계 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('tl_scco_sig_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:tl_scco_sig&RULE=Single"/>&nbsp;<label>경계라인</label></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                            <li>
                            	<div>
                            		<a href="javascript:toggle_layersLine('tl_scco_emd')">읍면동경계</a>
                            		<img src="/jsp/SH/img/btn-info02.png" class="tooltip-icon" onclick="showTooltip('tl_scco_emd_led')"/>
                            		<div class="open-info hide" id="tl_scco_emd_led" >
										<img class="arrow" src="/jsp/SH/img/ico-arr-top.png">
										<div id="lyrCls_LYRIDE_0000000000030">
											<h3>읍면동경계 범례</h3>
											<a class="close btnClose"><img src="/jsp/SH/img/btn-s-x.gif" alt="닫기" onclick="showTooltip('tl_scco_emd_led')" style="cursor: pointer"></a>
											<div class="text">
												<table>
													<colgroup>
														<col width="50%">
														<col width="50%">
													</colgroup>
													<tbody>
														<tr><td><img src="<c:out value="${geoserverURL}"/>&LAYER=SH_LM:tl_scco_emd&RULE=Single"/>&nbsp;<label>경계라인</label></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
                            	</div>
                            </li>
                        </ul>
                    </div>
        
    
    
	
    
	
	
    
    
    