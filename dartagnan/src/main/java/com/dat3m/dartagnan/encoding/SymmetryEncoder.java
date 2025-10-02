package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.BREAK_SYMMETRY_BY_SYNC_DEGREE;
import static com.dat3m.dartagnan.configuration.OptionNames.BREAK_SYMMETRY_ON;

@Options
public class SymmetryEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(SymmetryEncoder.class);

    private final Wmm memoryModel;
    private final EncodingContext context;
    private final List<Axiom> acycAxioms;
    private final ThreadSymmetry symm;
    private final RelationAnalysis ra;

    @Option(name = BREAK_SYMMETRY_ON,
            description = "The target to break symmetry on. Allowed options are:\n" +
                    "- A relation name to break symmetry on.\n" +
                    "- The special value \"_cf\" to break symmetry on the control flow.\n" +
                    "- The empty string to disable symmetry breaking.",
            secure = true)
    private String symmBreakTarget = "";

    @Option(name = BREAK_SYMMETRY_BY_SYNC_DEGREE,
            description = "Orders the relation edges to break on based on their synchronization strength." +
                    "Only has impact if breaking symmetry on relations rather than control flow.",
            secure = true)
    private boolean breakBySyncDegree = true;

    // =====================================================================

    private SymmetryEncoder(EncodingContext c, Configuration config) throws InvalidConfigurationException {
        context = c;
        memoryModel = c.getTask().getMemoryModel();
        acycAxioms = memoryModel.getAxioms().stream().filter(Axiom::isAcyclicity).collect(Collectors.toList());
        symm = c.getAnalysisContext().requires(ThreadSymmetry.class);
        ra = c.getAnalysisContext().requires(RelationAnalysis.class);
        config.inject(this);

        if (symmBreakTarget.isEmpty()) {
            logger.info("Symmetry breaking disabled.");
        } else if (symmBreakTarget.equals("_cf")) {
            logger.info("Breaking symmetry on control flow.");
            c.getAnalysisContext().requires(BranchEquivalence.class);
            this.breakBySyncDegree = false; // We cannot break by sync degree here
        } else {
            logger.info("Breaking symmetry on relation: " + symmBreakTarget);
            if (breakBySyncDegree && acycAxioms.isEmpty()) {
                breakBySyncDegree = false;
                logger.info("Disabled breaking by sync degree: Memory model has no acyclicity axioms.");
            }
            logger.info("Breaking by sync degree: " + breakBySyncDegree);
        }
    }

    public static SymmetryEncoder withContext(EncodingContext context) throws InvalidConfigurationException {
        return new SymmetryEncoder(context, context.getTask().getConfig());
    }

    public BooleanFormula encodeFullSymmetryBreaking() {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final EventGraph maySet;
        final EncodingContext.EdgeEncoder edgeEncoder;
        switch(symmBreakTarget) {
            case "":
                return bmgr.makeTrue();
            case "_cf":
                maySet = cfSet();
                edgeEncoder = context::execution;
                break;
            default:
                Wmm baseline = this.memoryModel;
                if (!baseline.containsRelation(symmBreakTarget) || !memoryModel.containsRelation(symmBreakTarget)) {
                    logger.warn("The wmm has no relation named {} to break symmetry on." +
                            " Symmetry breaking was disabled.", symmBreakTarget);
                    return bmgr.makeTrue();
                }
                maySet = ra.getKnowledge(memoryModel.getRelation(symmBreakTarget)).getMaySet();
                edgeEncoder = context.edge(baseline.getRelation(symmBreakTarget));
        }
        return symm.getNonTrivialClasses().stream()
                .map(symmClass -> encodeSymmetryBreakingOnClass(maySet, edgeEncoder, symmClass))
                .reduce(bmgr.makeTrue(), bmgr::and);
    }

    private BooleanFormula encodeSymmetryBreakingOnClass(EventGraph maySet, EncodingContext.EdgeEncoder edge, EquivalenceClass<Thread> symmClass) {
        Preconditions.checkArgument(symmClass.getEquivalence() == symm,
                "Symmetry class belongs to unexpected symmetry relation.");

        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final Thread rep = symmClass.getRepresentative();
        final List<Thread> symmThreads = new ArrayList<>(symmClass);
        symmThreads.sort(Comparator.comparingInt(Thread::getId));

        // ===== Construct row =====
        // IMPORTANT: Each thread writes to its own special location for the purpose of starting/terminating threads
        // These need to get skipped.
        Thread t1 = symmThreads.get(0);
        List<Tuple> t1Tuples = computeThreadTuples(maySet, symmClass, t1);

        // Construct symmetric rows
        List<BooleanFormula> enc = new ArrayList<>();
        final EncodingUtils utils = new EncodingUtils(context);
        for (int i = 1; i < symmThreads.size(); i++) {
            Thread t2 = symmThreads.get(i);
            Function<Event, Event> p = symm.createEventTransposition(t1, t2);
            List<Tuple> t2Tuples = t1Tuples.stream().map(t -> new Tuple(p.apply(t.first()), p.apply(t.second()))).toList();

            List<BooleanFormula> r1 = t1Tuples.stream().map(t -> edge.encode(t.first(), t.second())).toList();
            List<BooleanFormula> r2 = t2Tuples.stream().map(t -> edge.encode(t.first(), t.second())).toList();
            final String id = String.format("T%d_T%d", rep.getId(), i);
            enc.add(utils.encodeLexLeader(r2, r1, id)); // r1 >= r2
            t1 = t2;
            t1Tuples = t2Tuples;
        }

        return bmgr.and(enc);
    }

    private List<Tuple> computeThreadTuples(EventGraph maySet, EquivalenceClass<Thread> symmClass, Thread thread) {
        List<Tuple> tuples = new ArrayList<>();
        List<MemoryCoreEvent> spawned = thread.getSpawningEvents();
        maySet.apply((a, b) -> {
            if (!spawned.contains(a) && !spawned.contains(b)
                    && a.getThread() == thread && symmClass.contains(b.getThread())) {
                tuples.add(new Tuple(a, b));
            }
        });
        sort(tuples);
        return tuples;
    }

    private void sort(List<Tuple> row) {
        if (!breakBySyncDegree) {
            // ===== Natural order =====
            row.sort(Comparator.naturalOrder());
            return;
        }

        // ====== Sync-degree based order ======

        // Setup of data structures
        final Set<Event> inEvents = new HashSet<>();
        final Set<Event> outEvents = new HashSet<>();
        for (Tuple t : row) {
            inEvents.add(t.first());
            outEvents.add(t.second());
        }

        final List<RelationAnalysis.Knowledge> knowledge = acycAxioms.stream()
                .map(a -> ra.getKnowledge(a.getRelation()))
                .toList();
        final List<Map<Event, Set<Event>>> mustIn = knowledge.stream().map(k -> k.getMustSet().getInMap()).toList();
        final List<Map<Event, Set<Event>>> mustOut = knowledge.stream().map(k -> k.getMustSet().getOutMap()).toList();
        final Map<Event, Integer> combinedInDegree = new HashMap<>(inEvents.size());
        final Map<Event, Integer> combinedOutDegree = new HashMap<>(outEvents.size());
        for (Event e : inEvents) {
            int syncDeg = mustIn.stream().map(m -> m.getOrDefault(e, Set.of()).size() + 1).reduce(0, Integer::max);
            combinedInDegree.put(e, syncDeg);
        }
        for (Event e : outEvents) {
            int syncDec = mustOut.stream().map(m -> m.getOrDefault(e, Set.of()).size() + 1).reduce(0, Integer::max);
            combinedOutDegree.put(e, syncDec);
        }

        // Sort by sync degrees
        row.sort(Comparator.<Tuple>comparingInt(t -> combinedInDegree.get(t.first()) * combinedOutDegree.get(t.second())).reversed());
    }

    private EventGraph cfSet() {
        final BranchEquivalence branchEq = context.getAnalysisContext().requires(BranchEquivalence.class);
        MutableEventGraph cfSet = new MapEventGraph();
        branchEq.getAllEquivalenceClasses().forEach(c -> {
            if (c != branchEq.getInitialClass() && c != branchEq.getUnreachableClass()) {
                Event rep = c.getRepresentative();
                cfSet.add(rep, rep);
            }
        });
        return cfSet;
    }
}
