package com.dat3m.dartagnan.program.arch.linux.event;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.linux.utils.Mo;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.math.BigInteger;
import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;

public class RMWOpAndTest extends RMWAbstract implements RegWriter, RegReaderData {

    private final IOpBin op;

    public RMWOpAndTest(IExpr address, Register register, ExprInterface value, IOpBin op) {
        super(address, register, value, Mo.MB);
        this.op = op;
    }

    private RMWOpAndTest(RMWOpAndTest other){
        super(other);
        this.op = other.op;
    }

    @Override
    public String toString() {
        return resultRegister + " := atomic_" + op.toLinuxName() + "_and_test(" + value + ", " + address + ")";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWOpAndTest getCopy(){
        return new RMWOpAndTest(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        if(target == Arch.NONE) {
            Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            Load load = newRMWLoad(dummy, address, Mo.RELAXED);
            Local localOp = newLocal(dummy, new IExprBin(dummy, op, value));
            RMWStore store = newRMWStore(load, address, dummy, Mo.RELAXED);
            Local test = newLocal(resultRegister, new Atom(dummy, COpBin.EQ, new IConst(BigInteger.ZERO, resultRegister.getPrecision())));

            //TODO: Are the memory barriers really unconditional?
            List<Event> events = eventSequence(
                    Linux.newMemoryBarrier(),
                    load,
                    localOp,
                    store,
                    test,
                    Linux.newMemoryBarrier()
            );

            return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
        }
        return super.compileRecursive(target, nextId, predecessor, depth);
    }
}
