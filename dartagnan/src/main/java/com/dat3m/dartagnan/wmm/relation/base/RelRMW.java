package com.dat3m.dartagnan.wmm.relation.base;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.svcomp.event.EndAtomic;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterIntersection;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Flag;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Sets;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.List;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.program.utils.EType.SVCOMPATOMIC;
import static com.dat3m.dartagnan.program.utils.Utils.generalEqual;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.RMW;
import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;

/*
    NOTE: Changes to the semantics of this class may need to be reflected
    in RMWGraph for Refinement!
 */
public class RelRMW extends StaticRelation {

	private static final Logger logger = LogManager.getLogger(RelRMW.class);

    private final FilterAbstract loadExclFilter = FilterIntersection.get(
            FilterBasic.get(EType.EXCL),
            FilterBasic.get(EType.READ)
    );

    private final FilterAbstract storeExclFilter = FilterIntersection.get(
            FilterBasic.get(EType.EXCL),
            FilterBasic.get(EType.WRITE)
    );

    // Set without exclusive events
    private TupleSet baseMaxTupleSet;

    public RelRMW(){
        term = RMW;
    }

    @Override
    public void initialise(VerificationTask task, SolverContext ctx){
        super.initialise(task, ctx);
        this.baseMaxTupleSet = null;
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            getMaxTupleSet();
            minTupleSet = baseMaxTupleSet;

        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
        	logger.info("Computing maxTupleSet for " + getName());
            baseMaxTupleSet = new TupleSet();

            // RMWLoad -> RMWStore
            FilterAbstract filter = FilterIntersection.get(FilterBasic.get(EType.RMW), FilterBasic.get(EType.WRITE));
            for(Event store : task.getProgram().getCache().getEvents(filter)){
            	if(store instanceof RMWStore) {
                    baseMaxTupleSet.add(new Tuple(((RMWStore)store).getLoadEvent(), store));            		
            	}
            }

            //Locks: Load -> CondJump -> Store
            filter = FilterIntersection.get(FilterBasic.get(EType.RMW), FilterBasic.get(EType.LOCK));
            for(Event e : task.getProgram().getCache().getEvents(filter)){
            	if(e instanceof Load) {
            	    // Connect Load to Store
            		baseMaxTupleSet.add(new Tuple(e, e.getSuccessor().getSuccessor()));
            	}
            }

            // Atomics blocks: BeginAtomic -> EndAtomic
            filter = FilterIntersection.get(FilterBasic.get(EType.RMW), FilterBasic.get(SVCOMPATOMIC));
            for(Event end : task.getProgram().getCache().getEvents(filter)){
                List<Event> block = ((EndAtomic)end).getBlock().stream().filter(x -> x.is(EType.VISIBLE)).collect(Collectors.toList());
                for (int i = 0; i < block.size(); i++) {
                    for (int j = i + 1; j < block.size(); j++) {
                        baseMaxTupleSet.add(new Tuple(block.get(i), block.get(j)));
                    }

                }
            }
            removeMutuallyExclusiveTuples(baseMaxTupleSet);

            maxTupleSet = new TupleSet();
            maxTupleSet.addAll(baseMaxTupleSet);

            // LoadExcl -> StoreExcl
            //TODO: This can be improved using branching analysis
            // to find guaranteed pairs (the encoding can then also be improved)
            for(Thread thread : task.getProgram().getThreads()){
                for(Event load : thread.getCache().getEvents(loadExclFilter)){
                    for(Event store : thread.getCache().getEvents(storeExclFilter)){
                        if(load.getCId() < store.getCId()){
                            maxTupleSet.add(new Tuple(load, store));
                        }
                    }
                }
            }
            removeMutuallyExclusiveTuples(maxTupleSet);
            logger.info("maxTupleSet size for " + getName() + ": " + maxTupleSet.size());
        }
        return maxTupleSet;
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
        FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        
        // Encode base (not exclusive pairs) RMW
        TupleSet origEncodeTupleSet = encodeTupleSet;
        encodeTupleSet = new TupleSet(Sets.intersection(encodeTupleSet, baseMaxTupleSet));
        BooleanFormula enc = super.encodeApprox(ctx);
        encodeTupleSet = origEncodeTupleSet;

        // Encode RMW for exclusive pairs
		BooleanFormula unpredictable = bmgr.makeFalse();
        for(Thread thread : task.getProgram().getThreads()) {
            for (Event store : thread.getCache().getEvents(storeExclFilter)) {
            	BooleanFormula storeExec = bmgr.makeFalse();
                for (Event load : thread.getCache().getEvents(loadExclFilter)) {
                    if (load.getCId() < store.getCId()) {

                        // Encode if load and store form an exclusive pair
                    	BooleanFormula isPair = exclPair(load, store, ctx);
                    	BooleanFormula isExecPair = bmgr.and(isPair, store.exec());
                        enc = bmgr.and(enc, bmgr.equivalence(isPair, pairingCond(thread, load, store, ctx)));

                        // If load and store have the same address
                        BooleanFormula sameAddress = generalEqual(((MemEvent)load).getMemAddressExpr(), ((MemEvent)store).getMemAddressExpr(), ctx);
                        unpredictable = bmgr.or(unpredictable, bmgr.and(isExecPair, bmgr.not(sameAddress)));

                        // Relation between exclusive load and store
                        enc = bmgr.and(enc, bmgr.equivalence(this.getSMTVar(load, store, ctx), bmgr.and(isExecPair, sameAddress)));

                        // Can be executed if addresses mismatch, but behaviour is "constrained unpredictable"
                        // The implementation does not include all possible unpredictable cases: in case of address
                        // mismatch, addresses of read and write are unknown, i.e. read and write can use any address
                        storeExec = bmgr.or(storeExec, isPair);
                    }
                }
                enc = bmgr.and(enc, bmgr.implication(store.exec(), storeExec));
            }
        }
        return bmgr.and(enc, bmgr.equivalence(Flag.ARM_UNPREDICTABLE_BEHAVIOUR.repr(ctx), unpredictable));
    }

    private BooleanFormula pairingCond(Thread thread, Event load, Event store, SolverContext ctx){
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula pairingCond = bmgr.and(load.exec(), store.cf());

        for (Event otherLoad : thread.getCache().getEvents(loadExclFilter)) {
            if (otherLoad.getCId() > load.getCId() && otherLoad.getCId() < store.getCId()) {
                pairingCond = bmgr.and(pairingCond, bmgr.not(otherLoad.exec()));
            }
        }
        for (Event otherStore : thread.getCache().getEvents(storeExclFilter)) {
            if (otherStore.getCId() > load.getCId() && otherStore.getCId() < store.getCId()) {
                pairingCond = bmgr.and(pairingCond, bmgr.not(otherStore.cf()));
            }
        }
        return pairingCond;
    }

    private BooleanFormula exclPair(Event load, Event store, SolverContext ctx){
    	return ctx.getFormulaManager().makeVariable(BooleanType, "excl(" + load.getCId() + "," + store.getCId() + ")");
    }
}