<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


<style>
.menu.menu-type {
	border-bottom: 1px solid #CAE4FF;
	border-top: 1px solid #CAE4FF;
	background-color: #DEEEFF;
}
</style>


<div class="container container-body">
	<jsp:include page="/WEB-INF/views/template/board-sidebar.jsp"></jsp:include>
	<!-- 내용자리 -->
	<div class="container inner-container">
		<div class="content content-head">
			<div class="content-head-text">
				<i class="fa-solid fa-pause"></i>Q&A 게시판
			</div>
		</div>

		<div class="container inner-container">


			<div class="cell">
				<%-- 쉼표를 없애고 formattedTitle에 저장합니다 --%>
				<c:set var="formattedTitle"
					value="${fn:replace(qnaDto.qnaTitle, '➜,', '')}" />
				<h3>제목 : ${formattedTitle}</h3>
			</div>

			<div class="cell mt-50">
				<h3>내가 작성한 내용</h3>
			</div>

			<hr>

			<div class="cell" style="min-height: 250px">
				${qnaDto.qnaContent}</div>
			<div class="cell right py-10 px-10">
				<strong><label>작성자 : ${qnaDto.qnaWriter}</label></strong>
			</div>
			<hr>

			<div class="cell flex-cell auto-width">
				<div class="cell">
					<div class="cell">
						<label>작성일 : ${qnaDto.qnaWdate}</label> 
						<label>조회수 : ${qnaDto.qnaVcount}</label>
					</div>
				</div>

				<div class="cell right">
					<a class="btn link" href="write">질문글작성</a> <a class="btn link" href="list">목록으로</a>
					<c:if
						test="${sessionScope.loginLevel == '관리자' || sessionScope.loginLevel == '총관리자'}">
						<a class="btn negative"
							href="${pageContext.request.contextPath}board/qna/delete?qnaNo=${qnaDto.qnaNo}">질문글삭제</a>
					</c:if>
				</div>

			</div>
		</div>
	</div>
</div>




<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>