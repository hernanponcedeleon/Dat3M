package com.dat3m.dartagnan.utils;

import com.microsoft.z3.Context;

public class EncodingConf {

	private Context ctx;
	private boolean bp;
	
	public EncodingConf(Context ctx, boolean bp) {
		this.ctx = ctx;
		this.bp = bp;
	}
	
	public Context getCtx() {
		return ctx;
	}
	
	public boolean getBP() {
		return bp;
	}
}
