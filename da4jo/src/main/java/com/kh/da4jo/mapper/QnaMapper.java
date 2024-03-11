package com.kh.da4jo.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;
import com.kh.da4jo.dto.QnaDto;

@Service
public class QnaMapper implements RowMapper<QnaDto>{

	@Override
	public QnaDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		QnaDto qnaDto = new QnaDto();
		qnaDto.setQnaNo(rs.getInt("qna_no"));
		qnaDto.setQnaSecreate(rs.getString("qna_secreat"));
		qnaDto.setQnaTitle(rs.getString("qna_title"));
		qnaDto.setQnaContent(rs.getString("qna_content"));
		qnaDto.setQnaWriter(rs.getString("qna_writer"));
		qnaDto.setQnaWdate(rs.getDate("qna_wdate"));
		qnaDto.setQnaVcount(rs.getInt("qna_vcount"));
		
		return qnaDto;
	}

}