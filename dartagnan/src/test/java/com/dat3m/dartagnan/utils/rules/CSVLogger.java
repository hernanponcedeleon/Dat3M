package com.dat3m.dartagnan.utils.rules;

import org.apache.logging.log4j.LogManager;
import org.junit.rules.TestWatcher;
import org.junit.runner.Description;
import org.junit.runners.model.TestTimedOutException;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.util.function.Supplier;

import static com.dat3m.dartagnan.utils.ResourceHelper.getCSVFileName;

public class CSVLogger extends TestWatcher {

    private final Supplier<String> testNameSupplier;
    private final Supplier<String> pathSupplier;
    private long startTime;

    public CSVLogger(Supplier<String> testNameSupplier, Supplier<String> pathSupplier) {
        this.testNameSupplier = testNameSupplier;
        this.pathSupplier = pathSupplier;
    }

    @Override
    protected void starting(Description description) {
        startTime = System.currentTimeMillis();
    }

    private void logCSVLine(Description desc, String... values) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(getCSVFileName(desc.getTestClass(), testNameSupplier.get()), true))) {
            writer.append(String.join(", ", values));
            writer.append("\n");
        } catch (Exception e) {
            LogManager.getRootLogger().error(e.getMessage());
        }
    }

    @Override
    protected void succeeded(Description description) {
        logCSVLine(description, pathSupplier.get(), Long.toString(System.currentTimeMillis() - startTime));
    }

    @Override
    protected void failed(Throwable e, Description description) {
        String message = e instanceof TestTimedOutException ? "Timeout" : "Error";
        logCSVLine(description, pathSupplier.get(), message);
    }
}
