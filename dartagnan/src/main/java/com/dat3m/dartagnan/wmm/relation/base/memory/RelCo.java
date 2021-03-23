package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterMinus;
import com.microsoft.z3.*;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;

public class RelCo extends Relation {

    public RelCo(){
        term = "co";
        forceDoEncode = true;
    }

    // Temporary test code
    private boolean doEncode = true;
    // if set to false, the co-relation will not be encoded
    // and it will be considered empty for may and active set computations
    public void setDoEncode(Boolean value) {
        doEncode = value;
        maxTupleSet = value ? null : getMinTupleSet();
    }

    @Override
    public TupleSet getEncodeTupleSet() {
        if (!doEncode)
            return new TupleSet();
        return super.getEncodeTupleSet();
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet();

            if (task.getMemoryModel().isLocallyConsistent()) {
                for (Tuple t : getMaxTupleSet()) {
                    MemEvent w1 = (MemEvent) t.getFirst();
                    MemEvent w2 = (MemEvent) t.getSecond();

                    if (w2.is(EType.INIT))
                        continue;
                    if (w1.getMaxAddressSet().size() != 1 || w2.getMaxAddressSet().size() != 1)
                        continue;

                    if (w1.is(EType.INIT) || (w1.getThread() == w2.getThread() && w1.getCId() < w2.getCId()))
                        minTupleSet.add(t);
                }
            }
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){

        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            List<Event> eventsInit = task.getProgram().getCache().getEvents(FilterBasic.get(EType.INIT));
            List<Event> eventsStore = task.getProgram().getCache().getEvents(FilterMinus.get(
                    FilterBasic.get(EType.WRITE),
                    FilterBasic.get(EType.INIT)
            ));

            for(Event e1 : eventsInit){
                for(Event e2 : eventsStore){
                    if(MemEvent.canAddressTheSameLocation((MemEvent) e1, (MemEvent)e2)){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }

            for(Event e1 : eventsStore){
                for(Event e2 : eventsStore){
                    if(e1.getCId() != e2.getCId() && MemEvent.canAddressTheSameLocation((MemEvent) e1, (MemEvent)e2)){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }

            removeMutuallyExclusiveTuples(maxTupleSet);

            if (task.getMemoryModel().isLocallyConsistent()) {
                //TODO: Make sure that this is correct and does not cause any issues with totality of co
                int before = maxTupleSet.size();
                maxTupleSet.removeIf(t -> t.getSecond().is(EType.INIT)
                        || (t.getFirst().getThread() == t.getSecond().getThread()
                        && t.getFirst().getCId() > t.getSecond().getCId()));
                System.out.println("Local Consistency CO: " + (before - maxTupleSet.size()));
            }
        }
        return maxTupleSet;
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) {
        BoolExpr enc = ctx.mkTrue();

        if (!doEncode) {
            for (Tuple t : getMinTupleSet()) {
                enc = ctx.mkAnd(enc, ctx.mkEq(getSMTVar(t, ctx), getExecPair(t, ctx)));
            }
            return enc;
        }

        List<Event> eventsInit = task.getProgram().getCache().getEvents(FilterBasic.get(EType.INIT));
        List<Event> eventsStore = task.getProgram().getCache().getEvents(FilterMinus.get(
                FilterBasic.get(EType.WRITE),
                FilterBasic.get(EType.INIT)
        ));

        for(Event e : eventsInit) {
            enc = ctx.mkAnd(enc, ctx.mkEq(intVar("co", e, ctx), ctx.mkInt(0)));
        }

        List<IntExpr> intVars = new ArrayList<>();
        for(Event w : eventsStore) {
            IntExpr coVar = intVar("co", w, ctx);
            enc = ctx.mkAnd(enc, ctx.mkGt(coVar, ctx.mkInt(0)));
            intVars.add(coVar);
        }
        enc = ctx.mkAnd(enc, ctx.mkDistinct(intVars.toArray(new IntExpr[0])));

        for(Event w :  task.getProgram().getCache().getEvents(FilterBasic.get(EType.WRITE))){
            MemEvent w1 = (MemEvent)w;
            BoolExpr lastCo = w1.exec();

            for(Tuple t : maxTupleSet.getByFirst(w1)){
                MemEvent w2 = (MemEvent)t.getSecond();
                BoolExpr relation = getSMTVar(t, ctx);
                lastCo = ctx.mkAnd(lastCo, ctx.mkNot(relation));

                Expr a1 = w1.getMemAddressExpr().isBV() ? ctx.mkBV2Int((BitVecExpr)w1.getMemAddressExpr(), false) : w1.getMemAddressExpr();
                Expr a2 = w2.getMemAddressExpr().isBV() ? ctx.mkBV2Int((BitVecExpr)w2.getMemAddressExpr(), false) : w2.getMemAddressExpr();
                enc = ctx.mkAnd(enc, ctx.mkEq(relation, ctx.mkAnd(
                        ctx.mkAnd(ctx.mkAnd(w1.exec(), w2.exec()), ctx.mkEq(a1, a2)),
                        ctx.mkLt(intVar("co", w1, ctx), intVar("co", w2, ctx))
                )));

                // ============ Local consistency optimizations ============
                if (getMinTupleSet().contains(t)) {
                   enc = ctx.mkAnd(enc, ctx.mkEq(relation, ctx.mkAnd(w1.exec(), w2.exec())));
                } else if (task.getMemoryModel().isLocallyConsistent()) {
                    if (w2.is(EType.INIT) || (w1.getThread() == w2.getThread() && w1.getCId() > w2.getCId())){
                        enc = ctx.mkAnd(enc, ctx.mkEq(relation, ctx.mkFalse()));
                    }
                    if (w1.is(EType.INIT) || (w1.getThread() == w2.getThread() && w1.getCId() < w2.getCId())) {
                        enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(getExecPair(t, ctx), ctx.mkEq(a1, a2)), relation));
                    }
                }
            }

            BoolExpr lastCoExpr = ctx.mkBoolConst("co_last(" + w1.repr() + ")");
            enc = ctx.mkAnd(enc, ctx.mkEq(lastCoExpr, lastCo));

            for(Address address : w1.getMaxAddressSet()){
            	Expr a1 = w1.getMemAddressExpr().isBV() ? ctx.mkBV2Int((BitVecExpr)w1.getMemAddressExpr(), false) : w1.getMemAddressExpr();
            	Expr a2 = address.toZ3Int(ctx).isBV() ? ctx.mkBV2Int((BitVecExpr)address.toZ3Int(ctx), false) : address.toZ3Int(ctx);
				Expr v1 = address.getLastMemValueExpr(ctx).isBV() ? ctx.mkBV2Int((BitVecExpr)address.getLastMemValueExpr(ctx), false) : address.getLastMemValueExpr(ctx);
                Expr v2 = w1.getMemValueExpr().isBV() ? ctx.mkBV2Int((BitVecExpr)w1.getMemValueExpr(), false) : w1.getMemValueExpr();
				enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(lastCoExpr, ctx.mkEq(a1, a2)),ctx.mkEq(v1, v2)));
            }
        }
        return enc;
    }
}
