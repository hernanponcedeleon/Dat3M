package com.dat3m.dartagnan.wmm.relation.base;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterIntersection;
import com.dat3m.dartagnan.program.filter.FilterUnion;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Flag;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;
import static com.dat3m.dartagnan.program.event.Tag.SVCOMP.SVCOMPATOMIC;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.RMW;
import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;

/*
    NOTE: Changes to the semantics of this class may need to be reflected
    in RMWGraph for Refinement!
 */
public class RelRMW extends StaticRelation {

	private static final Logger logger = LogManager.getLogger(RelRMW.class);

    public RelRMW(){
        term = RMW;
        forceDoEncode = true;
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            getMaxTupleSet();
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
        	logger.info("Computing maxTupleSet for " + getName());
            minTupleSet = new TupleSet();

            // RMWLoad -> RMWStore
            FilterAbstract filter = FilterIntersection.get(FilterBasic.get(Tag.RMW), FilterBasic.get(Tag.WRITE));
            for(Event store : task.getProgram().getCache().getEvents(filter)){
            	if(store instanceof RMWStore) {
                    minTupleSet.add(new Tuple(((RMWStore)store).getLoadEvent(), store));
            	}
            }

            // Locks: Load -> Assume/CondJump -> Store
            FilterAbstract locks = FilterUnion.get(FilterBasic.get(Tag.C11.LOCK), 
            									   FilterBasic.get(Tag.Linux.LOCK_READ));
            filter = FilterIntersection.get(FilterBasic.get(Tag.RMW), locks);
            for(Event e : task.getProgram().getCache().getEvents(filter)){
            	// Connect Load to Store
                minTupleSet.add(new Tuple(e, e.getSuccessor().getSuccessor()));
            }

            // Atomics blocks: BeginAtomic -> EndAtomic
            filter = FilterIntersection.get(FilterBasic.get(Tag.RMW), FilterBasic.get(SVCOMPATOMIC));
            for(Event end : task.getProgram().getCache().getEvents(filter)){
                List<Event> block = ((EndAtomic)end).getBlock().stream().filter(x -> x.is(Tag.VISIBLE)).collect(Collectors.toList());
                for (int i = 0; i < block.size(); i++) {
                    for (int j = i + 1; j < block.size(); j++) {
                        minTupleSet.add(new Tuple(block.get(i), block.get(j)));
                    }

                }
            }
            removeMutuallyExclusiveTuples(minTupleSet);

            maxTupleSet = new TupleSet();
            maxTupleSet.addAll(minTupleSet);

            // LoadExcl -> StoreExcl
            for(Thread thread : task.getProgram().getThreads()) {
                addMatchingTupleSet(thread.getCache().getEvents(FilterBasic.get(Tag.EXCL)), Tag.READ, Tag.WRITE);
            }
            logger.info("maxTupleSet size for " + getName() + ": " + maxTupleSet.size());
        }
        return maxTupleSet;
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
        FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();
        BooleanFormula unpredictable = bmgr.makeFalse();
        Map<Event, BooleanFormula> map = new HashMap<>();
        for(Tuple tuple : maxTupleSet) {
            // not necessarily memory events
            Event load = tuple.getFirst();
            Event store = tuple.getSecond();
            BooleanFormula rel = this.getSMTVar(tuple, ctx);
            if(minTupleSet.contains(tuple)) {
                enc = bmgr.and(enc, bmgr.equivalence(rel, getExecPair(tuple, ctx)));
                if(!store.cfImpliesExec()) {
                    map.merge(store, load.exec(), bmgr::or);
                }
            } else {
                // Encode if load and store form an exclusive pair
                BooleanFormula isPair = exclPair(load, store, ctx);
                BooleanFormula isExecPair = bmgr.and(isPair, store.exec());
                enc = bmgr.and(enc, bmgr.equivalence(isPair, pairingCond(load, store, ctx)));
                // If load and store have the same address
                BooleanFormula sameAddress = generalEqual(((MemEvent) load).getMemAddressExpr(), ((MemEvent) store).getMemAddressExpr(), ctx);
                unpredictable = bmgr.or(unpredictable, bmgr.and(isExecPair, bmgr.not(sameAddress)));
                // Relation between exclusive load and store
                enc = bmgr.and(enc, bmgr.equivalence(rel, bmgr.and(isExecPair, sameAddress)));
                // Can be executed if addresses mismatch, but behaviour is "constrained unpredictable"
                // The implementation does not include all possible unpredictable cases: in case of address
                // mismatch, addresses of read and write are unknown, i.e. read and write can use any address
                map.merge(store, isPair, bmgr::or);
            }
        }
        for(Map.Entry<Event, BooleanFormula> entry : map.entrySet()) {
            enc = bmgr.and(enc, bmgr.implication(entry.getKey().exec(), entry.getValue()));
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