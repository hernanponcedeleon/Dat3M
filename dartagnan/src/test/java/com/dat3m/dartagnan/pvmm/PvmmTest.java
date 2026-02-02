package com.dat3m.dartagnan.pvmm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.ModelChecker;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.java_smt.api.Model;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static java.util.stream.Collectors.toMap;
import static org.junit.Assert.*;

public class PvmmTest {

    private static final Map<String, Path> libs = Map.of(
            "chains", Path.of(getRootPath("cat/chains")),
            "nochains", Path.of(getRootPath("cat/nochains"))
    );

    private static final String[] models = {
            "vulkan_pvmm",
            "vulkan_pvmm_semsc_constraint",
            //"vulkan_current_pvmm_semsc_constraint",
            "vulkan_pvmm_semsc",
            //"vulkan_pvmm_semsc_trans1",
            "vulkan_pvmm_semsc_trans2",
            "vulkan_current_pvmm",
            "vulkan_current_pvmm_semsc",
            //"vulkan_current_pvmm_semsc_trans1",
            "vulkan_current_pvmm_semsc_trans2",
    };

    private static final Object[][] expectedAll = {
                                                    // orig             // current
            // test                                 base    semsc       base    semsc

            {"f-graph-mp-semsc-a",                  FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"f-graph-mp-semsc-b",                  PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-mp-semsc-c",                  FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},

            {"f-graph-mp-avvis-a",                  PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-mp-avvis-b",                  FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},

            {"f-graph-problem-semsc-mp-a",          PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-semsc-mp-b",          FAIL,   PASS,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"f-graph-problem-semsc-mp-c",          PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-semsc-mp-fences-a",   PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-semsc-mp-fences-b",   FAIL,   PASS,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"f-graph-problem-semsc-mp-fences-c",   PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-semsc-lb-a",          PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-semsc-lb-b",          FAIL,   FAIL,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"f-graph-problem-semsc-lb-c",          FAIL,   FAIL,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"f-graph-problem-semsc-lb-c-acqrel",   FAIL,   FAIL,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"f-graph-problem-semsc-lb-d",          PASS,   FAIL,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-semsc-lb-d-acqrel",   PASS,   FAIL,   PASS,   PASS,       PASS,   PASS,   PASS},

            {"f-graph-problem-avvis-mp-a",          PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-avvis-mp-b",          FAIL,   PASS,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"f-graph-problem-avvis-mp-c",          FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"f-graph-problem-avvis-mp-d",          PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-avvis-mp-e",          FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"f-graph-problem-avvis-mp-f",          PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-avvis-mp-g",          FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"f-graph-problem-avvis-mp-aa",         PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-problem-avvis-mp-bb",         FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},

            {"f-graph-mp3-a",                       FAIL,   FAIL,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"f-graph-mp3-af",                      FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"f-graph-mp3-b",                       FAIL,   FAIL,   PASS,   FAIL,       FAIL,   PASS,   FAIL},
            {"f-graph-mp3-bf",                      FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},

            {"f-graph-mp3-sc-a",                    FAIL,   FAIL,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"f-graph-mp3-sc-af",                   FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},  // TODO:
            {"f-graph-mp3-sc-b",                    FAIL,   FAIL,   PASS,   FAIL,       FAIL,   PASS,   FAIL},
            {"f-graph-mp3-sc-b",                    FAIL,   FAIL,   PASS,   FAIL,       FAIL,   PASS,   FAIL},

            {"extra-sb",                            PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"extra-sb-fence",                      PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"extra-lb",                            FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"extra-lb-fence-1",                    FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"extra-lb-fence-2",                    FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"extra-mp3",                           FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"extra-mp3-fence1",                    FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"extra-mp3-fence2",                    PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"extra-mp-plus-fence",                 PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"extra-mp-plus",                       PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"extra-lb-plus",                       PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},

            {"mp3transitive3",                      FAIL,   FAIL,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"mp3transitive3-fence",                FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},

            {"old_f-graph-problem3-a",              FAIL,   PASS,   PASS,   PASS,       FAIL,   PASS,   PASS},
            {"old_f-graph-problem3-b",              PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
    };

    private static final Object[][] expectedChains = {
            {"f-graph-avvis-chains-semav",          FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},
            {"f-graph-avvis-chains-semvis",         FAIL,   FAIL,   FAIL,   FAIL,       FAIL,   FAIL,   FAIL},

            {"scopes-mp-acq-acq-a",                 PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"scopes-mp-acq-acq-b",                 FAIL,   FAIL,   FAIL,   FAIL,       PASS,   PASS,   PASS},
    };

    private static final Object[][] expectedNoChains = {
            {"f-graph-avvis-chains-semav",          PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"f-graph-avvis-chains-semvis",         PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},

            {"scopes-mp-acq-acq-a",                 PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
            {"scopes-mp-acq-acq-b",                 PASS,   PASS,   PASS,   PASS,       PASS,   PASS,   PASS},
    };

    private static final Map<String, Map<String, List<Result>>> expected = new HashMap<>();
    static {
        expected.put("chains", new HashMap<>());
        expected.put("nochains", new HashMap<>());
        for (String type : List.of("chains", "nochains")) {
            for (Object[] o : expectedAll) {
                expected.get(type).put((String) o[0], IntStream.range(1, o.length).boxed().map(i -> (Result) o[i]).toList());
            }
        }
        for (Object[] o : expectedChains) {
            expected.get("chains").put((String) o[0], IntStream.range(1, o.length).boxed().map(i -> (Result) o[i]).toList());
        }
        for (Object[] o : expectedNoChains) {
            expected.get("nochains").put((String) o[0], IntStream.range(1, o.length).boxed().map(i -> (Result) o[i]).toList());
        }
    }

    private final Printer printer = Printer.newInstance();

    @Test
    public void checkResult() throws Exception {
        for (Map.Entry<String, Map<String, List<Result>>> typeEntry : expected.entrySet()) {
            System.out.println(typeEntry.getKey());
            for (Map.Entry<String, List<Result>> programEntry : typeEntry.getValue().entrySet()) {
                String program = getRootPath("litmus/VULKAN/pvmm/" + programEntry.getKey() + ".litmus");
                System.out.println(program);
                for (int i = 0; i < programEntry.getValue().size(); i++) {
                    Result result = programEntry.getValue().get(i);
                    String model = getRootPath("cat/" + models[i] + ".cat");
                    System.out.println("    " + models[i]);
                    VerificationTask taskEager = mkTask(program, model, PROGRAM_SPEC, typeEntry.getKey());
                    try (ModelChecker mc = ModelChecker.create(taskEager, Method.EAGER)) {
                        mc.run();
                        assertEquals(result, mc.getResult());
                    }
                    VerificationTask taskLazy = mkTask(program, model, PROGRAM_SPEC, typeEntry.getKey());
                    try (ModelChecker mc = ModelChecker.create(taskLazy, Method.LAZY)) {
                        mc.run();
                        assertEquals(result, mc.getResult());
                    }
                }
            }
        }
    }

    @Test
    public void logRelations() throws Exception {
        for (Map.Entry<String, Map<String, List<Result>>> typeEntry : expected.entrySet()) {
            for (Map.Entry<String, List<Result>> programEntry : typeEntry.getValue().entrySet()) {
                String program = getRootPath("litmus/VULKAN/pvmm/" + programEntry.getKey() + ".litmus");
                System.out.println(program);
                for (int i = 0; i < programEntry.getValue().size(); i++) {
                    Result result = programEntry.getValue().get(i);
                    String modelPath = getRootPath("cat/" + models[i] + ".cat");
                    Property property = PROGRAM_SPEC;
                    if (result == FAIL) {
                        modelPath = getRootPath("cat/" + models[i] + "_cycle.cat");
                        property = CAT_SPEC;
                    }
                    VerificationTask task = mkTask(program, modelPath, property, typeEntry.getKey());
                    try (ModelChecker mc = ModelChecker.create(task, Method.EAGER)) {
                        mc.run();
                        assertTrue(mc.hasModel());
                        RelationAnalysis ra = mc.getEncodingContext().getAnalysisContext().get(RelationAnalysis.class);
                        Set<Relation> relations = task.getMemoryModel().getRelations();
                        Map<String, MutableEventGraph> data = extractRelationsData(task.getProgram(), relations, ra, mc.getProver().getModel());
                        data = translateEventIds(task.getProgram(), data);
                        log(models[i], task.getProgram(), typeEntry.getKey(), data);
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

    private void log(String model, Program program, String type, Map<String, MutableEventGraph> data) throws IOException {
        List<String> relations = data.keySet().stream().sorted().toList();
        StringBuilder sb = new StringBuilder();
        sb.append(printer.print(program));
        for (String relation : relations) {
            if (relation.matches("[a-z]+(\\#?[0-9]+[a-z_]*)?")) {
                sb.append(relation).append(": ").append(data.get(relation)).append("\n");
            }
        }
        Files.createDirectories(Path.of(getRootPath("output/data/" + type + "/" + model)));
        String filePath = getRootPath("output/data/" + type + "/" + model + "/" + program.getName() + ".log");
        Files.write(Path.of(filePath), sb.toString().getBytes());
    }

    private VerificationTask mkTask(String programPath, String modelPath, Property property, String type) throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(Configuration.builder()
                        .setOption(ENABLE_EXTENDED_RELATION_ANALYSIS, "false")
                        .setOption(ENABLE_ACTIVE_SETS, "false")
                        .build()
                )
                .withBound(1)
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat(libs.get(type)).parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(property));
    }
}
