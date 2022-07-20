package com.dat3m.dartagnan.wmm.relation;

import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;

/**
 *
 * @author Florian Furbach
 */
public class RecursiveRelation extends Relation {

    private Relation r1;
    private boolean doRecurse = false;

    public Relation getInner() {
        return r1;
    }

    public RecursiveRelation(String name) {
        super(name);
        term = name;
    }

    public static String makeTerm(String name){
        return name;
    }

    @Override
    public void initializeRelationAnalysis(VerificationTask task, Context context) {
        if(doRecurse){
            doRecurse = false;
            super.initializeRelationAnalysis(task, context);
            r1.initializeRelationAnalysis(task, context);
        }
    }

    public void setConcreteRelation(Relation r1){
        r1.setName(name);
        this.r1 = r1;
        this.term = r1.getTerm();
    }

    public void setDoRecurse(){
        doRecurse = true;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitRecursive(this, r1);
    }
}
