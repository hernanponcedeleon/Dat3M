package com.dat3m.dartagnan.asserts;

import com.dat3m.dartagnan.utils.EncodingConf;
import com.microsoft.z3.BoolExpr;

public class AssertTrue extends AbstractAssert {

    @Override
    public BoolExpr encode(EncodingConf conf) {
    	// We want the verification to succeed so it should be UNSAT
        return conf.getCtx().mkFalse();
    }

    @Override
    public String toString(){
        return "true";
    }
}
