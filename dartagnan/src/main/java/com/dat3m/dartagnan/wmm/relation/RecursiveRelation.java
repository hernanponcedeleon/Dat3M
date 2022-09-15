package com.dat3m.dartagnan.wmm.relation;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class RecursiveRelation extends Definition {

    private Definition r1;

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

    public void setConcreteRelation(Definition r1){
        r1.setName(name);
        this.r1 = r1;
        this.term = r1.getTerm();
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitRecursive(this, r1);
    }
}
