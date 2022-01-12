package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.google.common.base.Preconditions;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class RMWXchg extends RMWAbstract implements RegWriter, RegReaderData {

    public RMWXchg(IExpr address, Register register, IExpr value, String mo) {
        super(address, register, value, mo);
    }

    private RMWXchg(RMWXchg other){
        super(other);
    }

    @Override
    public String toString() {
        return resultRegister + " := atomic_xchg" + Tag.Linux.toText(mo) + "(" + address + ", " + value + ")";
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

        Fence optionalMbBefore = mo.equals(Tag.Linux.MO_MB) ? com.dat3m.dartagnan.program.event.EventFactory.Linux.newMemoryBarrier() : null;
        Load load = newRMWLoad(dummy, address, Tag.Linux.loadMO(mo));
        RMWStore store = newRMWStore(load, address, value, Tag.Linux.storeMO(mo));
        Local optionalUpdateReg = dummy != resultRegister ? newLocal(resultRegister, dummy) : null;
        Fence optionalMbAfter = mo.equals(Tag.Linux.MO_MB) ? com.dat3m.dartagnan.program.event.EventFactory.Linux.newMemoryBarrier() : null;

        return eventSequence(
                optionalMbBefore,
                load,
                store,
                optionalUpdateReg,
                optionalMbAfter
        );
    }
}