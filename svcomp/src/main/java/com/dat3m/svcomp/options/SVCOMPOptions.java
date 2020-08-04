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
    protected boolean incremental;
    protected boolean bp;
    
    public SVCOMPOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        addOption(new Option("cegar", true,
                "Use CEGAR"));

        addOption(new Option("incremental", true,
                "Use Incremental Solver"));

        addOption(new Option("w", "witness", false,
                "Creates a violation witness"));
        
        addOption(new Option("o", "optimization", true,
                "Optimization flag for LLVM compiler"));
        
        addOption(new Option("bp", "bit-precise", false,
                "Use bit precise encoding"));
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
        incremental = cmd.hasOption("incremental");
        if(cmd.hasOption("cegar")) {
            cegar = Integer.parseInt(cmd.getOptionValue("cegar"));        	
        }
        bp = cmd.hasOption("bit-precise");
    }

    public String getOptimization(){
        return optimization;
    }

    public boolean getGenerateWitness(){
        return witness;
    }

    public boolean getBP(){
        return bp;
    }

    public boolean getIncremental(){
        return incremental;
    }

    public Integer getCegar(){
        return cegar;
    }

    public List<Integer> getBounds() {
        return bounds;
    }
}
