package com.dat3m.svcomp.options;

import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;

import com.google.common.collect.ImmutableSet;

public class SVCOMPOptions extends Options {

    protected String programFilePath;
    protected String targetModelFilePath;
    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("c", "i")); 
    protected boolean createWitness = false;
    protected List<Integer> bounds = Arrays.asList(1);

    public SVCOMPOptions(){
        super();
        Option inputOption = new Option("i", "input", true,
                "Path to the file with input program");
        inputOption.setRequired(true);
        addOption(inputOption);

        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);

        Option witnessOption = new Option("w", "witness", false,
                "Creates a violation witness");
        witnessOption.setRequired(false);
        addOption(witnessOption);
        
        Option boudnsOption = new Option("b", "bounds", false,
                "List of bounds used for the verification");
        boudnsOption.setArgs(Option.UNLIMITED_VALUES);
        boudnsOption.setValueSeparator(',');
        addOption(boudnsOption);

}
    
    public void parse(String[] args) throws ParseException, RuntimeException {
        CommandLine cmd = new DefaultParser().parse(this, args);

        programFilePath = cmd.getOptionValue("input");
        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }
       	targetModelFilePath = cmd.getOptionValue("cat");
        createWitness = cmd.hasOption("witness");
        bounds = Arrays.asList(cmd.getOptionValues("b")).stream().map(s -> Integer.parseInt(s)).collect(Collectors.toList());
    }

    public String getProgramFilePath() {
        return programFilePath;
    }

    public String getTargetModelFilePath(){
        return targetModelFilePath;
    }

    public boolean getCreateWitness() {
        return createWitness;
    }

    public List<Integer> getBounds() {
        return bounds;
    }
}
