package com.dat3m.dartagnan.wmm.relation.unary;

import com.dat3m.dartagnan.wmm.relation.Relation;

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
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitInverse(this, r1);
    }
}