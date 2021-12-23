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
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

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
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        if(target == Arch.NONE) {
            Load load = newRMWLoad(resultRegister, address, Mo.RELAXED);
            RMWStore store = newRMWStore(load, address, new IExprBin(resultRegister, op, value), Mo.RELAXED);
            load.addFilters(EType.NORETURN);
            List<Event> events = eventSequence(
                    load,
                    store
            );
            return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
        }
        return super.compileRecursive(target, nextId, predecessor, depth + 1);
    }
}
