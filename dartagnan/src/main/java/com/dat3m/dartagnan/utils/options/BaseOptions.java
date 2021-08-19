package com.dat3m.dartagnan.utils.options;

import com.dat3m.dartagnan.analysis.Method;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.google.common.collect.ImmutableSet;
import org.apache.commons.cli.*;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import java.util.Arrays;
import java.util.Comparator;
import java.util.Set;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.analysis.Method.INCREMENTAL;
import static org.sosy_lab.java_smt.SolverContextFactory.Solvers.*;

public abstract class BaseOptions extends Options {

	public static final String METHOD_OPTION = "method";
	public static final String SMTSOLVER_OPTION = "solver";
	public static final String SMTSOLVER_TIMEOUT_OPTION = "timeout";
	
    protected String programFilePath;
    protected String targetModelFilePath;
    protected Settings settings;
    protected Arch target;

    protected Method method;
    protected Solvers smtsolver;

    private final Set<Method> supported_methods =
    		ImmutableSet.copyOf(Arrays.stream(Method.values())
            .sorted(Comparator.comparing(Method::toString))
    		.collect(Collectors.toList()));

    private final Set<String> supportedTargets =
    		ImmutableSet.copyOf(Arrays.stream(Arch.values())
    		.map(a -> a.toString().toLowerCase())
            .sorted(Comparator.comparing(String::toString))
    		.collect(Collectors.toList()));
    		
    public BaseOptions(){
        super();
        
        Option inputOption = new Option("i", "input", true,
                "Path to the file with input program");
        inputOption.setRequired(true);
        addOption(inputOption);

        addOption(new Option("t", "target", true,
                "Target architecture: " + supportedTargets));

        addOption(new Option("alias", true,
                "Type of alias analysis {none|andersen|cfs}"));

        addOption(new Option("u", "unroll", true,
                "Unrolling bound <integer>"));

        addOption(new Option(SMTSOLVER_TIMEOUT_OPTION, true,
                "Timeout (in secs) for the SMT solver"));
        
        addOption(new Option(METHOD_OPTION, true,
        		"The solver method to be used: " + supported_methods));
        
        Set<String> supported_smtsolvers =
        		ImmutableSet.copyOf(Arrays.stream(Solvers.values())
        		.map(a -> a.toString().toLowerCase())
                .sorted(Comparator.comparing(String::toString))
        		.collect(Collectors.toList()));
        addOption(new Option(SMTSOLVER_OPTION, true,
        		"The SMT solver to be used: " + supported_smtsolvers));
    }

    public void parse(String[] args) throws ParseException, RuntimeException {
        CommandLine cmd = new DefaultParser().parse(this, args);
        parseSettings(cmd);

        programFilePath = cmd.getOptionValue("input");
        targetModelFilePath = cmd.getOptionValue("cat");

        target = Arch.get(cmd.getOptionValue("target", Arch.NONE.toShortString()));
        method = Method.get(cmd.getOptionValue(METHOD_OPTION, INCREMENTAL.toShortString()));

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
        Alias alias = Alias.get(cmd.getOptionValue("alias", Alias.CFIS.toShortString()));

        int bound = 1;
        int solver_timeout = 0;
        if(cmd.hasOption("unroll")){
            try {
                bound = Math.max(1, Integer.parseInt(cmd.getOptionValue("unroll")));
            } catch (NumberFormatException e){
                throw new UnsupportedOperationException("Illegal unroll value");
            }
        }
        if(cmd.hasOption(SMTSOLVER_TIMEOUT_OPTION)){
            try {
            	solver_timeout = Math.max(1, Integer.parseInt(cmd.getOptionValue(SMTSOLVER_TIMEOUT_OPTION)));
            } catch (NumberFormatException e){
                throw new UnsupportedOperationException("Illegal solver_timeout value");
            }
        }
        settings = new Settings(alias, bound, solver_timeout);
    }
}
