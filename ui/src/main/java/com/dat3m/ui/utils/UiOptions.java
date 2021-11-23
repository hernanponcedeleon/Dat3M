package com.dat3m.ui.utils;

import com.dat3m.dartagnan.analysis.Method;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

public class UiOptions {

	private final Arch target;
	private final Method method;
	private final int bound;
	private final Alias alias;
	private final Solvers solver;
	private final int timeout;

	public UiOptions(Arch target, Method method, int bound, Alias alias, Solvers solver, int timeout) {
		this.target = target;
		this.method = method;
		this.bound = bound;
		this.alias = alias;
		this.solver = solver;
		this.timeout = timeout;
	}
	
	public Arch getTarget(){
		return target;
	}

	public Method getMethod() {
		return method;
	}

	public int getBound() {
		return bound;
	}

	public Alias getAlias() {
		return alias;
	}

	public Solvers getSolver() {
		return solver;
	}

	public int getTimeout() {
		return timeout;
	}
}
