package com.dat3m.dartagnan.drunner;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.drunner.printer.CsvPrinter;
import com.dat3m.dartagnan.encoding.ProverWithTracker;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import org.antlr.v4.runtime.InputMismatchException;
import org.antlr.v4.runtime.NoViableAltException;
import org.junit.Test;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.SolverContext;

import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;

public class ExecutionTest extends AbstractTest {

    private static final Object[][] TESTS = {
            {"checks-litmus-vulkan", "litmus-vulkan", "spirv-check", CAT_SPEC, false},
            {"races-litmus-vulkan", "litmus-vulkan", "spirv", CAT_SPEC, false},
            {"races-litmus-vulkan-filter", "litmus-vulkan", "spirv", CAT_SPEC, true},
            {"spec-litmus-vulkan", "litmus-vulkan", "spirv", PROGRAM_SPEC, false},

            {"checks-spirv-verification", "spirv-verification", "spirv-check", CAT_SPEC, false},
            {"races-spirv-verification", "spirv-verification", "spirv", CAT_SPEC, false},
            {"races-spirv-verification-filter", "spirv-verification", "spirv", CAT_SPEC, true},
            {"spec-spirv-verification", "spirv-verification", "spirv", PROGRAM_SPEC, false},
/*
            {"checks-spirv-empirical", "spirv-empirical", "spirv-check", CAT_SPEC, false},
            {"races-spirv-empirical", "spirv-empirical", "spirv", CAT_SPEC, false},
            {"races-spirv-empirical-filter", "spirv-empirical", "spirv", CAT_SPEC, true},
            {"spec-spirv-empirical", "spirv-empirical", "spirv", PROGRAM_SPEC, false}, */
    };

    private final Map<String, Map<String, String>> results = new HashMap<>();

    @Test
    public void run() throws Exception {
        for (Object[] params : TESTS) {
            String type = (String) params[0];
            String dir = (String) params[1];
            String model = (String) params[2];
            Property property = (Property) params[3];
            boolean filter = (Boolean) params[4];
            String modelPath = getRootPath(String.format("cat/%s.cat", model));
            Path rootPath = Path.of(basePath, dir);
            Map<String, String> data = new HashMap<>();
            for (String path : listFiles(rootPath)) {
                try (SolverContext ctx = mkCtx(); ProverWithTracker prover = mkProver(ctx)) {
                    String key = trimExtension(path.replace(rootPath.toString(), "")).trim();
                    try {
                        Result result = AssumeSolver.run(ctx, prover, mkTask(modelPath, path, property, filter)).getResult();
                        data.put(key, result.toString());
                    } catch (Exception e) {
                        Throwable cause = e.getCause();
                        if (cause instanceof NoViableAltException || cause instanceof InputMismatchException) {
                            data.put(key, "P_ERR");
                        } else {
                            data.put(key, e.getMessage());
                        }
                    }
                }
            }
            results.put(type, data);
        }
        System.out.print(new CsvPrinter(results).print());
    }

    private String trimExtension(String path) {
        if (path.endsWith(".litmus")) {
            return path.substring(0, path.length() - ".litmus".length());
        }
        if (path.endsWith(".spv.dis")) {
            return path.substring(0, path.length() - ".spv.dis".length());
        }
        throw new RuntimeException("Unknown file type: " + path);
    }

    private SolverContext mkCtx() throws InvalidConfigurationException {
        Configuration cfg = Configuration.builder().build();
        return SolverContextFactory.createSolverContext(
                cfg,
                BasicLogManager.create(cfg),
                ShutdownManager.create().getNotifier(),
                SolverContextFactory.Solvers.Z3);
    }

    private ProverWithTracker mkProver(SolverContext ctx) {
        return new ProverWithTracker(ctx, "", SolverContext.ProverOptions.GENERATE_MODELS);
    }
}
