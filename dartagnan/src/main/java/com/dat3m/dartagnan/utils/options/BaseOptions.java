package com.dat3m.dartagnan.utils.options;

import com.dat3m.dartagnan.analysis.Analysis;
import com.dat3m.dartagnan.analysis.Method;

import static com.dat3m.dartagnan.configuration.OptionNames.*;

import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

@Options
public abstract class BaseOptions {

	@Option(
		name=ANALYSIS,
		description="Analysis to be performed.",
		secure=true,
		toUppercase=true)
	protected Analysis analysis = Analysis.getDefault();

	@Option(
		name=VALIDATE,
		description="Run Dartagnan as a violation witness validator. Argument is the path to the witness file.")
	protected String witnessPath;

	@Option(
		name=METHOD,
		description="Solver method to be used",
		toUppercase=true)
	protected Method method = Method.getDefault();

	@Option(
		name=SOLVER,
		description="SMT solver to be used",
		toUppercase=true)
	protected Solvers solver = Solvers.Z3;

	@Option(
		name=TIMEOUT,
		description="Number of seconds before interrupting the SMT solving")
	protected int timeout = 0;
}