package com.dat3m.dartagnan.utils.options;

import static com.dat3m.dartagnan.analysis.AnalysisTypes.RACES;
import static com.dat3m.dartagnan.analysis.AnalysisTypes.REACHABILITY;
import static com.dat3m.dartagnan.analysis.AnalysisTypes.fromString;

import java.util.Arrays;
import java.util.Set;

import org.apache.commons.cli.*;

import com.dat3m.dartagnan.analysis.AnalysisTypes;
import com.google.common.collect.ImmutableSet;

public class DartagnanOptions extends BaseOptions {

	public static final String ANALYSIS_OPTION = "analysis";
	public static final String INCREMENTAL_SOLVER_OPTION = "incremental_solver";
	public static final String WITNESS_OPTION = "witness";

    private Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("litmus", "bpl"));
    private Set<AnalysisTypes> analyses = ImmutableSet.copyOf(Arrays.asList(REACHABILITY, RACES));
    private boolean incremental_solver;
    private String witness;
    private AnalysisTypes analysis = REACHABILITY; 
	
    public DartagnanOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        addOption(new Option(INCREMENTAL_SOLVER_OPTION, false,
        		"Use an incremental solver"));
        
        addOption(new Option("w", WITNESS_OPTION, true,
                "Creates a machine readable witness. The argument is the original *.c file from which the Boogie code was generated."));

        addOption(new Option("a", ANALYSIS_OPTION, true,
        		"The analysis to be performed: reachability (default), data-race detection"));
        }
    
    public void parse(String[] args) throws ParseException, RuntimeException {
    	super.parse(args);
        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }
        CommandLine cmd = new DefaultParser().parse(this, args);
        incremental_solver = cmd.hasOption(INCREMENTAL_SOLVER_OPTION);
        analysis = cmd.hasOption(ANALYSIS_OPTION) ? fromString(cmd.getOptionValue(ANALYSIS_OPTION)) : REACHABILITY; 
        witness = cmd.hasOption(WITNESS_OPTION) ? cmd.getOptionValue(WITNESS_OPTION) : null;
        if(!analyses.contains(analysis)) {
        	throw new RuntimeException("Unrecognized analysis");
        }
    }
    
    public boolean useISolver(){
        return incremental_solver;
    }

    public AnalysisTypes getAnalysis(){
		return analysis;
    }

    public String createWitness(){
        return witness;
    }
}
