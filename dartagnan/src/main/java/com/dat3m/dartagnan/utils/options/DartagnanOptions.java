package com.dat3m.dartagnan.utils.options;

import static com.dat3m.dartagnan.analysis.AnalysisTypes.RACES;
import static com.dat3m.dartagnan.analysis.AnalysisTypes.REACHABILITY;
import static com.dat3m.dartagnan.analysis.AnalysisTypes.TERMINATION;
import static com.dat3m.dartagnan.analysis.AnalysisTypes.fromString;

import java.util.Arrays;
import java.util.Set;

import org.apache.commons.cli.*;

import com.dat3m.dartagnan.analysis.AnalysisTypes;
import com.google.common.collect.ImmutableSet;

public class DartagnanOptions extends BaseOptions {

    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("litmus", "bpl"));
    protected boolean iSolver;
    protected String witness;
    private Set<AnalysisTypes> analyses = ImmutableSet.copyOf(Arrays.asList(REACHABILITY, RACES, TERMINATION));
    private AnalysisTypes analysis = REACHABILITY; 
	
    public DartagnanOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        addOption(new Option("incrementalSolver", false,
        		"Use an incremental solver"));
        
        addOption(new Option("w", "witness", true,
                "Creates a machine readable witness. The argument is the original *.c file from which the Boogie code was generated."));

        addOption(new Option("analysis", true,
        		"The analysis to be performed: reachability (default), data-race detection, termination"));
        }
    
    public void parse(String[] args) throws ParseException, RuntimeException {
    	super.parse(args);
        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }
        CommandLine cmd = new DefaultParser().parse(this, args);
        iSolver = cmd.hasOption("incrementalSolver");
        if(cmd.hasOption("analysis")) {
        	AnalysisTypes selectedAnalysis = fromString(cmd.getOptionValue("analysis"));
        	if(!analyses.contains(selectedAnalysis)) {
        		throw new RuntimeException("Unrecognized analysis");
        	}
        	analysis = selectedAnalysis;
        }
        if(cmd.hasOption("witness")) {
        	witness = cmd.getOptionValue("witness");
        }
    }
    
    public boolean useISolver(){
        return iSolver;
    }

    public AnalysisTypes getAnalysis(){
		return analysis;
    }

    public String createWitness(){
        return witness;
    }
}
