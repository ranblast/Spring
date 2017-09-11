package kr.koreait.DAO;

import java.util.ArrayList;

import kr.koreait.VO.RBoardCommentVO;

public interface RboardCommentDAO {

	void insertComment(RBoardCommentVO commentVO);

	ArrayList<RBoardCommentVO> commentSelect(int idx);

	RBoardCommentVO commentByIdx(int idx);

	void commentUpdate(RBoardCommentVO commentVO);

	void commentDelete(int idx);

	int commentCount(int idx);
}
