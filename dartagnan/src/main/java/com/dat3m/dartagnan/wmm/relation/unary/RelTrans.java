package com.dat3m.dartagnan.wmm.relation.unary;

import com.dat3m.dartagnan.wmm.relation.Relation;

/**
 *
 * @author Florian Furbach
 */
public class RelTrans extends UnaryRelation {

    public static String makeTerm(Relation r1){
        return r1.getName() + "^+";
    }

    public RelTrans(Relation r1) {
        super(r1);
        term = makeTerm(r1);
    }

    public RelTrans(Relation r1, String name) {
        super(r1, name);
        term = makeTerm(r1);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitTransitiveClosure(this, r1);
    }
}