package com.dat3m.dartagnan.program.processing;

import java.math.BigInteger;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
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
            Event exit = e .getSuccessor();
            Thread thread = e.getThread();
            for(int i = 0; i < (e.getLenght().getValueAsInt() / e.getStep()); i++) {
                IExpr offset = new IValue(BigInteger.valueOf(e.getStep() * i), e.getSrc().getPrecision());
                Register r = thread.newRegister(GlobalSettings.ARCH_PRECISION);
                Load load = EventFactory.newLoad(r, new IExprBin(e.getSrc(), IOpBin.PLUS, offset), "");
                cur.setSuccessor(load);
                Store store = EventFactory.newStore(new IExprBin(e.getDst(), IOpBin.PLUS, offset), r, "");
                load.setSuccessor(store);
                cur = store;
            }
            cur.setSuccessor(exit);
        }
    }

}
