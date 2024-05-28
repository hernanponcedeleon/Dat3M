package com.dat3m.ui.options.utils;

import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import java.util.Arrays;
import java.util.Comparator;

public class Helper {

    // Used to decide the solvers order shown by the selector in the UI
    public static Solvers[] solversOrderedValues() {
        return Arrays.stream(Solvers.values())
                .sorted(Comparator.comparing(Solvers::toString))
                .toArray(Solvers[]::new);
    }
}
