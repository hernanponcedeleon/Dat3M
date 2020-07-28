package com.dat3m.dartagnan.asserts;

import com.dat3m.dartagnan.utils.EncodingConf;
import com.microsoft.z3.BoolExpr;

public class AssertNot extends AbstractAssert {

    private AbstractAssert child;

    public AssertNot(AbstractAssert child){
        this.child = child;
    }

    AbstractAssert getChild(){
        return child;
    }

    @Override
    public BoolExpr encode(EncodingConf conf) {
        if(child != null){
            return conf.getCtx().mkNot(child.encode(conf));
        }
        throw new RuntimeException("Empty assertion clause in " + this.getClass().getName());
    }

    @Override
    public String toString() {
        return "!" + child.toString();
    }
}
