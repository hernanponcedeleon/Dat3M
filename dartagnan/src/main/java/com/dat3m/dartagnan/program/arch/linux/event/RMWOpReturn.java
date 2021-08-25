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
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;

public class RMWOpReturn extends RMWAbstract implements RegWriter, RegReaderData {

    private final IOpBin op;

    public RMWOpReturn(IExpr address, Register register, ExprInterface value, IOpBin op, String mo) {
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

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWOpReturn getCopy(){
        return new RMWOpReturn(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        if(target == Arch.NONE) {
            Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            Fence optionalMbBefore = mo.equals(Mo.MB) ? Linux.newMemoryBarrier() : null;
            Load load = newRMWLoad(dummy, address, Mo.loadMO(mo));
            Local localOp = newLocal(resultRegister, new IExprBin(dummy, op, value));
            RMWStore store = newRMWStore(load, address, resultRegister, Mo.storeMO(mo));
            Fence optionalMbAfter = mo.equals(Mo.MB) ? Linux.newMemoryBarrier() : null;

            List<Event> events = eventSequence(
                    optionalMbBefore,
                    load,
                    localOp,
                    store,
                    optionalMbAfter
            );
            return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
        }
        return super.compileRecursive(target, nextId, predecessor, depth + 1);
    }
}
