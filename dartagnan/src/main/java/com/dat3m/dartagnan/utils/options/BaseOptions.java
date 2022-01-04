package com.dat3m.dartagnan.utils.options;

import com.dat3m.dartagnan.analysis.Method;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;
import org.apache.commons.cli.*;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import java.util.Arrays;
import java.util.Comparator;
import java.util.Set;
import java.util.stream.Collectors;

import static org.sosy_lab.java_smt.SolverContextFactory.Solvers.*;

public abstract class BaseOptions extends Options {
	
	public static final String INPUT_OPTION = "input";
	public static final String CAT_OPTION = "cat";
	public static final String TARGET_OPTION = "target";
	public static final String UNROLL_OPTION = "unroll";
	public static final String METHOD_OPTION = "method";
	public static final String SMTSOLVER_OPTION = "solver";
	public static final String SMTSOLVER_TIMEOUT_OPTION = "timeout";
	
    protected String programFilePath;
    protected String targetModelFilePath;
    protected Settings settings;
    protected Arch target;
    protected Method method;
    protected Solvers smtsolver;

    private final Set<String> supported_methods =
    		ImmutableSet.copyOf(Arrays.stream(Method.values())
            .sorted(Comparator.comparing(Method::toString))
            .map(Method::asStringOption)
    		.collect(Collectors.toList()));

    private final Set<String> supportedTargets =
    		ImmutableSet.copyOf(Arrays.stream(Arch.values())
    		.map(a -> a.toString().toLowerCase())
            .sorted(Comparator.comparing(String::toString))
    		.collect(Collectors.toList()));
    		
    protected BaseOptions(){
        super();
        
        Option inputOption = new Option("i", INPUT_OPTION, true,
                "Path to the file with input program");
        inputOption.setRequired(true);
        addOption(inputOption);

        Option catOption = new Option(CAT_OPTION, true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        addOption(new Option("t", TARGET_OPTION, true,
                "Target architecture: " + supportedTargets));

        addOption(new Option("u", UNROLL_OPTION, true,
                "Unrolling bound <integer>"));

        addOption(new Option(SMTSOLVER_TIMEOUT_OPTION, true,
                "Timeout (in secs) for the SMT solver"));
        
        addOption(new Option(METHOD_OPTION, true,
        		"The solver method to be used: " + supported_methods));
        
        Set<String> supported_smtsolvers =
        		ImmutableSet.copyOf(Arrays.stream(values())
        		.map(a -> a.toString().toLowerCase())
                .sorted(Comparator.comparing(String::toString))
        		.collect(Collectors.toList()));
        addOption(new Option(SMTSOLVER_OPTION, true,
        		"The SMT solver to be used: " + supported_smtsolvers));
    }

    protected void parse(String[] args) throws ParseException {
        CommandLine cmd = new DefaultParser().parse(this, args);
        parseSettings(cmd);

        programFilePath = cmd.getOptionValue(INPUT_OPTION);
        targetModelFilePath = cmd.getOptionValue(CAT_OPTION);
        target = Arch.get(cmd.getOptionValue(TARGET_OPTION, Arch.getDefault().asStringOption()));
        method = Method.get(cmd.getOptionValue(METHOD_OPTION, Method.getDefault().asStringOption()));

        String solverString = cmd.getOptionValue(SMTSOLVER_OPTION, "unspecified");
        switch (solverString) {
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
            case "z3":
            case "unspecified":
                smtsolver = Z3;
                break;
            default:
                throw new UnsupportedOperationException("Unrecognized SMT solver: " + solverString);
        }
    }

    public Method getMethod(){
        return method;
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
        int bound = 1;
        int solver_timeout = 0;
        if(cmd.hasOption(UNROLL_OPTION)){
            try {
                bound = Math.max(1, Integer.parseInt(cmd.getOptionValue(UNROLL_OPTION)));
            } catch (NumberFormatException e){
                throw new IllegalArgumentException("Illegal unroll value");
            }
        }
        if(cmd.hasOption(SMTSOLVER_TIMEOUT_OPTION)){
            try {
            	solver_timeout = Math.max(1, Integer.parseInt(cmd.getOptionValue(SMTSOLVER_TIMEOUT_OPTION)));
            } catch (NumberFormatException e){
                throw new IllegalArgumentException("Illegal solver_timeout value");
            }
        }
        settings = new Settings(bound, solver_timeout);
    }
}
