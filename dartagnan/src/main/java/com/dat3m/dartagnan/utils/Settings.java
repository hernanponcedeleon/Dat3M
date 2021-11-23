package com.dat3m.dartagnan.utils;

import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

public class Settings {

    public static final String TACTIC = "qfbv";

    private final Alias alias;
    private final int bound;
    private final int solver_timeout;

    public Settings(Alias alias, int bound, int solver_timeout){
        this.alias = alias == null ? Alias.CFIS : alias;
        this.bound = Math.max(1, bound);
        this.solver_timeout = solver_timeout;
    }

    public Alias getAlias(){
        return alias;
    }

    public int getBound(){
        return bound;
    }

    public int getSolverTimeout(){
        return solver_timeout;
    }

    public boolean hasSolverTimeout(){
        return solver_timeout > 0;
    }

    @Override
    public String toString(){
        return " alias=" + alias + " bound=" + bound;
    }


    public Configuration applyToConfig(Configuration sourceConfig) throws InvalidConfigurationException {
        return Configuration.builder()
                .copyFrom(sourceConfig)
                .setOption("program.processing.loopBound", Integer.toString(bound))
                .setOption("program.analysis.alias", alias.toString())
                .setOption("verification.timeout", Integer.toString(solver_timeout))
                .build();

    }
}
