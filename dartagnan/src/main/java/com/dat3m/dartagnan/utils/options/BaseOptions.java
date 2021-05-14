package com.dat3m.dartagnan.utils.options;

import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import java.util.Set;

import org.apache.commons.cli.*;

public abstract class BaseOptions extends Options {

    protected String programFilePath;
    protected String targetModelFilePath;
    protected Set<String> supportedFormats; 
    protected Settings settings;
    protected Arch target;

    public BaseOptions(){
        super();
        Option inputOption = new Option("i", "input", true,
                "Path to the file with input program");
        inputOption.setRequired(true);
        addOption(inputOption);

        addOption(new Option("t", "target", true,
                "Target architecture {none|arm|arm8|power|tso}"));

        addOption(new Option("alias", true,
                "Type of alias analysis {none|andersen|cfs}"));

        addOption(new Option("u", "unroll", true,
                "Unrolling bound <integer>"));

        addOption(new Option("solver_timeout", true,
                "Timeout (in secs) for the SMT solver"));
    }

    public void parse(String[] args) throws ParseException, RuntimeException {
        CommandLine cmd = new DefaultParser().parse(this, args);
        parseSettings(cmd);

        programFilePath = cmd.getOptionValue("input");
        targetModelFilePath = cmd.getOptionValue("cat");

        if(cmd.hasOption("target")) {
            target = Arch.get(cmd.getOptionValue("target"));
        }
    }

    public String getProgramFilePath() {
        return programFilePath;
    }

    public String getTargetModelFilePath(){
        return targetModelFilePath;
    }

    public Settings getSettings(){
        return settings;
    }

    public Arch getTarget(){
        return target;
    }

    protected void parseSettings(CommandLine cmd){
        Alias alias = cmd.hasOption("alias") ? Alias.get(cmd.getOptionValue("alias")) : null;

        int bound = 1;
        int solver_timeout = 0;
        if(cmd.hasOption("unroll")){
            try {
                bound = Math.max(1, Integer.parseInt(cmd.getOptionValue("unroll")));
            } catch (NumberFormatException e){
                throw new UnsupportedOperationException("Illegal unroll value");
            }
        }
        if(cmd.hasOption("solver_timeout")){
            try {
            	solver_timeout = Math.max(1, Integer.parseInt(cmd.getOptionValue("solver_timeout")));
            } catch (NumberFormatException e){
                throw new UnsupportedOperationException("Illegal solver_timeout value");
            }
        }
        settings = new Settings(alias, bound, solver_timeout);
    }
}
