package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterMinus;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.GlobalSettings.ANTISYMM_CO;
import static com.dat3m.dartagnan.program.utils.EType.INIT;
import static com.dat3m.dartagnan.program.utils.EType.WRITE;
import static com.dat3m.dartagnan.program.utils.Utils.convertToIntegerFormula;
import static com.dat3m.dartagnan.program.utils.Utils.generalEqual;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.utils.Utils.edge;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;
import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;

public class RelCo extends Relation {

	private static final Logger logger = LogManager.getLogger(RelCo.class);

    public RelCo(){
        term = CO;
    }

	@Override
	public void fetchMinTupleSet() {
		if(minTupleSet.isEmpty()) {
			applyLocalConsistencyMinSet();
		}
	}

	@Override
	public boolean disable(TupleSet tuples) {
		super.disable(tuples);
		boolean changed = false;
		for(Tuple t : tuples) {
			Tuple inverse = t.getInverse();
			changed = maxTupleSet.contains(inverse)
					&& ((MemEvent)t.getFirst()).getMaxAddressSet().size() == 1
					&& ((MemEvent)t.getSecond()).getMaxAddressSet().size() == 1
					&& minTupleSet.add(inverse)
				|| changed;
		}
		return changed;
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
    	FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();

    	BooleanFormula enc = bmgr.makeTrue();

        List<Event> eventsInit = task.getProgram().getCache().getEvents(FilterBasic.get(INIT));
        List<Event> eventsStore = task.getProgram().getCache().getEvents(FilterMinus.get(
                FilterBasic.get(WRITE),
                FilterBasic.get(INIT)
        ));

		for(Event e : eventsInit) {
            enc = bmgr.and(enc, imgr.equal(getIntVar(e, ctx), imgr.makeNumber(BigInteger.ZERO)));
        }

        List<IntegerFormula> intVars = new ArrayList<>();
        for(Event w : eventsStore) {
        	IntegerFormula coVar = getIntVar(w, ctx);
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
                BooleanFormula execPair = getExecPair(t, ctx);
                lastCo = bmgr.and(lastCo, bmgr.not(relation));

                IntegerFormula a1 = convertToIntegerFormula(w1.getMemAddressExpr(), ctx);
                IntegerFormula a2 = convertToIntegerFormula(w2.getMemAddressExpr(), ctx);
                BooleanFormula sameAddress = imgr.equal(a1, a2);
                enc = bmgr.and(enc, bmgr.equivalence(relation,
                        bmgr.and(execPair, sameAddress, imgr.lessThan(getIntVar(w1, ctx), getIntVar(w2, ctx))
                )));

                // ============ Local consistency optimizations ============
                if (getMinTupleSet().contains(t)) {
                   enc = bmgr.and(enc, bmgr.equivalence(relation, execPair));
                } else if (task.getMemoryModel().isLocallyConsistent()) {
                    if (w2.is(INIT) || t.isBackward()){
                        enc = bmgr.and(enc, bmgr.equivalence(relation, bmgr.makeFalse()));
                    }
                    if (w1.is(INIT) || t.isForward()) {
                        enc = bmgr.and(enc, bmgr.implication(bmgr.and(execPair, sameAddress), relation));
                    }
                }
            }

            BooleanFormula lastCoExpr = fmgr.makeVariable(BooleanType, "co_last(" + w1.repr() + ")");
            enc = bmgr.and(enc, bmgr.equivalence(lastCoExpr, lastCo));

            for(Address address : w1.getMaxAddressSet()){
                IntegerFormula a1 = convertToIntegerFormula(w1.getMemAddressExpr(), ctx);
                IntegerFormula a2 = convertToIntegerFormula(address.toIntFormula(ctx), ctx);
                IntegerFormula v1 = convertToIntegerFormula(w1.getMemValueExpr(), ctx);
                IntegerFormula v2 = convertToIntegerFormula(address.getLastMemValueExpr(ctx), ctx);
                BooleanFormula sameAddress = imgr.equal(a1, a2);
                BooleanFormula sameValue = imgr.equal(v1, v2);
				enc = bmgr.and(enc, bmgr.implication(bmgr.and(lastCoExpr, sameAddress), sameValue));
            }
        }
        return enc;
    }

    private void applyLocalConsistencyMinSet() {
        if (task.getMemoryModel().isLocallyConsistent()) {
            for (Tuple t : getMaxTupleSet()) {
                MemEvent w1 = (MemEvent) t.getFirst();
                MemEvent w2 = (MemEvent) t.getSecond();

                if (w2.is(INIT)) {
                    continue;
                } else if (w1.getMaxAddressSet().size() != 1 || w2.getMaxAddressSet().size() != 1) {
                    continue;
                }

                if (w1.is(INIT) || t.isForward()) {
                    minTupleSet.add(t);
                }
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
        if(!ANTISYMM_CO) {
            return super.getSMTVar(edge, ctx);
        }

    	FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();

        MemEvent first = (MemEvent) edge.getFirst();
        MemEvent second = (MemEvent) edge.getSecond();
        // Doing the check at the java level seems to slightly improve  performance
        BooleanFormula eqAdd = first.getAddress().equals(second.getAddress()) ? bmgr.makeTrue() :
                generalEqual(first.getMemAddressExpr(), second.getMemAddressExpr(), ctx);
        return !getMaxTupleSet().contains(edge) ? bmgr.makeFalse() :
    		first.getCId() <= second.getCId() ?
    				edge(getName(), first, second, ctx) :
    					bmgr.ifThenElse(bmgr.and(getExecPair(edge, ctx), eqAdd),
    							bmgr.not(getSMTVar(edge.getInverse(), ctx)),
    							bmgr.makeFalse());
    }

    public IntegerFormula getIntVar(Event write, SolverContext ctx) {
        if (!write.is(WRITE)) {
            throw new IllegalArgumentException("Cannot get an int-var for non-writes.");
        }
        return intVar(term, write, ctx);
    }
}
