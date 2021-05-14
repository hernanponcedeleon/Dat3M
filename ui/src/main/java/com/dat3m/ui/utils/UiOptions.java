package com.dat3m.ui.utils;

import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.ui.options.utils.Method;
import com.dat3m.ui.options.utils.Task;

public class UiOptions {

	private final Task task;
	private Arch source;
	private Arch target;
	private final Method method;
	private final Settings settings;


	public UiOptions(Task task, Arch source, Arch target, Method method, Settings settings) {
		this.task = task;
		this.source = source;
		this.target = target;
		this.method = method;
		this.settings = settings;
	}
	
	public Task getTask() {
		return task;
	}

	public Arch getSource(){
		return source;
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

	public boolean validate(){
		if(task == Task.PORTABILITY && source == null){
			Utils.showError("Source settings must be specified for portability analysis");
			return false;
		}
		return true;
	}
}
