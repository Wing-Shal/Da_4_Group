package com.kh.da4jo.controller;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.kh.da4jo.dao.ImgDao;
import com.kh.da4jo.dao.MemberDao;
import com.kh.da4jo.dao.ReviewDao;
import com.kh.da4jo.dto.MemberDto;
import com.kh.da4jo.dto.QnaDto;
import com.kh.da4jo.dto.ReviewDto;
import com.kh.da4jo.service.ImgService;
import com.kh.da4jo.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board/review")
public class ReviewController {
	@Autowired
	private MemberDao memberDao;
	@Autowired
	private ReviewDao reviewDao;
	@Autowired
	private ImgService imgService;
	@Autowired
	private ImgDao imgDao;
	
	//리뷰 글 작성
	@GetMapping("/write")
		public String write() {
		return "/WEB-INF/views/board/review/write.jsp";
	}

	@PostMapping("/write")
	public String write(@ModelAttribute ReviewDto reviewDto, @RequestParam MultipartFile img, 
			@RequestParam float score, HttpSession session) throws IllegalStateException, IOException {
		String loginId = (String)session.getAttribute("loginId");
		reviewDto.setReviewWriter(loginId);
		
		//등록
		int reviewNo = reviewDao.getSequence();
		int reviewStar = (int)score;
		reviewDto.setReviewNo(reviewNo);
		reviewDto.setReviewStar(reviewStar);
		reviewDao.insert(reviewDto);
		
		if(!img.isEmpty()) {
			int imgNo = imgService.save(img);
			
			//연결
			reviewDao.connect(reviewNo, imgNo);
		}
		return "redirect:list";
	}
	
	//리뷰 목록
	@RequestMapping("/list")
	public String list(@ModelAttribute PageVO pageVO,
					 HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");

		MemberDto memberDto = memberDao.selectOne(loginId);
		model.addAttribute("memberDto", memberDto);
		
		int count = reviewDao.count(pageVO);
		pageVO.setCount(count);
		
		List<ReviewDto> list = reviewDao.selectListByPaging(pageVO);
		model.addAttribute("list", list); 
		
		return "/WEB-INF/views/board/review/list.jsp";
	}
	

	//상품번호를 전달하면 파일번호를 찾아서 리다이렉트하는 페이지
	@RequestMapping("/image")
	public String image(@RequestParam int reviewNo) {
		try {
			int imgNo = reviewDao.findImgNo(reviewNo);
			return "redirect:/download?imgNo="+imgNo;
		}
		catch(Exception e) {
			//기본이미지로
			return "redirect:https://via.placeholder.com/100x100?text=NO IMAGE";
		}
	}
	
	@RequestMapping("/detail")
	public String detail(@RequestParam int reviewNo, Model model) {
		
		ReviewDto reviewDto = reviewDao.selectOne(reviewNo);
		model.addAttribute("reviewDto", reviewDto);
		//조회한 게시글 정보에 있는 회원 아이디로 작성자 정보를 불러와서 첨부
		if(reviewDto.getReviewWriter() != null) {//작성자가 탈퇴하지 않았다면
			MemberDto memberDto = memberDao.selectOne(reviewDto.getReviewWriter());
			model.addAttribute("reviewDto", reviewDto);
		}
		return "/WEB-INF/views/board/review/detail.jsp";
	}
	
	
	//수정
	@GetMapping("/edit") 
	public String edit(@RequestParam int reviewNo, Model model) {
		ReviewDto reviewDto = reviewDao.selectOne(reviewNo);
		model.addAttribute("reviewDto", reviewDto);
		return "/WEB-INF/views/board/review/edit.jsp";
	}
	
	@PostMapping("/edit")
	public String edit(@ModelAttribute ReviewDto reviewDto) {
		//기존 글 조회하여 수정 전 이미지 그룹을 조사
		Set<Integer> before = new HashSet<>();
		ReviewDto findDto = reviewDao.selectOne(reviewDto.getReviewNo());
		Document doc = Jsoup.parse(findDto.getReviewContent()); //해석
		for(Element el : doc.select(".server-img")) {
			String key = el.attr("data-key"); //data-key 추출
			int attachNo = Integer.parseInt(key); //숫자로 변환
			before.add(attachNo); //저장
		}
		//수정한 글 조사하여 수정 후 이미지 그룹을 조사
		Set<Integer> after = new HashSet<>();
		Document doc2 = Jsoup.parse(reviewDto.getReviewContent()); //해석
		for(Element el : doc2.select(".server-img")) {
			String key = el.attr("data-key");
			int attachNo = Integer.parseInt(key); //숫자로 변환
			after.add(attachNo); //저장
		}
		
		//before에만 있는 번호를 찾아서 모두 삭제
		before.removeAll(after);
		
		//before에 남은 번호에 이미지를 모두 삭제
		for(int attachNo : before) {
			imgService.removeFile(attachNo);
		}
		
		reviewDao.update(reviewDto);
		return "redirect:detail?reviewNo=" + reviewDto.getReviewNo();
	}
	
	
	//삭제
	@RequestMapping("/delete")
	public String delete(@RequestParam int reviewNo) {
		ReviewDto reviewDto = reviewDao.selectOne(reviewNo);
		
		//Jsoup으로 내용을 탐색하는 과정
		Document document = Jsoup.parse(reviewDto.getReviewContent());
		Elements elements = document.select(".server-img"); 
		for(Element element : elements) {//반복문으로 한개씩 처리
			String key = element.attr("data-key"); //data-key 속성을 읽어라!
			int attachNo = Integer.parseInt(key); //숫자로 변환
			imgService.removeFile(attachNo); //파일삭제 + DB삭제
		}
		
		reviewDao.delete(reviewNo);

		return "redirect:/board/review/list";
	}
}
