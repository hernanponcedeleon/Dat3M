package com.dat3m.dartagnan.utils;

import com.dat3m.dartagnan.configuration.Method;
import org.junit.Test;

import static org.junit.Assume.assumeTrue;

public abstract class AbstractVerificationTaskSolverTest {

    @Test
    public void testAssume() throws Exception {
        assumeTrue(isEagerMethodEnabled());
        testSolver(Method.EAGER);
    }

    @Test
    public void testRefinement() throws Exception {
        assumeTrue(isLazyMethodEnabled());
        testSolver(Method.LAZY);
    }

    protected abstract void testSolver(Method method) throws Exception;

    protected boolean isEagerMethodEnabled() { return true; }
    protected boolean isLazyMethodEnabled() { return true; }
}
