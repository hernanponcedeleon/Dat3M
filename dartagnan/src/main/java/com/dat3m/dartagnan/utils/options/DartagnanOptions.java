package com.dat3m.dartagnan.utils.options;

import java.util.Arrays;
import java.util.Set;

import org.apache.commons.cli.*;

import com.google.common.collect.ImmutableSet;

public class DartagnanOptions extends BaseOptions {

    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("litmus", "bpl"));
    protected Integer cegar;
    protected boolean incremental;
	
    public DartagnanOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        addOption(new Option("cegar", true,
                "Use CEGAR"));
        
        addOption(new Option("incremental", false,
                "Use Incremental Solver"));
    }
    
    public void parse(String[] args) throws ParseException, RuntimeException {
    	super.parse(args);
        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }
        CommandLine cmd = new DefaultParser().parse(this, args);
        if(cmd.hasOption("cegar")) {
            cegar = Integer.parseInt(cmd.getOptionValue("cegar")) - 1;        	
        }
        incremental = cmd.hasOption("incremental");
    }
    
    public Integer getCegar(){
        return cegar;
    }
    
    public boolean getIncremental(){
        return incremental;
    }
}
