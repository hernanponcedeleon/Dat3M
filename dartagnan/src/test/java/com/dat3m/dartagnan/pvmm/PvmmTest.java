package com.dat3m.dartagnan.pvmm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.ProverWithTracker;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.ModelChecker;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import org.junit.Test;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static java.util.stream.Collectors.toMap;
import static org.junit.Assert.*;

public class PvmmTest {

    private static final String[] models = {
            "vulkan_pvmm",
            "vulkan_pvmm_semsc",
            //"vulkan_pvmm_semsc_trans1",
            "vulkan_pvmm_semsc_trans2",
            "vulkan_current_pvmm",
            "vulkan_current_pvmm_semsc",
            //"vulkan_current_pvmm_semsc_trans1",
            "vulkan_current_pvmm_semsc_trans2",
    };

    private static final Object[][] expected = {
                                                    // orig             // current
            // test                                 base    semsc       base    semsc

            {"f-graph-mp-semsc-a",                  FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"f-graph-mp-semsc-b",                  PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-mp-semsc-c",                  FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},

            {"f-graph-problem-semsc-mp-a",          PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-semsc-mp-b",          FAIL,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"f-graph-problem-semsc-mp-c",          PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-semsc-mp-fences-a",   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-semsc-mp-fences-b",   FAIL,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"f-graph-problem-semsc-mp-fences-c",   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-semsc-lb-a",          PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-semsc-lb-b",          FAIL,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"f-graph-problem-semsc-lb-c",          FAIL,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"f-graph-problem-semsc-lb-c-acqrel",   FAIL,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"f-graph-problem-semsc-lb-d",          PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-semsc-lb-d-acqrel",   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},

            {"f-graph-mp3",                         FAIL,   PASS,   FAIL,       FAIL,   PASS,   FAIL},

            {"f-graph-problem3-a",                  FAIL,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"f-graph-problem3-b",                  PASS,   PASS,   PASS,       PASS,   PASS,   PASS},

            {"scopes-mp-acq-acq-a",                 PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"scopes-mp-acq-acq-b",                 FAIL,   FAIL,   FAIL,       PASS,   PASS,   PASS},

            {"extra-sb",                            PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"extra-sb-fence",                      PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"extra-lb",                            FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"extra-lb-fence-1",                    FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"extra-lb-fence-2",                    FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"extra-mp3",                           FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"extra-mp3-fence1",                    FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"extra-mp3-fence2",                    PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"extra-mp-plus-fence",                 PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"extra-mp-plus",                       PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"extra-lb-plus",                       PASS,   PASS,   PASS,       PASS,   PASS,   PASS},

            {"mp3transitive3",                      FAIL,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"mp3transitive3-fence",                FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
    };

    private final Printer printer = Printer.newInstance();

    @Test
    public void checkResult() throws Exception {
        for (Object[] entry : expected) {
            String program = getRootPath("litmus/VULKAN/pvmm/" + entry[0] + ".litmus");
            for (int i = 1; i < entry.length; i++) {
                Result result = (Result) entry[i];
                String model = getRootPath("cat/" + models[i - 1] + ".cat");
                try (SolverContext ctx = mkCtx()) {
                    try (ProverWithTracker prover = mkProver(ctx)) {
                        VerificationTask task = mkTask(program, model, PROGRAM_SPEC);
                        assertEquals(result, AssumeSolver.run(ctx, prover, task).getResult());
                    }
                }
                try (SolverContext ctx = mkCtx()) {
                    try (ProverWithTracker prover = mkProver(ctx)) {
                        VerificationTask task = mkTaskRefinement(program, model, PROGRAM_SPEC);
                        assertEquals(result, RefinementSolver.run(ctx, prover, task).getResult());
                    }
                }
            }
        }
    }

    @Test
    public void logRelations() throws Exception {
        for (Object[] entry : expected) {
            String programPath = getRootPath("litmus/VULKAN/pvmm/" + entry[0] + ".litmus");
            for (int i = 1; i < entry.length; i++) {
                Result result = (Result) entry[i];
                String modelPath = getRootPath("cat/" + models[i - 1] + ".cat");
                Property property = PROGRAM_SPEC;
                if (result == FAIL) {
                    modelPath = getRootPath("cat/" + models[i - 1] + "_cycle.cat");
                    property = CAT_SPEC;
                }
                try (SolverContext ctx = mkCtx()) {
                    try (ProverWithTracker prover = mkProver(ctx)) {
                        VerificationTask task = mkTask(programPath, modelPath, property);
                        ModelChecker mc = AssumeSolver.run(ctx, prover, task);
                        assertTrue(mc.hasModel());
                        RelationAnalysis ra = mc.getEncodingContext().getAnalysisContext().get(RelationAnalysis.class);
                        Set<Relation> relations = task.getMemoryModel().getRelations();
                        Map<String, MutableEventGraph> data = extractRelationsData(task.getProgram(), relations, ra, prover.getModel());
                        data = translateEventIds(task.getProgram(), data);
                        log(models[i - 1], task.getProgram(), data);
                    }
                }
            }
        }
    }

    private Map<String, MutableEventGraph> extractRelationsData(
            Program program, Set<Relation> relations, RelationAnalysis analysis, Model model) {
        Map<String, Event> events = program
                .getThreadEvents()
                .stream()
                .collect(toMap(e -> Integer.toString(e.getGlobalId()), e -> e));
        Map<String, MutableEventGraph> data = relations
                .stream()
                .collect(toMap(Relation::getNameOrTerm, r -> MapEventGraph.from(analysis.getKnowledge(r).getMustSet())));
        for (Model.ValueAssignment ast : model.asList()) {
            if (ast.getValue() instanceof Boolean bVal && bVal) {
                String[] parts = ast.getName().split(" ");
                if (parts.length == 3 && data.containsKey(parts[0])) {
                    Event e1 = events.get(parts[1]);
                    Event e2 = events.get(parts[2]);
                    assertNotNull(e1);
                    assertNotNull(e2);
                    data.get(parts[0]).add(e1, e2);
                }
            }
        }
        return data;
    }

    private Map<String, MutableEventGraph> translateEventIds(Program program, Map<String, MutableEventGraph> data) {
        int counter = 1;
        Set<Event> filter = new HashSet<>();
        List<Event> events = program
                .getThreadEvents()
                .stream()
                .sorted(Comparator.comparing(Event::getGlobalId))
                .toList();
        for (Event event : events) {
            if ((event instanceof MemoryEvent || event instanceof GenericVisibleEvent)) {
                filter.add(event);
                event.setPrintId(counter);
                counter++;
            } else {
                event.setPrintId(0);
            }
        }
        return data.entrySet()
                .stream()
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        entry -> entry.getValue().filter((e1, e2) -> filter.contains(e1) && filter.contains(e2))));
    }

    private void log(String model, Program program, Map<String, MutableEventGraph> data) throws IOException {
        List<String> relations = data.keySet().stream().sorted().toList();
        StringBuilder sb = new StringBuilder();
        sb.append(printer.print(program));
        for (String relation : relations) {
            if (relation.matches("[a-z]+(\\#?[0-9]+[a-z_]*)?")) {
                sb.append(relation).append(": ").append(data.get(relation)).append("\n");
            }
        }
        Files.createDirectories(Path.of(getRootPath("output/data/" + model)));
        String filePath = getRootPath("output/data/" + model + "/" + program.getName() + ".log");
        Files.write(Path.of(filePath), sb.toString().getBytes());
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

    private VerificationTask mkTask(String programPath, String modelPath, Property property) throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(Configuration.builder()
                        .setOption(ENABLE_EXTENDED_RELATION_ANALYSIS, "false")
                        .setOption(ENABLE_ACTIVE_SETS, "false")
                        .build()
                )
                .withBound(1)
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(property));
    }

    private VerificationTask mkTaskRefinement(String programPath, String modelPath, Property property) throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(Configuration.builder()
                        .setOption(ENABLE_EXTENDED_RELATION_ANALYSIS, "false")
                        .setOption(ENABLE_ACTIVE_SETS, "true") // crashes without active set
                        .build()
                )
                .withBound(1)
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(property));
    }
}
