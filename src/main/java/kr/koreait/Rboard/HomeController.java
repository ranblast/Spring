package kr.koreait.Rboard;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.koreait.DAO.RboardCommentDAO;
import kr.koreait.DAO.RboardDAO;
import kr.koreait.VO.RBoardCommentList;
import kr.koreait.VO.RBoardCommentVO;
import kr.koreait.VO.RBoardList;
import kr.koreait.VO.RBoardVO;


@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	@Autowired
	private SqlSession sqlSession;
	
	AbstractApplicationContext ctx = new GenericXmlApplicationContext("classpath:applicationCTX.xml");
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
	
	@RequestMapping("/insertform")
	public String insertform(HttpServletRequest request, Model model) {
		
		return "insertform";
	}
	
	@RequestMapping("/insertOK")
	public String insertOK(HttpServletRequest request, Model model) {
		
		/*model.addAttribute("request", request);		
		service = ctx.getBean("insert", InsertService.class);
		service.execute(model);*/
		
		String name = request.getParameter("name");
		String password = request.getParameter("password");
		String title = request.getParameter("title");
		String content = request.getParameter("content");
//		mybatis를 사용하기위해 맵퍼에 dao를 추가해준다.
		RboardDAO rboardDAO = sqlSession.getMapper(RboardDAO.class);
//		mybatisdao.insert(name, subject, content);
		RBoardVO vo = ctx.getBean("vo", RBoardVO.class);
		vo.setName(name);
		vo.setPassword(password);
		vo.settitle(title);
		vo.setContent(content);
		vo.setIp(request.getRemoteAddr());		
		vo.setWdate(sdf.format(new Date()));
		rboardDAO.insert(vo);
//		mybatisdao.insert(new MvcBoardVO(name, subject, content));
		return "redirect:list";
	}
	
	@RequestMapping("/list")
	public String list(HttpServletRequest request, Model model) {
		
		RboardDAO rboardDAO = sqlSession.getMapper(RboardDAO.class);
		int pageSize = 10;
		String t = request.getParameter("currentPage");
		int currentPage = 1;
		
		if(t != null && !t.equals("") && t.trim().length() != 0) {
			try {
				currentPage = Integer.parseInt(t);
			} catch(Exception e) { }
		}
		int totalCount = rboardDAO.selectCount();
		
		
		RBoardList list = ctx.getBean("list", RBoardList.class);
		RboardCommentDAO commentDAO = sqlSession.getMapper(RboardCommentDAO.class);
		list = new RBoardList(pageSize, totalCount, currentPage);
		HashMap<String, Integer> hmap = new HashMap<>();
		hmap.put("startNo", list.getStartNo());
		hmap.put("endNo", list.getEndNo());
		list.setList(rboardDAO.selectList(hmap));
		for(RBoardVO vo : list.getList()) {
			vo.setCount(commentDAO.commentCount(vo.getIdx()));
		}
		model.addAttribute("list", list);
		model.addAttribute("currentPage", currentPage);
		return "list";		
	}
	
	@RequestMapping("/increment")
	public String increment(HttpServletRequest request, Model model) {
		model.addAttribute("request", request);
		int currentpage = Integer.parseInt(request.getParameter("currentPage"));
		int idx = Integer.parseInt(request.getParameter("idx"));
		RboardDAO rboardDAO = sqlSession.getMapper(RboardDAO.class);
		rboardDAO.increment(idx);
		
		model.addAttribute("idx", idx);
		model.addAttribute("currentPage", currentpage);
		return "redirect:view";
	}
	
	@RequestMapping("/view")
	public String view(HttpServletRequest request, Model model) {
		model.addAttribute("request", request);
		int idx = Integer.parseInt(request.getParameter("idx"));
		int currentpage = Integer.parseInt(request.getParameter("currentPage"));
		RboardDAO rboardDAO = sqlSession.getMapper(RboardDAO.class);
		RboardCommentDAO commentDAO = sqlSession.getMapper(RboardCommentDAO.class);
		RBoardVO vo = ctx.getBean("vo", RBoardVO.class);
		vo = rboardDAO.View(idx);
		RBoardCommentList commentList = ctx.getBean("commentlist", RBoardCommentList.class);
		commentList.setList(commentDAO.commentSelect(idx));
		model.addAttribute("vo", vo);
		model.addAttribute("comment", commentList);
		model.addAttribute("currentPage", currentpage);
		return "view";
	}
	
	@RequestMapping("/edit")
	public String edit(HttpServletRequest request, Model model) {
		model.addAttribute("request", request);
		int idx = Integer.parseInt(request.getParameter("idx"));
		int currentpage = Integer.parseInt(request.getParameter("currentPage"));
		RboardDAO rboardDAO = sqlSession.getMapper(RboardDAO.class);
		RBoardVO vo = ctx.getBean("vo", RBoardVO.class);
		vo = rboardDAO.View(idx);
		model.addAttribute("vo", vo);
		model.addAttribute("currentPage", currentpage);
		return "editok";
	}
	
	@RequestMapping("/editok")
	public String editok(HttpServletRequest request, Model model) {
		model.addAttribute("request", request);
		int idx = Integer.parseInt(request.getParameter("idx"));
		int currentpage = Integer.parseInt(request.getParameter("currentPage"));
		RboardDAO rboardDAO = sqlSession.getMapper(RboardDAO.class);
		RBoardVO vo = ctx.getBean("vo", RBoardVO.class);
		vo = rboardDAO.View(idx);
		model.addAttribute("vo", vo);
		model.addAttribute("currentPage", currentpage);
		return "redirect:list";
	}
	
//	게시글 한 건을 삭제하는 메소드
	@RequestMapping("/delete")
	public String delete(HttpServletRequest request, Model model) {
		model.addAttribute("request", request);
		int idx = Integer.parseInt(request.getParameter("idx"));
		int currentpage = Integer.parseInt(request.getParameter("currentPage"));
		RboardDAO rboardDAO = sqlSession.getMapper(RboardDAO.class);
		RBoardVO vo = ctx.getBean("vo", RBoardVO.class);
		vo = rboardDAO.View(idx);
		model.addAttribute("vo", vo);
		model.addAttribute("currentPage", currentpage);
		return "delete";
	}
	
	@RequestMapping("/deleteok")
	public String deleteok(HttpServletRequest request, Model model) {
		model.addAttribute("request", request);
		int idx = Integer.parseInt(request.getParameter("idx"));
		int currentpage = Integer.parseInt(request.getParameter("currentPage"));
		RboardDAO rboardDAO = sqlSession.getMapper(RboardDAO.class);
		rboardDAO.delete(idx);
		model.addAttribute("currentPage", currentpage);
		return "redirect:list";
	}
//	
////	게시글에 답글을 입력하는 메소드
	@RequestMapping("/reply")
	public String reply(HttpServletRequest request, Model model) {
		model.addAttribute("request", request);
		int idx = Integer.parseInt(request.getParameter("idx"));
		int currentpage = Integer.parseInt(request.getParameter("currentPage"));
		RboardDAO rboardDAO = sqlSession.getMapper(RboardDAO.class);
		RBoardVO vo = ctx.getBean("vo", RBoardVO.class);
		vo = rboardDAO.View(idx);
		model.addAttribute("vo", vo);
		model.addAttribute("currentPage", currentpage);
		return "reply";
	}
//	
////	답글을 저장하는 메소드
	@RequestMapping("/replyOK")
	public String replyOK(HttpServletRequest request, Model model) {
		model.addAttribute("request", request);
		int idx = Integer.parseInt(request.getParameter("idx"));
		int currentpage = Integer.parseInt(request.getParameter("currentPage"));
		String name = request.getParameter("name");
		String password = request.getParameter("password");
		String title = request.getParameter("title");
		String content = request.getParameter("content");
		RboardDAO rboardDAO = sqlSession.getMapper(RboardDAO.class);
		RBoardVO vo = ctx.getBean("vo", RBoardVO.class);
		vo = rboardDAO.View(idx);
		HashMap<String, Integer> hmap = new HashMap<>();
		hmap.put("ref", vo.getRef());
		hmap.put("seq", vo.getSeq());
		rboardDAO.replyIncrement(hmap);
		vo.setSeq(vo.getSeq() + 1);
		vo.setLev(vo.getLev() + 1);
		vo.setName(name);
		vo.setPassword(password);
		vo.settitle(title);
		vo.setContent(content);
		vo.setIp(request.getRemoteAddr());		
		vo.setWdate(sdf.format(new Date()));
		
		rboardDAO.replyInsert(vo);
		model.addAttribute("currentPage", currentpage);
		return "redirect:list";
	}
	
	@RequestMapping("/commentOK")
	public String commentOK(HttpServletRequest request, Model model) {
		model.addAttribute("request", request);
		int idx = Integer.parseInt(request.getParameter("idx"));
		int ref = Integer.parseInt(request.getParameter("ref"));
		int mode = Integer.parseInt(request.getParameter("mode"));
		System.out.println(idx);
		System.out.println(ref);
		int currentpage = Integer.parseInt(request.getParameter("currentPage"));
		String ip = request.getParameter("ip");
		String name = request.getParameter("name");
		String password = request.getParameter("password");
		String content = request.getParameter("content");
		RboardCommentDAO commentDAO = sqlSession.getMapper(RboardCommentDAO.class);
		RBoardCommentVO commentVO = ctx.getBean("commentvo", RBoardCommentVO.class);
		commentVO.setIdx(idx);
		commentVO.setRef(ref);
		commentVO.setIp(ip);
		commentVO.setWdate(sdf.format(new Date()));
		commentVO.setName(name);
		commentVO.setPassword(password);
		commentVO.setContent(content);
	
		switch (mode) {
		case 1:
			commentDAO.insertComment(commentVO);
			break;
			
		case 2:
			commentVO = commentDAO.commentByIdx(idx);
			commentDAO.commentUpdate(commentVO);
			break;
		
		case 3:
			commentVO = commentDAO.commentByIdx(idx);
			commentDAO.commentDelete(idx);
			break;
		}
		
		model.addAttribute("idx", ref);
		model.addAttribute("currentPage", currentpage);
		return "view";
	}
}
