package com.dat3m.dartagnan.program.arch.linux.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.EventFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.linux.event.cond.RMWReadCondCmp;
import com.dat3m.dartagnan.program.arch.linux.event.cond.RMWStoreCond;
import com.dat3m.dartagnan.program.arch.linux.utils.Mo;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;

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
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        if(target == Arch.NONE) {
            Register dummy = resultRegister;
            if(resultRegister == value || resultRegister == cmp){
                dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            }

            RMWReadCondCmp load = EventFactory.Linux.newRMWReadCondCmp(dummy, cmp, address, Mo.loadMO(mo));
            RMWStoreCond store = EventFactory.Linux.newRMWStoreCond(load, address, value, Mo.storeMO(mo));

            LinkedList<Event> events = new LinkedList<>(Arrays.asList(load, store));
            if (dummy != resultRegister) {
                events.addLast(EventFactory.newLocal(resultRegister, dummy));
            }
            if (Mo.MB.equals(mo)) {
                events.addFirst(EventFactory.Linux.newMemoryBarrier());
                events.addLast(EventFactory.Linux.newMemoryBarrier());
            }
            return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
        }
        return super.compileRecursive(target, nextId, predecessor, depth);
    }
}
