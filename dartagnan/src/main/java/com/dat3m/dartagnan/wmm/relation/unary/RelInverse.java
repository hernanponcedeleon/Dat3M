package com.dat3m.dartagnan.wmm.relation.unary;

import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Set;

import static com.dat3m.dartagnan.encoding.ProgramEncoder.execution;
import static java.util.stream.Collectors.toSet;

/**
 *
 * @author Florian Furbach
 */
public class RelInverse extends UnaryRelation {
    //TODO/Note: We can forward getSMTVar calls
    // to avoid encoding this completely!

    public static String makeTerm(Relation r1){
        return r1.getName() + "^-1";
    }

    public RelInverse(Relation r1){
        super(r1);
        term = makeTerm(r1);
    }

    public RelInverse(Relation r1, String name) {
        super(r1, name);
        term = makeTerm(r1);
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = r1.getMinTupleSet().inverse();
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = r1.getMaxTupleSet().inverse();
        }
        return maxTupleSet;
    }

    @Override
    public void activate(Set<Tuple> activeSet, WmmEncoder.Buffer buf) {
        buf.send(r1, activeSet.stream().map(Tuple::getInverse).collect(toSet()));
    }

    @Override
    public BooleanFormula encode(SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();

        ExecutionAnalysis exec = analysisContext.requires(ExecutionAnalysis.class);
		TupleSet minSet = getMinTupleSet();
        for(Tuple tuple : encodeTupleSet){
            BooleanFormula opt = minSet.contains(tuple) ? execution(tuple.getFirst(), tuple.getSecond(), exec, ctx) : r1.getSMTVar(tuple.getInverse(), ctx);
            enc = bmgr.and(enc, bmgr.equivalence(this.getSMTVar(tuple, ctx), opt));
        }
        return enc;
    }
}