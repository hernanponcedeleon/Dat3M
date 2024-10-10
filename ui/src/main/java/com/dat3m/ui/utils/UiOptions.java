package com.dat3m.ui.utils;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import java.util.EnumSet;
import java.util.List;
import java.util.Map;

import static com.dat3m.dartagnan.configuration.OptionNames.*;

public record UiOptions(Arch target, Method method, int bound, Solvers solver, int timeout, boolean showWitness,
                        String cflags, Map<String, String> config, EnumSet<Property> properties, ProgressModel progress) {

    public static final List<String> BASIC_OPTIONS = List.of(TARGET, METHOD, BOUND, SOLVER, TIMEOUT, WITNESS, PROPERTY, PROGRESSMODEL);
}