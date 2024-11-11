/**
 * 
 */

// 메뉴 - 대시보드
		function menuDashboard()
	 	{
			if($('img[id^=dashboard_img]').length == 0) {
				alert('등록된 대시보드 정보가 없습니다.');
				return;
			}

			if($("#theme").css("display") == "block"){
				$("#theme").hide();
			}
			if($("#geocoding-mini").css("display") == "block"){
				$("#geocoding-mini").hide();
			}

			$("#dashboard").css('top', '114px');
			if($("#dashboard").css("display") == "none"){
				$("#dashboard").show();

				menuUseLog('<%= RequestMappingConstants.WEB_DASHBOARD%>');
			}else{
				$("#dashboard").hide();
			}
	 	}

		// 메뉴 - 주제도면
		function menuTheme()
	 	{
			console.log("들어옴");
			if($("#theme").height() > $("body").height()) {
				$('html').css("overflow","hidden");
				$("#theme").css('overflow-y', 'auto');
			} else {
				$("#theme").css('overflow-y', '');
			}

			if($("#dashboard").css("display") == "block"){
				$("#dashboard").hide();
			}
			if($("#geocoding-mini").css("display") == "block"){
				$("#geocoding-mini").hide();
			}

			$("#theme").css('top', '114px');
			$("#themeDetail").css('top', '114px');
			$("#themeAdd").css('top', '114px');
			if($("#theme").css("display") == "none"){
				$("#theme").show();

				menuUseLog('<%= RequestMappingConstants.WEB_THEME%>');
				console.log("menuUseLog : " , menuUseLog('<%= RequestMappingConstants.WEB_THEME%>'));
			}else{
				$("#theme").hide();
			}
	 	}

		// 메뉴 - 주소변환
		function menuGeocoding()
		{
			if($('#boardList').length > 0) {
				location.href = '<%= RequestMappingConstants.WEB_GIS %>?theme=geoCoding';
				return;
			}

			if($("#dashboard").css("display") == "block"){
				$("#dashboard").hide();
			}
			if($("#theme").css("display") == "block"){
				$("#theme").hide();
			}

			if($("#geocoding-mini").css("display") == "none"){
				$("#geocoding-mini").show();

				menuUseLog('<%= RequestMappingConstants.WEB_GEOCODE %>');
			}else{
				$("#geocoding-mini").hide();
			}
		}