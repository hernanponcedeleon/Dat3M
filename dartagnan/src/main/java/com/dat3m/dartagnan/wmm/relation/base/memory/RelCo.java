package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.EventCache;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterMinus;
import com.dat3m.dartagnan.wmm.analysis.WmmAnalysis;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.base.Preconditions;
import com.google.common.base.Predicate;
import com.google.common.collect.Lists;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.IDL_TO_SAT;
import static com.dat3m.dartagnan.configuration.Property.LIVENESS;
import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;
import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.dat3m.dartagnan.program.event.Tag.INIT;
import static com.dat3m.dartagnan.program.event.Tag.WRITE;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;
import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;

@Options
public class RelCo extends Relation {

	private static final Logger logger = LogManager.getLogger(RelCo.class);

    // =========================== Configurables ===========================

    @Option(
            name=IDL_TO_SAT,
            description = "Use SAT-based encoding for totality and acyclicity.",
            secure = true)
    private boolean useSATEncoding = false;

    public boolean usesSATEncoding() { return useSATEncoding; }

	// =====================================================================

    public RelCo(){
        term = CO;
    }

    @Override
    public void configure(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            final WmmAnalysis wmmAnalysis = analysisContext.get(WmmAnalysis.class);
            minTupleSet = new TupleSet();
            if (wmmAnalysis.isLocallyConsistent()) {
                applyLocalConsistencyMinSet();
            }
        }
        return minTupleSet;
    }

    private void applyLocalConsistencyMinSet() {
        final AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
        for (Tuple t : getMaxTupleSet()) {
            MemEvent w1 = (MemEvent) t.getFirst();
            MemEvent w2 = (MemEvent) t.getSecond();
            if (!w2.is(INIT) && alias.mustAlias(w1, w2) && (w1.is(INIT) || t.isForward())) {
                minTupleSet.add(t);
            }
        }
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
        	logger.info("Computing maxTupleSet for " + getName());
        	final AliasAnalysis alias = analysisContext.requires(AliasAnalysis.class);
            final ExecutionAnalysis exec = analysisContext.requires(ExecutionAnalysis.class);
            final WmmAnalysis wmmAnalysis = analysisContext.requires(WmmAnalysis.class);
            final List<Event> allWrites = task.getProgram().getCache().getEvents(FilterBasic.get(WRITE));
            final List<Event> nonInitWrites = task.getProgram().getCache().getEvents(FilterMinus.get(
                    FilterBasic.get(WRITE),
                    FilterBasic.get(INIT)
            ));

            maxTupleSet = new TupleSet();
            for (Event w1 : allWrites) {
                for (Event w2 : nonInitWrites) {
                    if(w1.getCId() != w2.getCId() && !exec.areMutuallyExclusive(w1, w2)
                            && alias.mayAlias((MemEvent) w1, (MemEvent)w2)) {
                        maxTupleSet.add(new Tuple(w1, w2));
                    }
                }
            }

            if (wmmAnalysis.isLocallyConsistent()) {
                maxTupleSet.removeIf(Tuple::isBackward);
            }

            logger.info("maxTupleSet size for " + getName() + ": " + maxTupleSet.size());
        }
        return maxTupleSet;
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
        final BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        final boolean doEncodeLastCo = task.getProgram().getFormat().equals(LITMUS) || task.getProperty().contains(LIVENESS);

        BooleanFormula enc = useSATEncoding ? encodeSAT(ctx) : encodeIDL(ctx);
        if (doEncodeLastCo) {
            enc = bmgr.and(enc, encodeLastCoConstraints(ctx));
        }

        return enc;
    }

    private BooleanFormula encodeIDL(SolverContext ctx) {
        final AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
        final BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        final IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();
        final EventCache cache = task.getProgram().getCache();
        final List<MemEvent> allWrites = new ArrayList<>(Lists.transform(cache.getEvents(FilterBasic.get(WRITE)), MemEvent.class::cast));
        allWrites.sort(Comparator.comparingInt(Event::getCId));
        final TupleSet maxSet = getMaxTupleSet();
        final Set<Tuple> transCo = findTransitivelyImpliedCo();

        BooleanFormula enc = bmgr.makeTrue();
        // ---- Encode clock conditions (init = 0, non-init > 0) ----
        IntegerFormula zero = imgr.makeNumber(0);
        for (MemEvent w : allWrites) {
            IntegerFormula clock = getClockVar(w, ctx);
            enc = bmgr.and(enc, w.is(INIT) ? imgr.equal(clock, zero) : imgr.greaterThan(clock, zero));
        }

        // ---- Encode coherences ----
        for (int i = 0; i < allWrites.size() - 1; i++) {
            MemEvent w1 = allWrites.get(i);
            for (MemEvent w2 : allWrites.subList(i + 1, allWrites.size())) {
                Tuple t = new Tuple(w1, w2);
                boolean forwardPossible = maxSet.contains(t);
                boolean backwardPossible = maxSet.contains(t.getInverse());
                if (!forwardPossible && ! backwardPossible) {
                    continue;
                }

                BooleanFormula execPair = getExecPair(t, ctx);
                BooleanFormula sameAddress = alias.mustAlias(w1, w2) ? bmgr.makeTrue() :
                        generalEqual(w1.getMemAddressExpr(), w2.getMemAddressExpr(), ctx);
                BooleanFormula pairingCond = bmgr.and(execPair, sameAddress);
                BooleanFormula fCond = (w1.is(INIT) || transCo.contains(t)) ? bmgr.makeTrue() :
                        imgr.lessThan(getClockVar(w1, ctx), getClockVar(w2, ctx));
                BooleanFormula bCond = (w2.is(INIT) || transCo.contains(t.getInverse())) ? bmgr.makeTrue() :
                        imgr.lessThan(getClockVar(w2, ctx), getClockVar(w1, ctx));
                BooleanFormula coF = forwardPossible ? getSMTVar(w1, w2, ctx) : bmgr.makeFalse();
                BooleanFormula coB = backwardPossible ? getSMTVar(w2, w1, ctx) : bmgr.makeFalse();

                enc = bmgr.and(enc,
                        bmgr.implication(coF, fCond),
                        bmgr.implication(coB, bCond),
                        bmgr.equivalence(pairingCond, bmgr.or(coF, coB))
                );
            }
        }

        return enc;
    }

    protected BooleanFormula encodeSAT(SolverContext ctx) {
        final AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
        final BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        final EventCache cache = task.getProgram().getCache();
        final List<MemEvent> allWrites = new ArrayList<>(Lists.transform(cache.getEvents(FilterBasic.get(WRITE)), MemEvent.class::cast));
        allWrites.sort(Comparator.comparingInt(Event::getCId));
        final TupleSet maxSet = getMaxTupleSet();
        final TupleSet minSet = getMinTupleSet();

        BooleanFormula enc = bmgr.makeTrue();
        // ---- Encode coherences ----
        for (int i = 0; i < allWrites.size() - 1; i++) {
            MemEvent w1 = allWrites.get(i);
            for (MemEvent w2 : allWrites.subList(i + 1, allWrites.size())) {
                Tuple t = new Tuple(w1, w2);
                Tuple tInv = t.getInverse();
                boolean forwardPossible = maxSet.contains(t);
                boolean backwardPossible = maxSet.contains(tInv);
                if (!forwardPossible && !backwardPossible) {
                    continue;
                }

                BooleanFormula execPair = getExecPair(t, ctx);
                BooleanFormula sameAddress = alias.mustAlias(w1, w2) ? bmgr.makeTrue() :
                        generalEqual(w1.getMemAddressExpr(), w2.getMemAddressExpr(), ctx);
                BooleanFormula pairingCond = bmgr.and(execPair, sameAddress);
                BooleanFormula coF = forwardPossible ? getSMTVar(w1, w2, ctx) : bmgr.makeFalse();
                BooleanFormula coB = backwardPossible ? getSMTVar(w2, w1, ctx) : bmgr.makeFalse();

                enc = bmgr.and(enc,
                        bmgr.equivalence(pairingCond, bmgr.or(coF, coB)),
                        bmgr.or(bmgr.not(coF), bmgr.not(coB))
                );

                if (!minSet.contains(t) && !minSet.contains(tInv)) {
                    for (MemEvent w3 : allWrites) {
                        Tuple t1 = new Tuple(w1, w3);
                        Tuple t2 = new Tuple(w3, w2);
                        if (forwardPossible && maxSet.contains(t1) && maxSet.contains(t2)) {
                            BooleanFormula co1 = getSMTVar(w1, w3, ctx);
                            BooleanFormula co2 = getSMTVar(w3, w2, ctx);
                            enc = bmgr.and(enc, bmgr.implication(bmgr.and(co1, co2), coF));
                        }
                        if (backwardPossible && maxSet.contains(t1.getInverse()) && maxSet.contains(t2.getInverse())) {
                            BooleanFormula co1 = getSMTVar(w2, w3, ctx);
                            BooleanFormula co2 = getSMTVar(w3, w1, ctx);
                            enc = bmgr.and(enc, bmgr.implication(bmgr.and(co1, co2), coB));
                        }
                    }
                }
            }
        }

        return enc;
    }

    private BooleanFormula encodeLastCoConstraints(SolverContext ctx) {
        final AliasAnalysis alias = analysisContext.requires(AliasAnalysis.class);
        final ExecutionAnalysis exec = analysisContext.requires(ExecutionAnalysis.class);
        final BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        final TupleSet minSet = getMinTupleSet();
        final TupleSet maxSet = getMaxTupleSet();
        final EventCache cache = task.getProgram().getCache();
        final List<Init> initEvents = Lists.transform(cache.getEvents(FilterBasic.get(INIT)), Init.class::cast);
        final List<MemEvent> writes = Lists.transform(cache.getEvents(FilterBasic.get(WRITE)), MemEvent.class::cast);
        final boolean doEncodeFinalAddressValues = task.getProgram().getFormat() == LITMUS;

        // Find transitively implied coherences. We can use these to reduce the encoding.
        final Set<Tuple> transCo = findTransitivelyImpliedCo();
        // Find all writes that are never last, i.e., those that will always have a co-successor.
        final Set<Event> dominatedWrites = minSet.stream()
                .filter(t -> exec.isImplied(t.getFirst(), t.getSecond()))
                .map(Tuple::getFirst).collect(Collectors.toSet());


        // ---- Construct encoding ----
        BooleanFormula enc = bmgr.makeTrue();
        for (MemEvent w1 : writes) {
            if (dominatedWrites.contains(w1)) {
                enc = bmgr.and(enc, bmgr.equivalence(getLastCoVar(w1, ctx), bmgr.makeFalse()));
                continue;
            }

            BooleanFormula isLast = w1.exec();
            // ---- Find all possibly overwriting writes ----
            for (Tuple t : maxSet.getByFirst(w1)) {
                if (transCo.contains(t)) {
                    // We can skip the co-edge (w1,w2), because there will be an intermediate write w3
                    // that already witnesses that w1 is not last.
                    continue;
                }
                Event w2 = t.getSecond();
                BooleanFormula isAfter = minSet.contains(t) ? bmgr.not(w2.exec()) : bmgr.not(getSMTVar(t, ctx));
                isLast = bmgr.and(isLast, isAfter);
            }
            BooleanFormula lastCoExpr = getLastCoVar(w1, ctx);
            enc = bmgr.and(enc, bmgr.equivalence(lastCoExpr, isLast));

            if (doEncodeFinalAddressValues) {
                // ---- Encode final values of addresses ----
                for (Init init : initEvents) {
                    if (!alias.mayAlias(w1, init)) {
                        continue;
                    }
                    IExpr address = init.getAddress();
                    Formula a1 = w1.getMemAddressExpr();
                    Formula a2 = address.toIntFormula(init, ctx);
                    BooleanFormula sameAddress = alias.mustAlias(init, w1) ? bmgr.makeTrue() : generalEqual(a1, a2, ctx);
                    Formula v1 = w1.getMemValueExpr();
                    Formula v2 = init.getBase().getLastMemValueExpr(ctx, init.getOffset());
                    BooleanFormula sameValue = generalEqual(v1, v2, ctx);
                    enc = bmgr.and(enc, bmgr.implication(bmgr.and(lastCoExpr, sameAddress), sameValue));
                }
            }
        }
        return enc;
    }

    /*
        Returns a set of co-edges (w1, w2) (subset of maxTupleSet) whose clock-constraints
        do not need to get encoded explicitly.
        The reason is that whenever we have co(w1,w2) then there exists an intermediary
        w3 s.t. co(w1, w3) /\ co(w3, w2). As a result we have c(w1) < c(w3) < c(w2) transitively.
        Reasoning: Let (w1, w2) be a potential co-edge. Suppose there exists a w3 different to w1 and w2,
        whose execution is either implied by either w1 or w2.
        Now, if co(w1, w3) is a must-edge and co(w2, w3) is impossible, then we can reason as follows.
            - Suppose w1 and w2 get executed and their addresses match, then w3 must also get executed.
            - Since co(w1, w3) is a must-edge, we have that w3 accesses the same address as w1 and w2,
              and c(w1) < c(w3).
            - Because addr(w2)==addr(w3), we must also have either co(w2, e3) or co(w3, w2).
              The former is disallowed by assumption, so we have co(w3, w2) and hence c(w3) < c(w2).
            - By transitivity, we have c(w1) < c(w3) < c(w2) as desired.
            - Note that this reasoning has to be done inductively, because co(w1, w3) or co(w3, w2) may
              not involve encoding a clock constraint (due to this optimization).
        There is also a symmetric case where co(w3, w1) is impossible and co(w3, w2) is a must-edge.

     */
    private Set<Tuple> findTransitivelyImpliedCo() {
        final ExecutionAnalysis exec = analysisContext.requires(ExecutionAnalysis.class);
        final TupleSet min = getMinTupleSet();
        final TupleSet max = getMaxTupleSet();

        Set<Tuple> transCo = new HashSet<>();
        for (final Tuple t : max) {
            final MemEvent e1 = (MemEvent) t.getFirst();
            final MemEvent e2 = (MemEvent) t.getSecond();
            final Predicate<Event> execPred = (e3 -> e3 != e1 && e3 != e2 && (exec.isImplied(e1, e3) || exec.isImplied(e2, e3)));
            final boolean hasIntermediary = min.getByFirst(e1).stream().map(tuple -> (MemEvent)tuple.getSecond())
                                    .anyMatch(e3 -> execPred.apply(e3) && !max.contains(new Tuple(e2, e3))) ||
                                min.getBySecond(e2).stream().map(tuple -> (MemEvent)tuple.getFirst())
                                    .anyMatch(e3 -> execPred.apply(e3) && !max.contains(new Tuple(e3, e1)));
            if (hasIntermediary) {
                transCo.add(t);
            }
        }
        return transCo;
    }

    public IntegerFormula getClockVar(Event write, SolverContext ctx) {
    	Preconditions.checkArgument(write.is(WRITE), "Cannot get a clock-var for non-writes.");
        if (write.is(INIT)) {
            return ctx.getFormulaManager().getIntegerFormulaManager().makeNumber(0);
        }
        return intVar(term, write, ctx);
    }

    public BooleanFormula getLastCoVar(Event write, SolverContext ctx) {
        return ctx.getFormulaManager().makeVariable(BooleanType, "co_last(" + write.repr() + ")");
    }
}