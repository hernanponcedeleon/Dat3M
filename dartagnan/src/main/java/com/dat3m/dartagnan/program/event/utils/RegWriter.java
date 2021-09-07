package com.dat3m.dartagnan.program.event.utils;

import java.math.BigInteger;

import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public interface RegWriter {

    Register getResultRegister();

    default Formula getResultRegisterExpr(){
        throw new UnsupportedOperationException("RegResultExpr is available only for basic events");
    }

    default BigInteger getWrittenValue(Event e, Model model, SolverContext ctx){
        return new BigInteger(model.evaluate(getResultRegister().toIntFormulaResult(e, ctx)).toString());
    }
}
