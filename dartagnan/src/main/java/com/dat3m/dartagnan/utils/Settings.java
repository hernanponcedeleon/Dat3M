package com.dat3m.dartagnan.utils;

public class Settings {

    public static final String TACTIC = "qfbv";
    
    private final int bound;
    private final int solver_timeout;

    public Settings(int bound, int solver_timeout){
        this.bound = Math.max(1, bound);
        this.solver_timeout = solver_timeout;
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
        return " bound=" + bound;
    }
}
