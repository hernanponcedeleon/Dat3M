package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.lang.linux.cond.RMWReadCondCmp;
import com.dat3m.dartagnan.program.event.lang.linux.cond.RMWStoreCond;
import com.dat3m.dartagnan.program.event.lang.linux.utils.Tag;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class RMWCmpXchg extends RMWAbstract implements RegWriter, RegReaderData {

    private final ExprInterface cmp;

    public RMWCmpXchg(IExpr address, Register register, ExprInterface cmp, IExpr value, String mo) {
        super(address, register, value, mo);
        this.dataRegs = new ImmutableSet.Builder<Register>().addAll(value.getRegs()).addAll(cmp.getRegs()).build();
        this.cmp = cmp;
    }

    private RMWCmpXchg(RMWCmpXchg other){
        super(other);
        this.cmp = other.cmp;
    }

    @Override
    public String toString() {
        return resultRegister + " := atomic_cmpxchg" + Tag.toText(mo) + "(" + address + ", " + cmp + ", " + value + ")";
    }

    public ExprInterface getCmp() {
    	return cmp;
    }
    
    @Override
    public ExprInterface getMemValue(){
        return value;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWCmpXchg getCopy(){
        return new RMWCmpXchg(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public List<Event> compile(Arch target) {
        Preconditions.checkArgument(target == Arch.NONE, "Compilation to " + target + " is not supported for " + getClass().getName());

        Register dummy = resultRegister;
        if(resultRegister == value || resultRegister == cmp){
            dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        }

        RMWReadCondCmp load = Linux.newRMWReadCondCmp(dummy, cmp, address, Tag.loadMO(mo));
        RMWStoreCond store = Linux.newRMWStoreCond(load, address, value, Tag.storeMO(mo));
        Local optionalUpdateReg = dummy != resultRegister ? newLocal(resultRegister, dummy) : null;
        Fence optionalMbBefore = mo.equals(Tag.MB) ? Linux.newConditionalMemoryBarrier(load) : null;
        Fence optionalMbAfter = mo.equals(Tag.MB) ? Linux.newConditionalMemoryBarrier(load) : null;

        return eventSequence(
                optionalMbBefore,
                load,
                store,
                optionalUpdateReg,
                optionalMbAfter
        );
    }
}