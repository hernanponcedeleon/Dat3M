package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.lang.linux.utils.Mo;
import com.google.common.base.Preconditions;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class RMWFetchOp extends RMWAbstract implements RegWriter, RegReaderData {

    private final IOpBin op;

    public RMWFetchOp(IExpr address, Register register, IExpr value, IOpBin op, String mo) {
        super(address, register, value, mo);
        this.op = op;
    }

    private RMWFetchOp(RMWFetchOp other){
        super(other);
        this.op = other.op;
    }

    @Override
    public String toString() {
        return resultRegister + " := atomic_fetch_" + op.toLinuxName() + Mo.toText(mo) + "(" + value + ", " + address + ")";
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
    public RMWFetchOp getCopy(){
        return new RMWFetchOp(this);
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
        RMWStore store = newRMWStore(load, address, new IExprBin(dummy, op, value), Mo.storeMO(mo));
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