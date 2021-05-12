package com.dat3m.boogiesan;

import java.util.Set;

import org.apache.commons.cli.*;

public class BoogieSanOptions extends Options {

    protected String programFilePath;
    protected Set<String> supportedFormats; 

    public BoogieSanOptions(){
        super();
        Option inputOption = new Option("i", "input", true,
                "Path to the file with input program");
        inputOption.setRequired(true);
        addOption(inputOption);
    }

    public void parse(String[] args) throws ParseException, RuntimeException {
        CommandLine cmd = new DefaultParser().parse(this, args);

        programFilePath = cmd.getOptionValue("input");
    }

    public String getProgramFilePath() {
        return programFilePath;
    }
}
