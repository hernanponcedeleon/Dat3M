package com.dat3m.dartagnan.utils.options;

import com.dat3m.dartagnan.verification.analysis.Analysis;
import com.dat3m.dartagnan.verification.analysis.Method;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import static com.dat3m.dartagnan.configuration.OptionNames.*;

@Options
public abstract class BaseOptions {

	@Option(
		name=ANALYSIS,
		description="Analysis to be performed.",
		secure=true,
		toUppercase=true)
	private Analysis analysis = Analysis.getDefault();

	public Analysis getAnalysis() { return analysis; }

	@Option(
		name=VALIDATE,
		description="Run Dartagnan as a violation witness validator. Argument is the path to the witness file.")
	private String witnessPath;

	public boolean runValidator() { return witnessPath != null; }
	public String getWitnessPath() { return witnessPath; }

	@Option(
		name=METHOD,
		description="Solver method to be used",
		toUppercase=true)
	private Method method = Method.getDefault();

	public Method getMethod() { return method; }

	@Option(
		name=SOLVER,
		description="SMT solver to be used",
		toUppercase=true)
	private Solvers solver = Solvers.Z3;

	public Solvers getSolver() { return solver; }
	
	@Option(
		name=TIMEOUT,
		description="Number of seconds before interrupting the SMT solving")
	private int timeout = 0;
	
	public boolean hasTimeout() { return timeout > 0; }
	public int getTimeout() { return timeout;}

	@Option(
		name=PHANTOM_REFERENCES,
		description="Decrease references on Z3 formula objects once they are no longer referenced.")
	private boolean phantomReferences = true;
	
	public boolean usePhantomReferences() { return phantomReferences; }
}