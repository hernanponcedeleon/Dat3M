package com.dat3m.dartagnan.utils.options;

import com.dat3m.dartagnan.analysis.SolverTypes;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.google.common.collect.ImmutableSet;

import static com.dat3m.dartagnan.analysis.SolverTypes.INCREMENTAL;
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

public abstract class BaseOptions extends Options {

	public static final String SOLVER_OPTION = "solver";
	public static final String SMTSOLVER_OPTION = "smt_solver";

    protected String programFilePath;
    protected String targetModelFilePath;
    protected Set<String> supportedFormats; 
    protected Settings settings;
    protected Arch target;

    protected  SolverTypes solver;
    protected  Solvers smtsolver;

    private Set<SolverTypes> supported_solvers = ImmutableSet.copyOf(Arrays.asList(SolverTypes.values()));

    public BaseOptions(){
        super();
        Option inputOption = new Option("i", "input", true,
                "Path to the file with input program");
        inputOption.setRequired(true);
        addOption(inputOption);

        addOption(new Option("t", "target", true,
                "Target architecture {none|arm|arm8|power|tso}"));

        addOption(new Option("alias", true,
                "Type of alias analysis {none|andersen|cfs}"));

        addOption(new Option("u", "unroll", true,
                "Unrolling bound <integer>"));

        addOption(new Option("solver_timeout", true,
                "Timeout (in secs) for the SMT solver"));
        
        addOption(new Option(SOLVER_OPTION, true,
        		"The solver method to be used: two (default), incremental, assume"));
        
        addOption(new Option(SMTSOLVER_OPTION, true,
        		"The SMT solver to be used: z3 (default), mathsat5, smtinterpol, princess, boolector, cvc4, yices2"));
    }

    public void parse(String[] args) throws ParseException, RuntimeException {
        CommandLine cmd = new DefaultParser().parse(this, args);
        parseSettings(cmd);

        programFilePath = cmd.getOptionValue("input");
        targetModelFilePath = cmd.getOptionValue("cat");

        if(cmd.hasOption("target")) {
            target = Arch.get(cmd.getOptionValue("target"));
        }
        
        solver = cmd.hasOption(SOLVER_OPTION) ? SolverTypes.fromString(cmd.getOptionValue(SOLVER_OPTION)) : INCREMENTAL;
        if(!supported_solvers.contains(solver)) {
            throw new UnsupportedOperationException("Unrecognized solver method: " + solver);        		
        }

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
    }

    public SolverTypes getSolver(){
        return solver;
    }

    public Solvers getSMTSolver(){
        return smtsolver;
    }

    public String getProgramFilePath() {
        return programFilePath;
    }

    public String getTargetModelFilePath(){
        return targetModelFilePath;
    }

    public Settings getSettings(){
        return settings;
    }

    public Arch getTarget(){
        return target;
    }

    protected void parseSettings(CommandLine cmd){
        Alias alias = cmd.hasOption("alias") ? Alias.get(cmd.getOptionValue("alias")) : null;

        int bound = 1;
        int solver_timeout = 0;
        if(cmd.hasOption("unroll")){
            try {
                bound = Math.max(1, Integer.parseInt(cmd.getOptionValue("unroll")));
            } catch (NumberFormatException e){
                throw new UnsupportedOperationException("Illegal unroll value");
            }
        }
        if(cmd.hasOption("solver_timeout")){
            try {
            	solver_timeout = Math.max(1, Integer.parseInt(cmd.getOptionValue("solver_timeout")));
            } catch (NumberFormatException e){
                throw new UnsupportedOperationException("Illegal solver_timeout value");
            }
        }
        settings = new Settings(alias, bound, solver_timeout);
    }
}
