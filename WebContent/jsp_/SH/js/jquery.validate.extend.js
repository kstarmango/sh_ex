/*
 * 
 *  
 *  required:true				입력 필수 항목설정. text, password, select, radio, checkbox type에 사용
 *  remote:"check.do"			외부 URL을 이용한 validation이 필요한 경우 사용.
 *  email:true					이메일 형식의 값인지 체크.
 *  url:true					유효한 url 형식인지 체크.
 *  date:true					유효한 날짜 형식의 값인지 체크.
 *  dateISO:true				유효한 국제표준 날짜 형식인지 체크.
 *  number:true					유효한 숫자인지 체크.
 *  digits:true					유효한 digit 값인지 체크. number와 다른점은 양의 정수만 허용한다. 즉, 소수와 음수일 경우 false
 *  creditcard					유효한 카드번호 형식인지 체크. 공식페이지에서는 creditcard rule을 그대로 적용하지 말고 현지 사정에 맞게 수정하라고 권장
 *  equalTo:"#field"			다른 FORM 항목과 동일한 값인지 체크.
 *  maxlength:5					최대 길이 체크.
 *  minlength:10				최소 길이 체크.
 *  rangelength:[5,10]			길이 범위 체크.
 *  range:[5,10]				숫자의 범위 체크.
 *  max:5						숫자의 최대값 체크.
 *  min:10						숫자의 최소값 체크.
 *  -------------------------------------------------------------------------------------------------------------------
 *  
 *  *******************************************************************************************************************
 *  추가한 rule 규칙   (value 길이가 0 이상일 때만 체크한다)
 *  *******************************************************************************************************************
 *  telephone					전화번호 형식 체크
 *  cellphone					휴대폰번호 형식 체크
 *  phone						전화번호 또는 휴대폰번호 체크
 *  emailChk					e-mail 형식 확장 체크(기본제공형식의 경우 test@test 도 통과됨)
 *  lngEngorKor					영문,한글 체크
 *  lngEngorNum					영문,숫자 체크
 *  lngEngorNumorKor			영문,숫자,한글 체크
 *  lngEngNumSpecialCharMix		영문,숫자,특수문자를 반드시 조합하여 사용 체크
 *  identicalConsecutively		동일한 숫자 및 문자를 연속해서 4번이상 사용 불가 체크
 *  notEqualTo					다른 FORM 항목과 불일치한 값인지 체크.
 *  추후 계속 추가필요
 *  
 */


//validation 규칙(전화번호 규칙)
$.validator.addMethod('telephone', function (value, element) {
	return value.length == 0 ? true:/^\d{2,3}-\d{3,4}-\d{4}$/.test(value);
	}, '전화번호는 "지역번호-XXX-XXXX" 또는 "지역번호-XXXX-XXXX" 형태로 입력 하셔야 합니다.'
);


//validation 규칙(휴대폰 규칙)
$.validator.addMethod('cellphone', function (value, element) {
	return value.length == 0 ? true:/^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$/.test(value);
	}, '휴대폰번호는 "01X-XXX-XXXX" 또는 "01X-XXXX-XXXX" 형태로 입력 하셔야 합니다.'
);

//validation 규칙(전화번호 또는 휴대폰 규칙)
$.validator.addMethod('phone', function (value, element) {
	return value.length == 0 ? true:/(^02.{0}|^01.{1}|[0-9]{3})-?([0-9]{3,4})-?([0-9]{4})$/.test(value);
	}, '전화번호는 "02-XXX-XXXX" 또는 "0XX-XXXX-XXXX" 형태로 입력 하셔야 합니다.'
);


//validation 규칙(e-mail 규칙)
$.validator.addMethod('emailChk', function (value, element) {
	return value.length == 0 ? true:/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i.test(value);
	}, '올바른 이메일 형식으로 입력 하셔야 합니다.'
);

//validation 규칙(영문,한글)
$.validator.addMethod('lngEngorKor', function (value, element) {
	return value.length == 0 ? true:/^[ㄱ-ㅎ|가-힣|a-z|A-Z|\*]+$/.test(value);
	}, '한글 또는 영문만 입력 가능합니다.'
);

//validation 규칙(영문,숫자)
$.validator.addMethod('lngEngorNum', function (value, element) {
	return value.length == 0 ? true:/^[a-z|A-Z|0-9|\*]+$/.test(value);
	}, '영문 또는 숫자만 입력 가능합니다.'
);
//validation 규칙(영문,숫자,한글)
$.validator.addMethod('lngEngorNumorKor', function (value, element) {
	return value.length == 0 ? true:/^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|\*]+$/.test(value);
	}, '영문,숫자,한글만 입력 가능합니다.'
);

//validation 규칙( 영문 , 숫자, 특수문자를 조합하여 사용)
$.validator.addMethod('lngEngNumSpecialCharMix', function (value, element) {
	return value.length == 0 ? true:/^.*(?=.*[a-zA-Z])(?=.*[~,!,@,#,$,*,(,),=,+,_,.,|]).*$/.test(value);
	}, '영문,숫자,특수문자를 조합하여 사용해야 합니다.'
);

//validation 규칙( 동일한 숫자 및 문자를 연속해서 4번이상 사용 불가)
$.validator.addMethod('identicalConsecutively', function (value, element) {
	var temp = "";
	var intCnt = 0;
	for (var i = 0; i < value.length; i++) {
		temp = value.charAt(i);
		if (temp == value.charAt(i + 1) && temp == value.charAt(i + 2) && temp == value.charAt(i + 3)) {
			intCnt = intCnt + 1;
		}
	}
	return (intCnt > 0) ? false : true;
	}, '동일한 숫자 및 문자를 연속해서 4번이상 사용하실 수 없습니다.'
);

$.validator.addMethod("notEqualTo", function(value, element, param) {
    return this.optional(element) || value != $(param).val();
    }, "기존 값과 일치해서는 안됩니다."
);