package com.dat3m.dartagnan.program.arch.linux.event;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;
import com.dat3m.dartagnan.program.arch.linux.utils.Mo;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.base.Preconditions;

import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;

public class RMWOp extends RMWAbstract implements RegWriter, RegReaderData {

    private final IOpBin op;

    public RMWOp(IExpr address, Register register, IExpr value, IOpBin op) {
        super(address, register, value, Mo.RELAXED);
        this.op = op;
        addFilters(EType.NORETURN);
    }

    private RMWOp(RMWOp other){
        super(other);
        this.op = other.op;
    }

    @Override
    public String toString() {
        return "atomic_" + op.toLinuxName() + "(" + value + ", " + address + ")";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWOp getCopy(){
        return new RMWOp(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public List<Event> compile(Arch target) {
        Preconditions.checkArgument(target == Arch.NONE, "Compilation to " + target + " is not supported for " + getClass().getName());

        Load load = newRMWLoad(resultRegister, address, Mo.RELAXED);
        RMWStore store = newRMWStore(load, address, new IExprBin(resultRegister, op, value), Mo.RELAXED);
        load.addFilters(EType.NORETURN);
        return eventSequence(
                load,
                store
        );
    }
}