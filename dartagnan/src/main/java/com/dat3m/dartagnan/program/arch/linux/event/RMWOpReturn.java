package com.dat3m.dartagnan.program.arch.linux.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.linux.utils.Mo;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.configuration.Arch;
import com.google.common.base.Preconditions;

import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;

public class RMWOpReturn extends RMWAbstract implements RegWriter, RegReaderData {

    private final IOpBin op;

    public RMWOpReturn(IExpr address, Register register, IExpr value, IOpBin op, String mo) {
        super(address, register, value, mo);
        this.op = op;
    }

    private RMWOpReturn(RMWOpReturn other){
        super(other);
        this.op = other.op;
    }

    @Override
    public String toString() {
        return resultRegister + " := atomic_" + op.toLinuxName() + "_return" + Mo.toText(mo) + "(" + value + ", " + address + ")";
    }

    public IOpBin getOp() {
    	return op;
    }
    
    @Override
    public ExprInterface getMemValue(){
        return value;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWOpReturn getCopy(){
        return new RMWOpReturn(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public List<Event> compile(Arch target) {
        Preconditions.checkArgument(target == Arch.NONE, "Compilation to " + target + " is not supported for " + getClass().getName());

        Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        Fence optionalMbBefore = mo.equals(Mo.MB) ? Linux.newMemoryBarrier() : null;
        Load load = newRMWLoad(dummy, address, Mo.loadMO(mo));
        Local localOp = newLocal(resultRegister, new IExprBin(dummy, op, value));
        RMWStore store = newRMWStore(load, address, resultRegister, Mo.storeMO(mo));
        Fence optionalMbAfter = mo.equals(Mo.MB) ? Linux.newMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                localOp,
                store,
                optionalMbAfter
        );
    }
}