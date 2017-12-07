package com.bingo.crud.test;

import java.util.HashMap;
import java.util.Map;

public class TEST {
	public static void main(String[] args) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("u-10", "1234");
		map.put("test1", "test1");
		map.put("test11", "test11");
		map.put("u-99", "13435");
		map.put("test13", "test13");
		System.out.println(map);
		
		String keys = "";
		for(Map.Entry<String, String> entry:map.entrySet()){
			if(entry.getKey().contains("u-")){
				int index = entry.getKey().indexOf("-");
				String temp = entry.getKey().substring(index+1);
				keys += temp+",";
			}
		}
		keys = keys.substring(0,keys.lastIndexOf(","));
		System.out.println(keys);
	}
}
