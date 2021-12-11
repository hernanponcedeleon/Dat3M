package com.dat3m.dartagnan.wmm.relation.unary;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Sets;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Map;
import java.util.Set;
import java.util.function.Function;

/**
 *
 * @author Florian Furbach
 */
public class RelTransRef extends RelTrans {

    private TupleSet identityEncodeTupleSet = new TupleSet();
    private TupleSet transEncodeTupleSet = new TupleSet();

    public static String makeTerm(Relation r1){
        return r1.getName() + "^*";
    }

    public RelTransRef(Relation r1) {
        super(r1);
        term = makeTerm(r1);
    }

    public RelTransRef(Relation r1, String name) {
        super(r1, name);
        term = makeTerm(r1);
    }

    @Override
    public void initialise(VerificationTask task, SolverContext ctx){
        super.initialise(task, ctx);
        identityEncodeTupleSet = new TupleSet();
        transEncodeTupleSet = new TupleSet();
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            super.getMinTupleSet();
            for(Event e : task.getProgram().getCache().getEvents(FilterBasic.get(EType.VISIBLE))){
                minTupleSet.add(new Tuple(e, e));
            }
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            super.getMaxTupleSet();
            for (Map.Entry<Event, Set<Event>> entry : transitiveReachabilityMap.entrySet()) {
                entry.getValue().remove(entry.getKey());
            }
            for(Event e : task.getProgram().getCache().getEvents(FilterBasic.get(EType.VISIBLE))){
                maxTupleSet.add(new Tuple(e, e));
            }
        }
        return maxTupleSet;
    }

    //TODO: This is ugly code that produces encodeSets which are too large
    // However, the encoding does not care about the encodeSet and instead encodes (transEncode + identityEncode)
    // which is what the encodeSet of this relation should be
    @Override
    public void addEncodeTupleSet(TupleSet tuples){
        TupleSet activeSet = new TupleSet(Sets.intersection(Sets.difference(tuples, encodeTupleSet), maxTupleSet));
        encodeTupleSet.addAll(activeSet);

        for(Tuple tuple : activeSet){
            if(tuple.isLoop()){
                identityEncodeTupleSet.add(tuple);
            }
        }
        activeSet.removeAll(identityEncodeTupleSet);

        TupleSet temp = encodeTupleSet;
        encodeTupleSet = transEncodeTupleSet;
        super.addEncodeTupleSet(activeSet);
        encodeTupleSet = temp;
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
    	return invokeEncode(super::encodeApprox, ctx);
    }

    private BooleanFormula invokeEncode(Function<SolverContext, BooleanFormula> originalMethod, SolverContext ctx) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();

        TupleSet temp = encodeTupleSet;
        encodeTupleSet = transEncodeTupleSet;
        BooleanFormula enc = originalMethod.apply(ctx);
        encodeTupleSet = temp;

        for(Tuple tuple : identityEncodeTupleSet){
        	enc = bmgr.and(enc, bmgr.equivalence(tuple.getFirst().exec(), this.getSMTVar(tuple, ctx)));
        }
        return enc;
    }
}