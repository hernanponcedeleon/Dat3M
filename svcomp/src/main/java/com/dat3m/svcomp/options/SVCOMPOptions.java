package com.dat3m.svcomp.options;

import static java.util.stream.IntStream.rangeClosed;

import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.ParseException;

import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.google.common.collect.ImmutableSet;

public class SVCOMPOptions extends BaseOptions {

    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("c", "i")); 
    protected List<Integer> bounds = rangeClosed(1, 10000).boxed().collect(Collectors.toList());
    protected String optimization = "O0";
    protected boolean witness;
    protected Integer cegar;
    
    public SVCOMPOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        Option cegarOption = new Option("cegar", true,
                "Use CEGAR");
        addOption(cegarOption);

        Option witnessOption = new Option("w", "witness", false,
                "Creates a violation witness");
        addOption(witnessOption);
        
        Option optOption = new Option("o", "optimization", true,
                "Optimization flag for LLVM compiler");
        addOption(optOption);
}
    
    public void parse(String[] args) throws ParseException, RuntimeException {
    	super.parse(args);
        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }

    	CommandLine cmd = new DefaultParser().parse(this, args);
        if(cmd.hasOption("optimization")) {
        	optimization = cmd.getOptionValue("optimization");
        }
        witness = cmd.hasOption("witness");
        if(cmd.hasOption("cegar")) {
            cegar = Integer.parseInt(cmd.getOptionValue("cegar"));        	
        }
    }

    public String getOptimization(){
        return optimization;
    }

    public boolean getGenerateWitness(){
        return witness;
    }

    public Integer getCegar(){
        return cegar;
    }

    public List<Integer> getBounds() {
        return bounds;
    }
}
