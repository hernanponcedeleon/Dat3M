package com.dat3m.ui.utils;

import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import com.dat3m.dartagnan.analysis.Method;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.Arch;

public class UiOptions {

	private Arch target;
	private final Method method;
	private final Solvers solver;
	private final Settings settings;


	public UiOptions(Arch target, Method method, Solvers solver, Settings settings) {
		this.target = target;
		this.method = method;
		this.solver = solver;
		this.settings = settings;
	}
	
	public Arch getTarget(){
		return target;
	}

	public Method getMethod() {
		return method;
	}

	public Solvers getSolver() {
		return solver;
	}

	public Settings getSettings(){
		return settings;
	}
}
