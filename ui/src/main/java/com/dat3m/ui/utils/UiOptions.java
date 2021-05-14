package com.dat3m.ui.utils;

import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.ui.options.utils.Method;

public class UiOptions {

	private Arch target;
	private final Method method;
	private final Settings settings;


	public UiOptions(Arch target, Method method, Settings settings) {
		this.target = target;
		this.method = method;
		this.settings = settings;
	}
	
	public Arch getTarget(){
		return target;
	}

	public Method getMethod() {
		return method;
	}

	public Settings getSettings(){
		return settings;
	}
}
