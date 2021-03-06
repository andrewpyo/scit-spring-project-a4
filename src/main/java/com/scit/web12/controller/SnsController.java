package com.scit.web12.controller;

import java.util.ArrayList;
import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.scit.web12.service.SnsService;
import com.scit.web12.vo.BoardVO;

@RequestMapping(value="/sns")
@Controller
public class SnsController {
	private static final Logger logger = LoggerFactory.getLogger(SnsController.class);
	
	@Autowired
	private SnsService ss;

	@RequestMapping(value="/timeLine", method=RequestMethod.GET)
	public String timeLine(String member_id, Model model) {
		ArrayList<BoardVO> list = ss.boardList(member_id);
		model.addAttribute("list", list);
		System.out.println(list);
		
		return "sns/timeLine";
	}
	
	@RequestMapping(value="/infiniteScrollDown", method=RequestMethod.POST)
	public @ResponseBody ArrayList<BoardVO> infiniteScrollDownPOST(@RequestBody BoardVO boardVO){
		logger.info("infiniteScrollDownPOST is called......");
		int bnoToStart = boardVO.getBoard_no()-1;
		String bnoId = boardVO.getMember_id();
		System.out.println(boardVO);
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("bnoToStart", bnoToStart);
		map.put("bnoId", bnoId);
		return ss.infiniteScrollDown(map);
	}
	
	@RequestMapping(value="/infiniteScrollUp", method=RequestMethod.POST)
	public @ResponseBody ArrayList<BoardVO> infiniteScrollUpPOST(@RequestBody BoardVO boardVO){
		logger.info("infiniteScrollUpPOST is called......");
		int bnoToStart = boardVO.getBoard_no()+1;
		String bnoId = boardVO.getMember_id();
		System.out.println(boardVO);
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("bnoToStart", bnoToStart);
		map.put("bnoId", bnoId);
		return ss.infiniteScrollUp(map);
	}
	
	@ResponseBody
	@RequestMapping(value="/follow", method=RequestMethod.GET)
	public int follow(String msg) {
		System.out.println(msg);
		
		int follow_check = ss.follow(msg);
		System.out.println(follow_check);
		return 1;
	}
	
	@ResponseBody
	@RequestMapping(value="/followCancle", method=RequestMethod.GET)
	public int followCancle(String msg) {
		System.out.println(msg);
		int follow_check = ss.followCancle(msg);
		System.out.println(follow_check);
		return 0;
	}

}
