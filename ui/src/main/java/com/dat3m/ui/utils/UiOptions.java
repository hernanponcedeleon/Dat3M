package com.dat3m.ui.utils;

import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Arch;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

public class UiOptions {

	private final Arch target;
	private final Method method;
	private final int bound;
	private final Solvers solver;
	private final int timeout;

	public UiOptions(Arch target, Method method, int bound, Solvers solver, int timeout) {
		this.target = target;
		this.method = method;
		this.bound = bound;
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

	public Solvers getSolver() {
		return solver;
	}

	public int getTimeout() {
		return timeout;
	}
}