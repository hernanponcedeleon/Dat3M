package com.dat3m.dartagnan.utils.rules;

import org.junit.rules.TestRule;
import org.junit.runner.Description;
import org.junit.runners.model.Statement;
import org.junit.runners.model.TestTimedOutException;
import org.sosy_lab.common.ShutdownManager;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.function.Supplier;

public class ShutdownRule implements TestRule {


    private static final ExecutorService pool = Executors.newFixedThreadPool(2);
    private final Supplier<ShutdownManager> shutdownManagerSupplier;
    private final long timeout;
    private final TimeUnit timeUnit;

    public ShutdownRule(long timeout, TimeUnit timeUnit, Supplier<ShutdownManager> shutdownManagerSupplier) {
        this.timeout = timeout;
        this.timeUnit = timeUnit;
        this.shutdownManagerSupplier = shutdownManagerSupplier;
    }

    // This gets called in a separate thread.
    private void timedShutdown() {
        try {
            ShutdownManager manager = shutdownManagerSupplier.get();
            timeUnit.sleep(timeout);
            if (!Thread.interrupted()) {
                manager.requestShutdown("Timeout");
            }
        } catch (InterruptedException ignored) {
            // If this happens, the test finished in time.
        }
    }

    @Override
    public Statement apply(Statement base, Description description) {

        return new Statement() {
            @Override
            public void evaluate() throws Throwable {
                Future<?> task = null;
                long startTime = System.currentTimeMillis();
                try {
                    task = pool.submit(ShutdownRule.this::timedShutdown);
                    base.evaluate();
                    checkTimeout(startTime);
                } catch (Throwable e) {
                    checkTimeout(startTime);
                    throw e;
                } finally {
                    if (task != null && !task.isDone()) {
                        task.cancel(true);
                    }
                }
            }
        };
    }

    private void checkTimeout(long startTime) throws Throwable {
        long timeSpent = (System.currentTimeMillis() - startTime);
        timeSpent = timeUnit.convert(timeSpent, TimeUnit.MILLISECONDS);
        if (timeSpent >= timeout) {
            throw new TestTimedOutException(timeSpent, timeUnit);
        }
    }


}
