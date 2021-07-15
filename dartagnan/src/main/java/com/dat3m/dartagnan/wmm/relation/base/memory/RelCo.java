package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterMinus;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.BitvectorFormula;
import org.sosy_lab.java_smt.api.BitvectorFormulaManager;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.SolverContext;

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
    protected BooleanFormula encodeApprox(SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
    	IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();
    	BitvectorFormulaManager bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
    	
    	BooleanFormula enc = bmgr.makeTrue();

        List<Event> eventsInit = task.getProgram().getCache().getEvents(FilterBasic.get(INIT));
        List<Event> eventsStore = task.getProgram().getCache().getEvents(FilterMinus.get(
                FilterBasic.get(WRITE),
                FilterBasic.get(INIT)
        ));

        for(Event e : eventsInit) {
            enc = bmgr.and(enc, imgr.equal(intVar("co", e, ctx), imgr.makeNumber(BigInteger.ZERO)));
        }

        List<IntegerFormula> intVars = new ArrayList<>();
        for(Event w : eventsStore) {
        	IntegerFormula coVar = intVar("co", w, ctx);
            enc = bmgr.and(enc, imgr.greaterThan(coVar, imgr.makeNumber(BigInteger.ZERO)));
            intVars.add(coVar);
        }
        
        BooleanFormula distinct = intVars.size() > 1 ?
        		imgr.distinct(intVars) : 
                bmgr.makeTrue();
        
        enc = bmgr.and(enc, distinct);

        for(Event w :  task.getProgram().getCache().getEvents(FilterBasic.get(WRITE))){
            MemEvent w1 = (MemEvent)w;
            BooleanFormula lastCo = w1.exec();

            for(Tuple t : maxTupleSet.getByFirst(w1)){
                MemEvent w2 = (MemEvent)t.getSecond();
                BooleanFormula relation = getSMTVar(t, ctx);
                BooleanFormula execPair = bmgr.and(w1.exec(), w2.exec()); //getExecPair(t, ctx);
                lastCo = bmgr.and(lastCo, bmgr.not(relation));

                IntegerFormula a1 = w1.getMemAddressExpr() instanceof BitvectorFormula ?
                		bvmgr.toIntegerFormula((BitvectorFormula)w1.getMemAddressExpr(), false) :
                		(IntegerFormula)w1.getMemAddressExpr();
                IntegerFormula a2 = w2.getMemAddressExpr()instanceof BitvectorFormula ?
                		bvmgr.toIntegerFormula((BitvectorFormula)w2.getMemAddressExpr(), false) :
                		(IntegerFormula)w2.getMemAddressExpr();
                enc = bmgr.and(enc, bmgr.equivalence(relation, bmgr.and(
                		bmgr.and(bmgr.and(execPair), imgr.equal(a1, a2)),
                		imgr.lessThan(intVar("co", w1, ctx), intVar("co", w2, ctx))
                )));

                // ============ Local consistency optimizations ============
                if (getMinTupleSet().contains(t)) {
                   enc = bmgr.and(enc, bmgr.equivalence(relation, execPair));
                } else if (task.getMemoryModel().isLocallyConsistent()) {
                    if (w2.is(INIT) || t.isBackward()){
                        enc = bmgr.and(enc, bmgr.equivalence(relation, bmgr.makeFalse()));
                    }
                    if (w1.is(INIT) || t.isForward()) {
                        enc = bmgr.and(enc, bmgr.implication(bmgr.and(execPair, imgr.equal(a1, a2)), relation));
                    }
                }
            }

            BooleanFormula lastCoExpr = bmgr.makeVariable("co_last(" + w1.repr() + ")");
            enc = bmgr.and(enc, bmgr.equivalence(lastCoExpr, lastCo));

            for(Address address : w1.getMaxAddressSet()){
            	IntegerFormula a1 = w1.getMemAddressExpr() instanceof BitvectorFormula ?
            			bvmgr.toIntegerFormula((BitvectorFormula)w1.getMemAddressExpr(), false) : 
            			(IntegerFormula)w1.getMemAddressExpr();
            	IntegerFormula a2 = address.toZ3Int(ctx) instanceof BitvectorFormula ?
            			bvmgr.toIntegerFormula((BitvectorFormula)address.toZ3Int(ctx), false) :
            			(IntegerFormula)address.toZ3Int(ctx);
            	IntegerFormula v1 = address.getLastMemValueExpr(ctx) instanceof BitvectorFormula ?
            			bvmgr.toIntegerFormula((BitvectorFormula)address.getLastMemValueExpr(ctx), false) :
            			(IntegerFormula)address.getLastMemValueExpr(ctx);
            	IntegerFormula v2 = w1.getMemValueExpr() instanceof BitvectorFormula ?
            			bvmgr.toIntegerFormula((BitvectorFormula)w1.getMemValueExpr(), false) :
            			(IntegerFormula)w1.getMemValueExpr();
				enc = bmgr.and(enc, bmgr.implication(bmgr.and(lastCoExpr, imgr.equal(a1, a2)), imgr.equal(v1, v2)));
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
    public BooleanFormula getSMTVar(Tuple edge, SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
    	IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();
    	
    	if(!ANTISYMM_CO) {
    		return super.getSMTVar(edge, ctx);
    	}
        MemEvent first = (MemEvent) edge.getFirst();
        MemEvent second = (MemEvent) edge.getSecond();
        // Doing the check at the java level seems to slightly improve  performance
        BooleanFormula eqAdd = first.getAddress().equals(second.getAddress()) ? bmgr.makeTrue() : imgr.equal((IntegerFormula)first.getMemAddressExpr(), (IntegerFormula)second.getMemAddressExpr());
        return !getMaxTupleSet().contains(edge) ? bmgr.makeFalse() :
    		first.getUId() <= second.getUId() ?
    				edge(getName(), first, second, ctx) :
    					(BooleanFormula) bmgr.ifThenElse(bmgr.and(getExecPair(edge, ctx), eqAdd), 
    							bmgr.not(getSMTVar(edge.getInverse(), ctx)), 
    							bmgr.makeFalse());
    }
}
