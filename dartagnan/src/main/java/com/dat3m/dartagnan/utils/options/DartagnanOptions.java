package com.dat3m.dartagnan.utils.options;

import java.util.Arrays;
import java.util.Set;

import org.apache.commons.cli.*;

import com.google.common.collect.ImmutableSet;

public class DartagnanOptions extends BaseOptions {

    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("litmus", "bpl"));
    protected String overApproxFilePath;
    protected boolean iSolver;
	
    public DartagnanOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        addOption(new Option("cegar", true,
        		"Use CEGAR. Argument is the path to the over-approximation memory model"));

        addOption(new Option("incrementalSolver", false,
        		"Use an incremental solver"));
}
    
    public void parse(String[] args) throws ParseException, RuntimeException {
    	super.parse(args);
        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }
        CommandLine cmd = new DefaultParser().parse(this, args);
        if(cmd.hasOption("cegar")) {
            overApproxFilePath = cmd.getOptionValue("cegar");
        }
        iSolver = cmd.hasOption("incrementalSolver");
    }
    
    public String getOverApproxPath(){
        return overApproxFilePath;
    }
    
    public boolean useISolver(){
        return iSolver;
    }
}
