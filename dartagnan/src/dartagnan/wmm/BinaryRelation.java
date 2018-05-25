/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dartagnan.wmm;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.utils.PredicateUtils;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public abstract class BinaryRelation extends Relation {

    protected Relation r1;
    protected Relation r2;

    public BinaryRelation(String name, String term) {
        super(name, term);
    }

    public BinaryRelation(String name) {
        super(name);
    }

    /**
     * Creates a named binary relation.
     *
     * @param r1 the left child
     * @param r2 the right child
     * @param name
     * @param term
     */
    public BinaryRelation(Relation r1, Relation r2, String name, String term) {
        super(name, term);
        this.r1 = r1;
        this.r2 = r2;
        containsRec = r1.containsRec || r2.containsRec;
        namedRelations.addAll(r1.namedRelations);
        namedRelations.addAll(r2.namedRelations);

    }

    /**
     * Creates a binary relation.
     *
     * @param r1 the left child.
     * @param r2 the right child.
     * @param term that describes the relation
     */
    public BinaryRelation(Relation r1, Relation r2, String term) {
        super(term);
        this.r1 = r1;
        this.r2 = r2;
        containsRec = r1.containsRec || r2.containsRec;
        namedRelations.addAll(r1.namedRelations);
        namedRelations.addAll(r2.namedRelations);
    }

    @Override
    public BoolExpr encode(Program program, Context ctx, Set<String> encodedRels) throws Z3Exception {
        if (!encodedRels.contains(getName())) {
            encodedRels.add(getName());
            BoolExpr enc = r1.encode(program, ctx, encodedRels);
            enc = ctx.mkAnd(enc, r2.encode(program, ctx, encodedRels));
            if (PredicateUtils.usePredicate) {
                if (Relation.Approx) {
                    return ctx.mkAnd(enc, this.encodePredicateApprox(program, ctx));
                } else {
                    return ctx.mkAnd(enc, this.encodePredicateBasic(program, ctx));
                }
            } else {
                if (Relation.Approx) {
                    return ctx.mkAnd(enc, this.encodeApprox(program, ctx));
                } else {
                    return ctx.mkAnd(enc, this.encodeBasic(program, ctx));
                }
            }
        } else {
            return ctx.mkTrue();

        }
    }

}
