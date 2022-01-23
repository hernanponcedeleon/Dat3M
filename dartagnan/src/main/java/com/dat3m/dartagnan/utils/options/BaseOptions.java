package com.dat3m.dartagnan.utils.options;

import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import static com.dat3m.dartagnan.configuration.OptionNames.*;

@Options
public abstract class BaseOptions {

	@Option(
		name= PROPERTY,
		description="Property to be checked.",
		secure=true,
		toUppercase=true)
	private Property property = Property.getDefault();

	public Property getProperty() { return property; }

	@Option(
		name=VALIDATE,
		description="Performs violation witness validation. Argument is the path to the witness file.")
	private String witnessPath;

	public boolean runValidator() { return witnessPath != null; }
	public String getWitnessPath() { return witnessPath; }

	@Option(
		name=METHOD,
		description="Solver method to be used.",
		toUppercase=true)
	private Method method = Method.getDefault();

	public Method getMethod() { return method; }

	@Option(
		name=SOLVER,
		description="Uses the specified SMT solver as a backend.",
		toUppercase=true)
	private Solvers solver = Solvers.Z3;

	public Solvers getSolver() { return solver; }
	
	@Option(
		name=TIMEOUT,
		description="Timeout (in secs) before interrupting the SMT solver.")
	private int timeout = 0;
	
	public boolean hasTimeout() { return timeout > 0; }
	public int getTimeout() { return timeout;}

	@Option(
		name=PHANTOM_REFERENCES,
		description="Decrease references on Z3 formula objects once they are no longer referenced.")
	private boolean phantomReferences = true;
	
	public boolean usePhantomReferences() { return phantomReferences; }
}