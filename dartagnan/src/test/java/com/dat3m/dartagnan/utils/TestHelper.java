package com.dat3m.dartagnan.utils;

import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.verification.TaskSolver;
import com.dat3m.dartagnan.verification.VerificationTask;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.SolverException;
import java.nio.file.Path;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.dat3m.dartagnan.GlobalSettings.getExecutablePath;

public class TestHelper {

    private static final Logger logger = LoggerFactory.getLogger(TestHelper.class);

    private TestHelper() {
    }

    public static Configuration getBasicConfig() throws InvalidConfigurationException {
        return Configuration.builder()
                .setOption(OptionNames.SOLVER, SolverContextFactory.Solvers.Z3.name())
                .setOption(OptionNames.PHANTOM_REFERENCES, "true")
                .build();
    }

    public static Result createAndRunSolver(VerificationTask task, Method method) throws InvalidConfigurationException, SolverException, InterruptedException {
        try (TaskSolver solver = TaskSolver.createWithMethod(task, method)) {
            solver.run();
            return solver.getResult();
        }
    }

    public static void runDartagnanApplication(Path programPath, Path catPath, String... options) throws Exception {
        final Path dat3mJar = getExecutablePath(true);
        List<String> command = new ArrayList<>();
        command.add("java");
        command.add("-jar");
        command.add(dat3mJar.toAbsolutePath().toString());
        command.add(catPath.toAbsolutePath().toString());
        command.add(programPath.toAbsolutePath().toString());
        command.addAll(Arrays.asList(options));

        ProcessBuilder pb = new ProcessBuilder(command);
        Process process = pb.start();
        int exitCode = process.waitFor();

        if (exitCode != 0) {
            String error = new String(process.getErrorStream().readAllBytes());
            logger.warn("Dartagnan finished with exit code {}. Error:", exitCode, error);
        }
    }

}
