package com.dat3m.dartagnan.wmm.relation.base.memory;

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

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import static com.dat3m.dartagnan.GlobalSettings.ANTISYMM_CO;
import static com.dat3m.dartagnan.program.utils.EType.INIT;
import static com.dat3m.dartagnan.program.utils.EType.WRITE;
import static com.dat3m.dartagnan.wmm.utils.Utils.edge;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;

public class RelCo extends Relation {

	private static final Logger logger = LogManager.getLogger(RelCo.class);

    public RelCo(){
        term = "co";
        forceDoEncode = true;
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet();
            applyLocalConsistencyMinSet();
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
        	logger.info("Computing maxTupleSet for " + getName());
            maxTupleSet = new TupleSet();
            List<Event> eventsInit = task.getProgram().getCache().getEvents(FilterBasic.get(INIT));
            List<Event> eventsStore = task.getProgram().getCache().getEvents(FilterMinus.get(
                    FilterBasic.get(WRITE),
                    FilterBasic.get(INIT)
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
            applyLocalConsistencyMaxSet();

            logger.info("maxTupleSet size for " + getName() + ": " + maxTupleSet.size());
        }
        return maxTupleSet;
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) {
        BoolExpr enc = ctx.mkTrue();

        List<Event> eventsInit = task.getProgram().getCache().getEvents(FilterBasic.get(INIT));
        List<Event> eventsStore = task.getProgram().getCache().getEvents(FilterMinus.get(
                FilterBasic.get(WRITE),
                FilterBasic.get(INIT)
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

        for(Event w :  task.getProgram().getCache().getEvents(FilterBasic.get(WRITE))){
            MemEvent w1 = (MemEvent)w;
            BoolExpr lastCo = w1.exec();

            for(Tuple t : maxTupleSet.getByFirst(w1)){
                MemEvent w2 = (MemEvent)t.getSecond();
                BoolExpr relation = getSMTVar(t, ctx);
                BoolExpr execPair = ctx.mkAnd(w1.exec(), w2.exec()); //getExecPair(t, ctx);
                lastCo = ctx.mkAnd(lastCo, ctx.mkNot(relation));

                Expr a1 = w1.getMemAddressExpr().isBV() ? ctx.mkBV2Int((BitVecExpr)w1.getMemAddressExpr(), false) : w1.getMemAddressExpr();
                Expr a2 = w2.getMemAddressExpr().isBV() ? ctx.mkBV2Int((BitVecExpr)w2.getMemAddressExpr(), false) : w2.getMemAddressExpr();
                enc = ctx.mkAnd(enc, ctx.mkEq(relation, ctx.mkAnd(
                        ctx.mkAnd(ctx.mkAnd(execPair), ctx.mkEq(a1, a2)),
                        ctx.mkLt(intVar("co", w1, ctx), intVar("co", w2, ctx))
                )));

                // ============ Local consistency optimizations ============
                if (getMinTupleSet().contains(t)) {
                   enc = ctx.mkAnd(enc, ctx.mkEq(relation, execPair));
                } else if (task.getMemoryModel().isLocallyConsistent()) {
                    if (w2.is(INIT) || t.isBackward()){
                        enc = ctx.mkAnd(enc, ctx.mkEq(relation, ctx.mkFalse()));
                    }
                    if (w1.is(INIT) || t.isForward()) {
                        enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(execPair, ctx.mkEq(a1, a2)), relation));
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

    private void applyLocalConsistencyMinSet() {
        if (task.getMemoryModel().isLocallyConsistent()) {
            for (Tuple t : getMaxTupleSet()) {
                MemEvent w1 = (MemEvent) t.getFirst();
                MemEvent w2 = (MemEvent) t.getSecond();

                if (w2.is(INIT))
                    continue;
                if (w1.getMaxAddressSet().size() != 1 || w2.getMaxAddressSet().size() != 1)
                    continue;

                if (w1.is(INIT) || t.isForward())
                    minTupleSet.add(t);
            }
        }
    }

    private void applyLocalConsistencyMaxSet() {
        if (task.getMemoryModel().isLocallyConsistent()) {
            //TODO: Make sure that this is correct and does not cause any issues with totality of co
            maxTupleSet.removeIf(t -> t.getSecond().is(INIT) || t.isBackward());
        }
    }
    
    @Override
    public BoolExpr getSMTVar(Tuple edge, Context ctx) {
    	if(!ANTISYMM_CO) {
    		return super.getSMTVar(edge, ctx);
    	}
        MemEvent first = (MemEvent) edge.getFirst();
        MemEvent second = (MemEvent) edge.getSecond();
        // Doing the check at the java level seems to slightly improve  performance
        BoolExpr eqAdd = first.getAddress().equals(second.getAddress()) ? ctx.mkTrue() : ctx.mkEq(first.getMemAddressExpr(), second.getMemAddressExpr());
        return !getMaxTupleSet().contains(edge) ? ctx.mkFalse() :
    		first.getUId() <= second.getUId() ?
    				edge(getName(), first, second, ctx) :
    					(BoolExpr) ctx.mkITE(ctx.mkAnd(getExecPair(edge, ctx), eqAdd), 
    							ctx.mkNot(getSMTVar(edge.getInverse(), ctx)), 
    							ctx.mkFalse());
    }
}
