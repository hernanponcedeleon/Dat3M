package com.dat3m.dartagnan.program.event.rmw;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveAction;

public class RMWLoad extends Load implements RegWriter {

    public RMWLoad(Register reg, IExpr address, String mo) {
        super(reg, address, mo);
        addFilters(EType.RMW);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RecursiveAction unrollRecursive(int bound, Event predecessor, int depth) {
        throw new RuntimeException("RMWLoad cannot be unrolled: event must be generated during compilation");
    }
}
