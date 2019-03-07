package com.dat3m.ui.option;

import com.dat3m.dartagnan.program.utils.Alias;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.ui.utils.Task;

public class Option {

	private Task task;
	private Arch target;
	private Arch source;
	private Mode mode;
	private Alias alias;
	private int bound;

	public Option (Task task, Arch target, Arch source, Mode mode, Alias alias, int bound) {
		this.task = task;
		this.source = source;
		this.target = target;
		this.mode = mode;
		this.alias = alias;
		this.bound = bound;
	}
	
	public Task getTask() {
		return task;
	}
	
	public void setTask(Task task) {
		this.task = task;
	}

	public Arch getTarget() {
		return target;
	}
	
	public void setTarget(Arch target) {
		this.target = target;
	}

	public Arch getSource() {
		return source;
	}
	
	public void setSource(Arch source) {
		this.source = source;
	}

	public Mode getMode() {
		return mode;
	}
	
	public void setMode(Mode mode) {
		this.mode = mode;
	}

	public Alias getAlias() {
		return alias;
	}
	
	public void setAlias(Alias alias) {
		this.alias = alias;
	}

	public int getBound() {
		return bound;
	}
	
	public void setBound(int bound) {
		this.bound = bound;
	}
}
