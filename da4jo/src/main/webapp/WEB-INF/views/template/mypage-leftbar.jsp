<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<style>
.boxInfo {
	border-color: #6c6e6e33;
	border-width: 1px;
	border-style: solid;
	boarder-radius: 2px;
	font-size: 14px;
}

.memberInfo {
	font-size: 14px;
	border-bottom-color: #6c6e6e33;
	border-bottom-width: 1px;
	border-bottom-style: solid;
}

.detailInfo, .btnMypage {
	font-size: 12px;
	padding: 5px;
}

.profileEdit {
	display: none;
}
</style>

<style>
.menuBox {
	padding: 5px;
	padding-bottom: 20px;
	height: 200px;
	margin-top: 0px !important;
}

.title-head {
	background-color: #60A1F833;
}

img.newProfile { /*프로필 공간 고정*/
	width: 100%;
	height: 150px;
}
</style>

<script>

</script>

<div class="container flex-container">
	<div class="container inner-container">
		<!-- 회원 정보 -->
		<div class="boxInfo">
			<div class="cell center memberInfo">
				<img src="/member/img" width="100%" class="newProfile">
				<div class="cell">
					<input type="file" name="img" class="tool w-100 profileEdit"
						id="edit-profile">
				</div>
				<p>
					<b>'${sessionScope.loginId}'</b> 회원님
				</p>
			</div>
			<div class="cell center detailInfo">
				<p>
					<b>'${sessionScope.loginLevel}'</b> 입니다
				</p>
				<div class="cell pt-10">
					<a class="btn w-50 btnMypage" href="/member/mypage/change">개인정보
						변경</a>
				</div>
				<div class="cell">
					<a class="btn w-150 btnMypage" href="/member/mypage/password">비밀번호
						변경</a>
				</div>
			</div>
		</div>
		<br>
		<br>
		<!-- 메뉴바 -->
		<div class="title title-head">
			<div>MENU</div>
		</div>
		<div class="title title-body">
			<div class="title-body-main">
				<div class="title-body-text">
					<a class="link main-title">구매대행</a>
				</div>
				<div class="title-body-sub">
					<div class="title-body-text">
						<a class="link" href="/member/po/request">구매대행 신청서 작성</a>
					</div>
					<div class="title-body-text">
						<a class="link" href="/member/mypage/purchase/pendingPayment">구매대행
							결제대기</a>
					</div>
					<div class="title-body-text">
						<a class="link" href="/member/mypage/purchase/processList">배송
							진행 상황</a>
					</div>
					<div class="title-body-text">
						<a class="link" href="/member/mypage/purchase/list">구매대행 신청 내역</a>
					</div>
				</div>
			</div>
			<div class="title-body-main">
				<div class="title-body-text">
					<a class="link main-title">배송대행</a>
				</div>
				<div class="title-body-sub">
					<div class="title-body-text">
						<a class="link" href="/member/ship/request">배송대행 신청서 작성</a>
					</div>
					<div class="title-body-text">
						<a class="link" href="/member/mypage/ship/pendingPayment">배송대행
							결제대기</a>
					</div>
					<div class="title-body-text">
						<a class="link" href="/member/mypage/ship/processList">배송 진행
							상황</a>
					</div>
					<div class="title-body-text">
						<a class="link" href="/member/mypage/ship/list">배송대행 신청 내역</a>
					</div>
				</div>
			</div>
			<div class="title-body-main">
				<div class="title-body-text">
					<a class="link main-title" href="/member/board/qna">QNA 게시판</a>
				</div>
				<div class="title-body-sub">
					<div class="title-body-text">
						<a class="link" href="/member/board/qna">나의 문의목록</a>
					</div>

					<div class="title-body-text">
						<a class="link" href="/board/qna/write">문의 작성하기</a>
					</div>
				</div>
			</div>
			<div class="title-body-main">
				<div class="title-body-text">
					<a class="link main-title" href="/board/review/list">리뷰 게시판</a>
				</div>
				<div class="title-body-sub">
					<div class="title-body-text">
						<a class="link" href="/member/board/review">나의 리뷰목록</a>
					</div>
					<div class="title-body-text">
						<a class="link" href="/board/review/list">리뷰 작성하기</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 왼쪽 사이드 바 닫는 태그 -->