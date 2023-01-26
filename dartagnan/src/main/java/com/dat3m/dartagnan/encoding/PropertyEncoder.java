package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterMinus;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.RelationNameRepository;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Maps;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.Property.*;
import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.dat3m.dartagnan.program.event.Tag.INIT;
import static com.dat3m.dartagnan.program.event.Tag.WRITE;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkState;
public class PropertyEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(PropertyEncoder.class);

    private final EncodingContext context;
    private final Program program;
    private final Wmm memoryModel;
    private final ExecutionAnalysis exec;
    private final AliasAnalysis alias;
    private final RelationAnalysis ra;

    // =====================================================================

    private PropertyEncoder(EncodingContext c) {
        checkArgument(c.getTask().getProgram().isCompiled(),
                "The program must get compiled first before its properties can be encoded.");
        context = c;
        program = c.getTask().getProgram();
        memoryModel = c.getTask().getMemoryModel();
        exec = c.getAnalysisContext().requires(ExecutionAnalysis.class);
        alias = c.getAnalysisContext().requires(AliasAnalysis.class);
        ra = c.getAnalysisContext().requires(RelationAnalysis.class);
    }

    public static PropertyEncoder withContext(EncodingContext context) throws InvalidConfigurationException {
        return new PropertyEncoder(context);
    }

    @Override
    public void initializeEncoding(SolverContext context) { }

    public BooleanFormula encodeBoundEventExec() {
        logger.info("Encoding bound events execution");
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        return program.getCache().getEvents(FilterBasic.get(Tag.BOUND))
                .stream().map(context::execution).reduce(bmgr.makeFalse(), bmgr::or);
    }

    public BooleanFormula encodeSpecificationViolations() {
        final EnumSet<Property> property = context.getTask().getProperty();
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();

        BooleanFormula specViolation = bmgr.makeFalse();
        if(property.contains(REACHABILITY)) {
            specViolation = bmgr.or(specViolation, encodeAssertionViolations());
        }
        if(property.contains(LIVENESS)) {
            specViolation = bmgr.or(specViolation, encodeDeadlocks());
        }
        if(property.contains(RACES)) {
            specViolation = bmgr.or(specViolation, encodeDataRaces());
        }
        if(property.contains(CAT)) {
            specViolation = bmgr.or(specViolation, encodeCATPropertyViolations());
        }

        if (program.getFormat().equals(LITMUS) || property.contains(LIVENESS)) {
            // Both litmus assertions and liveness need to identify
            // the final stores to addresses.
            // TODO Optimization: This encoding can be restricted to only those addresses
            //  that are relevant for the specification (e.g., only variables that are used in spin loops).
            specViolation = bmgr.and(specViolation, encodeLastCoConstraints());
        }
        return specViolation;
    }

    private BooleanFormula encodeLastCoConstraints() {
        final Relation co = memoryModel.getRelation(CO);
        final SolverContext ctx = context.getSolverContext();
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final EncodingContext.EdgeEncoder coEncoder = context.edge(co);
        final TupleSet maySet = ra.getKnowledge(co).getMaySet();
        final TupleSet mustSet = ra.getKnowledge(co).getMustSet();
        final List<Event> initEvents = program.getCache().getEvents(FilterBasic.get(INIT));
        final List<Event> writes = program.getCache().getEvents(FilterBasic.get(WRITE));
        final boolean doEncodeFinalAddressValues = program.getFormat() == LITMUS;
        // Find transitively implied coherences. We can use these to reduce the encoding.
        final Set<Tuple> transCo = ra.findTransitivelyImpliedCo(co);
        // Find all writes that are never last, i.e., those that will always have a co-successor.
        final Set<Event> dominatedWrites = mustSet.stream()
                .filter(t -> exec.isImplied(t.getFirst(), t.getSecond()))
                .map(Tuple::getFirst).collect(Collectors.toSet());

        // ---- Construct encoding ----
        BooleanFormula enc = bmgr.makeTrue();
        for (Event writeEvent : writes) {
            MemEvent w1 = (MemEvent) writeEvent;
            if (dominatedWrites.contains(w1)) {
                enc = bmgr.and(enc, bmgr.not(lastCoVar(w1)));
                continue;
            }
            BooleanFormula isLast = context.execution(w1);
            // ---- Find all possibly overwriting writes ----
            for (Tuple coEdge : maySet.getByFirst(w1)) {
                if (transCo.contains(coEdge)) {
                    // We can skip the co-edge (w1,w2), because there will be an intermediate write w3
                    // that already witnesses that w1 is not last.
                    continue;
                }
                Event w2 = coEdge.getSecond();
                BooleanFormula isAfter = bmgr.not(mustSet.contains(coEdge) ? context.execution(w2) : coEncoder.encode(coEdge));
                isLast = bmgr.and(isLast, isAfter);
            }
            BooleanFormula lastCoExpr = lastCoVar(w1);
            enc = bmgr.and(enc, bmgr.equivalence(lastCoExpr, isLast));
            if (doEncodeFinalAddressValues) {
                // ---- Encode final values of addresses ----
                for (Event initEvent : initEvents) {
                    Init init = (Init) initEvent;
                    if (!alias.mayAlias(w1, init)) {
                        continue;
                    }
                    BooleanFormula sameAddress = context.sameAddress(init, w1);
                    Formula v2 = init.getBase().getLastMemValueExpr(ctx, init.getOffset());
                    BooleanFormula sameValue = context.equal(context.value(w1), v2);
                    enc = bmgr.and(enc, bmgr.implication(bmgr.and(lastCoExpr, sameAddress), sameValue));
                }
            }
        }
        return enc;
    }

    private BooleanFormula lastCoVar(Event write) {
        return context.getBooleanFormulaManager().makeVariable("co_last(" + write.getGlobalId() + ")");
    }

    // ======================================================================
    // ======================================================================
    // ========================== Reachability ==============================
    // ======================================================================
    // ======================================================================

    public BooleanFormula encodeAssertionViolations() {
        logger.info("Encoding assertions");
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        // FIXME: Assert.encode already negates its meaning (it is true IFF the assertion fails)
        //        This inversion is non-obvious and should not happen.
        final BooleanFormula assertionEncoding = program.getAss().encode(context);
        final BooleanFormula violationVariable = REACHABILITY.getSMTVariable(context);
        return bmgr.and(violationVariable, bmgr.equivalence(violationVariable, assertionEncoding));
    }

    // ======================================================================
    // ======================================================================
    // ========================= CAT Properties  ============================
    // ======================================================================
    // ======================================================================

    /*
        CAT Properties are defined within the .cat model itself using flagged axioms.
        CAUTION: A flagged axiom is considered a specification violation if it is satisfied!
    */
    public BooleanFormula encodeCATPropertyViolations() {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final EncodingContext ctx = this.context;
        final Wmm memoryModel = this.memoryModel;
        final List<Axiom> flaggedAxioms = memoryModel.getAxioms().stream()
                .filter(Axiom::isFlagged).collect(Collectors.toList());

        if (flaggedAxioms.isEmpty()) {
            logger.info("No CAT properties specified in the WMM. Skipping encoding.");
            return bmgr.makeFalse();
        } else {
            logger.info("Encoding CAT properties");
        }

        BooleanFormula axiomTracking = bmgr.makeTrue();
        BooleanFormula atLeastOneViolation = bmgr.makeFalse();
    	for(Axiom ax : flaggedAxioms) {
            final BooleanFormula violationVariable = CAT.getSMTVariable(ax, ctx);
			axiomTracking = bmgr.and(axiomTracking, bmgr.equivalence(violationVariable, ax.consistent(ctx)));
			atLeastOneViolation = bmgr.or(atLeastOneViolation, violationVariable);
    	}
        return bmgr.and(atLeastOneViolation, axiomTracking);
    }

    // ======================================================================
    // ======================================================================
    // ============================ Data races ==============================
    // ======================================================================
    // ======================================================================

    /*
        This data race encoding is only valid for models with a defined "hb"-relation
        Typically, this is only the case for SC/SVCOMP.
        More general notions of data races (for e.g. weak models) can be defined as a flagged axiom
        inside the .cat, just like C11 and LKMM do.
    */
    public BooleanFormula encodeDataRaces() {
        logger.info("Encoding data races");

        final Wmm memoryModel = this.memoryModel;
        checkState(memoryModel.containsRelation("hb"),
                "The provided WMM needs a happens-before relation 'hb' to encode data races.");
        final Relation hbRelation = memoryModel.getRelation("hb");
        checkState(memoryModel.getAxioms().stream().anyMatch(ax ->
                        ax.isAcyclicity() && ax.getRelation().equals(hbRelation)),
                "The provided WMM needs an 'acyclic(hb)' axiom to encode data races.");

        final EncodingContext ctx = this.context;
        final BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
        final IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();
        final EncodingContext.EdgeEncoder hbEncoder = ctx.edge(hbRelation);
        final Program program = this.program;
        final AliasAnalysis alias = this.alias;

        BooleanFormula hasRace = bmgr.makeFalse();
        for(Thread t1 : program.getThreads()) {
            for(Thread t2 : program.getThreads()) {
                if(t1 == t2) {
                    continue;
                }
                for(Event e1 : t1.getCache().getEvents(FilterMinus.get(FilterBasic.get(WRITE), FilterBasic.get(INIT)))) {
                    MemEvent w = (MemEvent)e1;
                    if (!w.canRace()) {
                        continue;
                    }
                    for(Event e2 : t2.getCache().getEvents(FilterMinus.get(FilterBasic.get(Tag.MEMORY), FilterBasic.get(INIT)))) {
                        MemEvent m = (MemEvent)e2;
                        if((w.hasFilter(Tag.RMW) && m.hasFilter(Tag.RMW)) || !m.canRace() || !alias.mayAlias(m, w)) {
                            continue;
                        }

                        final BooleanFormula isConflictingPair = bmgr.and(ctx.execution(m, w), ctx.sameAddress(m, w));
                        final BooleanFormula isAdjacentInHb = bmgr.and(
                                hbEncoder.encode(m, w), // In Hb
                                imgr.equal( // Adjacent (We assume "w-hb->m" cause in a race the store can be assumed to be first)
                                        ctx.clockVariable("hb", w),
                                        imgr.add(ctx.clockVariable("hb", m), imgr.makeNumber(1))
                                )
                        );
                        final BooleanFormula isRacingPair = bmgr.and(isConflictingPair, isAdjacentInHb);
                        hasRace = bmgr.or(hasRace, isRacingPair);
                    }
                }
            }
        }
        // We use the SMT variable to extract from the model if the property was violated
        final BooleanFormula raceVariable = RACES.getSMTVariable(ctx);
        return bmgr.and(raceVariable, bmgr.equivalence(raceVariable, hasRace));
    }

    // ======================================================================
    // ======================================================================
    // ============================= Liveness ===============================
    // ======================================================================
    // ======================================================================

    public BooleanFormula encodeDeadlocks() {
        logger.info("Encoding liveness");
        return new LivenessEncoder().encodeDeadlocks();
    }

    /*
        Encoder for the liveness property.

        We have a liveness violation in some execution if
            - At least one thread is stuck inside a loop (*)
            - All other threads are either stuck or terminated normally (**)

        (*) A thread is stuck if it finishes a loop iteration
            - without causing side-effects (e.g., visible stores)
            - while reading only from co-maximal stores
        => Without external help, a stuck thread will never be able to exit the loop.

        (**) A thread terminates normally IFF it does not terminate early (denoted by EARLYTERMINATION-tagged jumps)
             due to e.g.,
            - violating an assertion
            - reaching the loop unrolling bound
            - side-effect-free spinning

        NOTE: The definition of "stuck" is under-approximate: there are cases where a thread can actually be
        in a deadlock without satisfying the stated conditions (e.g., while producing side effects).
        Reasoning about such cases is more involved.
    */
    private class LivenessEncoder {

        private class SpinIteration {
            public final List<Load> containedLoads = new ArrayList<>();
            // Execution of the <boundJump> means the loop performed a side-effect-free
            // iteration without exiting. If such a jump is executed + all loads inside the loop
            // were co-maximal, then we have a deadlock condition.
            public final List<CondJump> spinningJumps = new ArrayList<>();
        }

        public BooleanFormula encodeDeadlocks() {
            final Program program = PropertyEncoder.this.program;
            final EncodingContext context = PropertyEncoder.this.context;
            final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
            final LoopAnalysis loopAnalysis = LoopAnalysis.newInstance(program);

            // Find spin loops of all threads
            final Map<Thread, List<SpinIteration>> spinloopsMap =
                    Maps.toMap(program.getThreads(), t -> this.findSpinLoopsInThread(t, loopAnalysis));
            // Compute "stuckness" encoding for all threads
            final Map<Thread, BooleanFormula> isStuckMap = Maps.toMap(program.getThreads(),
                    t -> this.generateStucknessEncoding(spinloopsMap.get(t), context));

            // Deadlock <=> allStuckOrDone /\ atLeastOneStuck
            BooleanFormula allStuckOrDone = bmgr.makeTrue();
            BooleanFormula atLeastOneStuck = bmgr.makeFalse();
            for (Thread thread : program.getThreads()) {
                final BooleanFormula isStuck = isStuckMap.get(thread);
                final BooleanFormula isTerminatingNormally = thread.getCache()
                        .getEvents(FilterBasic.get(Tag.EARLYTERMINATION)).stream()
                        .map(CondJump.class::cast)
                        .map(j -> bmgr.not(bmgr.and(context.execution(j), context.jumpCondition(j))))
                        .reduce(bmgr.makeTrue(), bmgr::and);

                atLeastOneStuck = bmgr.or(atLeastOneStuck, isStuck);
                allStuckOrDone = bmgr.and(allStuckOrDone, bmgr.or(isStuck, isTerminatingNormally));
            }

            final BooleanFormula deadlockVariable = LIVENESS.getSMTVariable(context);
            final BooleanFormula hasLivenessViolation = bmgr.and(allStuckOrDone, atLeastOneStuck);
            return bmgr.and(deadlockVariable, bmgr.equivalence(deadlockVariable, hasLivenessViolation));
        }

        // Compute "stuckness": A thread is stuck if it reaches a spin loop bound event
        // while only reading from co-maximal stores.
        private BooleanFormula generateStucknessEncoding(List<SpinIteration> loops, EncodingContext context) {
            final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
            final RelationAnalysis ra = PropertyEncoder.this.ra;
            final Relation rf = memoryModel.getRelation(RelationNameRepository.RF);
            final EncodingContext.EdgeEncoder rfEncoder = context.edge(rf);
            final TupleSet rfMaySet = ra.getKnowledge(rf).getMaySet();

            if (loops.isEmpty()) {
                return bmgr.makeFalse();
            }

            BooleanFormula isStuck = bmgr.makeFalse();
            for (SpinIteration loop : loops) {
                BooleanFormula allLoadsAreCoMaximal = bmgr.makeTrue();
                for (Load load : loop.containedLoads) {
                    final BooleanFormula readsCoMaximalStore = rfMaySet.getBySecond(load).stream()
                            .map(rfEdge -> bmgr.and(rfEncoder.encode(rfEdge), lastCoVar(rfEdge.getFirst())))
                            .reduce(bmgr.makeFalse(), bmgr::or);
                    final BooleanFormula isCoMaximalLoad = bmgr.implication(context.execution(load), readsCoMaximalStore);
                    allLoadsAreCoMaximal = bmgr.and(allLoadsAreCoMaximal, isCoMaximalLoad);
                }
                // Note that we assume (for now) that a SPINLOOP-tagged jump is executed only if the loop iteration
                // was side-effect free.
                final BooleanFormula isSideEffectFree = loop.spinningJumps.stream()
                        .map(j -> bmgr.and(context.execution(j), context.jumpCondition(j)))
                        .reduce(bmgr.makeFalse(), bmgr::or);
                isStuck = bmgr.or(isStuck, bmgr.and(isSideEffectFree, allLoadsAreCoMaximal));
            }
            return isStuck;
        }

        private List<SpinIteration> findSpinLoopsInThread(Thread thread, LoopAnalysis loopAnalysis) {
            final List<LoopAnalysis.LoopInfo> loops = loopAnalysis.getLoopsOfThread(thread);
            final List<SpinIteration> spinIterations = new ArrayList<>();

            for (LoopAnalysis.LoopInfo loop : loops) {
                for (LoopAnalysis.LoopIterationInfo iter : loop.getIterations()) {
                    final List<Event> iterBody = iter.computeBody();
                    final List<CondJump> spinningJumps = iterBody.stream()
                            .filter(e -> e instanceof CondJump && e.is(Tag.SPINLOOP))
                            .map(CondJump.class::cast)
                            .collect(Collectors.toList());

                    if (!spinningJumps.isEmpty()) {
                        final List<Load> loads = iterBody.stream()
                                .filter(Load.class::isInstance)
                                .map(Load.class::cast)
                                .collect(Collectors.toList());

                        final SpinIteration spinIter = new SpinIteration();
                        spinIter.spinningJumps.addAll(spinningJumps);
                        spinIter.containedLoads.addAll(loads);
                        spinIterations.add(spinIter);
                    }
                }
            }

            return spinIterations;
        }
    }
}