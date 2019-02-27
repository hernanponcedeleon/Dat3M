package com.dat3m.ui.utils;

import com.dat3m.dartagnan.program.utils.Alias;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;

public class Option {

	// All these are fields since they need to be updated by the listener
	private Task task = Task.REACHABILITY;
	private Arch target = Arch.NONE;
	private Arch source = Arch.NONE;
	private Mode mode = Mode.KNASTER;
	private Alias alias = Alias.CFS;
	private int bound = 1;

	public Option (Task task, Arch target, Arch source, Mode mode, Alias alias, int bound) {
		this.task = task;
		this.target = target;
		this.source = source;
		this.mode = mode;
		this.alias = alias;
		this.bound = bound;
	}
	
	public Task getTask() {
		return task;
	}
	
	public void setTak(Task task) {
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
