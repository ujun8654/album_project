package com.example.demo.dto;

import lombok.Data;

@Data
public class ResultData<DT> {
	private String rsCode;
	private String rsMsg;
	private DT rsData;
	
	public static <DT> ResultData<DT> from(String rsCode, String rsMsg) {
		return from(rsCode, rsMsg, null);
	}
	
	public static <DT> ResultData<DT> from(String rsCode, String rsMsg, DT rsData) {
		ResultData<DT> rd = new ResultData<>();
		
		rd.rsCode = rsCode;
		rd.rsMsg = rsMsg;
		rd.rsData = rsData;
		
		return rd;
	}
	
	public boolean isSuccess() {
		return this.rsCode.startsWith("S-");
	}
	
	public boolean isFail() {
		return this.isSuccess() == false;
	}
}
