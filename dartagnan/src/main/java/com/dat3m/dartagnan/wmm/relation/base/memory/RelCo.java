package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.EventCache;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterMinus;
import com.dat3m.dartagnan.wmm.analysis.WmmAnalysis;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
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

import static com.dat3m.dartagnan.configuration.OptionNames.IDL_TO_SAT;
import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;
import static com.dat3m.dartagnan.program.event.Tag.INIT;
import static com.dat3m.dartagnan.program.event.Tag.WRITE;
import static com.dat3m.dartagnan.wmm.analysis.RelationAnalysis.findTransitivelyImpliedCo;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.utils.Utils.*;

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
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitMemoryOrder(this);
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
        return useSATEncoding ? encodeSAT(ctx) : encodeIDL(ctx);
    }

    private BooleanFormula encodeIDL(SolverContext ctx) {
        final AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
        final BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        final IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();
        final EventCache cache = task.getProgram().getCache();
        final List<MemEvent> allWrites = new ArrayList<>(Lists.transform(cache.getEvents(FilterBasic.get(WRITE)), MemEvent.class::cast));
        allWrites.sort(Comparator.comparingInt(Event::getCId));
        final TupleSet maxSet = getMaxTupleSet();
        final Set<Tuple> transCo = findTransitivelyImpliedCo(this, exec);

        BooleanFormula enc = bmgr.makeTrue();
        // ---- Encode clock conditions (init = 0, non-init > 0) ----
        IntegerFormula zero = imgr.makeNumber(0);
        for (MemEvent w : allWrites) {
            IntegerFormula clock = coClockVar(w, ctx);
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
                        imgr.lessThan(coClockVar(w1, ctx), coClockVar(w2, ctx));
                BooleanFormula bCond = (w2.is(INIT) || transCo.contains(t.getInverse())) ? bmgr.makeTrue() :
                        imgr.lessThan(coClockVar(w2, ctx), coClockVar(w1, ctx));
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
}