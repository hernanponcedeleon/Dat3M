package com.dat3m.dartagnan.pvmm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.ProgramPrinter;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import com.dat3m.dartagnan.task.SMTModelChecker;
import com.dat3m.dartagnan.task.Task;
import com.dat3m.dartagnan.task.verification.AssumeSolver;
import com.dat3m.dartagnan.task.verification.VerificationStatus;
import com.dat3m.dartagnan.task.verification.VerificationTask;
import com.dat3m.dartagnan.task.verification.VerificationTaskSolver;
import com.dat3m.dartagnan.test.TestHelper;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.definition.Intersection;
import com.dat3m.dartagnan.wmm.definition.TransitiveClosure;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.java_smt.api.Model;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.Method.EAGER;
import static com.dat3m.dartagnan.configuration.Method.LAZY;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.test.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.ID;
import static java.util.stream.Collectors.toMap;
import static org.junit.Assert.*;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.*;

public class PvmmTest {

    private static final Map<String, Map<String, Map<String, VerificationStatus>>> expected = new HashMap<>();
    static {
        try {
            expected.put("chains", readFile("expected-chains"));
            expected.put("nochains", readFile("expected-nochains"));
            Map<String, Map<String, VerificationStatus>> all = readFile("expected-all");
            expected.get("chains").putAll(all);
            expected.get("nochains").putAll(all);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static final Map<String, Map<String, Map<String, VerificationStatus>>> expectedRaces = new HashMap<>();
    static {
        try {
            expectedRaces.put("chains", readFile("expected-races-chains"));
            expectedRaces.put("nochains", readFile("expected-races-nochains"));
            Map<String, Map<String, VerificationStatus>> all = readFile("expected-races-all");
            expectedRaces.get("chains").putAll(all);
            expectedRaces.get("nochains").putAll(all);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static Map<String, Map<String, VerificationStatus>> readFile(String f) throws IOException {
        Path file = getRootPath("litmus/VULKAN/pvmm/" + f + ".csv");
        Map<String, Map<String, VerificationStatus>> result = new HashMap<>();
        try (BufferedReader br = new BufferedReader(new FileReader(file.toFile()))) {
            String line = br.readLine();
            assertNotNull(line);
            String[] models = line.split(",");
            while ((line = br.readLine()) != null) {
                if (!line.isBlank()) {
                    String[] values = line.split(",");
                    if (values.length > 0) {
                        Map<String, VerificationStatus> data = new HashMap<>();
                        for (int i = 1; i < models.length; i++) {
                            data.put(models[i], VerificationStatus.valueOf(values[i]));
                        }
                        result.put(values[0], data);
                    }
                }
            }
        }
        return result;
    }

    private final ProgramPrinter printer = ProgramPrinter.newInstance();

    @Test
    public void checkRace() throws Exception {
        for (Map.Entry<String, Map<String, Map<String, VerificationStatus>>> typeEntry : expectedRaces.entrySet()) {
            System.out.println(typeEntry.getKey());
            for (Map.Entry<String, Map<String, VerificationStatus>> programEntry : typeEntry.getValue().entrySet()) {
                Path programPath = getRootPath("litmus/VULKAN/pvmm/" + programEntry.getKey() + ".litmus");
                System.out.println(programPath);
                for (Map.Entry<String, VerificationStatus> resultEntry : programEntry.getValue().entrySet()) {
                    VerificationStatus result = resultEntry.getValue() == PASS ? FAIL : PASS;
                    String suffix = typeEntry.getKey().equals("chains") ? "-chains" : "";
                    Path model = getRootPath("cat/" + resultEntry.getKey() + suffix + ".cat");
                    System.out.println("    " + resultEntry.getKey());
                    Program program = TestHelper.parseProgram(programPath);
                    Wmm mcm = TestHelper.parseWmm(model);
                    VerificationTask taskEager = mkTask(program, mcm, CAT_SPEC);
                    try (VerificationTaskSolver solver = VerificationTaskSolver.createWithMethod(taskEager, EAGER)) {
                        solver.run();
                        if (!result.equals(solver.getResult().getStatus())) {
                            System.out.println("Expected: " + result + " Actual: " + solver.getResult());
                        }
                        assertEquals(result, solver.getResult().getStatus());
                    }
                    program = TestHelper.parseProgram(programPath);
                    mcm = TestHelper.parseWmm(model);
                    VerificationTask taskLazy = mkTask(program, mcm, CAT_SPEC);
                    try (VerificationTaskSolver solver = VerificationTaskSolver.createWithMethod(taskLazy, LAZY)) {
                        solver.run();
                        if (!result.equals(solver.getResult().getStatus())) {
                            System.out.println("Expected: " + result + " Actual: " + solver.getResult());
                        }
                        assertEquals(result, solver.getResult().getStatus());
                    }
                }
            }
        }
    }

    @Test
    public void checkResult() throws Exception {
        for (Map.Entry<String, Map<String, Map<String, VerificationStatus>>> typeEntry : expected.entrySet()) {
            System.out.println(typeEntry.getKey());
            for (Map.Entry<String, Map<String, VerificationStatus>> programEntry : typeEntry.getValue().entrySet()) {
                Path programPath = getRootPath("litmus/VULKAN/pvmm/" + programEntry.getKey() + ".litmus");
                System.out.println(programPath);
                for (Map.Entry<String, VerificationStatus> resultEntry : programEntry.getValue().entrySet()) {
                    VerificationStatus result = resultEntry.getValue();
                    String suffix = typeEntry.getKey().equals("chains") ? "-chains" : "";
                    Path model = getRootPath("cat/" + resultEntry.getKey() + suffix + ".cat");
                    System.out.println("    " + resultEntry.getKey());
                    Program program = TestHelper.parseProgram(programPath);
                    Wmm mcm = TestHelper.parseWmm(model);
                    VerificationTask taskEager = mkTask(program, mcm, PROGRAM_SPEC);
                    try (VerificationTaskSolver solver = VerificationTaskSolver.createWithMethod(taskEager, EAGER)) {
                        solver.run();
                        if (!result.equals(solver.getResult().getStatus())) {
                            System.out.println("Expected: " + result + " Actual: " + solver.getResult());
                        }
                        assertEquals(result, solver.getResult().getStatus());
                    }
                    program = TestHelper.parseProgram(programPath);
                    mcm = TestHelper.parseWmm(model);
                    VerificationTask taskLazy = mkTask(program, mcm, PROGRAM_SPEC);
                    try (VerificationTaskSolver solver = VerificationTaskSolver.createWithMethod(taskLazy, LAZY)) {
                        solver.run();
                        if (!result.equals(solver.getResult().getStatus())) {
                            System.out.println("Expected: " + result + " Actual: " + solver.getResult());
                        }
                        assertEquals(result, solver.getResult().getStatus());
                    }
                }
            }
        }
    }

    @Test
    public void logRelations() throws Exception {
        for (Map.Entry<String, Map<String, Map<String, VerificationStatus>>> typeEntry : expected.entrySet()) {
            for (Map.Entry<String, Map<String, VerificationStatus>> programEntry : typeEntry.getValue().entrySet()) {
                Path programPath = getRootPath("litmus/VULKAN/pvmm/" + programEntry.getKey() + ".litmus");
                System.out.println(programPath);
                for (Map.Entry<String, VerificationStatus> resultEntry : programEntry.getValue().entrySet()) {
                    Path modelPath = getRootPath("cat/" + resultEntry.getKey() + ".cat");
                    System.out.println(modelPath);
                    mkLogRelationsTask(programPath, typeEntry.getKey(), resultEntry.getKey(), resultEntry.getValue(), true);
                }
            }
        }
    }

    private void mkLogRelationsTask(Path programPath, String modelType, String model, VerificationStatus result, boolean locallyConsistent) throws Exception {
        String suffix = modelType.equals("chains") ? "-chains" : "";
        Path modelPath = getRootPath("cat/" + model + suffix + ".cat");
        Program program = TestHelper.parseProgram(programPath);
        Wmm mcm = TestHelper.parseWmm(modelPath);
        Property property = PROGRAM_SPEC;
        if (result == FAIL) {
            removeAxiom(mcm, "racy");
            Axiom axiomCycle = removeAxiom(mcm, "consistency-cycle");
            if (axiomCycle == null) {
                axiomCycle = removeAxiom(mcm, "consistent-locord");
            }
            if (axiomCycle != null) {
                Relation transitive = mcm.addDefinition(new TransitiveClosure(mcm.newRelation(), axiomCycle.getRelation()));
                Relation cycle = mcm.addDefinition(new Intersection(mcm.newRelation("cycle"), mcm.getRelation(ID), transitive));
                mcm.addConstraint(new Emptiness(cycle, true, true));
            }
            Axiom axiomRf = removeAxiom(mcm, "consistency-rf");
            if (axiomRf != null) {
                mcm.addConstraint(new Emptiness(axiomRf.getRelation(), true, true));
            }
            Axiom axiomAtomic = removeAxiom(mcm, "atomic");
            if (axiomAtomic == null) {
                axiomAtomic = removeAxiom(mcm, "atomicity");
            }
            if (axiomAtomic != null) {
                mcm.addConstraint(new Emptiness(axiomAtomic.getRelation(), true, true));
            }
            Axiom axiomCo = removeAxiom(mcm, "consistent-co-locord");
            if (axiomCo != null) {
                mcm.addConstraint(new Emptiness(axiomCo.getRelation(), true, true));
            }
            Axiom irreflexiveLocord = removeAxiom(mcm, "consistent-communication");
            if (irreflexiveLocord != null) {
                mcm.addConstraint(new Emptiness(irreflexiveLocord.getRelation(), true, true));
            }
            Axiom irreflexiveIthb = removeAxiom(mcm, "consistent-ithb");
            if (irreflexiveIthb != null) {
                mcm.addConstraint(new Emptiness(irreflexiveIthb.getRelation(), true, true));
            }
            program.setFilterSpecification(program.getSpecification());
            property = CAT_SPEC;
        }
        VerificationTask task = mkTask(program, mcm, property, locallyConsistent);
        try (VerificationTaskSolver solver = VerificationTaskSolver.createWithMethod(task, EAGER)) {
            solver.run();
            SMTModelChecker checker = (SMTModelChecker) solver.verifier;
            if (!locallyConsistent) {
                assertFalse(checker.getProver().isUnsat());
            }
            if (!checker.getProver().isUnsat()) {
                RelationAnalysis ra = ((AssumeSolver)solver.verifier).analysisContext.get(RelationAnalysis.class);
                Set<Relation> relations = task.getMemoryModel().getRelations();
                Map<String, MutableEventGraph> data = extractRelationsData(task.getProgram(), relations, ra, checker.getProver().getModel());
                data = translateEventIds(task.getProgram(), data);
                log("data", model, task.getProgram(), modelType, data);
                return;
            }
        }
        mkLogRelationsTask(programPath, modelType, model, result, false);
    }

    @Test
    public void logRaces() throws Exception {
        for (Map.Entry<String, Map<String, Map<String, VerificationStatus>>> typeEntry : expectedRaces.entrySet()) {
            for (Map.Entry<String, Map<String, VerificationStatus>> programEntry : typeEntry.getValue().entrySet()) {
                Path programPath = getRootPath("litmus/VULKAN/pvmm/" + programEntry.getKey() + ".litmus");
                System.out.println(programPath);
                for (Map.Entry<String, VerificationStatus> resultEntry : programEntry.getValue().entrySet()) {
                    VerificationStatus result = resultEntry.getValue() == PASS ? FAIL : PASS;
                    doLogRaces(programPath, typeEntry.getKey(), resultEntry.getKey(), result, false);
                }
            }
        }
    }

    private void doLogRaces(Path programPath, String modelType, String model, VerificationStatus result, boolean asmoFix) throws Exception {
        String suffix = modelType.equals("chains") ? "-chains" : "";
        Path modelPath = getRootPath("cat/" + model + suffix + ".cat");
        System.out.println(modelPath);
        Program program = TestHelper.parseProgram(programPath);
        Wmm mcm = TestHelper.parseWmm(modelPath);
        if (asmoFix) {
            removeAxiom(mcm, "consistent-asmo");
        }
        Property property = CAT_SPEC;
        if (result == PASS) {
            property = PROGRAM_SPEC;
            program.setSpecification(Program.SpecificationType.EXISTS, program.getFilterSpecification());
        }
        VerificationTask task = mkTask(program, mcm, property);
        try (VerificationTaskSolver solver = VerificationTaskSolver.createWithMethod(task, EAGER)) {
            solver.run();
            SMTModelChecker checker = (SMTModelChecker) solver.verifier;
            if (asmoFix) {
                assertFalse(checker.getProver().isUnsat());
            }
            if (!checker.getProver().isUnsat()) {
                RelationAnalysis ra = ((AssumeSolver)solver.verifier).analysisContext.get(RelationAnalysis.class);
                Set<Relation> relations = task.getMemoryModel().getRelations();
                Map<String, MutableEventGraph> data = extractRelationsData(task.getProgram(), relations, ra, checker.getProver().getModel());
                data = translateEventIds(task.getProgram(), data);
                log("races", model, task.getProgram(), modelType, data);
                return;
            }
            doLogRaces(programPath, modelType, model, result, true);
        }
    }

    private Axiom removeAxiom(Wmm wmm, String name) {
        Optional<Axiom> axiom = wmm.getConstraints().stream()
                .filter(c -> c instanceof Axiom)
                .map(c -> (Axiom)c)
                .filter(c -> name.equals(c.getName()))
                .findFirst();
        if (axiom.isPresent()) {
            wmm.removeConstraint(axiom.get());
            return axiom.get();
        }
        return null;
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

    private void log(String dir, String model, Program program, String type, Map<String, MutableEventGraph> data) throws IOException {
        List<String> relations = data.keySet().stream().sorted().toList();
        StringBuilder sb = new StringBuilder();
        sb.append(printer.print(program));
        for (String relation : relations) {
            if (relation.matches("[a-z-]+(\\#?[0-9]+[a-z_]*)?")) {
                sb.append(relation).append(": ").append(data.get(relation)).append("\n");
            }
        }
        Files.createDirectories(getRootPath("output/" + dir + "/" + type + "/" + model));
        Path filePath = getRootPath("output/" + dir + "/" + type + "/" + model + "/" + program.getName() + ".log");
        Files.write(filePath, sb.toString().getBytes());
    }

    private VerificationTask mkTask(Program program, Wmm mcm, Property property) throws Exception {
        return mkTask(program, mcm, property, true);
    }

    private VerificationTask mkTask(Program program, Wmm mcm, Property property, boolean locallyConsistent) throws Exception {
        Task.TaskBuilder builder = Task.builder()
                .withConfig(Configuration.builder()
                        .setOption(ENABLE_EXTENDED_RELATION_ANALYSIS, "false")
                        .setOption(ENABLE_ACTIVE_SETS, "false")
                        .setOption(WMM_LOCALLY_CONSISTENT, Boolean.toString(locallyConsistent))
                        .build()
                )
                .withBound(1)
                .withTarget(Arch.VULKAN);
        return builder.build(program, mcm, EnumSet.of(property));
    }

    //@Test
    public void myTest() throws Exception {
        Path programPath = getRootPath("litmus/VULKAN/pvmm/tmp2.litmus");
        Path model = getRootPath("cat/vulkan-fixed.cat");
        Program program = TestHelper.parseProgram(programPath);
        Wmm mcm = TestHelper.parseWmm(model);
        VerificationTask taskEager = mkTask(program, mcm, PROGRAM_SPEC);
        try (VerificationTaskSolver solver = VerificationTaskSolver.createWithMethod(taskEager, EAGER)) {
            solver.run();
            System.out.println(printer.print(taskEager.getProgram()));
            System.out.println(solver.getResult());
            RelationAnalysis ra = ((AssumeSolver)solver.verifier).analysisContext.get(RelationAnalysis.class);
            Set<Relation> relations = taskEager.getMemoryModel().getRelations();
            SMTModelChecker checker = (SMTModelChecker) solver.verifier;
            Map<String, MutableEventGraph> data = extractRelationsData(taskEager.getProgram(), relations, ra, checker.getProver().getModel());
            for (Map.Entry<String, MutableEventGraph> e : data.entrySet().stream().sorted(Map.Entry.comparingByKey()).toList()){
                System.out.println(e.getKey() + ": " + e.getValue());
            }
        }
    }
}
