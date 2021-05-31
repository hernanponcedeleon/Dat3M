package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.microsoft.z3.BoolExpr;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.microsoft.z3.Context;

import java.util.List;
import java.util.ListIterator;

public class RelFencerel extends StaticRelation {

    private final String fenceName;

    public static String makeTerm(String fenceName){
        return "fencerel(" + fenceName + ")";
    }

    public RelFencerel(String fenceName) {
        this.fenceName = fenceName;
        term = makeTerm(fenceName);
    }

    public RelFencerel(String fenceName, String name) {
        super(name);
        this.fenceName = fenceName;
        term = makeTerm(fenceName);
    }

    public String getFenceName() { return fenceName; }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            BranchEquivalence eq = task.getBranchEquivalence();
            minTupleSet = new TupleSet();
            for(Thread t : task.getProgram().getThreads()){
                List<Event> fences = t.getCache().getEvents(FilterBasic.get(fenceName));
                if(!fences.isEmpty()){
                    List<Event> events = t.getCache().getEvents(FilterBasic.get(EType.MEMORY));
                    ListIterator<Event> it1 = events.listIterator();

                    while(it1.hasNext()){
                        Event e1 = it1.next();
                        ListIterator<Event> it2 = events.listIterator(it1.nextIndex());
                        while(it2.hasNext()){
                            Event e2 = it2.next();
                            for(Event f : fences) {
                            	if(f.cfImpliesExec() && e1.getCId() < f.getCId() && f.getCId() < e2.getCId()){
                                    if (eq.isImplied(e1, f) || eq.isImplied(e2, f)) {
                                        minTupleSet.add(new Tuple(e1, e2));
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            removeMutuallyExclusiveTuples(minTupleSet);
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Thread t : task.getProgram().getThreads()){
                List<Event> fences = t.getCache().getEvents(FilterBasic.get(fenceName));
                if(!fences.isEmpty()){
                    List<Event> events = t.getCache().getEvents(FilterBasic.get(EType.MEMORY));
                    ListIterator<Event> it1 = events.listIterator();

                    while(it1.hasNext()){
                        Event e1 = it1.next();
                        ListIterator<Event> it2 = events.listIterator(it1.nextIndex());
                        while(it2.hasNext()){
                            Event e2 = it2.next();
                            for(Event f : fences) {
                                if(f.getCId() > e1.getCId() && f.getCId() < e2.getCId()){
                                    maxTupleSet.add(new Tuple(e1, e2));
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            removeMutuallyExclusiveTuples(maxTupleSet);
        }
        return maxTupleSet;
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) {
        BoolExpr enc = ctx.mkTrue();

        List<Event> fences = task.getProgram().getCache().getEvents(FilterBasic.get(fenceName));

        for(Tuple tuple : encodeTupleSet){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            BoolExpr orClause = ctx.mkFalse();
            if(minTupleSet.contains(tuple)) {
                orClause = ctx.mkTrue();
            } else {
                for (Event fence : fences) {
                    if (fence.getCId() > e1.getCId() && fence.getCId() < e2.getCId()) {
                        orClause = ctx.mkOr(orClause, fence.exec());
                    }
                }
            }

            BoolExpr rel = this.getSMTVar(tuple, ctx);
            enc = ctx.mkAnd(enc, ctx.mkEq(rel, ctx.mkAnd(getExecPair(tuple, ctx), orClause)));
        }

        return enc;
    }
}
