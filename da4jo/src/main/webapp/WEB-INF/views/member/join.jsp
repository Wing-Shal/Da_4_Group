<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- 템플릿 페이지를 불러오는 코드 --%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<stlye> </stlye>

<script type="text/javascript">
	$(function() {
		var state = {
			//필수항목 : true; , 선택항목 : false;
			memberIdValid : false,
			memberPwValid : false,
			memberPwCheckValid : false,
			memberNameKorValid : false,
			memberNameEngValid : true,//선택
			memberEmailValid : false,
			isCertValid : false,
			memberContact1Valid : false,
			memberContact2Valid : true,//선택
			memberBirthValid : true, //선택
			memberClrearanceIdValid : true,//선택
			memberAddressValid : true,//선택
			//객체에 함수를 변수처럼 생성할 수 있다
			ok : function() {
				return this.memberIdValid && this.memberPwValid
						&& this.memberPwCheckValid && this.memberNameKorValid
						&& this.memberEmailValid && this.isCertValid
						&& this.memberContact1Valid && this.memberContact2Valid
						&& this.memberBirthValid
						&& this.memberClrearanceIdValid
						&& this.memberAddressValid;
			},
		};

		//아이디 검사(비동기)
		$("[name=memberId]").blur(
				function() {
					var regex = /^[a-z][a-z0-9]{7,19}$/;
					var value = $(this).val();

					if (regex.test(value)) {//아이디 형식 검사를 통과
						$.ajax({
							url : "${pageContext.request.contextPath}/rest/member/checkJoinId",
							method : "post",
							data : {
								memberId : value
							},
							success : function(response) {
								if (response == "joinN") {
									$("[name=memberId]").removeClass(
											"success fail fail2").addClass(
											"fail2");
									state.memberIdValid = false;
								} else if (response == "joinY") {
									$("[name=memberId]").removeClass(
											"success fail fail2").addClass(
											"success");
									state.memberIdValid = true;
								}
							}
						});
					} else {//아이디가 형식검사 통과
						$("[name=memberId]").removeClass("success fail fail2")
								.addClass("fail");
						state.memberIdValid = false;
					}
				});
		//비밀번호 검사(+비밀번호 확인)
		$("[name=memberPw]")
				.on(
						"blur",
						function() {
							var regex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$])[A-Za-z0-9!@#$%^&*]{6,15}$/;
							state.memberPwValid = regex.test($(this).val());
							$(this).removeClass("success fail").addClass(
									state.memberPwValid ? "success" : "fail");
						});
		$("#pw-reinput").blur(
				function() {
					var memberPw = $("[name=memberPw]").val();
					state.memberPwCheckValid = memberPw == $(this).val();

					if (memberPw.length == 0) {
						$(this).removeClass("success fail fail2").addClass(
								"fail2");
					} else {
						$(this).removeClass("success fail fail2").addClass(
								state.memberPwCheckValid ? "success" : "fail");
					}
				});

		//한글이름 검사
		$("[name=memberNameKor]").blur(
				function() {
					var regex = /^[가-힣]{2,7}$/;
					var value = $(this).val();
					state.memberNameKorValid = regex.test($(this).val);

					if (regex.test(value)) {// 형식 검사 통과
						$(this).removeClass("fail").addClass("success");
						state.memberNameKorValid = true;
					} else { //한글 이름 형식 검사 실패
						$(this).removeClass("success fail").addClass(
								state.memberNameKorValid ? "success" : "fail");
					}
				});
		//영어이름 검사
		$("[name=memberNameEng]").blur(
				function() {
					var regex = /^[A-Za-z]+$/;
					var value = $(this).val();
					state.memberNameEngValid = value.length == 0
							|| regex.test(value);
					$(this).removeClass("success fail").addClass(
							state.memberNameEngValid ? "success" : "fail");
				});
		$("[name=memberEmail]").on("input", function() {
			if (state.isCertValid) {
				alert("이메일 변경으로 재인증이 필요합니다.");
				state.memberEmailValid = false;
				state.isCertValid = false;
				$(this).removeClass("success fail").addClass("fail");
				$(".cert-wrapper").empty();
			}
		});

		//이메일 검사
		//인증을 마쳤는데 추가 입력을 하는 경우는 모든 상태를 초기화
		//- 이메일 판정 취소
		//- 인증번호 입력창 제거
		//- 이메일 피드백 제거
		$("[name=memberEmail]").on("input", function() {
			if (state.memberEmailValid) {
				state.memberEmailValid = false;
				$(this).removeClass("success fail");
				$(".cert-wrapper").empty();
			}
		});

		$("[name=memberEmail]").blur(
				function() {
					var regex = /^[a-z0-9_]{5,20}@[a-z0-9.]{1,20}$/;
					var value = $(this).val();

					if (regex.test(value)) {//이메일 형식 검사 통과
						$.ajax({
							url : "${pageContext.request.contextPath}/rest/member/checkEmail",
							method : "post",
							data : {
								memberEmail : value
							},
							success : function(response) {
								if (response == "emailN") {
									$("[name=memberEmail]").removeClass(
											"success fail fail2").addClass(
											"fail2");
									state.memberEmailValid = false;
								} else if (response == "emailY") {
									$("[name=memberEmail]").removeClass(
											"success fail fail2").addClass(
											"success");
									state.memberEmailValid = true;
								}
							}
						});
					} else {//이메일 형식 검사 실패
						$("[name=memberEmail]").removeClass(
								"success fail fail2").addClass("fail");
						state.memberEmailValid = false;
					}
				});
		//         //뒤에 있는 보내기 버튼을 활성화 또는 비활성화
		//         $(this).next(".btn-send-cert").prop("disabled", !isValid)
		//         				.removeClass("positive negative")
		//         				.addClass(isValid ? "positive" : "negative");

		//연락처1* 검사
		$("[name=memberContact1]")
				.blur(
						function() {
							var regex = /^[0-9]+$/;
							var value = $(this).val();
							state.memberContact1Valid = regex.test($(this).val);

							if (regex.test(value)) {
								$(this).removeClass("fail").addClass("success");
								state.memberContact1Valid = true;
							} else {
								$(this).removeClass("success fail").addClass(
										state.memberContact1Valid ? "success"
												: "fail");
							}
						});

		//연락처2 검사
		$("[name=memberContact2]").blur(
				function() {
					var regex = /^[0-9]+$/;
					var value = $(this).val();
					state.memberContact2Valid = value.length == 0
							|| regex.test(value);
					$(this).removeClass("success fail").addClass(
							state.memberContact2Valid ? "success" : "fail");
				});

		//생년월일 검사
		$("[name=memberBirth]")
				.blur(
						function() {
							var regex = /^(19[0-9]{2}|20[0-9]{2})-(02-(0[1-9]|1[0-9]|2[0-8])|(0[469]|11)-(0[1-9]|1[0-9]|2[0-9]|30)|(0[13578]|1[02])-(0[1-9]|1[0-9]|2[0-9]|3[01]))$/;
							var value = $(this).val();
							state.memberBirthValid = value.length == 0
									|| regex.test(value);
							$(this).removeClass("success fail")
									.addClass(
											state.memberBirthValid ? "success"
													: "fail");
						});

		//통관번호 
		$("[name=memberClearanceId]").blur(
				function() {
					var regex = /^P[0-9]{12}$/; //db 정규표현식 P대문자만 허용 됨
					var value = $(this).val();
					state.memberClearanceIdValid = value.length == 0
							|| regex.test(value);
					$(this).removeClass("success fail").addClass(
							state.memberClearanceIdValid ? "success" : "fail");
				});

		//주소
		$("[name=memberAddress2]")
				.blur(
						function() {
							var zipcode = $("[name=memberZipcode]").val();
							var address1 = $("[name=memberAddress1]").val();
							var address2 = $("[name=memberAddress2]").val();

							var isClear = zipcode.length == 0
									&& address1.length == 0
									&& address2.length == 0;
							var isFill = zipcode.length > 0
									&& address1.length > 0
									&& address2.length > 0;
							var address2Null = zipcode.length > 0
									&& address1.length > 0
									&& address2.length == 0;

							state.memberAddressValid = isClear || isFill
									|| address2Null;

							$(
									"[name=memberZipcode], [name=memberAddress1], [name=memberAddress2]")
									.removeClass("success fail")
									.addClass(
											state.memberAddressValid ? "success"
													: "fail");
						});

		var timer;
		var minutes = 5;
		var seconds = 0;

		function startTimer() {
			timer = setInterval(updateTimer, 1000);
		}

		function updateTimer() {
			if (seconds > 0) {
				seconds--;
			} else {
				if (minutes > 0) {
					minutes--;
					seconds = 59;
				} else {
					clearInterval(timer);
					$(".timer").hide(); // 타이머 숨기기
					return;
				}
			}

			var timerText = ("0" + minutes).slice(-2) + ":"
					+ ("0" + seconds).slice(-2);
			$(".timer").text(timerText);
		}

		startTimer();

		// 인증번호 입력 시 타이머 숨기기
		$("input[name='verificationCode']").on("input", function() {
			if ($(this).val().length > 0) {
				clearInterval(timer);
				$(".timer").hide(); // 타이머 숨기기
			}
		});

		//인증메일 보내기
		var memberEmail;
		$(".btn-send-cert").click(
				function() {
					var btn = this;
					$(btn).find("span").text("전송중");
					$(btn).find("i").removeClass("fa-regular fa-paper-plane")
							.addClass("fa-solid fa-spinner fa-spin");
					$(btn).prop("disabled", true);

					//이메일 불러오기
					var email = $("[name=memberEmail]").val();
					if (email.length == 0)
						return;

					$.ajax({
						url : "${pageContext.request.contextPath}/rest/member/sendCert",
						method : "post",
						data : {
							memberEmail : email
						},
						success : function(response) {
							//템플릿을 불러와서 인증번호 입력창을 추가
							var templateText = $("#cert-template").text();
							var templateHtml = $.parseHTML(templateText);

							$(".cert-wrapper").empty().append(templateHtml);
							//$(".cert-wrapper").html(templateHtml);

							//이메일 정보를 저장
							memberEmail = email;
						},
						error : function() {
							alert("시스템 오류. 잠시 후 이용바람");
						},
						complete : function() {
							$(btn).find("span").text("완료");
							$(btn).find("i").removeClass(
									"fa-solid fa-spinner fa-spin").addClass(
									"fa-regular fa-paper-plane");
							$(btn).prop("disabled", false);
						},
					});
				});

		//인증번호 확인버튼 이벤트
		$(document).on(
				"click",
				".btn-check-cert",
				function() {
					var number = $(".cert-input").val();//인증번호
					if (memberEmail == undefined || number.length == 0)
						return;

					$.ajax({
						url : "${pageContext.request.contextPath}/rest/member/checkCert",
						method : "post",
						data : {
							certEmail : memberEmail,
							certNumber : number
						},
						success : function(response) {
							//response는 true 아니면 false이므로 상태를 갱신하도록 처리
							$(".cert-input").removeClass("success fail")
									.addClass(
											response === true ? "success"
													: "fail");

							if (response) {
								//$(".btn-check-cert").off("click");
								//$(".btn-check-cert").remove();
								$(".btn-check-cert").prop("disabled", true);
								state.isCertValid = true;

								// 인증번호 입력 후 타이머를 멈추고 숨기기
								clearInterval(timer);
								$(".timer").text("인증완료").css("color", "green");
								$(".timer").fadeOut(1000); // 1초 후 타이머 숨기기
								$(".cert-wrapper").empty();

							} else {
								state.memberEmailValid = false;
							}
						},
						error : function() {
							alert("확인 과정에서 오류가 발생했습니다");
						},
					//complete:function(){}
					});
				});

		$(".check-form").submit(function(e) {
			var joinAgree =  $("[name=joinAgree]").is(':checked');
			if (!joinAgree) {
            	alert("약관에 동의해주세요.");
            	return false;
        	}
			
			//입력창 중에서 success fail fail2가 없는 창
			$(this).find(".tool").not(".success, .fail, .fail2").blur();
			//console.table(state);
			return state.ok();
		});
	});
</script>

<script type="text/template" id="cert-template">
        <div>
			<div class="cell flex-cell">
           		<input type="text" class="tool cert-input" 
                                        placeholder="인증번호">
				<button type= "button" class="btn btn-check-cert">확인</button>
			</div>
			<div class="success-feedback">이메일 인증 완료</div>
            <div class="fail-feedback">인증번호 불일치</div>
			<div class="timer"></div>
		</div>
     </div>
	</script>

<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	$(function() {
		$(".btn-address-search").click(function() {
			new daum.Postcode({
				oncomplete : function(data) {
					// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

					// 각 주소의 노출 규칙에 따라 주소를 조합한다.
					// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
					var addr = ''; // 주소 변수

					//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
					if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
						addr = data.roadAddress;
					} else { // 사용자가 지번 주소를 선택했을 경우(J)
						addr = data.jibunAddress;
					}

					// 우편번호와 주소 정보를 해당 필드에 넣는다.
					$("[name=memberZipcode]").val(data.zonecode);
					$("[name=memberAddress1]").val(addr);

					// 커서를 상세주소 필드로 이동한다.
					$("[name=memberAddress2]").focus();
				}
			}).open();
		});

		$(".btn-address-clear").click(function() {
			$("[name=memberZipcode]").val("");
			$("[name=memberAddress1]").val("");
			$("[name=memberAddress2]").val("");
		});

	});
</script>

<style>
/*
	input.tool {
		border-radius: 10px;
		
	}
	*/
.box {
	display: block;
	font-size: 15px;
	padding: 0.7em;
	/* margin: 10px 0px; */
}
/* .box도 있고 .input도 있는 경우 선택*/
.box.input {
	border: 2px solid #ccc;
	/* 입력창의 기본 강조효과 제거 */
	outline: none;
}
/* 조건부 선택자*/
.box.input:focus {
	border-color: #2db400;
}

.box.input {
	/*  	    border-bottom: 1px;  */
	border-radius: 4px;
	/* 	    border-top-right-radius: 4px; */
	/* padding: 0.4em; */
}
/*
	.box.input[name=memberPw]{
	    border-top-width: 1px;
	    border-top-left-radius: 4px;
	    border-top-right-radius: 4px;
	     padding: 0.4em; 
	*/
}
* {
	box-sizing: border-box;
	font-family: sans-serif;
}
/*아이디,비밀번호 placeholder*/
input.tool::placeholder {
	color: #b2bec3;
	font-size: 14px;
}

.timer {
	color: red;
}

.join {
	color: white;
	background-color: #74b9ff;
	border-radius: 5px;
}

.block {
	padding: 0.4em;
	margin-top: 1em;
	box-shadow: 0 0 40px rgba(0, 0, 0, 0.2);
	border-radius: 0.5em;
}
/* 웹킷(WebKit) 기반 브라우저용 스타일 */
input[type="file"]::-webkit-file-upload-button {
	background: #74b9ff;;
	color: #fff;
	border: none;
	padding: 10px 20px;
	border-radius: 5px;
	cursor: pointer;
}

/* 파이어폭스(Firefox)용 스타일 */
.input::file-selector-button {
	background: #74b9ff;;
	color: #fff;
	border: none;
	padding: 10px 20px;
	border-radius: 5px;
	cursor: pointer; # agency_buy_write .document_box { overflow : auto;
	height: 170px;
	margin-bottom: 7px;
	padding: 10px;
	line-height: 150%;
	border: 1px solid #ddd;
	background: #fff;
}


</style>


</head>
<body>
	<div class="container w-600"
		style="margin-bottom: 3em; margin-top: 3em;">
		<form action="join" method="post" autocomplete="off"
			enctype="multipart/form-data" class="check-form">
			<div class="container w-550">
				<div class="cell center">
					<label><img src="${pageContext.request.contextPath}/image/logotemplatecut.png"
						style="width: 200px"></label>
				</div>

				<!-- 첫번째 블럭 -->

				<div class="container w-450 block">
					<div class="container w-400">
						<p class="right" style="font-size: 12px; color: red;">* 표시는 필수
							항목입니다.</p>
						<style>
							#document_box {
								overflow: auto;
								height: 170px;
								margin-bottom: 7px;
								padding: 10px;
								line-height: 150%;
								border: 1px solid #ddd;
								background: #fff;
								overflow: auto;
							}
							
							.step-agreement {
								padding: 0;
								border: 1px solid #e0e0e0;
								background: #fff;
								margin-bottom: 50px;
								font-size: 12px;
							}
							
							.step-agreement .checkbox {
								margin-top: 15px;
								margin-bottom: 15px;
							}
						</style>
						<div class="area step step-agreement">
							<div id="document_box">
								<p>개인정보보호법에 따라 다사조에 회원가입 신청하시는 분께 수집하는 개인정보의 항목, 개인정보의 수집 및
									이용목적, 개인정보의 보유 및 이용기간, 동의 거부권 및 동의 거부 시 불이익에 관한 사항을 안내 드리오니 자세히
									읽은 후 동의하여 주시기 바랍니다. 1. 수집하는 개인정보 이용자는 회원가입을 하지 않아도 정보 검색, 뉴스 보기
									등 대부분의 다사조 서비스를 회원과 동일하게 이용할 수 있습니다. 이용자가 메일, 캘린더, 카페, 블로그 등과
									같이 개인화 혹은 회원제 서비스를 이용하기 위해 회원가입을 할 경우, 다사조는 서비스 이용을 위해 필요한 최소한의
									개인정보를 수집합니다. 회원가입 시점에 다사조가 이용자로부터 수집하는 개인정보는 아래와 같습니다. - 회원 가입
									시 필수항목으로 아이디, 비밀번호, 이름, 생년월일, 성별, 휴대전화번호를, 선택항목으로 이메일주소를 수집합니다.
									실명 인증된 아이디로 가입 시, 암호화된 동일인 식별정보(CI), 중복가입 확인정보(DI), 내외국인 정보를 함께
									수집합니다. 만14세 미만 아동의 경우, 법정대리인 정보(법정대리인의 이름, 중복가입확인정보(DI),
									휴대전화번호)를 추가로 수집합니다. - 비밀번호 없이 회원 가입 시에는 필수항목으로 아이디, 이름, 생년월일,
									휴대전화번호를, 선택항목으로 비밀번호를 수집합니다. - 단체 회원가입 시 필수 항목으로 단체아이디, 비밀번호,
									단체이름, 이메일주소, 휴대전화번호를, 선택항목으로 단체 대표자명을 수집합니다. 서비스 이용 과정에서 이용자로부터
									수집하는 개인정보는 아래와 같습니다. - 회원정보 또는 개별 서비스에서 프로필 정보(별명, 프로필 사진)를 설정할
									수 있습니다. 회원정보에 별명을 입력하지 않은 경우에는 마스킹 처리된 아이디가 별명으로 자동 입력됩니다. -
									다사조 내의 개별 서비스 이용, 이벤트 응모 및 경품 신청 과정에서 해당 서비스의 이용자에 한해 추가 개인정보
									수집이 발생할 수 있습니다. 추가로 개인정보를 수집할 경우에는 해당 개인정보 수집 시점에서 이용자에게 ‘수집하는
									개인정보 항목, 개인정보의 수집 및 이용목적, 개인정보의 보관기간’에 대해 안내 드리고 동의를 받습니다. 서비스
									이용 과정에서 IP 주소, 쿠키, 서비스 이용 기록, 기기정보, 위치정보가 생성되어 수집될 수 있습니다. 또한
									이미지 및 음성을 이용한 검색 서비스 등에서 이미지나 음성이 수집될 수 있습니다. 구체적으로 1) 서비스 이용
									과정에서 이용자에 관한 정보를 자동화된 방법으로 생성하여 이를 저장(수집)하거나, 2) 이용자 기기의 고유한
									정보를 원래의 값을 확인하지 못 하도록 안전하게 변환하여 수집합니다. 서비스 이용 과정에서 위치정보가 수집될 수
									있으며, 다사조에서 제공하는 위치기반 서비스에 대해서는 '다사조 위치기반서비스 이용약관'에서 자세하게 규정하고
									있습니다. 이와 같이 수집된 정보는 개인정보와의 연계 여부 등에 따라 개인정보에 해당할 수 있고, 개인정보에
									해당하지 않을 수도 있습니다. 생성정보 수집에 대한 추가 설명 - IP(Internet Protocol) 주소란?
									IP 주소는 인터넷 망 사업자가 인터넷에 접속하는 이용자의 PC 등 기기에 부여하는 온라인 주소정보 입니다. IP
									주소가 개인정보에 해당하는지 여부에 대해서는 각국마다 매우 다양한 견해가 있습니다. - 서비스 이용기록이란?
									다사조 접속 일시, 이용한 서비스 목록 및 서비스 이용 과정에서 발생하는 정상 또는 비정상 로그 일체,메일 수발신
									과정에서 기록되는 이메일주소, 친구 초대하기 또는 선물하기 등에서 입력하는 휴대전화번호, 스마트스토어 판매자와
									구매자간 상담내역(다사조톡톡 및 상품 Q&A 게시글) 등을 의미합니다. - 기기정보란? 본 개인정보처리방침에
									기재된 기기정보는 생산 및 판매 과정에서 기기에 부여된 정보뿐 아니라, 기기의 구동을 위해 사용되는 S/W를 통해
									확인 가능한 정보를 모두 일컫습니다. OS(Windows, MAC OS 등) 설치 과정에서 이용자가 PC에
									부여하는 컴퓨터의 이름, PC에 장착된 주변기기의 일련번호, 스마트폰의 통신에 필요한 고유한 식별값(IMEI,
									IMSI), AAID 혹은 IDFA, 설정언어 및 설정 표준시, USIM의 통신사 코드 등을 의미합니다. 단,
									다사조는 IMEI와 같은 기기의 고유한 식별값을 수집할 필요가 있는 경우, 이를 수집하기 전에 다사조도 원래의
									값을 알아볼 수 없는 방식으로 암호화 하여 식별성(Identifiability)을 제거한 후에 수집합니다. -
									쿠키(cookie)란? 쿠키는 이용자가 웹사이트를 접속할 때에 해당 웹사이트에서 이용자의 웹브라우저를 통해
									이용자의 PC에 저장하는 매우 작은 크기의 텍스트 파일입니다. 이후 이용자가 다시 웹사이트를 방문할 경우 웹사이트
									서버는 이용자 PC에 저장된 쿠키의 내용을 읽어 이용자가 설정한 서비스 이용 환경을 유지하여 편리한 인터넷 서비스
									이용을 가능케 합니다. 또한 방문한 서비스 정보, 서비스 접속 시간 및 빈도, 서비스 이용 과정에서 생성된 또는
									제공(입력)한 정보 등을 분석하여 이용자의 취향과 관심에 특화된 서비스(광고 포함)를 제공할 수 있습니다.
									이용자는 쿠키에 대한 선택권을 가지고 있으며, 웹브라우저에서 옵션을 설정함으로써 모든 쿠키를 허용하거나, 쿠키가
									저장될 때마다 확인을 거치거나, 아니면 모든 쿠키의 저장을 거부할 수도 있습니다. 다만, 쿠키의 저장을 거부할
									경우에는 로그인이 필요한 다사조 일부 서비스의 이용에 불편이 있을 수 있습니다. 쿠키에 관한 자세한 내용(다사조
									프라이버시 센터) 알아보기 2. 수집한 개인정보의 이용 다사조 및 다사조 관련 제반 서비스(모바일 웹/앱 포함)의
									회원관리, 서비스 개발・제공 및 향상, 안전한 인터넷 이용환경 구축 등 아래의 목적으로만 개인정보를 이용합니다.
									- 회원 가입 의사의 확인, 연령 확인 및 법정대리인 동의 진행, 이용자 및 법정대리인의 본인 확인, 이용자
									식별, 회원탈퇴 의사의 확인 등 회원관리를 위하여 개인정보를 이용합니다. - 콘텐츠 등 기존 서비스 제공(광고
									포함)에 더하여, 인구통계학적 분석, 서비스 방문 및 이용기록의 분석, 개인정보 및 관심에 기반한 이용자간 관계의
									형성, 지인 및 관심사 등에 기반한 맞춤형 서비스 제공 등 신규 서비스 요소의 발굴 및 기존 서비스 개선 등을
									위하여 개인정보를 이용합니다. - 법령 및 다사조 이용약관을 위반하는 회원에 대한 이용 제한 조치, 부정 이용
									행위를 포함하여 서비스의 원활한 운영에 지장을 주는 행위에 대한 방지 및 제재, 계정도용 및 부정거래 방지, 약관
									개정 등의 고지사항 전달, 분쟁조정을 위한 기록 보존, 민원처리 등 이용자 보호 및 서비스 운영을 위하여
									개인정보를 이용합니다. - 유료 서비스 제공에 따르는 본인인증, 구매 및 요금 결제, 상품 및 서비스의 배송을
									위하여 개인정보를 이용합니다. - 이벤트 정보 및 참여기회 제공, 광고성 정보 제공 등 마케팅 및 프로모션
									목적으로 개인정보를 이용합니다. - 서비스 이용기록과 접속 빈도 분석, 서비스 이용에 대한 통계, 서비스 분석 및
									통계에 따른 맞춤 서비스 제공 및 광고 게재 등에 개인정보를 이용합니다. - 보안, 프라이버시, 안전 측면에서
									이용자가 안심하고 이용할 수 있는 서비스 이용환경 구축을 위해 개인정보를 이용합니다. 3. 개인정보의 보관기간
									회사는 원칙적으로 이용자의 개인정보를 회원 탈퇴 시 지체없이 파기하고 있습니다. 단, 이용자에게 개인정보
									보관기간에 대해 별도의 동의를 얻은 경우, 또는 법령에서 일정 기간 정보보관 의무를 부과하는 경우에는 해당 기간
									동안 개인정보를 안전하게 보관합니다. 이용자에게 개인정보 보관기간에 대해 회원가입 시 또는 서비스 가입 시 동의를
									얻은 경우는 아래와 같습니다. - 부정 가입 및 이용 방지 부정 이용자의 가입인증 휴대전화번호 또는 DI (만
									14세 미만의 경우 법정대리인DI) : 탈퇴일로부터 6개월 보관 탈퇴한 이용자의 휴대전화번호(휴대전화 인증 시),
									DI(아이핀 인증 시): 탈퇴일로부터 6개월 보관(복호화가 불가능한 일방향 암호화(해시)하여 보관) - 다사조
									서비스 제공을 위한 본인 확인 통신사 정보 : 수집 시점으로부터 1년 보관 전자상거래 등에서의 소비자 보호에 관한
									법률, 전자문서 및 전자거래 기본법, 통신비밀보호법 등 법령에서 일정기간 정보의 보관을 규정하는 경우는 아래와
									같습니다. 다사조는 이 기간 동안 법령의 규정에 따라 개인정보를 보관하며, 본 정보를 다른 목적으로는 절대
									이용하지 않습니다. - 전자상거래 등에서 소비자 보호에 관한 법률 계약 또는 청약철회 등에 관한 기록: 5년 보관
									대금결제 및 재화 등의 공급에 관한 기록: 5년 보관 소비자의 불만 또는 분쟁처리에 관한 기록: 3년 보관 -
									전자문서 및 전자거래 기본법 공인전자주소를 통한 전자문서 유통에 관한 기록 : 5년 보관 - 통신비밀보호법 로그인
									기록: 3개월 4. 개인정보 수집 및 이용 동의를 거부할 권리 이용자는 개인정보의 수집 및 이용 동의를 거부할
									권리가 있습니다. 회원가입 시 수집하는 최소한의 개인정보, 즉, 필수 항목에 대한 수집 및 이용 동의를 거부하실
									경우, 회원가입이 어려울 수 있습니다
								</p>
							</div>
							<div class="checkbox text-right">
								<label><input name="joinAgree" type="checkbox"
									class="type_checkbox" /> <span>위의 주의사항을 모두 확인하였으며, 위 사항에
									동의합니다.</span></label>
							</div>
						</div>
					</div>
					<!-- 아이디 입력창 -->
					<div class="cell">
						<input type="text" name="memberId" class="tool w-100 box input"
							placeholder="아이디*">
						<div class="success-feedback">
							<label></label>
						</div>
						<div class="fail-feedback">아이디는 소문자 시작, 숫자 포함 8~20자로 작성하세요</div>
						<div class="fail2-feedback">이미 사용중인 아이디입니다</div>
					</div>
					<!-- 비밀번호 입력창 -->
					<div class="cell">
						<input type="password" name="memberPw"
							class="tool w-100 box input" placeholder="비밀번호*">
						<div class="success-feedback">
							<label></label>
						</div>
						<div class="fail-feedback">비밀번호에는 반드시 영문 대,소문자와 숫자, 특수문자가
							포함되어야 합니다</div>
					</div>

					<!-- 비밀번호 확인 입력창 -->
					<div class="cell">
						<input type="password" id="pw-reinput"
							class="tool w-100 box input" placeholder="비밀번호 확인 *">
						<div class="success-feedback">
							<label></label>
						</div>
						<div class="fail-feedback">비밀번호가 일치하지 않습니다</div>
						<div class="fail2-feedback">비밀번호를 먼저 입력하세요</div>
					</div>
					<!-- 한국이름 입력창 -->
					<div class="cell">
						<input type="text" name="memberNameKor"
							class="tool w-100 box input" placeholder="한국이름*">
						<div class="success-feedback">
							<label></label>
						</div>
						<div class="fail-feedback">한글 이름을 입력해주세요</div>
					</div>
					<!-- 영어이름 입력창 -->
					<div class="cell">
						<input type="text" name="memberNameEng"
							class="tool w-100 box input" placeholder="영어이름">
						<div class="success-feedback">
							<label></label>
						</div>
						<div class="fail-feedback">잘못된 영어 이름입니다.</div>
					</div>
					<!-- 이메일 입력창 -->
					<div class="cell">
						<div class="flex-cell" style="flex-wrap: wrap;">
							<input type="email" name="memberEmail"
								class="tool width-fill box input" placeholder="이메일">
							<button type="button" class="btn btn-send-cert"
								style="background-color: #74b9ff; color: white;">

								<span>인증번호 요청</span>
							</button>
							<div class="fail-feedback w-100">잘못된 이메일 형식입니다</div>
							<div class="fail2-feedback w-100">사용중인 이메일입니다</div>
						</div>
					</div>
					<div class="cell cert-wrapper"></div>
				</div>
			</div>
			<div class="container w-450 block">
				<div class="container w-400">
					<!-- 연락처1 입력창 -->
					<div class="cell">
						<input type="text" name="memberContact1"
							class="tool w-100 box input" placeholder="연락처1* (숫자만 입력해주세요)">
						<div class="success-feedback">
							<label></label>
						</div>
						<div class="fail-feedback">연락처 형식 오류</div>
					</div>
					<!-- 연락처2 입력창 -->
					<div class="cell">
						<input type="text" name="memberContact2"
							class="tool w-100 box input" placeholder="연락처2  (숫자만 입력해주세요)">
						<div class="success-feedback">
							<label></label>
						</div>
						<div class="fail-feedback">잘못된 연락처입니다.</div>
					</div>

					<!-- 생년월일 입력창 -->
					<div class="cell">
						<input type="text" name="memberBirth" class="tool w-100 box input"
							placeholder="생년월일 YYYY-MM-DD">
						<div class="success-feedback">
							<label></label>
						</div>
						<div class="fail-feedback">잘못된 형식입니다.</div>
					</div>
					<!-- 통관번호 입력창 -->
					<div class="cell">
						<input type="text" name="memberClearanceId"
							class="tool w-100 box input"
							placeholder="통관번호 ex)P1111222233334444">
						<div class="success-feedback">
							<label></label>
						</div>
						<div class="fail-feedback">잘못된 형식입니다.</div>
					</div>
					<!-- 주소 입력창 -->
					<!-- 우편번호 입력창 -->
					<div class="cell flex-cell">
						<input type="text" name="memberZipcode"
							class="tool w-100 box input" placeholder="우편번호" readonly>
						<button type="button" class="btn btn-address-search"
							style="border-right: 1px; background-color: #74b9ff; color: white;">
							<i class="fa-solid fa-magnifying-glass"></i>
						</button>
						<button type="button" class="btn btn-address-clear"
							style="background-color: #74b9ff; color: white;">
							<i class="fa-solid fa-xmark"></i>
						</button>
					</div>
					<!-- 기본주소 입력창 -->
					<div class="cell">
						<input type="text" name="memberAddress1"
							class="tool w-100 box input" placeholder="기본주소" readonly>
					</div>
					<div class="cell">
						<input type="text" name="memberAddress2"
							class="tool w-100 box input" placeholder="상세주소">
						<div class="success-feedback">
							<label></label>
						</div>
						<div class="fail-feedback">주소를 검색하여 우편번호를 입력해주세요.</div>
					</div>
					<!-- 프로필 이미지 입력창 -->
					<div class="cell">
						<!-- 							<label for="img"><img src="${pageContext.request.contextPath}/image/user.png" style="width: 200px"></label> -->
						<label style="color: #b2bec3; font-size: 15px;">프로필 이미지</label> <input
							type="file" id="img" name="img" class="tool w-100 box input">
					</div>
				</div>
			</div>

			<div class="container w-450" style="margin-bottom: 3em;">
				<div class="cell">
					<button type="submit" class="btn w-100 join">
						<i class="fa-solid fa-user"></i> 회원가입
					</button>
				</div>
			</div>
	</div>
	</form>
	</div>

	<%-- 템플릿 페이지를 불러오는 코드 --%>
	<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>