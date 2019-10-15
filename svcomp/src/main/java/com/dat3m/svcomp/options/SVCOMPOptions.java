package com.dat3m.svcomp.options;

import java.util.Arrays;
import java.util.Set;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;

import com.google.common.collect.ImmutableSet;

public class SVCOMPOptions extends Options {

    protected String programFilePath;
    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("c", "i")); 
    protected boolean createWitness = false;

    public SVCOMPOptions(){
        super();
        Option inputOption = new Option("i", "input", true,
                "Path to the file with input program");
        inputOption.setRequired(false);
        addOption(inputOption);

        Option witnessOption = new Option("w", "witness", false,
                "Creates a violation witness");
        witnessOption.setRequired(false);
        addOption(witnessOption);

}
    
    public void parse(String[] args) throws ParseException, RuntimeException {
        CommandLine cmd = new DefaultParser().parse(this, args);

        programFilePath = cmd.getOptionValue("input");
        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }
        createWitness = cmd.hasOption("witness");
    }

    public String getProgramFilePath() {
        return programFilePath;
    }

    public boolean getCreateWitness() {
        return createWitness;
    }
}
