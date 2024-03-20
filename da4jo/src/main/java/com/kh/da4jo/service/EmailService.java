package com.kh.da4jo.service;

import java.text.DecimalFormat;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import com.kh.da4jo.dao.CertDao;
import com.kh.da4jo.dao.MemberDao;
import com.kh.da4jo.dto.CertDto;
import com.kh.da4jo.dto.MemberDto;

@Service
public class EmailService {
	
	@Autowired
	private JavaMailSender sender;
	@Autowired
	private MemberDao memberDao;
	@Autowired
	private CertDao certDao;
	//웰컴 메일 발송
	public void welcomSendMail(String email) {
		SimpleMailMessage message = new SimpleMailMessage();
		message.setTo(email);//받는 사람
		message.setSubject("[다사조] WELCOME!!");//제목
		message.setText("다 사줘~~~");//내용
		
		sender.send(message);//보내기
	}
	
	//아이디 찾기
	public boolean sendMemberId(String memberEmail) {
		MemberDto memberDto = memberDao.selectEmail(memberEmail);
		
		if(memberDto != null) {//존재하는 이메일
			SimpleMailMessage message = new SimpleMailMessage();
			message.setTo(memberDto.getMemberEmail());//받는 사람(분실자)
			message.setSubject("[다사조] 아이디 찾기 ");//제목
			message.setText(memberDto.getMemberNameKor()+"님의 아이디는 [" 
																+ memberDto.getMemberId()+"] 입니다.");
			sender.send(message);
			return true;
		}
		else {//존재하지 않는 이메일
			return false;		
		}
	}
	//임시 비밀번호 발송
	public void sendTempPassword(MemberDto memberDto) {
		String lower = "abcdefghijklmnopqrstuvwxyz";//3글자
		String upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";//3글자
		String number = "0123456789";//1글자
		String special = "!@#$%^&*";//1글자
		
		Random r = new Random();//랜덤 도구
		StringBuffer buffer = new StringBuffer();//문자열 합성 도구
		
		for(int i=0; i<3; i++) {//lower 3개 추출
			int pos = r.nextInt(lower.length())+0;//lower에서의 랜덤 위치
			buffer.append(lower.charAt(pos));//버퍼에 추가
		}
		for(int i=0; i<3; i++) {//upper 3개 추출
			int pos = r.nextInt(upper.length())+0;//upper에서의 랜덤 위치
			buffer.append(upper.charAt(pos));//버퍼에 추가
		}
		for(int i=0; i<1; i++) {//number 1개 추출
			int pos = r.nextInt(number.length())+0;//number에서의 랜덤 위치
			buffer.append(number.charAt(pos));//버퍼에 추가
		}
		for(int i=0; i<1; i++) {//special 1개 추출
			int pos = r.nextInt(special.length())+0;//special에서의 랜덤 위치
			buffer.append(special.charAt(pos));//버퍼에 추가
		}
		//생성한 비밀번호로 DB를 변경
		memberDto.setMemberPw(buffer.toString());//비밀번호 설정 후
		memberDao.updateMemberPw(memberDto);//변경 처리
		
		//이메일 발송
		SimpleMailMessage message = new SimpleMailMessage();
		message.setTo(memberDto.getMemberEmail());
		message.setSubject("[다사조] 임시 비밀번호 안내");
		message.setText("임시 비밀번호는 "+memberDto.getMemberPw()+"입니다.");
		
		sender.send(message);
		}
		
	//인증번호 발송 - 주어진 이메일에 무작위 6자리 숫자를 전송
	public void sendCert(String memberEmail) {
		Random r = new Random();
		int number = r.nextInt(1000000);// 000000 ~ 999999
		DecimalFormat fmt = new DecimalFormat("000000");

		//메일 발송
		SimpleMailMessage message = new SimpleMailMessage();
		message.setTo(memberEmail);
		message.setSubject("[다사조] 회원가입 인증번호");
		message.setText("인증번호는 [" + fmt.format(number) + "] 입니다.");
		
		sender.send(message);
		
		//인증번호 저장 - 기존 내역 삭제 후 저장
		certDao.delete(memberEmail);
		CertDto certDto = new CertDto();
		certDto.setCertEmail(memberEmail);
		certDto.setCertNumber(fmt.format(number));
		certDao.insert(certDto);
	}
	
	//캐시 충전 승인 완료 후 이메일 발송
	public boolean sendApprove(String memberEmail) {
		MemberDto memberDto = memberDao.selectEmail(memberEmail);
		
		if(memberDto != null) {//존재하는 이메일
			SimpleMailMessage message = new SimpleMailMessage();
			message.setTo(memberDto.getMemberEmail());//받는 사람(분실자)
			message.setSubject("[다사조] 캐시 충전 완료 ");//제목
			message.setText(memberDto.getMemberNameKor()+"님의 캐시가 충전완료 되었습니다. "
					+ "\n 현재 캐시는 "+ memberDto.getMemberCredit() +"원 입니다.");
			sender.send(message);
			return true;
		}
		else {//존재하지 않는 이메일
			return false;		
		}
	}
	
}






