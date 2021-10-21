package com.dat3m.dartagnan.utils.rules;

import com.dat3m.dartagnan.utils.ResourceHelper;
import org.apache.logging.log4j.LogManager;
import org.junit.Test;
import org.junit.rules.TestWatcher;
import org.junit.runner.Description;
import org.junit.runners.model.TestTimedOutException;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.reflect.Method;
import java.util.function.Supplier;

import static com.dat3m.dartagnan.utils.ResourceHelper.getCSVFileName;

public class CSVLogger extends TestWatcher {

    private final Supplier<String> pathSupplier;
    private long startTime;

    public CSVLogger(Supplier<String> pathSupplier) {
        this.pathSupplier = pathSupplier;
    }

    @Override
    protected void starting(Description description) {
        startTime = System.currentTimeMillis();
    }

    private void logCSVLine(Description desc, String... values) {
        FileName nameAttr = desc.getAnnotation(FileName.class);
        if (nameAttr == null) {
            return;
        }

        try (BufferedWriter writer = new BufferedWriter(
                new FileWriter(getCSVFileName(desc.getTestClass(), nameAttr.value()), true))
        ) {
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

    public static class Initialization extends TestWatcher {
        @Override
        protected void starting(Description description) {
            Class<?> testClass = description.getTestClass();
            for (Method m : testClass.getMethods()) {
                FileName nameAttr = m.getAnnotation(FileName.class);
                Test testAttr = m.getAnnotation(Test.class); // We only log test methods
                if (nameAttr != null && testAttr != null) {
                    try {
                        ResourceHelper.initialiseCSVFile(testClass, nameAttr.value());
                    } catch (Exception e) {
                        LogManager.getRootLogger().error("Failed to create CSV files due to error.");
                        LogManager.getRootLogger().error(e.getMessage());
                        throw new RuntimeException(e);
                    }
                }
            }
        }
    }

    @Retention(RetentionPolicy.RUNTIME)
    @Target(ElementType.METHOD)
    public @interface FileName {
        String value();
    }
}
