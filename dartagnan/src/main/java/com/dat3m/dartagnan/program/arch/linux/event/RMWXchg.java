package com.dat3m.dartagnan.program.arch.linux.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
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

public class RMWXchg extends RMWAbstract implements RegWriter, RegReaderData {

    public RMWXchg(IExpr address, Register register, IExpr value, String mo) {
        super(address, register, value, mo);
    }

    private RMWXchg(RMWXchg other){
        super(other);
    }

    @Override
    public String toString() {
        return resultRegister + " := atomic_xchg" + Mo.toText(mo) + "(" + address + ", " + value + ")";
    }

    @Override
    public ExprInterface getMemValue(){
        return value;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWXchg getCopy(){
        return new RMWXchg(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public List<Event> compile(Arch target) {
        Preconditions.checkArgument(target == Arch.NONE, "Compilation to " + target + " is not supported for " + getClass().getName());

        Register dummy = resultRegister;
        if(resultRegister == value){
            dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        }

        Fence optionalMbBefore = mo.equals(Mo.MB) ? Linux.newMemoryBarrier() : null;
        Load load = newRMWLoad(dummy, address, Mo.loadMO(mo));
        RMWStore store = newRMWStore(load, address, value, Mo.storeMO(mo));
        Local optionalUpdateReg = dummy != resultRegister ? newLocal(resultRegister, dummy) : null;
        Fence optionalMbAfter = mo.equals(Mo.MB) ? Linux.newMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                store,
                optionalUpdateReg,
                optionalMbAfter
        );
    }
}