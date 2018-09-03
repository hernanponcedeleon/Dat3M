package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class RelInverse extends UnaryRelation {

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
    public Set<Tuple> getMaxTupleSet(Program program){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
            for(Tuple pair : r1.getMaxTupleSet(program)){
                maxTupleSet.add(new Tuple(pair.getSecond(), pair.getFirst()));
            }
        }
        return maxTupleSet;
    }

    @Override
    public void addEncodeTupleSet(Set<Tuple> tuples){
        encodeTupleSet.addAll(tuples);
        Set<Tuple> activeSet = new HashSet<>(tuples);
        activeSet.retainAll(maxTupleSet);
        if(!activeSet.isEmpty()){
            Set<Tuple> invSet = new HashSet<>();
            for(Tuple pair : activeSet){
                invSet.add(new Tuple(pair.getSecond(), pair.getFirst()));
            }
            r1.addEncodeTupleSet(invSet);
        }
    }

    @Override
    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

        for(Tuple tuple : encodeTupleSet){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();
            BoolExpr opt = Utils.edge(r1.getName(), e2, e1, ctx);
            if (r1.containsRec) {
                opt = ctx.mkAnd(opt, ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx), Utils.intCount(r1.getName(), e2, e1, ctx)));
            }
            enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), opt));
        }
        return enc;
    }

    @Override
    protected BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

        for(Tuple tuple : encodeTupleSet){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();
            BoolExpr opt = Utils.edge(r1.getName(), e2, e1, ctx);
            enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), opt));
        }
        return enc;
    }
}
    

