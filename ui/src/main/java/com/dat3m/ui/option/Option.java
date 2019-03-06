package com.dat3m.ui.option;

import com.dat3m.dartagnan.program.utils.Alias;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.ui.utils.Task;

public class Option {

	private static Task task = Task.REACHABILITY;
	private static Arch target = Arch.NONE;
	private static Arch source = Arch.NONE;
	private static Mode mode = Mode.KNASTER;
	private static Alias alias = Alias.CFS;
	private static int bound = 1;

	public Option (Task task, Arch target, Arch source, Mode mode, Alias alias, int bound) {
		Option.task = task;
		Option.target = target;
		Option.source = source;
		Option.mode = mode;
		Option.alias = alias;
		Option.bound = bound;
	}
	
	public Task getTask() {
		return task;
	}
	
	public void setTask(Task task) {
		Option.task = task;
	}

	public Arch getTarget() {
		return target;
	}
	
	public void setTarget(Arch target) {
		Option.target = target;
	}

	public Arch getSource() {
		return source;
	}
	
	public void setSource(Arch source) {
		Option.source = source;
	}

	public Mode getMode() {
		return mode;
	}
	
	public void setMode(Mode mode) {
		Option.mode = mode;
	}

	public Alias getAlias() {
		return alias;
	}
	
	public void setAlias(Alias alias) {
		Option.alias = alias;
	}

	public int getBound() {
		return bound;
	}
	
	public void setBound(int bound) {
		Option.bound = bound;
	}
}
