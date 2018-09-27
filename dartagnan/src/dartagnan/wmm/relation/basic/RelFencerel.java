package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Thread;
import dartagnan.program.event.Event;
import dartagnan.program.event.Fence;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.Collection;
import java.util.Comparator;
import java.util.List;
import java.util.ListIterator;
import java.util.stream.Collectors;

import static dartagnan.utils.Utils.edge;

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
                List<Fence> fences = t.getEventRepository()
                        .getEvents(EventRepository.EVENT_FENCE)
                        .stream()
                        .filter(e -> ((Fence)e).getName().equals(fenceName))
                        .map(e -> (Fence)e)
                        .collect(Collectors.toList());

                if(!fences.isEmpty()){
                    List<Event> events = t.getEventRepository().getEvents(EventRepository.EVENT_MEMORY)
                            .stream()
                            .sorted(Comparator.comparing(Event::getEId))
                            .collect(Collectors.toList());


                    ListIterator<Event> it1 = events.listIterator();
                    while(it1.hasNext()){
                        Event e1 = it1.next();
                        ListIterator<Event> it2 = events.listIterator(it1.nextIndex());
                        while(it2.hasNext()){
                            Event e2 = it2.next();
                            for(Fence f : fences) {
                                if(f.getEId() > e1.getEId() && f.getEId() < e2.getEId()){
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
    protected BoolExpr encodeBasic() throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

        Collection<Event> fences = program.getEventRepository()
                .getEvents(EventRepository.EVENT_FENCE)
                .stream()
                .filter(e -> ((Fence)e).getName().equals(fenceName))
                .collect(Collectors.toSet());

        for(Tuple tuple : encodeTupleSet){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            BoolExpr orClause = ctx.mkFalse();
            for(Event fence : fences){
                if(fence.getEId() > e1.getEId() && fence.getEId() < e2.getEId()){
                    orClause = ctx.mkOr(orClause, fence.executes(ctx));
                }
            }

            BoolExpr rel = edge(this.getName(), e1, e2, ctx);
            enc = ctx.mkAnd(enc, ctx.mkEq(rel, ctx.mkAnd(e1.executes(ctx), e2.executes(ctx), orClause)));
        }

        return enc;
    }
}
