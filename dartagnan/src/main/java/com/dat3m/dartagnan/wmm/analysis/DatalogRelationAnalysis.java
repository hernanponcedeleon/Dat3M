package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Register.UsageType;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.filter.*;
import com.dat3m.dartagnan.program.memory.VirtualMemoryObject;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.witness.graphml.WitnessGraph;
import com.dat3m.dartagnan.wmm.*;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.EventGraph;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.google.common.base.VerifyException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.io.*;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.*;
import java.util.function.Predicate;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.Arch.RISCV;
import static com.dat3m.dartagnan.program.Register.UsageType.*;
import static com.dat3m.dartagnan.program.event.Tag.*;

import com.dat3m.dartagnan.wmm.RelationNameRepository;

import static com.dat3m.dartagnan.wmm.utils.EventGraph.difference;
import static com.google.common.base.Preconditions.checkNotNull;
import static com.google.common.base.Verify.verify;
import static com.google.common.collect.Lists.reverse;
import static java.util.stream.Collectors.toList;
import static java.util.stream.IntStream.iterate;

public class DatalogRelationAnalysis implements RelationAnalysis {

    private static final Logger logger = LogManager.getLogger(DatalogRelationAnalysis.class);

    protected final VerificationTask task;
    protected final Context analysisContext;
    protected final ExecutionAnalysis exec;
    protected final AliasAnalysis alias;
    protected final Dependency dep;
    protected final WmmAnalysis wmmAnalysis;
    protected final BranchEquivalence eq;
    protected final Map<Relation, Knowledge> knowledgeMap = new HashMap<>();
    protected final EventGraph mutex = new EventGraph();
    private final Map<Relation, String> relationToDatalogName = new IdentityHashMap<>();
    private final Map<Filter, String> filterToDatalogName = new IdentityHashMap<>();
    private final Set<Relation> translatedRelations = new HashSet<>();
    private final Set<Filter> translatedFilters = new HashSet<>();
    private final Set<Relation> translatedBaseRelations = new HashSet<>();
    private final Set<String> translatedAnalyses = new HashSet<>();
    private final Map<String, String> sanitizedToOriginalName = new HashMap<>();
    static private final String LIB_NAME = "util.dl";
    static private final String MODEL_NAME = "model.dl";
    private int free_index = 0;
    private Path tempDir;
    private final Map<Integer, Event> idToEvent = new HashMap<>();


    protected DatalogRelationAnalysis(VerificationTask t, Context context, Configuration config) {
        task = checkNotNull(t);
        analysisContext = context;
        exec = context.requires(ExecutionAnalysis.class);
        alias = context.requires(AliasAnalysis.class);
        dep = context.requires(Dependency.class);
        wmmAnalysis = context.requires(WmmAnalysis.class);
        eq = analysisContext.requires(BranchEquivalence.class);
    }

    /**
     * Performs a static analysis on the relationships that may occur in an execution.
     *
     * @param task    Program, target memory model and property to check.
     * @param context Collection of static analyses already performed on {@code task} with respect to {@code memoryModel}.
     *                Should at least include the following elements:
     *                <ul>
     *                    <li>{@link ExecutionAnalysis}
     *                    <li>{@link Dependency}
     *                    <li>{@link AliasAnalysis}
     *                    <li>{@link WmmAnalysis}
     *                </ul>
     * @param config  User-defined options to further specify the behavior.
     */
    public static DatalogRelationAnalysis fromConfig(VerificationTask task, Context context, Configuration config) throws InvalidConfigurationException {
        return new DatalogRelationAnalysis(task, context, config);
    }

    private static void forFilesRead(String dir, String name, String ext, ThrowingBiConsumer<BufferedReader, BufferedReader> readerConsumer) throws IOException {
        try (BufferedReader mayReader = Files.newBufferedReader(Paths.get(dir, name + ".May" + ext)); BufferedReader mustReader = Files.newBufferedReader(Paths.get(dir, name + ".Must" + ext))) {
            readerConsumer.accept(mayReader, mustReader);
        }
    }

    private void readFile(BufferedReader reader, EventGraph set) throws IOException {
        String line;
        while ((line = reader.readLine()) != null) {
            String[] tokens = line.split("\t");
            verify(tokens.length == 2, "malformed datalog file");
            set.add(idToEvent.get(Integer.parseInt(tokens[0])), idToEvent.get(Integer.parseInt(tokens[1])));
        }
    }

    private Knowledge readKnowledge(Relation relation) {
        boolean isBase = translatedBaseRelations.contains(relation);
        boolean isCompound = translatedRelations.contains(relation);
        String name = getRelationDatalogName(relation);
        verify(isBase || isCompound, "relation " + name + " not translated");
        verify(tempDir != null, "datalog directory was not created");
        EventGraph maySet = new EventGraph();
        EventGraph mustSet = new EventGraph();
        try {
            forFilesRead(tempDir.toString(), name, isBase ? ".facts" : ".csv", (may, must) -> {
                readFile(may, maySet);
                readFile(must, mustSet);
            });
        } catch (IOException e) {
            verify(false, "could not read datalog data for " + name);
        }
        return new Knowledge(maySet, mustSet);
    }

    @Override
    public Knowledge getKnowledge(Relation relation) {
        return knowledgeMap.computeIfAbsent(relation, this::readKnowledge);
    }

    @Override
    public EventGraph getContradictions() {
        //TODO return undirected pairs
        return mutex;
    }

    @Override
    public void populateQueue(Map<Relation, List<EventGraph>> queue, Set<Relation> relations) {
        // TODO implement as a datalog pass
        Propagator p = new Propagator();
        for (Relation r : relations) {
            EventGraph may = new EventGraph();
            EventGraph must = new EventGraph();
            if (r.getDependencies().isEmpty()) {
                continue;
            }
            for (Relation c : r.getDependencies()) {
                p.setSource(c);
                p.setMay(getKnowledge(p.getSource()).getMaySet());
                p.setMust(getKnowledge(p.getSource()).getMustSet());
                NativeRelationAnalysis.Delta s = r.getDefinition().accept(p);
                may.addAll(s.may);
                must.addAll(s.must);
            }
            may.removeAll(getKnowledge(r).getMaySet());
            EventGraph must2 = difference(getKnowledge(r).getMustSet(), must);
            queue.computeIfAbsent(r, k -> new ArrayList<>()).add(EventGraph.union(may, must2));
        }
    }

    protected final class Propagator implements Definition.Visitor<NativeRelationAnalysis.Delta> {
        private Relation source;
        private EventGraph may;
        private EventGraph must;

        public Relation getSource() {
            return source;
        }

        public void setSource(Relation source) {
            this.source = source;
        }

        public EventGraph getMay() {
            return may;
        }

        public void setMay(EventGraph may) {
            this.may = may;
        }

        public EventGraph getMust() {
            return must;
        }

        public void setMust(EventGraph must) {
            this.must = must;
        }

        @Override
        public NativeRelationAnalysis.Delta visitUnion(Union union) {
            if (union.getOperands().contains(source)) {
                return new NativeRelationAnalysis.Delta(may, must);
            }
            return NativeRelationAnalysis.Delta.EMPTY;
        }

        @Override
        public NativeRelationAnalysis.Delta visitIntersection(Intersection inter) {
            final List<Relation> operands = inter.getOperands();
            if (operands.contains(source)) {
                EventGraph maySet = operands.stream()
                        .map(r -> source.equals(r) ? may : getKnowledge(r).getMaySet())
                        .sorted(Comparator.comparingInt(EventGraph::size))
                        .reduce(EventGraph::intersection)
                        .orElseThrow();
                EventGraph mustSet = operands.stream()
                        .map(r -> source.equals(r) ? must : getKnowledge(r).getMustSet())
                        .sorted(Comparator.comparingInt(EventGraph::size))
                        .reduce(EventGraph::intersection)
                        .orElseThrow();
                return new NativeRelationAnalysis.Delta(maySet, mustSet);
            }
            return NativeRelationAnalysis.Delta.EMPTY;
        }

        @Override
        public NativeRelationAnalysis.Delta visitDifference(Difference diff) {
            if (diff.getMinuend().equals(source)) {
                Knowledge k = getKnowledge(diff.getSubtrahend());
                return new NativeRelationAnalysis.Delta(difference(may, k.getMustSet()), difference(must, k.getMaySet()));
            }
            return NativeRelationAnalysis.Delta.EMPTY;
        }

        @Override
        public NativeRelationAnalysis.Delta visitComposition(Composition comp) {
            final Relation r1 = comp.getLeftOperand();
            final Relation r2 = comp.getRightOperand();
            EventGraph maySet = new EventGraph();
            EventGraph mustSet = new EventGraph();
            if (r1.equals(source)) {
                computeComposition(maySet, may, getKnowledge(r2).getMaySet(), true);
                computeComposition(mustSet, must, getKnowledge(r2).getMustSet(), false);
            }
            if (r2.equals(source)) {
                computeComposition(maySet, getKnowledge(r1).getMaySet(), may, true);
                computeComposition(mustSet, getKnowledge(r1).getMustSet(), must, false);
            }
            return new NativeRelationAnalysis.Delta(maySet, mustSet);
        }

        private void computeComposition(EventGraph result, EventGraph left, EventGraph right, final boolean isMay) {
            for (Event e1 : left.getDomain()) {
                Set<Event> update = new HashSet<>();
                for (Event e : left.getRange(e1)) {
                    if (isMay || exec.isImplied(e1, e)) {
                        update.addAll(right.getRange(e));
                    } else {
                        update.addAll(right.getRange(e).stream()
                                .filter(e2 -> exec.isImplied(e2, e)).toList());
                    }
                }
                update.removeIf(e -> exec.areMutuallyExclusive(e1, e));
                result.addRange(e1, update);
            }
        }

        @Override
        public NativeRelationAnalysis.Delta visitDomainIdentity(DomainIdentity domId) {
            if (domId.getOperand().equals(source)) {
                EventGraph maySet = new EventGraph();
                may.getDomain().forEach(e -> maySet.add(e, e));
                EventGraph mustSet = new EventGraph();
                must.apply((e1, e2) -> {
                    if (exec.isImplied(e1, e2)) {
                        mustSet.add(e1, e1);
                    }
                });
                return new NativeRelationAnalysis.Delta(maySet, mustSet);
            }
            return NativeRelationAnalysis.Delta.EMPTY;
        }

        @Override
        public NativeRelationAnalysis.Delta visitRangeIdentity(RangeIdentity rangeId) {
            if (rangeId.getOperand().equals(source)) {
                EventGraph maySet = new EventGraph();
                may.getRange().forEach(e -> maySet.add(e, e));
                EventGraph mustSet = new EventGraph();
                must.apply((e1, e2) -> {
                    if (exec.isImplied(e2, e1)) {
                        mustSet.add(e2, e2);
                    }
                });
                return new NativeRelationAnalysis.Delta(maySet, mustSet);
            }
            return NativeRelationAnalysis.Delta.EMPTY;
        }

        @Override
        public NativeRelationAnalysis.Delta visitInverse(Inverse inv) {
            if (inv.getOperand().equals(source)) {
                return new NativeRelationAnalysis.Delta(may.inverse(), must.inverse());
            }
            return NativeRelationAnalysis.Delta.EMPTY;
        }

        @Override
        public NativeRelationAnalysis.Delta visitTransitiveClosure(TransitiveClosure trans) {
            final Relation rel = trans.getDefinedRelation();
            if (trans.getOperand().equals(source)) {
                EventGraph maySet = computeTransitiveClosure(getKnowledge(rel).getMaySet(), may, true);
                EventGraph mustSet = computeTransitiveClosure(getKnowledge(rel).getMustSet(), must, false);
                return new NativeRelationAnalysis.Delta(maySet, mustSet);
            }
            return NativeRelationAnalysis.Delta.EMPTY;
        }

        private EventGraph computeTransitiveClosure(EventGraph oldOuter, EventGraph inner, boolean isMay) {
            EventGraph outer = new EventGraph(oldOuter);
            EventGraph update = inner.filter(outer::add);
            EventGraph updateComposition = new EventGraph();
            computeComposition(updateComposition, update, oldOuter, isMay);
            update.addAll(updateComposition.filter(outer::add));
            while (!update.isEmpty()) {
                EventGraph t = new EventGraph();
                computeComposition(t, inner, update, isMay);
                update = t.filter(outer::add);
            }
            return outer;
        }
    }

    @Override
    public EventGraph findTransitivelyImpliedCo(Relation co) {
        final Knowledge k = getKnowledge(co);
        EventGraph transCo = new EventGraph();
        Map<Event, Set<Event>> mustIn = k.getMustSet().getInMap();
        Map<Event, Set<Event>> mustOut = k.getMustSet().getOutMap();
        k.getMaySet().apply((e1, e2) -> {
            final MemoryEvent x = (MemoryEvent) e1;
            final MemoryEvent z = (MemoryEvent) e2;
            boolean hasIntermediary = mustOut.getOrDefault(x, Set.of()).stream().anyMatch(y -> y != x && y != z &&
                    (exec.isImplied(x, y) || exec.isImplied(z, y)) &&
                    !k.getMaySet().contains(z, y))
                    || mustIn.getOrDefault(z, Set.of()).stream().anyMatch(y -> y != x && y != z &&
                    (exec.isImplied(x, y) || exec.isImplied(z, y)) &&
                    !k.getMaySet().contains(y, x));
            if (hasIntermediary) {
                transCo.add(e1, e2);
            }
        });
        return transCo;
    }

    private String getRelationDatalogName(Relation r) {
        return getRelationDatalogName(r, false);
    }

    public String getRelationDatalogName(Relation r, boolean full) {
        String name = relationToDatalogName.computeIfAbsent(r, k -> sanitize(r.getDefinition().accept(new DatalogNameVisitor()).toString()));
        return full || name.length() < 200 ? name : "rel" + System.identityHashCode(name);
    }

    private String getFilterDatalogName(Filter f) {
        return filterToDatalogName.computeIfAbsent(f, k -> f instanceof TagFilter tf ? sanitize(tf.toString()) : "fil" + System.identityHashCode(f));
    }

    @FunctionalInterface
    private interface ThrowingBiConsumer<T, U> {
        void accept(T var1, U var2) throws IOException;
    }

    private static void forFactFilesWrite(String dir, String name, ThrowingBiConsumer<Writer, Writer> writerConsumer) throws IOException {
        try (Writer mayWriter = Files.newBufferedWriter(Paths.get(dir, name + ".May.facts")); Writer mustWriter = Files.newBufferedWriter(Paths.get(dir, name + ".Must.facts"))) {
            writerConsumer.accept(mayWriter, mustWriter);
        }
    }

    private static void addData(Writer writer, String... args) {
        try {
            writer.write(String.join("\t", args));
            writer.write('\n');
        } catch (IOException e) {
            verify(false, "could not write a data point");
        }
    }

    private static void addData(Writer writer, int... args) {
        addData(writer, Arrays.stream(args).mapToObj(String::valueOf).toArray(String[]::new));
    }

    private static void addData(Writer writer, Event... args) {
        addData(writer, Arrays.stream(args).mapToInt(Event::getGlobalId).toArray());
    }

    private void writeTag(String tag, Writer may, Writer must) {
        List<Writer> writers = List.of(may, must);
        task.getProgram().getThreadEvents().stream().filter(e -> e.hasTag(tag)).forEach(e -> writers.forEach(w -> addData(w, e)));
    }

    private void writeAnalysis(String name, Writer may, Writer must) {
        switch (name) {
            case "event_to_thread" -> {
                List<Writer> writers = List.of(may, must);
                task.getProgram().getThreads().forEach(t -> t.getEvents().stream()
                        .filter(e -> e.hasTag(VISIBLE))
                        .forEach(e -> writers.forEach(w -> addData(w, e.getGlobalId(), t.getId()))));
            }
            case "mutex" -> {
                List<Event> events = task.getProgram().getThreadEvents();
                List<Writer> writers = List.of(may, must);
                for (int i = 1; i < events.size(); i++) {
                    Event ei = events.get(i);
                    events.stream().limit(i).filter(e -> exec.areMutuallyExclusive(ei, e)).forEach(e -> writers.forEach(w -> {
                        addData(w, ei, e);
                        addData(w, e, ei);
                    }));
                }
            }
            case "implies" -> {
                List<Event> events = task.getProgram().getThreadEvents();
                List<Writer> writers = List.of(may, must);
                events.forEach(e1 -> events.stream().filter(e2 -> exec.isImplied(e1, e2)).forEach(e2 -> writers.forEach(w -> addData(w, e1, e2))));
            }
            case "jump" -> {
                List<Writer> writers = List.of(may, must);
                task.getProgram().getThreads().stream()
                        .map(t -> t.getEvents(CondJump.class))
                        .flatMap(List::stream)
                        .forEach(j -> (j instanceof IfAsJump ifJump ? ifJump.getBranchesEvents() : j.getSuccessor().getSuccessors())
                                .forEach(s -> writers
                                        .forEach(w -> addData(w, j, s))));
            }
            case "GOTO" -> {
                List<Writer> writers = List.of(may, must);
                task.getProgram().getThreads().stream()
                        .map(t -> t.getEvents(CondJump.class))
                        .flatMap(List::stream)
                        .filter(CondJump::isGoto)
                        .forEach(j -> writers.forEach(w -> addData(w, j)));
            }
            case "DEAD" -> {
                List<Writer> writers = List.of(may, must);
                task.getProgram().getThreads().stream()
                        .map(t -> t.getEvents(CondJump.class))
                        .flatMap(List::stream)
                        .filter(CondJump::isDead)
                        .forEach(j -> writers.forEach(w -> addData(w, j)));
            }
            case "THREAD" -> {
                List<Writer> writers = List.of(may, must);
                task.getProgram().getThreads().forEach(t -> writers.forEach(w -> addData(w, t.getId())));
            }
            case "VISIBLE" -> writeTag(VISIBLE, may, must);
            default -> writeTag(sanitizedToOriginalName.getOrDefault(name, name), may, must);
        }
    }

    private void deleteOnExit(Path path) {
        Runtime.getRuntime().addShutdownHook(new java.lang.Thread() {
            @Override
            public void run() {
                if (!Files.exists(path)) {
                    return;
                }
                try {
                    Files.walkFileTree(path, new SimpleFileVisitor<>() {
                        @Override
                        public FileVisitResult postVisitDirectory(Path dir, IOException exc)
                                throws IOException {
                            Files.deleteIfExists(dir);
                            return super.postVisitDirectory(dir, exc);
                        }

                        @Override
                        public FileVisitResult visitFile(Path file, BasicFileAttributes attrs)
                                throws IOException {
                            Files.deleteIfExists(file);
                            return super.visitFile(file, attrs);
                        }
                    });
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
        });
    }

    private Path writeDatalog(StringBuilder datalogProgram) throws IOException {
        tempDir = Files.createTempDirectory("datalog");
        deleteOnExit(tempDir);
        String tempDirPath = tempDir.toString();
        logger.info("using temp dir: " + tempDir);
        try (InputStream libIn = getClass().getResourceAsStream("/" + LIB_NAME)) {
            verify(libIn != null, "resource not found: %s", LIB_NAME);
            Files.copy(libIn, Paths.get(tempDirPath, LIB_NAME));
        }
        Files.writeString(Paths.get(tempDir.toString(), MODEL_NAME), datalogProgram.toString());
        for (Relation r : translatedBaseRelations) {
            forFactFilesWrite(tempDirPath, getRelationDatalogName(r), (may, must) -> {
                Knowledge k = r.getDefinition().accept(new NativeRelationAnalysis.Initializer(task.getProgram(), task.getWitness(), exec, alias, wmmAnalysis, dep, eq));
                k.getMaySet().apply((e1, e2) -> addData(may, e1, e2));
                k.getMustSet().apply((e1, e2) -> addData(must, e1, e2));
            });
        }
        for (String a : translatedAnalyses) {
            forFactFilesWrite(tempDirPath, a, (may, must) -> writeAnalysis(a, may, must));
        }
        return tempDir;
    }

    private void runDatalog(Path tempDir) throws InterruptedException, IOException {
        String command = "souffle " + Paths.get(tempDir.toString(), MODEL_NAME);
        logger.info("running datalog: " + command);
        Process process = Runtime.getRuntime().exec(new String[]{"bash", "-c", command}, null, tempDir.toFile());
        try (BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
            String line;
            while ((line = in.readLine()) != null) {
                logger.info(line);
            }
        }
        try (BufferedReader in = new BufferedReader(new InputStreamReader(process.getErrorStream()))) {
            String line;
            while ((line = in.readLine()) != null) {
                logger.warn(line);
            }
        }
        int returnCode = process.waitFor();
        verify(returnCode == 0, "datalog execution failed");
        logger.info("finished datalog");
    }

    @Override
    public void run() {
        logger.trace("Start");
        final Wmm memoryModel = task.getMemoryModel();
        StringBuilder datalogProgram = new StringBuilder("#include \"").append(LIB_NAME).append("\"\n");
        memoryModel.getRelations().stream()
                .filter(Predicate.not(translatedRelations::contains))
                .map(r -> {
                    translatedRelations.add(r);
                    return r.getDefinition().accept(new DatalogGenerator());
                })
                .forEachOrdered(datalogProgram::append);
        task.getProgram().getThreadEvents().forEach(e -> idToEvent.put(e.getGlobalId(), e));
        Path tempDir;
        try {
            tempDir = writeDatalog(datalogProgram);
        } catch (IOException e) {
            throw new VerifyException("could not write datalog");
        }
        try {
            runDatalog(tempDir);
        } catch (InterruptedException e) {
            throw new VerifyException("could not finish datalog");
        } catch (IOException e) {
            throw new VerifyException("could not start datalog");
        }
        logger.trace("End");
    }

    private String sanitize(String s) {
        assert (s != null);
        String result = VISIBLE.equals(s) ? "VISIBLE" : s.replaceAll("[\\-.]", "_").replace("__", "_VISIBLE");
        sanitizedToOriginalName.putIfAbsent(result, s);
        return result;
    }

    private class DatalogNameVisitor implements Definition.Visitor<StringBuilder>, Filter.Visitor<StringBuilder> {

        private final StringBuilder name = new StringBuilder();
        private final Map<Object, Integer> termToOffset = new HashMap<>();
        private final Map<Object, String> termToName = new HashMap<>();
        private int recursiveCount = 0;

        private boolean checkRecursion(Object target) {
            Integer offset = termToOffset.get(target);
            if (offset == null) {
                termToOffset.put(target, name.length());
                return false;
            }
            String recursiveName = termToName.computeIfAbsent(target, k -> {
                String result = "name" + recursiveCount++;
                String prefix = String.format("recursive_%s_", result);
                name.insert(offset, prefix);
                int prefixLength = prefix.length();
                termToOffset.entrySet().stream().filter(e -> e.getValue() > offset)
                        .forEach(e -> termToOffset.put(e.getKey(), e.getValue() + prefixLength));
                return result;
            });
            name.append(recursiveName);
            return true;
        }

        @Override
        public StringBuilder visitUnion(Union def) {
            if (checkRecursion(def.getDefinedRelation())) {
                return name;
            }
            verify(!def.getOperands().isEmpty());
            name.append("union_".repeat(def.getOperands().size() - 1));
            name.setLength(name.length() - 1);
            def.getOperands().stream().map(Relation::getDefinition).forEachOrdered(d -> {
                name.append("_");
                d.accept(this);
            });
            return name;
        }

        @Override
        public StringBuilder visitIntersection(Intersection def) {
            if (checkRecursion(def.getDefinedRelation())) {
                return name;
            }
            verify(!def.getOperands().isEmpty());
            name.append("intersection_".repeat(def.getOperands().size() - 1));
            name.setLength(name.length() - 1);
            def.getOperands().stream().map(Relation::getDefinition).forEachOrdered(d -> {
                name.append("_");
                d.accept(this);
            });
            return name;
        }

        @Override
        public StringBuilder visitDifference(Difference def) {
            if (checkRecursion(def.getDefinedRelation())) {
                return name;
            }
            name.append("difference");
            Stream.of(def.getMinuend(), def.getSubtrahend()).map(Relation::getDefinition).forEachOrdered(d -> {
                name.append("_");
                d.accept(this);
            });
            return name;
        }

        @Override
        public StringBuilder visitComposition(Composition def) {
            if (checkRecursion(def.getDefinedRelation())) {
                return name;
            }
            name.append("composition");
            Stream.of(def.getLeftOperand(), def.getRightOperand()).map(Relation::getDefinition).forEachOrdered(d -> {
                name.append("_");
                d.accept(this);
            });
            return name;
        }

        @Override
        public StringBuilder visitDomainIdentity(DomainIdentity def) {
            if (checkRecursion(def.getDefinedRelation())) {
                return name;
            }
            name.append("domain_");
            return def.getOperand().getDefinition().accept(this);
        }

        @Override
        public StringBuilder visitRangeIdentity(RangeIdentity def) {
            if (checkRecursion(def.getDefinedRelation())) {
                return name;
            }
            name.append("identity_range_");
            return def.getOperand().getDefinition().accept(this);
        }

        @Override
        public StringBuilder visitInverse(Inverse def) {
            if (checkRecursion(def.getDefinedRelation())) {
                return name;
            }
            name.append("inverse_");
            return def.getOperand().getDefinition().accept(this);
        }

        @Override
        public StringBuilder visitTransitiveClosure(TransitiveClosure def) {
            if (checkRecursion(def.getDefinedRelation())) {
                return name;
            }
            name.append("closure_");
            return def.getOperand().getDefinition().accept(this);
        }

        @Override
        public StringBuilder visitSetIdentity(SetIdentity def) {
            if (checkRecursion(def.getDefinedRelation())) {
                return name;
            }
            name.append("identity_");
            return def.getFilter().accept(this);
        }

        @Override
        public StringBuilder visitProduct(CartesianProduct def) {
            if (checkRecursion(def.getDefinedRelation())) {
                return name;
            }
            name.append("product_");
            def.getFirstFilter().accept(this);
            name.append("_");
            return def.getSecondFilter().accept(this);
        }

        @Override
        public StringBuilder visitFences(Fences fence) {
            if (checkRecursion(fence.getDefinedRelation())) {
                return name;
            }
            name.append("fence_");
            return fence.getFilter().accept(this);
        }

        @Override
        public StringBuilder visitFree(Free def) {
            return name.append(relationToDatalogName.computeIfAbsent(def.getDefinedRelation(), r -> "free" + free_index++));
        }

        @Override
        public StringBuilder visitEmpty(Empty def) {
            return name.append("empty");
        }

        @Override
        public StringBuilder visitProgramOrder(ProgramOrder po) {
            return name.append(RelationNameRepository.PO);
        }

        @Override
        public StringBuilder visitExternal(External ext) {
            return name.append(RelationNameRepository.EXT);
        }

        @Override
        public StringBuilder visitInternal(Internal internal) {
            return name.append(RelationNameRepository.INT);
        }

        @Override
        public StringBuilder visitInternalDataDependency(DirectDataDependency idd) {
            return name.append(RelationNameRepository.IDD);
        }

        @Override
        public StringBuilder visitAddressDependency(DirectAddressDependency addrDirect) {
            return name.append(RelationNameRepository.ADDRDIRECT);
        }

        @Override
        public StringBuilder visitControlDependency(DirectControlDependency ctrlDirect) {
            return name.append(RelationNameRepository.CTRLDIRECT);
        }

        @Override
        public StringBuilder visitReadModifyWrites(ReadModifyWrites rmw) {
            return name.append(RelationNameRepository.RMW);
        }

        @Override
        public StringBuilder visitCoherence(Coherence co) {
            return name.append(RelationNameRepository.CO);
        }

        @Override
        public StringBuilder visitReadFrom(ReadFrom rf) {
            return name.append(RelationNameRepository.RF);
        }

        @Override
        public StringBuilder visitSameLocation(SameLocation loc) {
            return name.append(RelationNameRepository.LOC);
        }

        @Override
        public StringBuilder visitCASDependency(CASDependency casDep) {
            return name.append(RelationNameRepository.CASDEP);
        }

        @Override
        public StringBuilder visitLinuxCriticalSections(LinuxCriticalSections rscs) {
            return name.append(RelationNameRepository.CRIT);
        }

        @Override
        public StringBuilder visitSameVirtualLocation(SameVirtualLocation vloc) {
            return name.append(RelationNameRepository.VLOC);
        }

        @Override
        public StringBuilder visitSameScope(SameScope sc) {
            return name.append(RelationNameRepository.SR).append("_").append(sc.getSpecificScope());
        }

        @Override
        public StringBuilder visitSyncBarrier(SyncBar sync_bar) {
            return name.append(RelationNameRepository.SYNC_BARRIER);
        }

        @Override
        public StringBuilder visitSyncWith(SyncWith sync_with) {
            return name.append(RelationNameRepository.SSW);
        }

        @Override
        public StringBuilder visitSyncFence(SyncFence sync_fen) {
            return name.append(RelationNameRepository.SYNC_FENCE);
        }

        @Override
        public StringBuilder visitTagFilter(TagFilter tagFilter) {
            return name.append(tagFilter);
        }

        @Override
        public StringBuilder visitIntersectionFilter(IntersectionFilter intersectionFilter) {
            if (checkRecursion(intersectionFilter)) {
                return name;
            }
            name.append("intersection");
            Stream.of(intersectionFilter.getLeft(), intersectionFilter.getRight()).forEachOrdered(f -> {
                name.append("_");
                f.accept(this);
            });
            return name;
        }

        @Override
        public StringBuilder visitDifferenceFilter(DifferenceFilter differenceFilter) {
            if (checkRecursion(differenceFilter)) {
                return name;
            }
            name.append("difference");
            Stream.of(differenceFilter.getLeft(), differenceFilter.getRight()).forEachOrdered(f -> {
                name.append("_");
                f.accept(this);
            });
            return name;
        }

        @Override
        public StringBuilder visitUnionFilter(UnionFilter unionFilter) {
            if (checkRecursion(unionFilter)) {
                return name;
            }
            name.append("union");
            Stream.of(unionFilter.getLeft(), unionFilter.getRight()).forEachOrdered(f -> {
                name.append("_");
                f.accept(this);
            });
            return name;
        }
    }

    private class DatalogGenerator implements Definition.Visitor<StringBuilder>, Filter.Visitor<StringBuilder> {

        private final StringBuilder program = new StringBuilder();

        private void operator(String result, String op1, String op2, String operator, boolean isResultBinary) {
            program.append(String.format("%s_OPERATOR_%s(%s, %s, %s", op2 == null ? "UNARY" : "BINARY", isResultBinary ? "BINARY" : "UNARY", operator, result, op1));
            if (op2 != null) {
                program.append(", ").append(op2);
            }
            program.append(")\n");
        }

        private void base(String name, boolean isResultBinary) {
            program.append(String.format("BASE(%s, %s)\n", name, isResultBinary ? "Binary" : "Unary"));
        }

        private void binaryRelationOperator(String result, String op1, String op2, String operator) {
            operator(result, op1, op2, operator, true);
        }

        private void binaryRelationOperator(String result, Relation op1, Relation op2, String operator) {
            binaryRelationOperator(result, getRelationDatalogName(op1), getRelationDatalogName(op2), operator);
        }

        private void binaryRelationOperator(String result, String op1, Relation op2, String operator) {
            binaryRelationOperator(result, op1, getRelationDatalogName(op2), operator);
        }

        private void unaryRelationOperator(String result, String op, String operator) {
            operator(result, op, null, operator, true);
        }

        private void unaryRelationOperator(String result, Relation op, String operator) {
            unaryRelationOperator(result, getRelationDatalogName(op), operator);
        }

        private void defineRelations(Stream<Relation> relations) {
            relations.filter(Predicate.not(translatedRelations::contains))
                    .forEachOrdered(r -> {
                        translatedRelations.add(r);
                        r.getDefinition().accept(this);
                    });
        }

        private void defineBaseRelation(Relation relation) {
            translatedBaseRelations.add(relation);
            base(getRelationDatalogName(relation), true);
        }

        private void binaryFilterComposer(String result, String op1, String op2, String operator) {
            operator(result, op1, op2, operator, true);
        }

        private void binaryFilterComposer(String result, Filter op1, Filter op2, String operator) {
            binaryFilterComposer(result, getFilterDatalogName(op1), getFilterDatalogName(op2), operator);
        }

        private void unaryFilterComposer(String result, String op, String operator) {
            operator(result, op, null, operator, true);
        }

        private void unaryFilterComposer(String result, Filter op, String operator) {
            unaryFilterComposer(result, getFilterDatalogName(op), operator);
        }

        private void binaryFilterOperator(String result, String op1, String op2, String operator) {
            operator(result, op1, op2, operator, false);
        }

        private void binaryFilterOperator(String result, Filter op1, Filter op2, String operator) {
            binaryFilterOperator(result, getFilterDatalogName(op1), getFilterDatalogName(op2), operator);
        }

        private void defineBaseFilter(String name) {
            base(name, false);
        }

        private void defineFilters(Stream<Filter> filters) {
            filters.filter(translatedFilters::add)
                    .forEachOrdered(f -> f.accept(this));
        }

        private void defineAnalyses(Stream<String> analyses) {
            analyses.filter(translatedAnalyses::add).forEachOrdered(n -> base(n, true));
        }

        private void defineTags(Stream<String> tags) {
            tags.filter(Predicate.not(translatedAnalyses::contains)).forEachOrdered(t -> {
                translatedAnalyses.add(t);
                defineBaseFilter(t);
            });
        }

        @Override
        public StringBuilder visitUnion(Union def) {
            verify(def.getOperands().size() > 1);
            defineRelations(def.getOperands().stream());
            String currentName = getRelationDatalogName(def.getDefinedRelation());
            var prevName = new Object() {
                String value = getRelationDatalogName(def.getOperands().get(0));
            };
            int[] i = {0};
            def.getOperands().stream()
                    .skip(1)
                    .limit(def.getOperands().size() - 1)
                    .map(DatalogRelationAnalysis.this::getRelationDatalogName)
                    .forEachOrdered(n -> {
                        String nextName = currentName + i[0]++;
                        binaryRelationOperator(nextName, prevName.value, n, "UNION");
                        prevName.value = nextName;
                    });
            binaryRelationOperator(currentName, prevName.value, def.getOperands().get(def.getOperands().size() - 1), "UNION");
            return program;
        }

        @Override
        public StringBuilder visitIntersection(Intersection def) {
            verify(def.getOperands().size() > 1);
            defineRelations(def.getOperands().stream());
            String currentName = getRelationDatalogName(def.getDefinedRelation());
            var prevName = new Object() {
                String value = getRelationDatalogName(def.getOperands().get(0));
            };
            int[] i = {0};
            def.getOperands().stream()
                    .skip(1)
                    .limit(def.getOperands().size() - 1)
                    .map(DatalogRelationAnalysis.this::getRelationDatalogName)
                    .forEachOrdered(n -> {
                        String nextName = currentName + i[0]++;
                        binaryRelationOperator(nextName, prevName.value, n, "INTERSECTION");
                        prevName.value = nextName;
                    });
            binaryRelationOperator(currentName, prevName.value, def.getOperands().get(def.getOperands().size() - 1), "INTERSECTION");
            return program;
        }

        @Override
        public StringBuilder visitDifference(Difference def) {
            defineRelations(Stream.of(def.getMinuend(), def.getSubtrahend()));
            binaryRelationOperator(getRelationDatalogName(def.getDefinedRelation()), def.getMinuend(), def.getSubtrahend(), "DIFFERENCE");
            return program;
        }

        @Override
        public StringBuilder visitComposition(Composition def) {
            defineRelations(Stream.of(def.getLeftOperand(), def.getRightOperand()));
            defineAnalyses(Stream.of("implies", "mutex"));
            binaryRelationOperator(getRelationDatalogName(def.getDefinedRelation()), def.getLeftOperand(), def.getRightOperand(), "COMPOSITION");
            return program;
        }

        @Override
        public StringBuilder visitDomainIdentity(DomainIdentity def) {
            defineRelations(Stream.of(def.getOperand()));
            defineAnalyses(Stream.of("implies"));
            unaryRelationOperator(getRelationDatalogName(def.getDefinedRelation()), def.getOperand(), "DOMAIN_IDENTITY");
            return program;
        }

        @Override
        public StringBuilder visitRangeIdentity(RangeIdentity def) {
            defineRelations(Stream.of(def.getOperand()));
            defineAnalyses(Stream.of("implies"));
            unaryRelationOperator(getRelationDatalogName(def.getDefinedRelation()), def.getOperand(), "RANGE_IDENTITY");
            return program;
        }

        @Override
        public StringBuilder visitInverse(Inverse def) {
            defineRelations(Stream.of(def.getOperand()));
            unaryRelationOperator(getRelationDatalogName(def.getDefinedRelation()), def.getOperand(), "INVERSE");
            return program;
        }

        @Override
        public StringBuilder visitTransitiveClosure(TransitiveClosure def) {
            defineRelations(Stream.of(def.getOperand()));
            defineAnalyses(Stream.of("implies", "mutex"));
            unaryRelationOperator(getRelationDatalogName(def.getDefinedRelation()), def.getOperand(), "CLOSURE");
            return program;
        }

        @Override
        public StringBuilder visitSetIdentity(SetIdentity def) {
            defineFilters(Stream.of(def.getFilter()));
            unaryFilterComposer(getRelationDatalogName(def.getDefinedRelation()), def.getFilter(), "IDENTITY");
            return program;
        }

        @Override
        public StringBuilder visitProduct(CartesianProduct def) {
            defineFilters(Stream.of(def.getFirstFilter(), def.getSecondFilter()));
            defineAnalyses(Stream.of("mutex"));
            binaryFilterComposer(getRelationDatalogName(def.getDefinedRelation()), def.getFirstFilter(), def.getSecondFilter(), "PRODUCT");
            return program;
        }

        @Override
        public StringBuilder visitFences(Fences fence) {
            Filter filter = fence.getFilter();
            defineFilters(Stream.of(filter, Filter.byTag(VISIBLE)));
            defineAnalyses(Stream.of("mutex, implies"));
            return program.append(String.format("FENCES(%s, %s)\n", getRelationDatalogName(fence.getDefinedRelation()), getFilterDatalogName(filter)));
        }

        @Override
        public StringBuilder visitFree(Free def) {
            return program.append(String.format("FREE(%s)\n", getRelationDatalogName(def.getDefinedRelation())));
        }

        @Override
        public StringBuilder visitEmpty(Empty def) {
            return program.append(String.format("EMPTY(%s)\n", getRelationDatalogName(def.getDefinedRelation())));
        }

        @Override
        public StringBuilder visitProgramOrder(ProgramOrder po) {
            Filter filter = po.getFilter();
            defineFilters(Stream.of(filter));
            defineAnalyses(Stream.of("mutex", "event_to_thread"));
            return program.append(String.format("PO(%s, %s)\n", getRelationDatalogName(po.getDefinedRelation()), getFilterDatalogName(filter)));
        }

        @Override
        public StringBuilder visitExternal(External ext) {
            defineTags(Stream.of("THREAD"));
            defineAnalyses(Stream.of("mutex", "event_to_thread"));
            defineFilters(Stream.of(Filter.byTag(VISIBLE)));
            return program.append(String.format("EXT(%s)\n", getRelationDatalogName(ext.getDefinedRelation())));
        }

        @Override
        public StringBuilder visitInternal(Internal internal) {
            defineTags(Stream.of("THREAD"));
            defineAnalyses(Stream.of("mutex", "event_to_thread"));
            defineFilters(Stream.of(Filter.byTag(VISIBLE)));
            return program.append(String.format("INT(%s)\n", getRelationDatalogName(internal.getDefinedRelation())));
        }

        @Override
        public StringBuilder visitInternalDataDependency(DirectDataDependency idd) {
            defineBaseRelation(idd.getDefinedRelation());
            return program;
        }

        @Override
        public StringBuilder visitAddressDependency(DirectAddressDependency addrDirect) {
            defineBaseRelation(addrDirect.getDefinedRelation());
            return program;
        }

        @Override
        public StringBuilder visitControlDependency(DirectControlDependency ctrlDirect) {
            defineBaseRelation(ctrlDirect.getDefinedRelation());
            return program;
        }

        @Override
        public StringBuilder visitReadModifyWrites(ReadModifyWrites rmw) {
            defineBaseRelation(rmw.getDefinedRelation());
            return program;
        }

        @Override
        public StringBuilder visitCoherence(Coherence co) {
            defineBaseRelation(co.getDefinedRelation());
            return program;
        }

        @Override
        public StringBuilder visitReadFrom(ReadFrom rf) {
            defineBaseRelation(rf.getDefinedRelation());
            return program;
        }

        @Override
        public StringBuilder visitSameLocation(SameLocation loc) {
            defineBaseRelation(loc.getDefinedRelation());
            return program;
        }

        @Override
        public StringBuilder visitCASDependency(CASDependency casDep) {
            defineBaseRelation(casDep.getDefinedRelation());
            return program;
        }

        @Override
        public StringBuilder visitLinuxCriticalSections(LinuxCriticalSections rscs) {
            defineBaseRelation(rscs.getDefinedRelation());
            return program;
        }

        @Override
        public StringBuilder visitSameVirtualLocation(SameVirtualLocation vloc) {
            defineBaseRelation(vloc.getDefinedRelation());
            return program;
        }

        @Override
        public StringBuilder visitSameScope(SameScope sc) {
            defineBaseRelation(sc.getDefinedRelation());
            return program;
        }

        @Override
        public StringBuilder visitSyncBarrier(SyncBar sync_bar) {
            defineBaseRelation(sync_bar.getDefinedRelation());
            return program;
        }

        @Override
        public StringBuilder visitSyncWith(SyncWith sync_with) {
            defineBaseRelation(sync_with.getDefinedRelation());
            return program;
        }

        @Override
        public StringBuilder visitSyncFence(SyncFence sync_fen) {
            defineBaseRelation(sync_fen.getDefinedRelation());
            return program;
        }

        @Override
        public StringBuilder visitTagFilter(TagFilter tagFilter) {
            defineTags(Stream.of(sanitize(tagFilter.toString())));
            return program;
        }

        @Override
        public StringBuilder visitIntersectionFilter(IntersectionFilter intersectionFilter) {
            defineFilters(Stream.of(intersectionFilter.getLeft(), intersectionFilter.getRight()));
            binaryFilterOperator(getFilterDatalogName(intersectionFilter), intersectionFilter.getLeft(), intersectionFilter.getRight(), "INTERSECTION");
            return program;
        }

        @Override
        public StringBuilder visitDifferenceFilter(DifferenceFilter differenceFilter) {
            defineFilters(Stream.of(differenceFilter.getLeft(), differenceFilter.getRight()));
            binaryFilterOperator(getFilterDatalogName(differenceFilter), differenceFilter.getLeft(), differenceFilter.getRight(), "DIFFERENCE");
            return program;
        }

        @Override
        public StringBuilder visitUnionFilter(UnionFilter unionFilter) {
            defineFilters(Stream.of(unionFilter.getLeft(), unionFilter.getRight()));
            binaryFilterOperator(getFilterDatalogName(unionFilter), unionFilter.getLeft(), unionFilter.getRight(), "UNION");
            return program;
        }
    }

    @Override
    public void runExtended() {
        verify(false, "extended analysis unimplemented");
    }

    private long countSet(String type) {
        String command = String.format("( find %s/ \\( -name '*.%s.facts' -o -name '*.%s.csv' \\) -print0 | xargs -0 cat ) | wc -l", tempDir, type, type);
        String line = null;
        try {
            Process process = Runtime.getRuntime().exec(new String[]{"bash", "-c", command});
            try (BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                line = in.readLine();
            }
            int returnCode = process.waitFor();
            verify(returnCode == 0, "set counting failed with error code " + returnCode);
        } catch (InterruptedException | IOException e) {
            e.printStackTrace();
            verify(false, "could not calculate " + type + " set size" + e.getMessage());
        }
        verify(line != null, "could not calculate " + type + " set size");
        return Long.parseLong(line);
    }

    @Override
    public long countMaySet() {
        return countSet("May");
    }

    @Override
    public long countMustSet() {
        return countSet("Must");
    }
}
