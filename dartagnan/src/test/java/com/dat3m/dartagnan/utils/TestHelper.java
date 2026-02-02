package com.dat3m.dartagnan.utils;

import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.ModelChecker;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.SolverException;

public class TestHelper {

    private TestHelper() {
    }

    public static Configuration getBasicConfig() throws InvalidConfigurationException {
        return Configuration.builder()
                .setOption(OptionNames.SOLVER, SolverContextFactory.Solvers.Z3.name())
                .setOption(OptionNames.PHANTOM_REFERENCES, "true")
                .build();
    }

    public static Result createAndRunModelChecker(VerificationTask task, Method method) throws InvalidConfigurationException, SolverException, InterruptedException {
        try (ModelChecker checker = ModelChecker.create(task, method)) {
            checker.run();
            return checker.getResult();
        }
    }

}
