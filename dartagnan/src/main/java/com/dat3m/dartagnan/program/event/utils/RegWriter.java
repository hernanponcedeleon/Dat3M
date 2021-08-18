package com.dat3m.dartagnan.program.event.utils;

import org.sosy_lab.java_smt.api.Formula;

import com.dat3m.dartagnan.program.Register;

public interface RegWriter {

    Register getResultRegister();

    default Formula getResultRegisterExpr(){
        throw new UnsupportedOperationException("RegResultExpr is available only for basic events");
    }
}
