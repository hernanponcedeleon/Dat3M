package com.dat3m.dartagnan.utils.rules;

import com.dat3m.dartagnan.utils.TestHelper;
import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.function.Supplier;

public class SolverContextProvider extends AbstractProvider<SolverContext> {

    private final Supplier<ShutdownNotifier> shutdownNotifierSupplier;

    public SolverContextProvider(Supplier<ShutdownNotifier> shutdownNotifierSupplier) {
        this.shutdownNotifierSupplier = shutdownNotifierSupplier;
    }

    @Override
    protected SolverContext provide() throws Throwable {
        return TestHelper.createContextWithShutdownNotifier(shutdownNotifierSupplier.get());
    }

}
