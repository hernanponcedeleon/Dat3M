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
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
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
            verify(false, "could not read datalog data for " + name + isBase);
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
            EventGraph next;
            EventGraph outer = new EventGraph(oldOuter);
            outer.addAll(inner);
            for (EventGraph current = inner; !current.isEmpty(); current = next) {
                next = new EventGraph();
                for (Event e1 : current.getDomain()) {
                    Set<Event> update = new HashSet<>();
                    for (Event e2 : current.getRange(e1)) {
                        if (isMay) {
                            update.addAll(outer.getRange(e2));
                        } else {
                            boolean implies = exec.isImplied(e1, e2);
                            update.addAll(outer.getRange(e2).stream()
                                    .filter(e -> implies || exec.isImplied(e, e2))
                                    .toList());
                        }
                    }
                    Set<Event> known = outer.getRange(e1);
                    update.removeIf(e -> known.contains(e) || exec.areMutuallyExclusive(e1, e));
                    if (!update.isEmpty()) {
                        next.addRange(e1, update);
                    }
                }
                outer.addAll(next);
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
        String name = relationToDatalogName.computeIfAbsent(r, k -> sanitize(r.getDefinition().accept(new DatalogNameVisitor()).toString()));
        return name.length() < 200 ? name : "rel" + System.identityHashCode(name);
    }

    public String getRelationDatalogName(Relation r, boolean full) {
        String name = relationToDatalogName.computeIfAbsent(r, k -> sanitize(r.getDefinition().accept(new DatalogNameVisitor()).toString()));
        return full || name.length() < 200 ? name : "rel" + System.identityHashCode(name);
    }

    private String getFilterDatalogName(Filter f) {
        return filterToDatalogName.computeIfAbsent(f, k -> sanitize(f.accept(new DatalogNameVisitor()).toString()));
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

    private Path writeDatalog(StringBuilder datalogProgram) throws IOException {
        tempDir = Files.createTempDirectory("datalog");
        String tempDirPath = tempDir.toString();
        logger.info("using temp dir: " + tempDir);
        try (InputStream libIn = getClass().getResourceAsStream("/" + LIB_NAME)) {
            verify(libIn != null, "resource not found: %s", LIB_NAME);
            Files.copy(libIn, Paths.get(tempDirPath, LIB_NAME));
        }
        Files.writeString(Paths.get(tempDir.toString(), MODEL_NAME), datalogProgram.toString());
        for (Relation r : translatedBaseRelations) {
            forFactFilesWrite(tempDirPath, getRelationDatalogName(r), (may, must) -> r.getDefinition().accept(new Initializer(may, must)));
        }
        for (String a : translatedAnalyses) {
            forFactFilesWrite(tempDirPath, a, (may, must) -> writeAnalysis(a, may, must));
        }
        return tempDir;
    }

    private void runDatalog(Path tempDir) throws InterruptedException, IOException {
        String command = "souffle " + Paths.get(tempDir.toString(), MODEL_NAME);
        logger.info("running datalog: " + command);
        Process process = Runtime.getRuntime().exec(command, null, tempDir.toFile());
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
        String result = VISIBLE.equals(s) ? "VISIBLE" : s.replace('-', '_').replace("__", "_VISIBLE");
        sanitizedToOriginalName.putIfAbsent(result, s);
        return result;
    }

    private class DatalogNameVisitor implements Definition.Visitor<StringBuilder>, Filter.Visitor<StringBuilder> {

        private final StringBuilder name = new StringBuilder();

        @Override
        public StringBuilder visitUnion(Union def) {
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
            name.append("difference");
            Stream.of(def.getMinuend(), def.getSubtrahend()).map(Relation::getDefinition).forEachOrdered(d -> {
                name.append("_");
                d.accept(this);
            });
            return name;
        }

        @Override
        public StringBuilder visitComposition(Composition def) {
            name.append("composition");
            Stream.of(def.getLeftOperand(), def.getRightOperand()).map(Relation::getDefinition).forEachOrdered(d -> {
                name.append("_");
                d.accept(this);
            });
            return name;
        }

        @Override
        public StringBuilder visitDomainIdentity(DomainIdentity def) {
            name.append("domain_");
            return def.getOperand().getDefinition().accept(this);
        }

        @Override
        public StringBuilder visitRangeIdentity(RangeIdentity def) {
            name.append("identity_range_");
            return def.getOperand().getDefinition().accept(this);
        }

        @Override
        public StringBuilder visitInverse(Inverse def) {
            name.append("inverse_");
            return def.getOperand().getDefinition().accept(this);
        }

        @Override
        public StringBuilder visitTransitiveClosure(TransitiveClosure def) {
            name.append("closure_");
            return def.getOperand().getDefinition().accept(this);
        }

        @Override
        public StringBuilder visitSetIdentity(SetIdentity def) {
            name.append("identity_");
            return def.getFilter().accept(this);
        }

        @Override
        public StringBuilder visitProduct(CartesianProduct def) {
            name.append("product_");
            def.getFirstFilter().accept(this);
            name.append("_");
            return def.getSecondFilter().accept(this);
        }

        @Override
        public StringBuilder visitFences(Fences fence) {
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
            name.append("intersection");
            Stream.of(intersectionFilter.getLeft(), intersectionFilter.getRight()).forEachOrdered(f -> {
                name.append("_");
                f.accept(this);
            });
            return name;
        }

        @Override
        public StringBuilder visitDifferenceFilter(DifferenceFilter differenceFilter) {
            name.append("difference");
            Stream.of(differenceFilter.getLeft(), differenceFilter.getRight()).forEachOrdered(f -> {
                name.append("_");
                f.accept(this);
            });
            return name;
        }

        @Override
        public StringBuilder visitUnionFilter(UnionFilter unionFilter) {
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
            program.append(op2 == null ? "UNARY" : "BINARY").append("_OPERATOR_").append(isResultBinary ? "BINARY" : "UNARY").append("(").append(operator).append(", ").append(result).append(", ").append(op1);
            if (op2 != null) {
                program.append(", ").append(op2);
            }
            program.append(")\n");
        }

        private void base(String name, boolean isResultBinary) {
            program.append("BASE(").append(name).append(", ").append(isResultBinary ? "Binary" : "Unary").append(")\n");
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

        private void defineBaseRelation(String name) {
            base(name, true);
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
            analyses.filter(translatedAnalyses::add).forEachOrdered(this::defineBaseRelation);
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
            return program.append("FENCES(fencerel, ").append(getFilterDatalogName(filter)).append(")\n");
        }

        @Override
        public StringBuilder visitFree(Free def) {
            return program.append("FREE(").append(getRelationDatalogName(def.getDefinedRelation())).append(")\n");
        }

        @Override
        public StringBuilder visitEmpty(Empty def) {
            return program.append("FREE(empty)\n");
        }

        @Override
        public StringBuilder visitProgramOrder(ProgramOrder po) {
            Filter filter = po.getFilter();
            defineFilters(Stream.of(filter));
            defineAnalyses(Stream.of("mutex"));
            return program.append("PO(").append(sanitize(RelationNameRepository.PO)).append(", ").append(getFilterDatalogName(filter)).append(")\n");
        }

        @Override
        public StringBuilder visitExternal(External ext) {
            defineTags(Stream.of("THREAD"));
            defineAnalyses(Stream.of("mutex", "event_to_thread"));
            defineFilters(Stream.of(Filter.byTag(VISIBLE)));
            return program.append("EXT(").append(sanitize(RelationNameRepository.EXT)).append(")\n");
        }

        @Override
        public StringBuilder visitInternal(Internal internal) {
            defineTags(Stream.of("THREAD"));
            defineAnalyses(Stream.of("mutex", "event_to_thread"));
            defineFilters(Stream.of(Filter.byTag(VISIBLE)));
            return program.append("INT(").append(sanitize(RelationNameRepository.INT)).append(")\n");
        }

        @Override
        public StringBuilder visitInternalDataDependency(DirectDataDependency idd) {
            translatedBaseRelations.add(idd.getDefinedRelation());
            defineBaseRelation(RelationNameRepository.IDD);
            return program;
        }

        @Override
        public StringBuilder visitAddressDependency(DirectAddressDependency addrDirect) {
            translatedBaseRelations.add(addrDirect.getDefinedRelation());
            defineBaseRelation(RelationNameRepository.ADDRDIRECT);
            return program;
        }

        @Override
        public StringBuilder visitControlDependency(DirectControlDependency ctrlDirect) {
            translatedBaseRelations.add(ctrlDirect.getDefinedRelation());
            defineBaseRelation(RelationNameRepository.CTRLDIRECT);
            return program;
            /*
            defineTags(Stream.of("GOTO", "DEAD"));
            defineAnalyses(Stream.of("mutex", "jump"));
            return program.append("CTRLDIRECT(").append(sanitize(RelationNameRepository.CTRLDIRECT)).append(")\n");*/
        }

        @Override
        public StringBuilder visitReadModifyWrites(ReadModifyWrites rmw) {
            translatedBaseRelations.add(rmw.getDefinedRelation());
            defineBaseRelation(RelationNameRepository.RMW);
            return program;
        }

        @Override
        public StringBuilder visitCoherence(Coherence co) {
            translatedBaseRelations.add(co.getDefinedRelation());
            defineBaseRelation(RelationNameRepository.CO);
            return program;
        }

        @Override
        public StringBuilder visitReadFrom(ReadFrom rf) {
            translatedBaseRelations.add(rf.getDefinedRelation());
            defineBaseRelation(RelationNameRepository.RF);
            return program;
        }

        @Override
        public StringBuilder visitSameLocation(SameLocation loc) {
            translatedBaseRelations.add(loc.getDefinedRelation());
            defineBaseRelation(RelationNameRepository.LOC);
            return program;
        }

        @Override
        public StringBuilder visitCASDependency(CASDependency casDep) {
            translatedBaseRelations.add(casDep.getDefinedRelation());
            defineBaseRelation(RelationNameRepository.CASDEP);
            return program;
        }

        @Override
        public StringBuilder visitLinuxCriticalSections(LinuxCriticalSections rscs) {
            translatedBaseRelations.add(rscs.getDefinedRelation());
            defineBaseRelation(RelationNameRepository.CRIT);
            return program;
        }

        @Override
        public StringBuilder visitSameVirtualLocation(SameVirtualLocation vloc) {
            translatedBaseRelations.add(vloc.getDefinedRelation());
            defineBaseRelation(RelationNameRepository.VLOC);
            return program;
        }

        @Override
        public StringBuilder visitSameScope(SameScope sc) {
            translatedBaseRelations.add(sc.getDefinedRelation());
            defineBaseRelation(RelationNameRepository.SR + "_" + sc.getSpecificScope());
            return program;
        }

        @Override
        public StringBuilder visitSyncBarrier(SyncBar sync_bar) {
            translatedBaseRelations.add(sync_bar.getDefinedRelation());
            defineBaseRelation(RelationNameRepository.SYNC_BARRIER);
            return program;
        }

        @Override
        public StringBuilder visitSyncWith(SyncWith sync_with) {
            defineBaseRelation(RelationNameRepository.SSW);
            return program;
        }

        @Override
        public StringBuilder visitSyncFence(SyncFence sync_fen) {
            translatedBaseRelations.add(sync_fen.getDefinedRelation());
            defineBaseRelation(RelationNameRepository.SYNC_FENCE);
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

    // TODO rewrite in datalog
    private class Initializer implements Definition.Visitor<Void> {
        final Program program = task.getProgram();
        final WitnessGraph witness = task.getWitness();
        private final Writer mayWriter;
        private final Writer mustWriter;

        public Initializer(Writer mayWriter, Writer mustWriter) {
            this.mayWriter = mayWriter;
            this.mustWriter = mustWriter;
        }

        @Override
        public Void visitControlDependency(DirectControlDependency ctrlDep) {
            //TODO: We can restrict the codomain to visible events as the only usage of this Relation is in
            // ctrl := idd^+;ctrlDirect & (R*V)
            List<Writer> writers = List.of(mayWriter, mustWriter);
            for (Thread thread : program.getThreads()) {
                for (CondJump jump : thread.getEvents(CondJump.class)) {
                    if (jump.isGoto() || jump.isDead()) {
                        continue; // There is no point in ctrl-edges from unconditional jumps.
                    }

                    final List<Event> ctrlDependentEvents;
                    if (jump instanceof IfAsJump ifJump) {
                        // Ctrl dependencies of Ifs (under Linux) only extend up until the merge point of both
                        // branches.
                        ctrlDependentEvents = ifJump.getBranchesEvents();
                    } else {
                        // Regular jumps give dependencies to all successors.
                        ctrlDependentEvents = jump.getSuccessor().getSuccessors();
                    }

                    for (Event e : ctrlDependentEvents) {
                        if (!exec.areMutuallyExclusive(jump, e)) {
                            writers.forEach(w -> addData(w, jump, e));
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitAddressDependency(DirectAddressDependency addrDep) {
            computeInternalDependencies(EnumSet.of(ADDR));
            return null;
        }

        @Override
        public Void visitInternalDataDependency(DirectDataDependency idd) {
            // FIXME: Our "internal data dependency" relation is quite odd an contains all but address dependencies.
            computeInternalDependencies(EnumSet.of(DATA, CTRL, OTHER));
            return null;
        }

        @Override
        public Void visitCASDependency(CASDependency casDep) {
            List<Writer> writers = List.of(mayWriter, mustWriter);
            // The target of a CASDep is always the successor of the origin
            program.getThreadEvents().stream().filter(e -> e.hasTag(IMM.CASDEPORIGIN)).forEach(e -> writers.forEach(w -> addData(w, e, e.getSuccessor())));
            return null;
        }

        @Override
        public Void visitLinuxCriticalSections(LinuxCriticalSections rscs) {
            //assume locks and unlocks are distinct
            Map<Event, Set<Event>> mayMap = new HashMap<>();
            Map<Event, Set<Event>> mustMap = new HashMap<>();
            for (Thread thread : program.getThreads()) {
                List<Event> locks = reverse(thread.getEvents().stream().filter(e -> e.hasTag(Linux.RCU_LOCK)).collect(toList()));
                for (Event unlock : thread.getEvents()) {
                    if (!unlock.hasTag(Linux.RCU_UNLOCK)) {
                        continue;
                    }
                    // iteration order assures that all intermediaries were already iterated
                    for (Event lock : locks) {
                        if (unlock.getGlobalId() < lock.getGlobalId() ||
                                exec.areMutuallyExclusive(lock, unlock) ||
                                Stream.concat(mustMap.getOrDefault(lock, Set.of()).stream(),
                                                mustMap.getOrDefault(unlock, Set.of()).stream())
                                        .anyMatch(e -> exec.isImplied(lock, e) || exec.isImplied(unlock, e))) {
                            continue;
                        }
                        boolean noIntermediary =
                                mayMap.getOrDefault(unlock, Set.of()).stream()
                                        .allMatch(e -> exec.areMutuallyExclusive(lock, e)) &&
                                        mayMap.getOrDefault(lock, Set.of()).stream()
                                                .allMatch(e -> exec.areMutuallyExclusive(e, unlock));
                        addData(mayWriter, lock, unlock);
                        mayMap.computeIfAbsent(lock, x -> new HashSet<>()).add(unlock);
                        mayMap.computeIfAbsent(unlock, x -> new HashSet<>()).add(lock);
                        if (noIntermediary) {
                            addData(mustWriter, lock, unlock);
                            mustMap.computeIfAbsent(lock, x -> new HashSet<>()).add(unlock);
                            mustMap.computeIfAbsent(unlock, x -> new HashSet<>()).add(lock);
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitReadModifyWrites(ReadModifyWrites rmw) {
            //NOTE: Changes to the semantics of this method may need to be reflected in RMWGraph for Refinement!
            // ----- Compute must set -----
            // RMWLoad -> RMWStore
            for (RMWStore store : program.getThreadEvents(RMWStore.class)) {
                addData(mustWriter, store.getLoadEvent(), store);
                addData(mayWriter, store.getLoadEvent(), store);
            }

            // Atomics blocks: BeginAtomic -> EndAtomic
            for (EndAtomic end : program.getThreadEvents(EndAtomic.class)) {
                List<Event> block = end.getBlock().stream().filter(x -> x.hasTag(VISIBLE)).toList();
                for (int i = 0; i < block.size(); i++) {
                    Event e = block.get(i);
                    for (int j = i + 1; j < block.size(); j++) {
                        if (!exec.areMutuallyExclusive(e, block.get(j))) {
                            addData(mustWriter, e, block.get(j));
                            addData(mayWriter, e, block.get(j));
                        }
                    }
                }
            }
            // ----- Compute may set -----
            // LoadExcl -> StoreExcl
            for (Thread thread : program.getThreads()) {
                List<Event> events = thread.getEvents().stream().filter(e -> e.hasTag(EXCL)).toList();
                // assume order by globalId
                // assume globalId describes a topological sorting over the control flow
                for (int end = 1; end < events.size(); end++) {
                    if (!(events.get(end) instanceof RMWStoreExclusive store)) {
                        continue;
                    }
                    int start = iterate(end - 1, i -> i >= 0, i -> i - 1)
                            .filter(i -> exec.isImplied(store, events.get(i)))
                            .findFirst().orElse(0);
                    List<Event> candidates = events.subList(start, end).stream()
                            .filter(e -> !exec.areMutuallyExclusive(e, store))
                            .toList();
                    int size = candidates.size();
                    for (int i = 0; i < size; i++) {
                        Event load = candidates.get(i);
                        List<Event> intermediaries = candidates.subList(i + 1, size);
                        if (!(load instanceof Load) || intermediaries.stream().anyMatch(e -> exec.isImplied(load, e))) {
                            continue;
                        }
                        addData(mayWriter, load, store);
                        if (intermediaries.stream().allMatch(e -> exec.areMutuallyExclusive(load, e)) &&
                                (store.doesRequireMatchingAddresses() || alias.mustAlias((Load) load, store))) {
                            addData(mustWriter, load, store);
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitCoherence(Coherence co) {
            logger.trace("Computing knowledge about memory order");
            List<Store> nonInitWrites = program.getThreadEvents(Store.class);
            nonInitWrites.removeIf(Init.class::isInstance);
            EventGraph may = new EventGraph();
            for (Store w1 : program.getThreadEvents(Store.class)) {
                for (Store w2 : nonInitWrites) {
                    if (w1.getGlobalId() != w2.getGlobalId() && !exec.areMutuallyExclusive(w1, w2)
                            && alias.mayAlias(w1, w2)) {
                        may.add(w1, w2);
                    }
                }
            }
            EventGraph must = new EventGraph();
            may.apply((e1, e2) -> {
                MemoryCoreEvent w1 = (MemoryCoreEvent) e1;
                MemoryCoreEvent w2 = (MemoryCoreEvent) e2;
                if (!w2.hasTag(INIT) && alias.mustAlias(w1, w2) && w1.hasTag(INIT)) {
                    must.add(w1, w2);
                }
            });
            if (wmmAnalysis.isLocallyConsistent()) {
                may.removeIf(Tuple::isBackward);
                may.apply((e1, e2) -> {
                    MemoryCoreEvent w1 = (MemoryCoreEvent) e1;
                    MemoryCoreEvent w2 = (MemoryCoreEvent) e2;
                    if (alias.mustAlias(w1, w2) && Tuple.isForward(e1, e2)) {
                        must.add(w1, w2);
                    }
                });
            }

            // Must-co from violation witness
            if (!witness.isEmpty()) {
                must.addAll(witness.getCoherenceKnowledge(program, alias));
            }

            may.apply((e1, e2) -> addData(mayWriter, e1, e2));
            must.apply((e1, e2) -> addData(mustWriter, e1, e2));

            logger.debug("Initial may set size for memory order: {}", may.size());
            return null;
        }

        @Override
        public Void visitReadFrom(ReadFrom rf) {
            logger.trace("Computing knowledge about read-from");
            final BranchEquivalence eq = analysisContext.requires(BranchEquivalence.class);
            EventGraph may = new EventGraph();
            EventGraph must = new EventGraph();
            List<Load> loadEvents = program.getThreadEvents(Load.class);
            for (Store e1 : program.getThreadEvents(Store.class)) {
                for (Load e2 : loadEvents) {
                    if (alias.mayAlias(e1, e2) && !exec.areMutuallyExclusive(e1, e2)) {
                        may.add(e1, e2);
                    }
                }
            }

            // Here we add must-rf edges between loads/stores that synchronize threads.
            for (Thread thread : program.getThreads()) {
                List<MemoryCoreEvent> spawned = thread.getSpawningEvents();
                if (spawned.size() == 2) {
                    MemoryCoreEvent startLoad = spawned.get(0);
                    MemoryCoreEvent startStore = spawned.get(1);
                    must.add(startStore, startLoad);
                    if (eq.isImplied(startLoad, startStore)) {
                        may.removeIf((e1, e2) -> e2 == startLoad && e1 != startStore);
                    }
                }
            }

            if (wmmAnalysis.isLocallyConsistent()) {
                // Remove future reads
                may.removeIf(Tuple::isBackward);
                // Remove past reads
                EventGraph deletedEdges = new EventGraph();
                Map<Event, List<Event>> writesByRead = new HashMap<>();
                may.apply((e1, e2) -> writesByRead.computeIfAbsent(e2, x -> new ArrayList<>()).add(e1));
                for (Load read : program.getThreadEvents(Load.class)) {
                    // The set of same-thread writes as well as init writes that could be read from (all before the read)
                    // sorted by order (init events first)
                    List<MemoryCoreEvent> possibleWrites = writesByRead.getOrDefault(read, List.of()).stream()
                            .filter(e -> (e.getThread() == read.getThread() || e.hasTag(INIT)))
                            .map(x -> (MemoryCoreEvent) x)
                            .sorted((o1, o2) -> o1.hasTag(INIT) == o2.hasTag(INIT) ? (o1.getGlobalId() - o2.getGlobalId()) : o1.hasTag(INIT) ? -1 : 1)
                            .toList();
                    // The set of writes that won't be readable due getting overwritten.
                    Set<MemoryCoreEvent> deletedWrites = new HashSet<>();
                    // A rf-edge (w1, r) is impossible, if there exists a write w2 such that
                    // - w2 is exec-implied by w1 or r (i.e. cf-implied + w2.cfImpliesExec)
                    // - w2 must alias with either w1 or r.
                    for (int i = 0; i < possibleWrites.size(); i++) {
                        MemoryCoreEvent w1 = possibleWrites.get(i);
                        for (MemoryCoreEvent w2 : possibleWrites.subList(i + 1, possibleWrites.size())) {
                            // w2 dominates w1 if it aliases with it and it is guaranteed to execute if either w1 or the read are
                            // executed
                            if ((exec.isImplied(w1, w2) || exec.isImplied(read, w2))
                                    && (alias.mustAlias(w1, w2) || alias.mustAlias(w2, read))) {
                                deletedWrites.add(w1);
                                break;
                            }
                        }
                    }
                    for (Event w : deletedWrites) {
                        deletedEdges.add(w, read);
                    }
                }
                may.removeAll(deletedEdges);
            }
            if (wmmAnalysis.doesRespectAtomicBlocks()) {
                //TODO: This function can not only reduce rf-edges
                // but we could also figure out implied coherences:
                // Assume w1 and w2 are aliasing in the same block and w1 is before w2,
                // then if w1 is co-before some external w3, then so is w2, i.e.
                // co(w1, w3) => co(w2, w3), but we also have co(w2, w3) => co(w1, w3)
                // so co(w1, w3) <=> co(w2, w3).
                // This information is not expressible in terms of min/must sets, but
                // we could still encode it.
                int sizeBefore = may.size();
                // Atomics blocks: BeginAtomic -> EndAtomic
                for (EndAtomic endAtomic : program.getThreadEvents(EndAtomic.class)) {
                    // Collect memEvents of the atomic block
                    List<Store> writes = new ArrayList<>();
                    List<Load> reads = new ArrayList<>();
                    for (Event b : endAtomic.getBlock()) {
                        if (b instanceof Load load) {
                            reads.add(load);
                        } else if (b instanceof Store store) {
                            writes.add(store);
                        }
                    }
                    for (Load r : reads) {
                        // If there is any write w inside the atomic block that is guaranteed to
                        // execute before the read and that aliases with it,
                        // then the read won't be able to read any external writes
                        boolean hasImpliedWrites = writes.stream()
                                .anyMatch(w -> w.getGlobalId() < r.getGlobalId()
                                        && exec.isImplied(r, w) && alias.mustAlias(r, w));
                        if (hasImpliedWrites) {
                            may.removeIf((e1, e2) -> e2 == r && Tuple.isCrossThread(e1, e2));
                        }
                    }
                }
                logger.debug("Atomic block optimization eliminated {} reads", sizeBefore - may.size());
            }

            // Must-rf from violation witness
            if (!witness.isEmpty()) {
                EventGraph g = witness.getReadFromKnowledge(program, alias);
                must.addAll(g);
                for (Event r : g.getRange()) {
                    may.removeIf((e1, e2) -> e2 == r);
                }
            }

            may.apply((e1, e2) -> addData(mayWriter, e1, e2));
            must.apply((e1, e2) -> addData(mustWriter, e1, e2));

            logger.debug("Initial may set size for read-from: {}", may.size());
            return null;
        }

        @Override
        public Void visitSameLocation(SameLocation loc) {
            EventGraph may = new EventGraph();
            List<MemoryCoreEvent> events = program.getThreadEvents(MemoryCoreEvent.class);
            for (MemoryCoreEvent e1 : events) {
                for (MemoryCoreEvent e2 : events) {
                    if (alias.mayAlias(e1, e2) && !exec.areMutuallyExclusive(e1, e2)) {
                        may.add(e1, e2);
                    }
                }
            }
            EventGraph must = new EventGraph();
            may.apply((e1, e2) -> {
                if (alias.mustAlias((MemoryCoreEvent) e1, (MemoryCoreEvent) e2)) {
                    must.add(e1, e2);
                }
            });

            may.apply((e1, e2) -> addData(mayWriter, e1, e2));
            must.apply((e1, e2) -> addData(mustWriter, e1, e2));

            return null;
        }

        private void computeInternalDependencies(Set<UsageType> usageTypes) {
            EventGraph may = new EventGraph();
            EventGraph must = new EventGraph();

            for (RegReader regReader : program.getThreadEvents(RegReader.class)) {
                for (Register.Read regRead : regReader.getRegisterReads()) {
                    if (!usageTypes.contains(regRead.usageType())) {
                        continue;
                    }
                    final Register register = regRead.register();
                    // Register x0 is hardwired to the constant 0 in RISCV
                    // https://en.wikichip.org/wiki/risc-v/registers,
                    // and thus it generates no dependency, see
                    // https://github.com/herd/herdtools7/issues/408
                    // TODO: Can't we just replace all reads of "x0" by 0 in RISC-specific preprocessing?
                    if (program.getArch().equals(RISCV) && register.getName().equals("x0")) {
                        continue;
                    }
                    Dependency.State r = dep.of(regReader, register);
                    for (Event regWriter : r.may) {
                        may.add(regWriter, regReader);
                    }
                    for (Event regWriter : r.must) {
                        must.add(regWriter, regReader);
                    }
                }
            }

            // We need to track ExecutionStatus events separately, because they induce data-dependencies
            // without reading from a register.
            if (usageTypes.contains(DATA)) {
                for (ExecutionStatus execStatus : program.getThreadEvents(ExecutionStatus.class)) {
                    if (execStatus.doesTrackDep()) {
                        may.add(execStatus.getStatusEvent(), execStatus);
                        must.add(execStatus.getStatusEvent(), execStatus);
                    }
                }
            }

            may.apply((e1, e2) -> addData(mayWriter, e1, e2));
            must.apply((e1, e2) -> addData(mustWriter, e1, e2));
        }

        @Override
        public Void visitSameScope(SameScope sc) {
            final String specificScope = sc.getSpecificScope();
            List<Event> events = program.getThreadEvents().stream()
                    .filter(e -> e.hasTag(VISIBLE) && e.getThread().hasScope())
                    .toList();
            for (Event e1 : events) {
                for (Event e2 : events) {
                    if (exec.areMutuallyExclusive(e1, e2)) {
                        continue;
                    }
                    Thread thread1 = e1.getThread();
                    Thread thread2 = e2.getThread();
                    if (specificScope != null) { // scope specified
                        if (thread1.getScopeHierarchy().canSyncAtScope(thread2.getScopeHierarchy(), specificScope)) {
                            addData(mayWriter, e1, e2);
                            addData(mustWriter, e1, e2);
                        }
                    } else {
                        String scope1 = Tag.getScopeTag(e1, program.getArch());
                        String scope2 = Tag.getScopeTag(e2, program.getArch());
                        if (!scope1.isEmpty() && !scope2.isEmpty() && thread1.getScopeHierarchy().canSyncAtScope(thread2.getScopeHierarchy(), scope1)
                                && thread2.getScopeHierarchy().canSyncAtScope(thread1.getScopeHierarchy(), scope2)) {
                            addData(mayWriter, e1, e2);
                            addData(mustWriter, e1, e2);
                        }
                    }
                }
            }

            return null;
        }

        @Override
        public Void visitSyncBarrier(SyncBar syncBar) {
            List<FenceWithId> fenceEvents = program.getThreadEvents(FenceWithId.class);
            for (FenceWithId e1 : fenceEvents) {
                for (FenceWithId e2 : fenceEvents) {
                    // “A bar.sync or bar.red or bar.arrive operation synchronizes with a bar.sync
                    // or bar.red operation executed on the same barrier.”
                    if (exec.areMutuallyExclusive(e1, e2) || e2.hasTag(PTX.ARRIVE)) {
                        continue;
                    }
                    addData(mayWriter, e1, e2);
                    if (e1.getFenceID().equals(e2.getFenceID())) {
                        addData(mustWriter, e1, e2);
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitSyncFence(SyncFence syncFence) {
            List<Event> fenceEventsSC = program.getThreadEventsWithAllTags(VISIBLE, FENCE, PTX.SC);
            for (Event e1 : fenceEventsSC) {
                for (Event e2 : fenceEventsSC) {
                    if (!exec.areMutuallyExclusive(e1, e2)) {
                        addData(mayWriter, e1, e2);
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitSameVirtualLocation(SameVirtualLocation vloc) {
            List<MemoryCoreEvent> events = program.getThreadEvents(MemoryCoreEvent.class);
            for (MemoryCoreEvent e1 : events) {
                for (MemoryCoreEvent e2 : events) {
                    if (sameGenericAddress(e1, e2) && !exec.areMutuallyExclusive(e1, e2)) {
                        if (alias.mustAlias(e1, e2)) {
                            addData(mustWriter, e1, e2);
                        }
                        if (alias.mayAlias(e1, e2)) {
                            addData(mayWriter, e1, e2);
                        }
                    }
                }
            }
            return null;
        }

        // GPU memory models make use of virtual addresses.
        // This models same_alias_r from the PTX Alloy model
        // Checking address1 and address2 hold the same generic address
        private static boolean sameGenericAddress(MemoryCoreEvent e1, MemoryCoreEvent e2) {
            // TODO: Add support for pointers, i.e. if `x` and `y` virtually alias,
            // then `x + offset` and `y + offset` should too
            if (!(e1.getAddress() instanceof VirtualMemoryObject addr1)
                    || !(e2.getAddress() instanceof VirtualMemoryObject addr2)) {
                return false;
            }
            return addr1.getGenericAddress() == addr2.getGenericAddress();
        }

        @Override
        public Void visitSyncWith(SyncWith syncWith) {
            List<Event> events = new ArrayList<>(program.getThreadEventsWithAllTags(VISIBLE));
            events.removeIf(Init.class::isInstance);
            for (Event e1 : events) {
                for (Event e2 : events) {
                    Thread thread1 = e1.getThread();
                    Thread thread2 = e2.getThread();
                    if (thread1 == thread2 || !thread1.hasSyncSet()) {
                        continue;
                    }
                    if (thread1.getSyncSet().contains(thread2) && !exec.areMutuallyExclusive(e1, e2)) {
                        addData(mayWriter, e1, e2);
                        addData(mustWriter, e1, e2);
                    }
                }
            }
            return null;
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
