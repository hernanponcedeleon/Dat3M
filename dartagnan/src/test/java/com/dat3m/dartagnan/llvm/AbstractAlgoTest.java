package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.task.verification.VerificationStatus;

import java.util.EnumSet;

/**
 * Base class for LLVM tests that check a single memory model.
 * Subclasses list their rows via task(...) or eagerOnly(...), each with its own bound.
 * Rows built with eagerOnly(...) disable the lazy method, because it times out at that bound.
 */
public abstract class AbstractAlgoTest extends AbstractLlvmTest {

    private final int bound;
    private final boolean lazyEnabled;

    protected AbstractAlgoTest(String name, Arch target, int bound, VerificationStatus expected, boolean lazyEnabled) {
        super(name, target, expected);
        this.bound = bound;
        this.lazyEnabled = lazyEnabled;
    }

    protected static Object[] task(String name, int bound, VerificationStatus expected) {
        return new Object[]{name, bound, expected, true};
    }

    protected static Object[] eagerOnly(String name, int bound, VerificationStatus expected) {
        return new Object[]{name, bound, expected, false};
    }

    @Override
    protected int getBound() { return bound; }

    @Override
    protected EnumSet<Property> getTestedProperties() { return Property.getDefault(); }

    @Override
    protected long getTimeoutSeconds() { return 300; }

    @Override
    protected boolean isLazyMethodEnabled() { return lazyEnabled; }
}
