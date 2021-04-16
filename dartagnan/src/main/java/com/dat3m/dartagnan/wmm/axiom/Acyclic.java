package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import static com.dat3m.dartagnan.program.utils.EType.VISIBLE;

import java.util.*;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author Florian Furbach
 */
public class Acyclic extends Axiom {

	private static final Logger logger = LogManager.getLogger(Acyclic.class);

    public Acyclic(Relation rel) {
        super(rel);
    }

    public Acyclic(Relation rel, boolean negate) {
        super(rel, negate);
    }

    @Override
    public TupleSet getEncodeTupleSet(){
        logger.info("Computing encodeTupleSet for " + this);
        // ====== Construct [Event -> Successor] mapping ======
        Map<Event, Collection<Event>> succMap = new HashMap<>();
        TupleSet relMaxTuple = rel.getMaxTupleSet();
        for (Tuple t : relMaxTuple) {
            succMap.computeIfAbsent(t.getFirst(), key -> new ArrayList<>()).add(t.getSecond());
        }

        // ====== Compute SCCs ======
        DependencyGraph<Event> depGraph = DependencyGraph.from(succMap.keySet(), succMap);
        TupleSet result = new TupleSet();
        for (Set<DependencyGraph<Event>.Node> scc : depGraph.getSCCs()) {
            // ====== Singleton SCC ======
            if (scc.size() == 1) {
                Event e = scc.stream().findAny().get().getContent();
                Tuple t = new Tuple(e, e);
                if (relMaxTuple.contains(t)) {
                    result.add(t);
                }
                continue;
            }
            // ====== General SCC ======
            for (DependencyGraph<Event>.Node node1 : scc) {
                Event e1 = node1.getContent();
                for (DependencyGraph<Event>.Node node2 : scc) {
                    Event e2 = node2.getContent();
                    Tuple t = new Tuple(e1,e2);
                    if (relMaxTuple.contains(t)) {
                        result.add(t);
                    }
                }
            }
        }
        for (Tuple t : result) {
            Event e1 = t.getFirst();
            Event e2 = t.getSecond();
            if (!e1.is(VISIBLE) || !e2.is(VISIBLE)) {
                System.out.println(t);
            }
        }

        logger.info("encodeTupleSet size " + result.size());
        return result;
    }

    @Override
    protected BoolExpr _consistent(Context ctx) {
        BoolExpr enc = ctx.mkTrue();

        for(Tuple tuple : rel.getEncodeTupleSet()){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();
            enc = ctx.mkAnd(enc, ctx.mkImplies(rel.getSMTVar(tuple, ctx), ctx.mkLt(Utils.intVar(rel.getName(), e1, ctx), Utils.intVar(rel.getName(), e2, ctx))));
        }
        return enc;
    }

    @Override
    protected BoolExpr _inconsistent(Context ctx) {
        return ctx.mkAnd(satCycleDef(ctx), satCycle(ctx));
    }

    @Override
    protected String _toString() {
        return "acyclic " + rel.getName();
    }

    private BoolExpr satCycle(Context ctx) {
        Set<Event> cycleEvents = new HashSet<>();
        for(Tuple tuple : rel.getEncodeTupleSet()){
            cycleEvents.add(tuple.getFirst());
        }

        BoolExpr cycle = ctx.mkFalse();
        for(Event e : cycleEvents){
            cycle = ctx.mkOr(cycle, cycleVar(rel.getName(), e, ctx));
        }

        return cycle;
    }

    private BoolExpr satCycleDef(Context ctx){
        BoolExpr enc = ctx.mkTrue();
        Set<Event> encoded = new HashSet<>();
        String name = rel.getName();

        for(Tuple t : rel.getEncodeTupleSet()){
            Event e1 = t.getFirst();
            Event e2 = t.getSecond();

            enc = ctx.mkAnd(enc, ctx.mkImplies(
                    cycleEdge(name, e1, e2, ctx),
                    ctx.mkAnd(
                            e1.exec(),
                            e2.exec(),
                            rel.getSMTVar(t, ctx),
                            cycleVar(name, e1, ctx),
                            cycleVar(name, e2, ctx)
            )));

            if(!encoded.contains(e1)){
                encoded.add(e1);

                BoolExpr source = ctx.mkFalse();
                for(Tuple tuple1 : rel.getEncodeTupleSet().getByFirst(e1)){
                    BoolExpr opt = cycleEdge(name, e1, tuple1.getSecond(), ctx);
                    for(Tuple tuple2 : rel.getEncodeTupleSet().getByFirst(e1)){
                        if(tuple1.getSecond().getCId() != tuple2.getSecond().getCId()){
                            opt = ctx.mkAnd(opt, ctx.mkNot(cycleEdge(name, e1, tuple2.getSecond(), ctx)));
                        }
                    }
                    source = ctx.mkOr(source, opt);
                }

                BoolExpr target = ctx.mkFalse();
                for(Tuple tuple1 : rel.getEncodeTupleSet().getBySecond(e1)){
                    BoolExpr opt = cycleEdge(name, tuple1.getFirst(), e1, ctx);
                    for(Tuple tuple2 : rel.getEncodeTupleSet().getBySecond(e1)){
                        if(tuple1.getFirst().getCId() != tuple2.getFirst().getCId()){
                            opt = ctx.mkAnd(opt, ctx.mkNot(cycleEdge(name, tuple2.getFirst(), e1, ctx)));
                        }
                    }
                    target = ctx.mkOr(target, opt);
                }

                enc = ctx.mkAnd(enc, ctx.mkImplies(cycleVar(name, e1, ctx), ctx.mkAnd(source, target)));
            }
        }

        return enc;
    }

    private BoolExpr cycleVar(String relName, Event e, Context ctx) {
        return ctx.mkBoolConst("Cycle(" + e.repr() + ")(" + relName + ")");
    }

    private BoolExpr cycleEdge(String relName, Event e1, Event e2, Context ctx) {
        return ctx.mkBoolConst("Cycle:" + relName + "(" + e1.repr() + "," + e2.repr() + ")");
    }
}