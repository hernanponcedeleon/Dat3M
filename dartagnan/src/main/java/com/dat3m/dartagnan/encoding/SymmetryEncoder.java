package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.utils.Tuple;
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
        final Set<Tuple> maySet;
        final EncodingContext.EdgeEncoder edgeEncoder;
        switch(symmBreakTarget) {
            case "":
                return bmgr.makeTrue();
            case "_cf":
                maySet = cfSet();
                edgeEncoder = t -> context.execution(t.getFirst(), t.getSecond());
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

    private BooleanFormula encodeSymmetryBreakingOnClass(Set<Tuple> maySet, EncodingContext.EdgeEncoder edge, EquivalenceClass<Thread> symmClass) {
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
        List<Tuple> t1Tuples = new ArrayList<>();
        for (Tuple t : maySet) {
            Event a = t.getFirst();
            Event b = t.getSecond();
            if (!a.hasTag(Tag.C11.PTHREAD) && !b.hasTag(Tag.C11.PTHREAD)
                    && a.getThread() == t1 && symmClass.contains(b.getThread())) {
                t1Tuples.add(t);
            }
        }
        sort(t1Tuples);

        // Construct symmetric rows
        List<BooleanFormula> enc = new ArrayList<>();
        for (int i = 1; i < symmThreads.size(); i++) {
            Thread t2 = symmThreads.get(i);
            Function<Event, Event> p = symm.createEventTransposition(t1, t2);
            List<Tuple> t2Tuples = t1Tuples.stream().map(t -> t.permute(p)).collect(Collectors.toList());

            List<BooleanFormula> r1 = t1Tuples.stream().map(edge::encode).collect(Collectors.toList());
            List<BooleanFormula> r2 = t2Tuples.stream().map(edge::encode).collect(Collectors.toList());
            final String id = "_" + rep.getId() + "_" + i;
            enc.add(encodeLexLeader(id, r2, r1, context)); // r1 >= r2
            t1 = t2;
            t1Tuples = t2Tuples;
        }

        return bmgr.and(enc);
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
            inEvents.add(t.getFirst());
            outEvents.add(t.getSecond());
        }

        final List<RelationAnalysis.Knowledge> knowledge = acycAxioms.stream()
                .map(a -> ra.getKnowledge(a.getRelation()))
                .collect(Collectors.toList());
        final List<Function<Event, Collection<Tuple>>> mustIn = knowledge.stream()
                .map(RelationAnalysis.Knowledge::getMustIn)
                .collect(Collectors.toList());
        final List<Function<Event, Collection<Tuple>>> mustOut = knowledge.stream()
                .map(RelationAnalysis.Knowledge::getMustOut)
                .collect(Collectors.toList());
        final Map<Event, Integer> combinedInDegree = new HashMap<>(inEvents.size());
        final Map<Event, Integer> combinedOutDegree = new HashMap<>(outEvents.size());
        for (Event e : inEvents) {
            int syncDeg = mustIn.stream().mapToInt(m -> m.apply(e).size() + 1).max().orElse(0);
            combinedInDegree.put(e, syncDeg);
        }
        for (Event e : outEvents) {
            int syncDec = mustOut.stream().mapToInt(m -> m.apply(e).size() + 1).max().orElse(0);
            combinedOutDegree.put(e, syncDec);
        }

        // Sort by sync degrees
        row.sort(Comparator.<Tuple>comparingInt(t -> combinedInDegree.get(t.getFirst()) * combinedOutDegree.get(t.getSecond())).reversed());
    }

    // ========================= Static utility ===========================

    /*
        Encodes that any assignment obeys "r1 <= r2" where the order is
        the lexicographic order based on "false < true".
        In other words, for all assignments to the variables of r1/r2,
        the first time r1(i) and r2(i) get different truth values,
        we will have r1(i) = FALSE and r2(i) = TRUE.

        NOTE: Creates extra variables named "yi_<uniqueIdent>" which can cause conflicts if
              <uniqueIdent> is not uniquely used.
    */
    public static BooleanFormula encodeLexLeader(String uniqueIdent, List<BooleanFormula> r1, List<BooleanFormula> r2, EncodingContext context) {
        Preconditions.checkArgument(r1.size() == r2.size());
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        // Return TRUE if there is nothing to encode
        if(r1.isEmpty()) {
            return bmgr.makeTrue();
        }
        final int size = r1.size();
        final String suffix = "_" + uniqueIdent;

        // We interpret the variables of <ri> as x1(ri), ..., xn(ri).
        // We create helper variables y0_suffix, ..., y(n-1)_suffix (note the index shift compared to xi)
        // xi gets related to y(i-1) and yi

        BooleanFormula ylast = bmgr.makeVariable("y0" + suffix); // y(i-1)
        List<BooleanFormula> enc = new ArrayList<>();
        enc.add(ylast);
        // From x1 to x(n-1)
        for (int i = 1; i < size; i++) {
            BooleanFormula y = bmgr.makeVariable("y" + i + suffix); // yi
            BooleanFormula a = r1.get(i-1); // xi(r1)
            BooleanFormula b = r2.get(i-1); // xi(r2)
            enc.add(bmgr.or(y, bmgr.not(ylast), bmgr.not(a))); // (see below)
            enc.add(bmgr.or(y, bmgr.not(ylast), b));           // "y(i-1) implies ((xi(r1) >= xi(r2))  =>  yi)"
            enc.add(bmgr.or(bmgr.not(ylast), bmgr.not(a), b)); // "y(i-1) implies (xi(r1) <= xi(r2))"
                    // NOTE: yi = TRUE means the prefixes (x1, x2, ..., xi) of the rows r1/r2 are equal
                    //       yi = FALSE means that no conditions are imposed on xi
                    // The first point, where y(i-1) is TRUE but yi is FALSE, is the breaking point
                    // where xi(r1) < xi(r2) holds (afterwards all yj (j >= i+1) are unconstrained and can be set to
                    // FALSE by the solver)
            ylast = y;
        }
        // Final iteration for xn is handled differently as there is no variable yn anymore.
        BooleanFormula a = r1.get(size-1);
        BooleanFormula b = r2.get(size-1);
        enc.add(bmgr.or(bmgr.not(ylast), bmgr.not(a), b));

        return bmgr.and(enc);
    }

    private Set<Tuple> cfSet() {
        final BranchEquivalence branchEq = context.getAnalysisContext().requires(BranchEquivalence.class);
        return branchEq.getAllEquivalenceClasses().stream()
                .filter(c -> c != branchEq.getInitialClass() && c != branchEq.getUnreachableClass())
                .map(EquivalenceClass::getRepresentative)
                .map(rep -> new Tuple(rep, rep))
                .collect(Collectors.toSet());
    }
}
