<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <%@ page
import="egovframework.syesd.cmmn.constants.RequestMappingConstants"%> <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- <link rel="stylesheet" href="https://uicdn.toast.com/grid/latest/tui-grid.css" /> -->
<!-- <script src="https://uicdn.toast.com/grid/latest/tui-grid.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script> -->

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script>
    $(document).ready(function () {
        // 창 minimize / maxmise
        var search_list_is_min = false;
        var search_list_mini_width;
        var search_list_mini_height;

        $('#search-list-mini-min').click(function () {
            if (!search_list_is_min) {
                search_list_mini_width = $('#search_list_mini').width();
                search_list_mini_height = $('#search_list_mini').height();

                $('#search_list_contents_group').css('display', 'none');
                $('#search_list_button_group').css('display', 'none');

                $('#search_list_mini_title_head').css('border-radius', '0px / 0px');
                $('#search_list_mini').css('border-radius', '0px / 0px');
                $('#search_list_mini').css('width', 600);
                $('#search_list_mini').css('height', 40);

                search_list_is_min = true;
            }
        });

        $('#search-list-mini-max').click(function () {
            if (search_list_is_min) {
                $('#search_list_contents_group').css('display', 'block');
                $('#search_list_button_group').css('display', 'block');

                $('#search_list_mini_title_head').css('border-radius', '10px 10px 0 0');
                $('#search_list_mini').css('border-radius', '10px 10px 10px 10px');
                $('#search_list_mini').css('width', search_list_mini_width);
                $('#search_list_mini').css('height', search_list_mini_height);

                search_list_is_min = false;
            }
        });

        $('#search-list-mini-close, #search_list_close').click(function () {
            $('#search_item_edit').hide();
            $('#search_item_edit_save').hide();
            $('#search_item_edit_cancel').hide();
            $('#search_comprehensive').hide();

            $('#search_list_mini').hide();
        });

        $('#search_list_mini').resizable({
            minWidth: 900,
            minHeight: 600,
            maxHeight: 600,
        });

        $('#search_item_edit').click(function () {
            // 속성 편집 창보기 - 미완성
            {
                console.log('속성 편집 창보기');
            }

            $('#search_item_edit').hide();
            $('#search_item_edit_save').show();
            $('#search_item_edit_cancel').show();
        });

        $('#search_item_edit_save').click(function () {
            // 속성 편집 저장 & 창닫기 - 미완성
            {
                console.log('속성 편집 저장');
            }

            $('#search_item_edit_cancel').trigger('click');
        });

        $('#search_item_edit_cancel').click(function () {
            $('#search_item_edit').hide();
            $('#search_item_edit_save').hide();
            $('#search_item_edit_cancel').hide();
        });
    });
</script>

<!-- 검색 결과 Side-Panel -->
<div class="side-pane info-mini layer-pop" style="width: 450px; height: auto; min-height: 300px; display: none;" id="search_list_mini">
    <!-- Page-Title -->
    <div class="row page-title-box-wrap tit info-mini" id="search_list_mini_title_head">
        <div class="page-title-box info-mini col-xs-12" style="width: 340px">
            <p class="page-title m-b-0" id="info_mini_address">
                <i class="fa fa-map-o m-r-5"></i>
                <b><span id="search_list_mini_title"></span> 검색결과</b>
            </p>
        </div>
        <!-- <div class="close-btn tab"> -->
        <div class="pop_head_btn close-btn tab" style="display: flex">
            <button type="button" class="w-cls tab" id="search-list-mini-close">×</button>
            <!-- <button type="button" class="close tab" id="search_list_mini_close">×</button> -->
        </div>
    </div>
    <!-- End Page-Title -->

    <!--정보 Panel-Content -->
    <div class="row" style="display: block" id="search_list_contents_group">
        <div class="col-sm-12" id="modalCnt">
            <div id="loading_area">데이터 로딩중</div>
            <div class="card-box last table-responsive searchResult" style="border: 0px; display: none" id="content_area"></div>
        </div>
    </div>

    <!-- End 정보 Panel-Content -->


</div>
<!-- End 검색 결과 Side-Panel -->
