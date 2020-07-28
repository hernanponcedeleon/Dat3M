package com.dat3m.dartagnan.asserts;

import com.dat3m.dartagnan.utils.EncodingConf;
import com.microsoft.z3.BoolExpr;

public class AssertCompositeOr extends AbstractAssert {

    private AbstractAssert a1;
    private AbstractAssert a2;

    public AssertCompositeOr(AbstractAssert a1, AbstractAssert a2){
        this.a1 = a1;
        this.a2 = a2;
    }

    @Override
    public BoolExpr encode(EncodingConf conf) {
        return conf.getCtx().mkOr(a1.encode(conf), a2.encode(conf));
    }

    @Override
    public String toString() {
        return "(" + a1 + " || " + a2 + ")";
    }
}
