package com.dat3m.dartagnan.utils.options;

import org.apache.commons.cli.*;

public class DartagnanOptions extends BaseOptions {

    public DartagnanOptions(){
        super();
        Option catOption = new Option("cat", true,
                "Path to the CAT file");
        catOption.setRequired(true);
        addOption(catOption);
    }
}
