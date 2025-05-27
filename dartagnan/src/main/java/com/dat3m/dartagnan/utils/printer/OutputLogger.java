package com.dat3m.dartagnan.utils.printer;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.ExitCode;
import com.dat3m.dartagnan.utils.Utils;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import org.sosy_lab.common.configuration.Configuration;

import static com.dat3m.dartagnan.utils.Result.*;

public class OutputLogger {

    private final List<ResultSummary> results = new ArrayList();
    private final File modelFile;
    private final Configuration config;

    public OutputLogger(File file, Configuration config) {
        this.modelFile = file;
        this.config = config;
    }

    public void addResult(ResultSummary result) {
        results.add(result);
    }

    public void toStdOut(boolean batchMode) {
        if (batchMode) {
            System.out.println("================ Configuration ==================");
            System.out.println("cat = " + modelFile);
            System.out.print(config.asPropertiesString()); // it already contains its own \n
            System.out.println("=================================================");
        }
        for (ResultSummary r : results) {
            if (batchMode) {
                System.out.println();
            }
            System.out.println(r);
        }
    }

    public record ResultSummary (
            String test, String filter, Result result, String condition,
            String reason, String details, long time, ExitCode code) {

        public static final String PROGRAM_SPEC_REASON = "Program specification violation found";
        public static final String TERMINATION_REASON = "Termination violation found";
        public static final String CAT_SPEC_REASON = "CAT specification violation found";
        public static final String SVCOMP_RACE_REASON = "SVCOMP data race found";
        public static final String BOUND_REASON = "Not fully unrolled loops";

        @Override
        public String toString() {
            final String shownFilter = !filter.isEmpty() ? String.format("Filter: %s%n", filter) : "";
            final String shownCondition = !condition.isEmpty() ? String.format("Condition: %s", condition) : "";
            final String shownReason = result != PASS && !reason.isEmpty() ? String.format("Reason: %s%n", reason) : "";
            final String shownDetails = !details.isEmpty() ? String.format("Details:%n%s", details) : "";
            final String shownTime = time > 0 ? String.format("Time: %s", Utils.toTimeString(time)) : "";
            return String.format("Test: %s%n%sResult: %s%n%s%s%s%s",
                test, shownFilter, result, shownReason, shownCondition, shownDetails, shownTime);
        }

        public String toUIString() {
            return String.format("Result: %s%n%sTime: %s", result, !details.isEmpty() ? "Details:%n" + details : "", Utils.toTimeString(time));
        }
    }

}

