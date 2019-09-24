package com.dat3m.dartagnan.utils.options;

import com.dat3m.dartagnan.parsers.boogie.C2BoogieRunner;
import com.dat3m.dartagnan.svcomp.SVCOMPSanitizer;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.google.common.collect.ImmutableSet;

import java.io.File;
import java.util.Arrays;
import java.util.Set;

import org.apache.commons.cli.*;

public abstract class BaseOptions extends Options {

    protected String programFilePath;
    protected String targetModelFilePath;
    protected Set<String> supportedFormats = ImmutableSet.copyOf(Arrays.asList("litmus", "pts", "bpl", "c", "i")); 
    protected Settings settings;
    protected Arch target;

    private String graphFilePath = "out.dot";

    public BaseOptions(){
        super();
        Option inputOption = new Option("i", "input", true,
                "Path to the file with input program");
        inputOption.setRequired(true);
        addOption(inputOption);

        Option targetOption = new Option("t", "target", true,
                "Target architecture {none|arm|arm8|power|tso}");
        addOption(targetOption);

        Option modeOption = new Option("m", "mode", true,
                "Encoding mode {knastertarski|idl|kleene}");
        addOption(modeOption);

        Option aliasOption = new Option("a", "alias", true,
                "Type of alias analysis {none|andersen|cfs}");
        addOption(aliasOption);

        addOption(new Option("unroll", true,
                "Unrolling bound <integer>"));

        addOption(new Option("witness", false,
                "It generates a SVCOMP violation witness if the verification fails"));

        addOption(new Option("draw", true,
                "Path to save the execution graph if the state is reachable"));

        addOption(new Option("rels", true,
                "Relations to be drawn in the graph"));
    }

    public void parse(String[] args) throws ParseException, RuntimeException {
        CommandLine cmd = new DefaultParser().parse(this, args);
        parseSettings(cmd);
        parseGraphFilePath(cmd);

        String inputFilePath = cmd.getOptionValue("input");
        if(supportedFormats.stream().map(f -> inputFilePath.endsWith(f)). allMatch(b -> b.equals(false))) {
            throw new RuntimeException("Unrecognized program format");
        }
        programFilePath = cmd.getOptionValue("input");
        targetModelFilePath = cmd.getOptionValue("cat");

        if(cmd.hasOption("target")) {
            target = Arch.get(cmd.getOptionValue("target"));
        }
    }

    public String getProgramFilePath() {
    	if(programFilePath.endsWith(".c") || programFilePath.endsWith(".i")) {
			programFilePath = new C2BoogieRunner(new SVCOMPSanitizer(programFilePath).run(settings.getBound())).run();
    	}
        return programFilePath;
    }

    public String getTargetModelFilePath(){
        return targetModelFilePath;
    }

    public String getGraphFilePath(){
        return graphFilePath;
    }

    public Settings getSettings(){
        return settings;
    }

    public Arch getTarget(){
        return target;
    }

    protected void parseSettings(CommandLine cmd){
        Mode mode = cmd.hasOption("mode") ? Mode.get(cmd.getOptionValue("mode")) : null;
        Alias alias = cmd.hasOption("alias") ? Alias.get(cmd.getOptionValue("alias")) : null;
        boolean draw = cmd.hasOption("draw");
        boolean witness = cmd.hasOption("witness");
        String[] relations = cmd.hasOption("rels") ? cmd.getOptionValue("rels").split(",") : new String[0];

        int bound = 1;
        if(cmd.hasOption("unroll")){
            try {
                bound = Math.max(1, Integer.parseInt(cmd.getOptionValue("unroll")));
            } catch (NumberFormatException e){
                throw new UnsupportedOperationException("Illegal unroll value");
            }
        }
        settings = new Settings(mode, alias, bound, witness, draw, relations);
    }

    protected void parseGraphFilePath(CommandLine cmd){
        if(cmd.hasOption("draw")){
            String path = cmd.getOptionValue("draw");
            if(!path.isEmpty()){
                graphFilePath = path;
            }
        }
    }
}
