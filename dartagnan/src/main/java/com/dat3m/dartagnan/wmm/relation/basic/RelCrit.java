package com.dat3m.dartagnan.wmm.relation.basic;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.microsoft.z3.BoolExpr;

import static com.dat3m.dartagnan.wmm.utils.Utils.edge;

public class RelCrit extends BasicRelation {

    public RelCrit(){
        term = "crit";
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Thread thread : program.getThreads()){
                for(Event lock : thread.getCache().getEvents(FilterBasic.get(EType.RCU_LOCK))){
                    for(Event unlock : thread.getCache().getEvents(FilterBasic.get(EType.RCU_UNLOCK))){
                        if(lock.getCId() < unlock.getCId()){
                            maxTupleSet.add(new Tuple(lock, unlock));
                        }
                    }
                }
            }
        }
        return maxTupleSet;
    }

    // TODO: Not the most efficient implementation
    // Let's see if we need to keep a reference to a thread in events for anything else, and then optimize this method
    @Override
    protected BoolExpr encodeApprox() {
        BoolExpr enc = ctx.mkTrue();
        for(Thread thread : program.getThreads()){
            for(Event lock : thread.getCache().getEvents(FilterBasic.get(EType.RCU_LOCK))){
                for(Event unlock : thread.getCache().getEvents(FilterBasic.get(EType.RCU_UNLOCK))){
                    if(lock.getCId() < unlock.getCId()){
                        Tuple tuple = new Tuple(lock, unlock);
                        if(encodeTupleSet.contains(tuple)){
                            BoolExpr relation = ctx.mkAnd(lock.executes(ctx), unlock.executes(ctx));
                            for(Event otherLock : thread.getCache().getEvents(FilterBasic.get(EType.RCU_LOCK))){
                                if(otherLock.getCId() > lock.getCId() && otherLock.getCId() < unlock.getCId()){
                                    relation = ctx.mkAnd(relation, ctx.mkNot(edge("crit", otherLock, unlock, ctx)));
                                }
                            }
                            for(Event otherUnlock : thread.getCache().getEvents(FilterBasic.get(EType.RCU_UNLOCK))){
                                if(otherUnlock.getCId() > lock.getCId() && otherUnlock.getCId() < unlock.getCId()){
                                    relation = ctx.mkAnd(relation, ctx.mkNot(edge("crit", lock, otherUnlock, ctx)));
                                }
                            }
                            enc = ctx.mkAnd(enc, ctx.mkEq(edge("crit", lock, unlock, ctx), relation));
                        }
                    }
                }
            }
        }
        return enc;
    }
}
