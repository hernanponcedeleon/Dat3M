package com.dat3m.dartagnan.programNew;

import java.util.List;

public class Program {

    private String name;
    private List<Function> functions;
    private List<GlobalVariable> globalVariables;

    // First function is implicitly the main function
    public Function getEntryFunction() { return functions.get(0); }


}
