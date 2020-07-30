package com.dat3m.dartagnan.program.arch.linux.event;

import com.dat3m.dartagnan.program.arch.linux.utils.Mo;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.rmw.cond.FenceCond;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.rmw.cond.RMWReadCondCmp;
import com.dat3m.dartagnan.program.event.rmw.cond.RMWStoreCond;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;

import java.util.Arrays;
import java.util.LinkedList;

public class RMWCmpXchg extends RMWAbstract implements RegWriter, RegReaderData {

    private final ExprInterface cmp;

    public RMWCmpXchg(IExpr address, Register register, ExprInterface cmp, ExprInterface value, String mo) {
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
        return resultRegister + " := atomic_cmpxchg" + Mo.toText(mo) + "(" + address + ", " + cmp + ", " + value + ")";
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
    public int compile(Arch target, int nextId, Event predecessor) {
        if(target == Arch.NONE) {
            Register dummy = resultRegister;
            if(resultRegister == value || resultRegister == cmp){
                dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            }

            RMWReadCondCmp load = new RMWReadCondCmp(dummy, cmp, address, Mo.loadMO(mo));
            RMWStoreCond store = new RMWStoreCond(load, address, value, Mo.storeMO(mo));

            LinkedList<Event> events = new LinkedList<>(Arrays.asList(load, store));
            if (dummy != resultRegister) {
                events.addLast(new Local(resultRegister, dummy));
            }
            if (Mo.MB.equals(mo)) {
                events.addFirst(new FenceCond(load, "Mb"));
                events.addLast(new FenceCond(load, "Mb"));
            }
            return compileSequence(target, nextId, predecessor, events);
        }
        return super.compile(target, nextId, predecessor);
    }
}
