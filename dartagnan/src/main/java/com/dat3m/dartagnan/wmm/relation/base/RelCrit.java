package com.dat3m.dartagnan.wmm.relation.base;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class RelCrit extends StaticRelation {
    //TODO: We can optimize this a lot by using branching analysis

    public RelCrit(){
        term = "crit";
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet();
            // Todo
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Thread thread : task.getProgram().getThreads()){
                for(Event lock : thread.getCache().getEvents(FilterBasic.get(EType.RCU_LOCK))){
                    for(Event unlock : thread.getCache().getEvents(FilterBasic.get(EType.RCU_UNLOCK))){
                        if(lock.getCId() < unlock.getCId()){
                            maxTupleSet.add(new Tuple(lock, unlock));
                        }
                    }
                }
            }
            removeMutuallyExclusiveTuples(maxTupleSet);
        }
        return maxTupleSet;
    }

    // TODO: Not the most efficient implementation
    // Let's see if we need to keep a reference to a thread in events for anything else, and then optimize this method
    @Override
    protected BoolExpr encodeApprox(Context ctx) {
        BoolExpr enc = ctx.mkTrue();
        for(Thread thread : task.getProgram().getThreads()){
            for(Event lock : thread.getCache().getEvents(FilterBasic.get(EType.RCU_LOCK))){
                for(Event unlock : thread.getCache().getEvents(FilterBasic.get(EType.RCU_UNLOCK))){
                    if(lock.getCId() < unlock.getCId()){
                        Tuple tuple = new Tuple(lock, unlock);
                        if(encodeTupleSet.contains(tuple)){
                            BoolExpr relation = ctx.mkAnd(lock.exec(), unlock.exec());
                            for(Event otherLock : thread.getCache().getEvents(FilterBasic.get(EType.RCU_LOCK))){
                                if(otherLock.getCId() > lock.getCId() && otherLock.getCId() < unlock.getCId()){
                                    relation = ctx.mkAnd(relation, ctx.mkNot(this.getSMTVar(otherLock, unlock, ctx)));
                                }
                            }
                            for(Event otherUnlock : thread.getCache().getEvents(FilterBasic.get(EType.RCU_UNLOCK))){
                                if(otherUnlock.getCId() > lock.getCId() && otherUnlock.getCId() < unlock.getCId()){
                                    relation = ctx.mkAnd(relation, ctx.mkNot(this.getSMTVar(lock, otherUnlock, ctx)));
                                }
                            }
                            enc = ctx.mkAnd(enc, ctx.mkEq(this.getSMTVar(tuple, ctx), relation));
                        }
                    }
                }
            }
        }
        return enc;
    }
}