package porthosc.memorymodels.relations;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import porthosc.languages.syntax.xgraph.program.XProgram;

import java.util.Set;


public abstract class ZBinaryRelation extends ZRelation {

    protected ZRelation r1;
    protected ZRelation r2;

    public ZBinaryRelation(String name, String term) {
        super(name, term);
    }

    public ZBinaryRelation(String name) {
        super(name);
    }

    public ZBinaryRelation(ZRelation r1, ZRelation r2, String name, String term) {
        super(name, term);
        this.r1 = r1;
        this.r2 = r2;
        containsRec = r1.containsRec || r2.containsRec;
        namedRelations.addAll(r1.namedRelations);
        namedRelations.addAll(r2.namedRelations);

    }

    public ZBinaryRelation(ZRelation r1, ZRelation r2, String term) {
        super(term);
        this.r1 = r1;
        this.r2 = r2;
        containsRec = r1.containsRec || r2.containsRec;
        namedRelations.addAll(r1.namedRelations);
        namedRelations.addAll(r2.namedRelations);
    }

    @Override
    public BoolExpr encode(XProgram program, Context ctx, Set<String> encodedRels) throws Z3Exception {
        if (!encodedRels.contains(getName())) {
            encodedRels.add(getName());
            BoolExpr enc = r1.encode(program, ctx, encodedRels);
            enc = ctx.mkAnd(enc, r2.encode(program, ctx, encodedRels));
            if (ZRelation.Approx) {
                return ctx.mkAnd(enc, this.encodeApprox(program, ctx));
            }
            else {
                return ctx.mkAnd(enc, this.encodeBasic(program, ctx));
            }
        }
        else {
            //System.out.println("skipped encoding of: " + name);
            return ctx.mkTrue();

        }
    }

}
