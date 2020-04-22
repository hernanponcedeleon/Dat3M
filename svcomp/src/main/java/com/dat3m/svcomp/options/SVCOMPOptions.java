package com.dat3m.svcomp.options;

import static java.util.stream.IntStream.rangeClosed;

import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;

import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.google.common.collect.ImmutableSet;

public class SVCOMPOptions extends BaseOptions {

    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("c", "i")); 
    protected List<Integer> bounds = rangeClosed(1, 10000).boxed().collect(Collectors.toList());
    protected String optimization = "O0";
    
    public SVCOMPOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        Option witnessOption = new Option("w", "witness", false,
                "Creates a violation witness");
        addOption(witnessOption);
        
        Option optOption = new Option("o", "optimization", true,
                "Optimization flag for LLVM compiler");
        addOption(optOption);
}
    
    public void parse(String[] args) throws ParseException, RuntimeException {
        CommandLine cmd = new DefaultParser().parse(this, args);
        parseSettings(cmd);

        programFilePath = cmd.getOptionValue("input");
        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }
        targetModelFilePath = cmd.getOptionValue("cat");
        if(cmd.hasOption("optimization")) {
        	optimization = cmd.getOptionValue("optimization");
        }
    }

    public String getOptimization(){
        return optimization;
    }

    public List<Integer> getBounds() {
        return bounds;
    }
}
