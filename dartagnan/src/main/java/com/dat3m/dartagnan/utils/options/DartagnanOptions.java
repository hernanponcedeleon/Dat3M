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

    private final Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("litmus", "bpl"));
    private final Set<AnalysisTypes> analyses = ImmutableSet.copyOf(Arrays.asList(REACHABILITY, RACES));
    private boolean incremental_solver;
    private String witness;
    private AnalysisTypes analysis = REACHABILITY; 
	
    public DartagnanOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        addOption(new Option("incremental_solver", false,
        		"Use an incremental solver"));
        
        addOption(new Option("w", "witness", true,
                "Creates a machine readable witness. The argument is the original *.c file from which the Boogie code was generated."));

        addOption(new Option("a", "analysis", true,
        		"The analysis to be performed: reachability (default), data-race detection"));
        }
    
    public void parse(String[] args) throws ParseException, RuntimeException {
    	super.parse(args);
        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }
        CommandLine cmd = new DefaultParser().parse(this, args);
        incremental_solver = cmd.hasOption("incremental_solver");
        if(cmd.hasOption("analysis")) {
        	analysis = fromString(cmd.getOptionValue("analysis"));
        	if(!analyses.contains(analysis)) {
        		throw new RuntimeException("Unrecognized analysis");
        	}
        }
        if(cmd.hasOption("witness")) {
        	witness = cmd.getOptionValue("witness");
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
