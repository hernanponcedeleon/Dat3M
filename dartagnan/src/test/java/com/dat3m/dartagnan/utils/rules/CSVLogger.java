package com.dat3m.dartagnan.utils.rules;

import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Result;

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

/*
    DESC: The CSVLogger creates for each annotated test method a .csv file that contains
        - timing information if successful
        - error/timeout information if an error/a timeout occurred

    USAGE: - Add the ClassRule <CSVLogger.Initialization> to the test class (this creates the .csv files)
           - Create a CSVLogger Rule in a RuleChain and put it as close to the actual test execution
             as possible, to get the most accurate timings. The rule populates the created .csv files.
           - Annotate test methods with the @CSVLogger.FileName Attribute. e.g.
                @CSVLogger.FileName("csv/mytest")
             which will cause the creation of a .csv file "DAT3M_OUTPUT/csv/<TESTCLASS>-mytest.csv"
             ( See ResourceHelper.getCSVFileName for details)
           - The <nameSupplier> is used to name the entry inside the .csv file

    NOTE: To properly work with a Timeout Rule, the CSVLogger needs to be put before the Timeout Rule.
          As a Timeout Rule runs the test in a separate thread, this may force some initialization code
          to be moved AFTER the Timeout rule (cause some resources can only be used by the thread that created
          it, which is, e.g., the case for Z3's Context and Solver objects).
          Overall, this forces some setup code to be measured by the Logger (which is usually not that crucial)
 */
public class CSVLogger extends TestWatcher {

    private final Supplier<String> nameSupplier;
    private final Supplier<Result> resultSupplier;
    private long startTime;

    private CSVLogger(Supplier<String> nameSupplier, Supplier<Result> resultSupplier) {
        this.nameSupplier = nameSupplier;
        this.resultSupplier = resultSupplier;
    }

    public static CSVLogger create(Supplier<String> nameSupplier, Supplier<Result> resultSupplier) {
        return new CSVLogger(nameSupplier, resultSupplier);
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
    	String result = resultSupplier.get().toString();
		String time = Long.toString(System.currentTimeMillis() - startTime);
		logCSVLine(description, nameSupplier.get(), result, time);
    }

    @Override
    protected void failed(Throwable e, Description description) {
        String result = e instanceof TestTimedOutException ? "TIMEOUT" : "ERROR";
		String time = Long.toString(System.currentTimeMillis() - startTime);
        logCSVLine(description, nameSupplier.get(), result, time);
    }

    public static class Initialization extends TestWatcher {
        private Initialization() { }

        public static Initialization create() {
            return new Initialization();
        }

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
