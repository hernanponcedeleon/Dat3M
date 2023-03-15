package com.dat3m.dartagnan.program.processing;

import java.math.BigInteger;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.lang.std.MemCpy;

public class MemCpyUnrolling implements ProgramProcessor {

    private MemCpyUnrolling() { }

    public static MemCpyUnrolling newInstance() { return new MemCpyUnrolling(); }

    @Override
    public void run(Program program) {

        for (MemCpy e : program.getEvents(MemCpy.class)) {
            Event cur = e.getPredecessor();
            final Event exit = e .getSuccessor();
            for(int i = 0; i < getBytes(e); i++) {
                IExpr offset = new IValue(BigInteger.valueOf(i), e.getSrc().getPrecision());
                Register r = e.getThread().newRegister(GlobalSettings.getArchPrecision());
                Load load = EventFactory.newLoad(r, new IExprBin(e.getSrc(), IOpBin.PLUS, offset), "");
                cur.setSuccessor(load);
                Store store = EventFactory.newStore(new IExprBin(e.getDst(), IOpBin.PLUS, offset), r, "");
                load.setSuccessor(store);
                cur = store;
            }
            cur.setSuccessor(exit);
        }
    }

    private int getBytes(MemCpy memcpy) {
        try {
            return memcpy.getBytes().reduce().getValueAsInt();
        } catch (Exception e) {
            final String error = String.format("Variable-lenght memcpy '%s' is not supported", memcpy);
            throw new MalformedProgramException(error);
        }
    }

}
