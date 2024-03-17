<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
</div>
</div>
<div class="footer">
	<div class="container" style="width: 1140px;">
		<div class="footer-top">
			<div class="cell flex-cell center auto-width">
				<div class="cell cs">
					<h3>
						고객센터 <span>/ CS center</span>
					</h3>
					<div class="cell">
						<ul class="menu">
							<li><a href="/board/qna/list"> <img
									src="/image/1대1문의.png">
							</a></li>
							<li><a href=""> <img src="/image/FAQ.png">
							</a></li>
						</ul>
					</div>
					<div class="cell worktime">
						<strong>평일</strong> : 09:30 ~ 16:20 / 점심시간 : 11:20 ~ 12:20<br>
						토요일, 일요일 및 법정공휴일은 휴무입니다.<br> (근무시간 외 상담은 게시판 이용 부탁드립니다.)
					</div>
					<div class="cell email">
						<strong>Email : <a href="malito:maseukana43@gmail.com"
							class="link">maseukana43@gmail.com</a>
						</strong>
					</div>
				</div>
				<div class="cell currency">
					<h3>
						환율안내 <span>/ Exchange rate</span>
					</h3>
					<div class="cell center">
						<h1>환율 표 자리</h1>
					</div>
				</div>
				<script type="text/javascript">
					$(document).ready(function(){// 문서가 준비되면 동작
						$.ajax({
							url : "/rest/notice/list",//noticeRestController에 매핑
							method : "GET", // 단순히 읽기만 함
							success : function(response) {// 읽어들이면 동작
							 	for (var i = 0; i < response.length; i++) {
									var notice = response[i];
									  // 새로운 <li> 요소를 생성하여 공지사항 제목을 포함시킵니다.
									var titleLink = $("<a>").attr("href", "/board/notice/detail?noticeNo=" + notice.noticeNo).text(notice.noticeTitle).css("font-size", "13px");;
									    // <li> 요소를 생성하고 타이틀 링크를 하위 요소로 추가합니다.
									    var listItem = $("<li class=link menu>").append(titleLink);
									    // 작성일을 오른쪽에 보여줍니다.
									    listItem.append($('<span class="wdate">').text(notice.noticeWdate));
									    // footer-notice-list 클래스를 가진 요소에 <li> 요소를 추가합니다.
									    $(".footer-notice-list").append(listItem);
							 	} 
							},
							error : function(xhr, status, error) {// 엉키면...
								console.error("띠로리...");
							}
							
						});
					});
				</script>
				<div class="cell notice" id="notice-list">
					<h3>
						공지사항 <span>/ Notice</span> <a href="/board/notice/list"
							class="link-notice"><i class="fa-solid fa-plus"></i></a>
					</h3>
					<div class="cell center">
						<ul class="menu footer-notice-list">
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="footer-middle"></div>
		<div class="footer-bottom"></div>
	</div>
</div>
</main>
</body>
</html>