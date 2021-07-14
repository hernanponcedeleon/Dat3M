package com.dat3m.dartagnan.utils.options;

import static com.dat3m.dartagnan.analysis.AnalysisTypes.REACHABILITY;
import static com.dat3m.dartagnan.analysis.SolverTypes.TWO;
import static org.sosy_lab.java_smt.SolverContextFactory.Solvers.BOOLECTOR;
import static org.sosy_lab.java_smt.SolverContextFactory.Solvers.CVC4;
import static org.sosy_lab.java_smt.SolverContextFactory.Solvers.MATHSAT5;
import static org.sosy_lab.java_smt.SolverContextFactory.Solvers.PRINCESS;
import static org.sosy_lab.java_smt.SolverContextFactory.Solvers.SMTINTERPOL;
import static org.sosy_lab.java_smt.SolverContextFactory.Solvers.YICES2;
import static org.sosy_lab.java_smt.SolverContextFactory.Solvers.Z3;

import java.util.Arrays;
import java.util.Set;

import org.apache.commons.cli.*;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import com.dat3m.dartagnan.analysis.AnalysisTypes;
import com.dat3m.dartagnan.analysis.SolverTypes;
import com.google.common.collect.ImmutableSet;

public class DartagnanOptions extends BaseOptions {

	public static final String ANALYSIS_OPTION = "analysis";
	public static final String SOLVER_OPTION = "solver";
	public static final String SMTSOLVER_OPTION = "smt_solver";
	public static final String WITNESS_OPTION = "create_witness";
	public static final String WITNESS_PATH_OPTION = "witness";

    private Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("litmus", "bpl", "c"));
    private Set<AnalysisTypes> supportedAnalyses = ImmutableSet.copyOf(AnalysisTypes.values());
    private Set<SolverTypes> supportedSolvers = ImmutableSet.copyOf(SolverTypes.values());
    private AnalysisTypes analysis;
	private SolverTypes solver;
    private String witness;
    private String witnessFilePath;
    private Solvers smtsolver;

    public DartagnanOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        addOption(new Option(SOLVER_OPTION, true,
        		"The solver method to be used: two (default), incremental, assume"));
        
        addOption(new Option(SMTSOLVER_OPTION, true,
        		"The SMT solver to be used: z3 (default), mathsat5, smtinterpol, princess, boolector, cvc4, yices2"));
        
        addOption(new Option("w", WITNESS_OPTION, true,
                "Creates a machine readable witness. The argument is the original *.c file from which the Boogie code was generated."));

        addOption(new Option("a", ANALYSIS_OPTION, true,
        		"The analysis to be performed: reachability (default), data-race detection"));
        
        addOption(new Option(WITNESS_PATH_OPTION, true,
        		"Path to the machine readable witness file"));
        }
    
    public void parse(String[] args) throws ParseException, RuntimeException {
    	super.parse(args);
        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }
        CommandLine cmd = new DefaultParser().parse(this, args);

        solver = cmd.hasOption(SOLVER_OPTION) ? SolverTypes.fromString(cmd.getOptionValue(SOLVER_OPTION)) : TWO;
        
        smtsolver = Z3;
        if(cmd.hasOption(SMTSOLVER_OPTION)) {
    		switch(cmd.getOptionValue(SMTSOLVER_OPTION)) {
			case "mathsat5":
				smtsolver = MATHSAT5;
				break;
			case "smtinterpol":
				smtsolver = SMTINTERPOL;
				break;
			case "princess":
				smtsolver = PRINCESS;
				break;
			case "boolector":
				smtsolver = BOOLECTOR;
				break;
			case "cvc4":
				smtsolver = CVC4;
				break;
			case "yices2":
				smtsolver = YICES2;
				break;
    		}        	
        }
        if(!supportedSolvers.contains(solver)) {
        	throw new RuntimeException("Unrecognized solver method: " + solver);
        }

        analysis = cmd.hasOption(ANALYSIS_OPTION) ? AnalysisTypes.fromString(cmd.getOptionValue(ANALYSIS_OPTION)) : REACHABILITY;
        if(!supportedAnalyses.contains(analysis)) {
        	throw new RuntimeException("Unrecognized analysis: " + analysis);
        }

        witness = cmd.hasOption(WITNESS_OPTION) ? cmd.getOptionValue(WITNESS_OPTION) : null;
        witnessFilePath = cmd.hasOption(WITNESS_PATH_OPTION) ? cmd.getOptionValue(WITNESS_PATH_OPTION) : null;
    }
    
    public SolverTypes solver(){
        return solver;
    }

    public Solvers getSMTSolver(){
        return smtsolver;
    }

    public AnalysisTypes getAnalysis(){
		return analysis;
    }

    public String createWitness(){
        return witness;
    }

    public String getWitnessPath() {
        return witnessFilePath;
    }
}
