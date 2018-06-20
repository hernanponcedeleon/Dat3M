package porthosc.memorymodels.relations;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import porthosc.languages.syntax.xgraph.program.XProgram;

import java.util.Set;


public abstract class ZUnaryRelation extends ZRelation {

    protected ZRelation r1;

    public ZUnaryRelation(ZRelation r1, String name, String term) {
        super(name, term);
        this.r1 = r1;
        containsRec = r1.containsRec;
        namedRelations.addAll(r1.getNamedRelations());

    }

    public ZUnaryRelation(ZRelation r1, String term) {
        super(term);
        this.r1 = r1;
        containsRec = r1.containsRec;
        namedRelations.addAll(r1.getNamedRelations());
    }

    @Override
    public BoolExpr encode(XProgram program, Context ctx, Set<String> encodedRels) throws Z3Exception {
        if (!encodedRels.contains(getName())) {
            encodedRels.add(getName());
            BoolExpr enc = r1.encode(program, ctx, encodedRels);
            if (!ZRelation.Approx) {
                return ctx.mkAnd(enc, this.encodeBasic(program, ctx));
            }
            else {
                return ctx.mkAnd(enc, this.encodeApprox(program, ctx));
            }
        }
        else {
            //System.out.println("skipped encoding of: "+name);
            return ctx.mkTrue();
        }
    }

}
