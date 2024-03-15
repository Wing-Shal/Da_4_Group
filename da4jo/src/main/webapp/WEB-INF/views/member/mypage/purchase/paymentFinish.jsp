<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<style>
.boxInfo{
	border-color: #6c6e6e33;
	border-width: 1px;
    border-style: solid;
	boarder-radius: 2px;
	font-size: 14px;
}

.memberInfo{
	font-size:14px;
	border-bottom-color: #6c6e6e33;
	border-bottom-width: 1px;
    border-bottom-style: solid;
}

.detailInfo,
.btn {
	font-size: 12px;
	padding: 5px;
}

.profileEdit{
	display : none;
}

</style>

<!-- 결제 완료 페이지 -->
<br>
<br>
<div class="container container-body">
	<!-- 마이페이지 헤더 -->
	<div class="container inner-container">
		<div class="content content-head">
			<div class="content-head-text">
				<i class="fa-solid fa-pause"></i>결제 완료
			</div>
		</div>
	</div>
	<div class="container flex-container">
		<!-- 왼쪽 사이드 바 -->
		<div class="container inner-container">
			<!-- 회원 정보 -->
			<div class="boxInfo">
				<div class="cell center memberInfo">
					<img src="img" width="100%" class="newProfile">
					<div class="cell">
						<label for="edit-profile"><i class="fa-solid fa-plus">수정</i></label>
						<input type="file" name="img" class="tool w-100 profileEdit" id="edit-profile">
					</div>
					<p><b>'${memberDto.memberId}'</b> 회원님</p>
				</div>
				<div class="cell center detailInfo">
					<p><b>'${memberDto.memberLevel}'</b> 입니다</p>
					<div class="cell pt-10">
						<a class="btn w-50" href="/member/mypage/change">개인정보 변경</a>
					</div>
					<div class="cell">
						<a class="btn w-150" href="/member/mypage/password">비밀번호 변경</a>
					</div>
				</div>
			</div>
			<br><br>
			<!-- 메뉴바 -->
			<div class="title title-head">
				<div>MENU</div>
			</div>
			<div class="title title-body">
				<div class="title-body-main">
					<div class="title-body-text">
						<a class="link">구매대행</a>
					</div>
					<div class="title-body-sub">
						<div class="title-body-text">
							<a class="link">구매대행 신청서 작성</a>
						</div>
						<div class="title-body-text">
							<a class="link">구매대행 결제대기</a>
						</div>
						<div class="title-body-text">
							<a class="link">구매대행 신청 내역</a>
						</div>
					</div>
				</div>
				<div class="title-body-main">
					<div class="title-body-text">
						<a class="link">QNA</a>
					</div>
				</div>
				<div class="title-body-main">
					<div class="title-body-text">
						<a class="link" href="/member/board/review">내가 쓴 리뷰</a>
					</div>
				</div>
			</div>
		</div><!-- 왼쪽 사이드 바 닫는 태그 -->
		<!-- 오른쪽 내용 -->
		<div class="container inner-container">
			<div class="content content-body">
				<!-- 결제 완료 페이지 -->
				<div class="cell center">
					<h1>결제 완료!</h1>
				</div>
				<div class="cell center">
					<a href="/member/mypage" class="btn">마이페이지로 이동</a>
				</div>	
			</div>
		</div><!-- 오른쪽 내용 닫는 태그 -->
	</div><!-- 컨텐트 자리 닫는 태그 -->
</div>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>