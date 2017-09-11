package kr.koreait.DAO;

import java.util.ArrayList;
import java.util.HashMap;

import kr.koreait.VO.RBoardVO;

public interface RboardDAO {

	void insert(RBoardVO vo);

	ArrayList<RBoardVO> selectList(HashMap<String, Integer> hmap);
	
	void increment(int idx);
	
	RBoardVO View(int idx);
	
	void edit(RBoardVO vo);
	
	void delete(int idx);
	
	void replyIncrement(HashMap<String, Integer> hmap);
	
	void replyInsert(RBoardVO vo);

	int selectCount();

	


}
