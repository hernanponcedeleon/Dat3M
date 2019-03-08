package com.dat3m.ui.option;

import com.dat3m.dartagnan.program.utils.Alias;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.ui.utils.Task;

public class Option {

	private final Task task;
	private final Arch target;
	private final Arch source;
	private final Mode mode;
	private final Alias alias;
	private final int bound;

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

	public Arch getTarget() {
		return target;
	}

	public Arch getSource() {
		return source;
	}

	public Mode getMode() {
		return mode;
	}

	public Alias getAlias() {
		return alias;
	}

	public int getBound() {
		return bound;
	}

	// TODO: Implementation
	public boolean validate(){
		boolean somethingIsWrong = false;
		if(somethingIsWrong){
			// TODO: Show alert with what is wrong
			return false;
		}
	    return true;
    }
}
