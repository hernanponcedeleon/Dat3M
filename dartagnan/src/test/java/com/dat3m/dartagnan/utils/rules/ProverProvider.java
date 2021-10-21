package com.dat3m.dartagnan.utils.rules;

import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.function.Supplier;

public class ProverProvider extends Provider<ProverEnvironment> {

    private final Supplier<SolverContext> contextSupplier;
    private final Supplier<SolverContext.ProverOptions[]> optionsProvider;

    public ProverProvider(Supplier<SolverContext> contextSupplier, Supplier<SolverContext.ProverOptions[]> optionsProvider) {
        this.contextSupplier = contextSupplier;
        this.optionsProvider = optionsProvider;
    }

    @Override
    protected ProverEnvironment provide() {
        return contextSupplier.get().newProverEnvironment(optionsProvider.get());
    }
}
