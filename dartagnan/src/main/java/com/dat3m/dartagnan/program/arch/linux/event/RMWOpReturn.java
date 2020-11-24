package com.dat3m.dartagnan.program.arch.linux.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.linux.utils.Mo;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.rmw.RMWLoad;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.Arrays;
import java.util.LinkedList;

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
    public int compile(Arch target, int nextId, Event predecessor) {
        if(target == Arch.NONE) {
            Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            RMWLoad load = new RMWLoad(dummy, address, Mo.loadMO(mo));
            Local local = new Local(resultRegister, new IExprBin(dummy, op, value));
            RMWStore store = new RMWStore(load, address, resultRegister, Mo.storeMO(mo));

            LinkedList<Event> events = new LinkedList<>(Arrays.asList(load, local, store));
            if (Mo.MB.equals(mo)) {
                events.addFirst(new Fence("Mb"));
                events.addLast(new Fence("Mb"));
            }
            return compileSequence(target, nextId, predecessor, events);
        }
        return super.compile(target, nextId, predecessor);
    }
}
