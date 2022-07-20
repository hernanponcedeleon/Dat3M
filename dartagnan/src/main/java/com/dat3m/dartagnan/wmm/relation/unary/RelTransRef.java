package com.dat3m.dartagnan.wmm.relation.unary;

import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Set;

import static java.util.stream.Collectors.toSet;

/**
 *
 * @author Florian Furbach
 */
public class RelTransRef extends RelTrans {

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
    public void initializeRelationAnalysis(RelationAnalysis.Buffer a) {
        super.initializeRelationAnalysis(a);
        Set<Tuple> set = a.task().getProgram().getCache().getEvents(FilterBasic.get(Tag.VISIBLE)).stream().map(e -> new Tuple(e, e)).collect(toSet());
        a.send(this, set, set);
    }

    @Override
    public BooleanFormula encode(Set<Tuple> encodeTupleSet, WmmEncoder encoder) {
        SolverContext ctx = encoder.solverContext();
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();

        BooleanFormula enc = super.encode(encodeTupleSet.stream().filter(t -> !t.isLoop()).collect(toSet()), encoder);

        for(Tuple tuple : encodeTupleSet) {
            if(tuple.isLoop()) {
                enc = bmgr.and(enc, bmgr.equivalence(tuple.getFirst().exec(), encoder.edge(this, tuple)));
            }
        }
        return enc;
    }
}