package com.dat3m.dartagnan.wmm.relation.base;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterIntersection;
import com.dat3m.dartagnan.program.filter.FilterUnion;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Flag;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.List;

import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;
import static com.dat3m.dartagnan.program.event.Tag.SVCOMP.SVCOMPATOMIC;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.RMW;
import static com.google.common.base.Preconditions.checkState;
import static java.util.stream.Collectors.toList;
import static java.util.stream.IntStream.iterate;
import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;

/*
    NOTE: Changes to the semantics of this class may need to be reflected
    in RMWGraph for Refinement!
 */
public class RelRMW extends StaticRelation {

    public RelRMW(){
        term = RMW;
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            computeTupleSets();
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            computeTupleSets();
        }
        return maxTupleSet;
    }

    private void computeTupleSets() {
        // ----- Compute minTupleSet -----
        minTupleSet = new TupleSet();
        // RMWLoad -> RMWStore
        for(Event store : task.getProgram().getCache().getEvents(
                FilterIntersection.get(FilterBasic.get(Tag.RMW), FilterBasic.get(Tag.WRITE)))){
            if(store instanceof RMWStore) {
                minTupleSet.add(new Tuple(((RMWStore)store).getLoadEvent(), store));
            }
        }
        // Locks: Load -> Assume/CondJump -> Store
        for(Event e : task.getProgram().getCache().getEvents(FilterIntersection.get(
                FilterIntersection.get(FilterBasic.get(Tag.RMW), FilterBasic.get(Tag.READ)),
                FilterUnion.get(FilterBasic.get(Tag.C11.LOCK), FilterBasic.get(Tag.Linux.LOCK_READ))))){
            // Connect Load to Store
            minTupleSet.add(new Tuple(e, e.getSuccessor().getSuccessor()));
        }
        // Atomics blocks: BeginAtomic -> EndAtomic
        for(Event end : task.getProgram().getCache().getEvents(
                FilterIntersection.get(FilterBasic.get(Tag.RMW), FilterBasic.get(SVCOMPATOMIC)))){
            List<Event> block = ((EndAtomic)end).getBlock().stream().filter(x -> x.is(Tag.VISIBLE)).collect(toList());
            for (int i = 0; i < block.size(); i++) {
                for (int j = i + 1; j < block.size(); j++) {
                    minTupleSet.add(new Tuple(block.get(i), block.get(j)));
                }

            }
        }
        removeMutuallyExclusiveTuples(minTupleSet);

        // ----- Compute maxTupleSet -----
        final AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
        final ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
        maxTupleSet = new TupleSet(minTupleSet);
        // LoadExcl -> StoreExcl
        for (Thread thread : task.getProgram().getThreads()) {
            List<Event> events = thread.getCache().getEvents(FilterBasic.get(Tag.EXCL));
            // assume order by cId
            // assume cId describes a topological sorting over the control flow
            for (int end = 1; end < events.size(); end++) {
                Event store = events.get(end);
                if (!store.is(Tag.WRITE)) {
                    continue;
                }
                int start = iterate(end - 1, i -> i >= 0, i -> i - 1)
                        .filter(i -> exec.isImplied(store, events.get(i)))
                        .findFirst().orElse(0);
                List<Event> candidates = events.subList(start, end).stream()
                        .filter(e -> !exec.areMutuallyExclusive(e, store))
                        .collect(toList());
                int size = candidates.size();
                for (int i = 0; i < size; i++) {
                    Event load = candidates.get(i);
                    List<Event> intermediaries = candidates.subList(i + 1, size);
                    if (!load.is(Tag.READ) || intermediaries.stream().anyMatch(e -> exec.isImplied(load, e))) {
                        continue;
                    }
                    Tuple tuple = new Tuple(load, store);
                    maxTupleSet.add(tuple);
                    if (intermediaries.stream().allMatch(e -> exec.areMutuallyExclusive(load, e)) &&
                            (store.is(Tag.MATCHADDRESS) || alias.mustAlias((MemEvent) load, (MemEvent) store))) {
                        minTupleSet.add(tuple);
                    }
                }
            }
        }
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
        FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();
        BooleanFormula unpredictable = bmgr.makeFalse();
        for(Event store : task.getProgram().getCache().getEvents(
                FilterIntersection.get(FilterBasic.get(Tag.WRITE), FilterBasic.get(Tag.EXCL)))) {
            checkState(store instanceof MemEvent, "non-memory event participating in '" + getName() + "'");
            BooleanFormula storeExec = bmgr.makeFalse();
            for(Tuple t : maxTupleSet.getBySecond(store)) {
                MemEvent load = (MemEvent) t.getFirst();
                BooleanFormula sameAddress = generalEqual(load.getMemAddressExpr(), ((MemEvent) store).getMemAddressExpr(), ctx);
                // Encode if load and store form an exclusive pair
                BooleanFormula isPair = exclPair(load, store, ctx);
                BooleanFormula pairingCond = pairingCond(load, store, ctx);
                // For ARMv8, the store can be executed if addresses mismatch, but behaviour is "constrained unpredictable"
                // The implementation does not include all possible unpredictable cases: in case of address
                // mismatch, addresses of read and write are unknown, i.e. read and write can use any address.
                // For RISCV and Power, addresses should match.
                if(store.is(Tag.MATCHADDRESS)) {
                    pairingCond = bmgr.and(pairingCond, sameAddress);
                } else {
                    unpredictable = bmgr.or(unpredictable, bmgr.and(store.exec(), isPair, bmgr.not(sameAddress)));
                }
                enc = bmgr.and(enc, bmgr.equivalence(isPair, pairingCond));
                storeExec = bmgr.or(storeExec, isPair);
            }
            enc = bmgr.and(enc, bmgr.implication(store.exec(), storeExec));
        }

        final AliasAnalysis alias = analysisContext.requires(AliasAnalysis.class);
        for(Tuple tuple : encodeTupleSet) {
            MemEvent load = (MemEvent) tuple.getFirst();
            MemEvent store = (MemEvent) tuple.getSecond();
            BooleanFormula sameAddress = (alias.mustAlias(load, store) || store.is(Tag.MATCHADDRESS)) ? bmgr.makeTrue()
                    : generalEqual(load.getMemAddressExpr(), store.getMemAddressExpr(), ctx);
            enc = bmgr.and(enc, bmgr.equivalence(
                    getSMTVar(tuple, ctx),
                    minTupleSet.contains(tuple) ? getExecPair(tuple, ctx) :
                            // Relation between exclusive load and store
                            bmgr.and(store.exec(), exclPair(load, store, ctx), sameAddress)));
        }
        return bmgr.and(enc, bmgr.equivalence(Flag.ARM_UNPREDICTABLE_BEHAVIOUR.repr(ctx), unpredictable));
    }

    private BooleanFormula pairingCond(Event load, Event store, SolverContext ctx){
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula pairingCond = bmgr.and(load.exec(), store.cf());

        for (Tuple t : maxTupleSet.getBySecond(store)) {
            Event otherLoad = t.getFirst();
            if(otherLoad.getCId() > load.getCId()) {
                pairingCond = bmgr.and(pairingCond, bmgr.not(otherLoad.exec()));
            }
        }
        for (Tuple t : maxTupleSet.getByFirst(load)) {
            Event otherStore = t.getSecond();
            if(otherStore.getCId() < store.getCId()) {
                pairingCond = bmgr.and(pairingCond, bmgr.not(otherStore.cf()));
            }
        }
        return pairingCond;
    }

    private BooleanFormula exclPair(Event load, Event store, SolverContext ctx){
    	return ctx.getFormulaManager().makeVariable(BooleanType, "excl(" + load.getCId() + "," + store.getCId() + ")");
    }
}