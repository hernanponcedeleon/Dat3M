package com.dat3m.dartagnan.others.utils.rules;

import org.junit.rules.TestWatcher;
import org.junit.runner.Description;
import org.sosy_lab.common.ShutdownManager;

import java.util.function.Supplier;

/*
    DESC: This rule can be used in combination with a Timeout Rule to notify
    the testing thread to shutdown on timeout.
    Usually, if a timeout occurs, the test thread gets its "interrupted flag" set to TRUE
    and then gets abandoned to start running the next tests.
    If the interrupted thread does not respond to its flag, it may keep running in the background
    until it regularly terminates.
    This rule can notify the thread to terminate properly, potentially reducing the time it
    runs in the background.

    USAGE: Place this rule BEFORE a Timeout rule (Shutdown -> Timeout)
 */
public class RequestShutdownOnError extends TestWatcher {

    private final Supplier<ShutdownManager> shutdownManagerSupplier;

    private RequestShutdownOnError(Supplier<ShutdownManager> shutdownManagerSupplier) {
        this.shutdownManagerSupplier = shutdownManagerSupplier;
    }

    public static RequestShutdownOnError create(Supplier<ShutdownManager> shutdownManagerSupplier) {
        return new RequestShutdownOnError(shutdownManagerSupplier);
    }

    @Override
    protected void failed(Throwable e, Description description) {
        shutdownManagerSupplier.get().requestShutdown(e.toString());
    }
}
