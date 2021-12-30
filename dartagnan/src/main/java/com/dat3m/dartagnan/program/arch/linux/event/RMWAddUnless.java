package com.dat3m.dartagnan.program.arch.linux.event;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.linux.event.cond.RMWReadCondUnless;
import com.dat3m.dartagnan.program.arch.linux.event.cond.RMWStoreCond;
import com.dat3m.dartagnan.program.arch.linux.utils.Mo;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;

import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;

public class RMWAddUnless extends RMWAbstract implements RegWriter, RegReaderData {

    private final ExprInterface cmp;

    public RMWAddUnless(IExpr address, Register register, ExprInterface cmp, IExpr value) {
        super(address, register, value, Mo.MB);
        dataRegs = new ImmutableSet.Builder<Register>().addAll(value.getRegs()).addAll(cmp.getRegs()).build();
        this.cmp = cmp;
    }

    private RMWAddUnless(RMWAddUnless other){
        super(other);
        this.cmp = other.cmp;
    }

    @Override
    public String toString() {
        return resultRegister + " := atomic_add_unless" + "(" + address + ", " + value + ", " + cmp + ")";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWAddUnless getCopy(){
        return new RMWAddUnless(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        if(target == Arch.NONE) {
            Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
            RMWReadCondUnless load = Linux.newRMWReadCondUnless(dummy, cmp, address, Mo.RELAXED);
            RMWStoreCond store = Linux.newRMWStoreCond(load, address, new IExprBin(dummy, IOpBin.PLUS, value), Mo.RELAXED);
            Local local = newLocal(resultRegister, new Atom(dummy, COpBin.NEQ, cmp));

            List<Event> events = eventSequence(
                    Linux.newConditionalMemoryBarrier(load),
                    load,
                    store,
                    local,
                    Linux.newConditionalMemoryBarrier(load)
            );

            return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
        }
        return super.compileRecursive(target, nextId, predecessor, depth + 1);
    }
}
