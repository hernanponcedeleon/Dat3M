package com.dat3m.ui.options.utils;

import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.dat3m.ui.utils.Utils;
import com.google.common.collect.ImmutableSet;

import java.util.Collection;

public class Options {

	private final Task task;
	private final Arch target;
	private final Arch source;
	private final Mode mode;
	private final Alias alias;
	private final int bound;
	private final boolean drawGraph;
	private final ImmutableSet<String> relations;

	public Options(Task task, Arch target, Arch source, Mode mode, Alias alias, int bound,
			boolean drawGraph, Collection<String> relations) {
		this.task = task;
		this.source = source;
		this.target = target;
		this.mode = mode;
		this.alias = alias;
		this.bound = bound;
		this.drawGraph = drawGraph;
		this.relations = relations == null ? ImmutableSet.of() : ImmutableSet.copyOf(relations);
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

	public boolean getDrawGraph(){
		return drawGraph;
	}

	public ImmutableSet<String> getRelations(){
		return relations;
	}

	public boolean validate(){
		if(drawGraph && mode.equals(Mode.KNASTER)){
			Utils.showError("Execution graph is not available in Knaster-Tarski encoding mode");
			return false;
		}
		return true;
	}
}
