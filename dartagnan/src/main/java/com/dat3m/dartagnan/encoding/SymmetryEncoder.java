package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.smt.EncodingUtils;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.utils.symmetry.CoSymmetryBreaking;
import com.google.common.base.Preconditions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.*;
import java.util.function.Function;

import static com.dat3m.dartagnan.configuration.OptionNames.BREAK_SYMMETRY_ON;

@Options
public class SymmetryEncoder {

    private static final Logger logger = LoggerFactory.getLogger(SymmetryEncoder.class);

    private static final String CO = "co";
    private static final String CF = "cf";

    private final EncodingContext context;
    private final ThreadSymmetry symm;

    @Option(name = BREAK_SYMMETRY_ON,
            description = """
                    The target to break symmetry on. Allowed options are:
                    - "co" to break symmetry on the coherence order of symmetric stores (see CoSymmetryBreaking).
                    - "cf" to break symmetry on the control flow.
                    - The empty string to disable symmetry breaking.""",
            secure = true)
    private String symmBreakTarget = "";

    // =====================================================================

    private SymmetryEncoder(EncodingContext c, Configuration config) throws InvalidConfigurationException {
        context = c;
        symm = c.getAnalysisContext().requires(ThreadSymmetry.class);
        config.inject(this);

        switch (symmBreakTarget) {
            case "" -> logger.info("Symmetry breaking disabled.");
            case CO -> logger.info("Breaking symmetry on coherence.");
            case CF -> {
                logger.info("Breaking symmetry on control flow.");
                c.getAnalysisContext().requires(BranchEquivalence.class);
            }
            default -> throw new InvalidConfigurationException(String.format(
                    "Unknown value \"%s\" for option %s. Allowed values are \"%s\", \"%s\", and \"\".",
                    symmBreakTarget, BREAK_SYMMETRY_ON, CO, CF));
        }
    }

    public static SymmetryEncoder withContext(EncodingContext context) throws InvalidConfigurationException {
        return new SymmetryEncoder(context, context.getTask().getConfig());
    }

    public BooleanFormula encodeFullSymmetryBreaking() {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        return switch (symmBreakTarget) {
            case CO -> new CoSymmetryBreaking(context).encode();
            case CF -> {
                final Set<Event> cfReps = controlFlowRepresentatives();
                yield symm.getNonTrivialClasses().stream()
                        .map(symmClass -> encodeControlFlowSymmetryBreakingOnClass(cfReps, symmClass))
                        .reduce(bmgr.makeTrue(), bmgr::and);
            }
            default -> bmgr.makeTrue();
        };
    }

    /*
        Lex-leader constraints on the control flow: each thread's row consists of the execution variables of its own
        branch representatives, in a fixed order that is the same for all threads (up to the thread renaming).
        Since every row only refers to its own thread, the chained constraints r1 >= r2 >= ... >= rk sort the threads
        by their control-flow vectors, which is sound.
     */
    private BooleanFormula encodeControlFlowSymmetryBreakingOnClass(Set<Event> cfReps, EquivalenceClass<Thread> symmClass) {
        Preconditions.checkArgument(symmClass.getEquivalence() == symm,
                "Symmetry class belongs to unexpected symmetry relation.");

        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final Thread rep = symmClass.getRepresentative();
        final List<Thread> symmThreads = new ArrayList<>(symmClass);
        symmThreads.sort(Comparator.comparingInt(Thread::getId));

        // IMPORTANT: Each thread writes to its own special location for the purpose of starting/terminating threads.
        // These need to get skipped.
        Thread t1 = symmThreads.getFirst();
        final Set<? extends Event> spawning = new HashSet<>(t1.getSpawningEvents());
        List<Event> t1Row = t1.getEvents().stream()
                .filter(e -> cfReps.contains(e) && !spawning.contains(e))
                .sorted(Event::compareTo)
                .toList();

        final List<BooleanFormula> enc = new ArrayList<>();
        final EncodingUtils utils = context.getFormulaManager().getEncodingUtils();
        for (int i = 1; i < symmThreads.size(); i++) {
            final Thread t2 = symmThreads.get(i);
            final Function<Event, Event> p = symm.createEventTransposition(t1, t2);
            final List<Event> t2Row = t1Row.stream().map(p).toList();

            final List<BooleanFormula> r1 = t1Row.stream().map(context::execution).toList();
            final List<BooleanFormula> r2 = t2Row.stream().map(context::execution).toList();
            final String id = String.format("T%d_%d", rep.getId(), i);
            enc.add(utils.encodeLexLeader(r2, r1, id)); // r1 >= r2

            t1 = t2;
            t1Row = t2Row;
        }

        return bmgr.and(enc);
    }

    private Set<Event> controlFlowRepresentatives() {
        final BranchEquivalence branchEq = context.getAnalysisContext().requires(BranchEquivalence.class);
        final Set<Event> reps = new HashSet<>();
        branchEq.getAllEquivalenceClasses().forEach(c -> {
            if (c != branchEq.getInitialClass() && c != branchEq.getUnreachableClass()) {
                reps.add(c.getRepresentative());
            }
        });
        return reps;
    }
}
