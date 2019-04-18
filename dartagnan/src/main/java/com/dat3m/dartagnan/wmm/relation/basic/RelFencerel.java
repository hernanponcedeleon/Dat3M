package com.dat3m.dartagnan.wmm.relation.basic;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.microsoft.z3.BoolExpr;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.List;
import java.util.ListIterator;

import static com.dat3m.dartagnan.wmm.utils.Utils.edge;

public class RelFencerel extends Relation {

    private String fenceName;

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

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Thread t : program.getThreads()){
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
        }
        return maxTupleSet;
    }

    @Override
    protected BoolExpr encodeApprox() {
        BoolExpr enc = ctx.mkTrue();

        List<Event> fences = program.getCache().getEvents(FilterBasic.get(fenceName));

        for(Tuple tuple : encodeTupleSet){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            BoolExpr orClause = ctx.mkFalse();
            for(Event fence : fences){
                if(fence.getCId() > e1.getCId() && fence.getCId() < e2.getCId()){
                    orClause = ctx.mkOr(orClause, fence.executes(ctx));
                }
            }

            BoolExpr rel = edge(this.getName(), e1, e2, ctx);
            enc = ctx.mkAnd(enc, ctx.mkEq(rel, ctx.mkAnd(e1.executes(ctx), e2.executes(ctx), orClause)));
        }

        return enc;
    }
}
