package com.dat3m.porthos.utils.options;

import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;

import java.util.Arrays;
import java.util.Set;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.ParseException;

public class PorthosOptions extends BaseOptions {

    private String sourceModelFilePath;
    private Arch source;
    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("pts"));

    public PorthosOptions(){
        super();

        Option sourceCatOption = new Option("scat", true,
                "Path to the CAT file of the source memory model");
        sourceCatOption.setRequired(true);
        addOption(sourceCatOption);

        Option targetCatOption = new Option("tcat", true,
                "Path to the CAT file of the target memory model");
        targetCatOption.setRequired(true);
        addOption(targetCatOption);

        Option sourceOption = new Option("s", "source", true,
                "Source architecture {none|arm|arm8|power|tso}");
        sourceOption.setRequired(true);
        addOption(sourceOption);
    }

    public void parse(String[] args) throws ParseException, RuntimeException {
    	super.parse(args);
        if(supportedFormats.stream().map(f -> programFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }

    	CommandLine cmd = new DefaultParser().parse(this, args);
    	
        sourceModelFilePath = cmd.getOptionValue("scat");
        targetModelFilePath = cmd.getOptionValue("tcat");
        source = Arch.get(cmd.getOptionValue("source"));
        target = Arch.get(cmd.getOptionValue("target"));
    }

    public String getSourceModelFilePath(){
        return sourceModelFilePath;
    }

    public Arch getSource(){
        return source;
    }
}
