package com.dat3m.svcomp.options;

import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;

public class SVCOMPOptions extends Options {

    public SVCOMPOptions(){
        super();
        Option inputOption = new Option("i", "input", true,
                "Path to the file with input program");
        inputOption.setRequired(true);
        addOption(inputOption);
    }
}
