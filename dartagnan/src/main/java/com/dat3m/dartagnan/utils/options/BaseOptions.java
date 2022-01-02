package com.dat3m.dartagnan.utils.options;

import com.dat3m.dartagnan.analysis.Method;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

@Options
public abstract class BaseOptions {

	public static final String METHOD = "method";
	public static final String SOLVER = "solver";
	public static final String TIMEOUT = "timeout";

	@Option(
		name=METHOD,
		description="Solver method to be used",
		toUppercase=true)
	protected Method method = Method.getDefault();

	@Option(
		name=SOLVER,
		description="SMT library to be used",
		toUppercase=true)
	protected Solvers solver = Solvers.Z3;

	@Option(
		name=TIMEOUT,
		description="Number of seconds before interrupting the SMT solving")
	protected int timeout = 0;
}