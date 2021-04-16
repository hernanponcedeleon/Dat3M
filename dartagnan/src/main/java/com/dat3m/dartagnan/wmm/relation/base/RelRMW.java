package com.dat3m.dartagnan.wmm.relation.base;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.svcomp.event.EndAtomic;
import com.dat3m.dartagnan.program.arch.aarch64.utils.EType;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterIntersection;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Flag;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Sets;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import static com.dat3m.dartagnan.program.utils.EType.SVCOMPATOMIC;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;
import java.util.stream.Collectors;

public class RelRMW extends StaticRelation {

	private static final Logger logger = LogManager.getLogger(RelRMW.class);

    private final FilterAbstract loadFilter  = FilterIntersection.get(
            FilterBasic.get(EType.EXCL),
            FilterBasic.get(EType.READ)
    );

    private final FilterAbstract storeFilter = FilterIntersection.get(
            FilterBasic.get(EType.EXCL),
            FilterBasic.get(EType.WRITE)
    );

    // Set without exclusive events
    private TupleSet baseMaxTupleSet;

    public RelRMW(){
        term = "rmw";
        forceDoEncode = true;
    }

    @Override
    public void initialise(VerificationTask task, Context ctx){
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
                for(Event load : thread.getCache().getEvents(loadFilter)){
                    for(Event store : thread.getCache().getEvents(storeFilter)){
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
    protected BoolExpr encodeApprox(Context ctx) {
        // Encode base (not exclusive pairs) RMW
        TupleSet origEncodeTupleSet = encodeTupleSet;
        encodeTupleSet = new TupleSet(Sets.intersection(encodeTupleSet, baseMaxTupleSet));
        BoolExpr enc = super.encodeApprox(ctx);
        encodeTupleSet = origEncodeTupleSet;

        // Encode RMW for exclusive pairs
        BoolExpr unpredictable = ctx.mkFalse();
        for(Thread thread : task.getProgram().getThreads()) {
            for (Event store : thread.getCache().getEvents(storeFilter)) {
                BoolExpr storeExec = ctx.mkFalse();
                for (Event load : thread.getCache().getEvents(loadFilter)) {
                    if (load.getCId() < store.getCId()) {

                        // Encode if load and store form an exclusive pair
                        BoolExpr isPair = exclPair(load, store, ctx);
                        BoolExpr isExecPair = ctx.mkAnd(isPair, store.exec());
                        enc = ctx.mkAnd(enc, ctx.mkEq(isPair, pairingCond(thread, load, store, ctx)));

                        // If load and store have the same address
                        BoolExpr sameAddress = ctx.mkEq(((MemEvent)load).getMemAddressExpr(), (((MemEvent)store).getMemAddressExpr()));
                        unpredictable = ctx.mkOr(unpredictable, ctx.mkAnd(isExecPair, ctx.mkNot(sameAddress)));

                        // Relation between exclusive load and store
                        enc = ctx.mkAnd(enc, ctx.mkEq(this.getSMTVar(load, store, ctx), ctx.mkAnd(isExecPair, sameAddress)));

                        // Can be executed if addresses mismatch, but behaviour is "constrained unpredictable"
                        // The implementation does not include all possible unpredictable cases: in case of address
                        // mismatch, addresses of read and write are unknown, i.e. read and write can use any address
                        storeExec = ctx.mkOr(storeExec, isPair);
                    }
                }
                enc = ctx.mkAnd(enc, ctx.mkImplies(store.exec(), storeExec));
            }
        }
        return ctx.mkAnd(enc, ctx.mkEq(Flag.ARM_UNPREDICTABLE_BEHAVIOUR.repr(ctx), unpredictable));
    }

    private BoolExpr pairingCond(Thread thread, Event load, Event store, Context ctx){
        BoolExpr pairingCond = ctx.mkAnd(load.exec(), store.cf());

        for (Event otherLoad : thread.getCache().getEvents(loadFilter)) {
            if (otherLoad.getCId() > load.getCId() && otherLoad.getCId() < store.getCId()) {
                pairingCond = ctx.mkAnd(pairingCond, ctx.mkNot(otherLoad.exec()));
            }
        }
        for (Event otherStore : thread.getCache().getEvents(storeFilter)) {
            if (otherStore.getCId() > load.getCId() && otherStore.getCId() < store.getCId()) {
                pairingCond = ctx.mkAnd(pairingCond, ctx.mkNot(otherStore.cf()));
            }
        }
        return pairingCond;
    }

    private BoolExpr exclPair(Event load, Event store, Context ctx){
        return ctx.mkBoolConst("excl(" + load.getCId() + "," + store.getCId() + ")");
    }
}