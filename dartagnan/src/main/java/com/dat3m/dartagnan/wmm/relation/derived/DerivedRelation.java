package com.dat3m.dartagnan.wmm.relation.derived;

import com.dat3m.dartagnan.wmm.relation.Relation;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public abstract class DerivedRelation extends Relation {


    protected DerivedRelation() {
        super();
    }

    protected DerivedRelation(String name) {
        super(name);
    }


    // TODO: Understand why this function is needed
    @Override
    public int updateRecursiveGroupId(int parentId){
        if(recursiveGroupId == 0 || forceUpdateRecursiveGroupId){
            forceUpdateRecursiveGroupId = false;
            int id = 0;
            for (Relation rel : getDependencies()) {
                id |= rel.updateRecursiveGroupId(parentId | recursiveGroupId);
            }
            recursiveGroupId |= id & parentId;
        }
        return recursiveGroupId;
    }

    @Override
    public BoolExpr encode(Context ctx) {
        if(isEncoded){
            return ctx.mkTrue();
        }
        isEncoded = true;
        BoolExpr enc = doEncode(ctx);
        for (Relation rel : getDependencies()) {
            enc = ctx.mkAnd(enc, rel.encode(ctx));
        }
        return enc;
    }
}
