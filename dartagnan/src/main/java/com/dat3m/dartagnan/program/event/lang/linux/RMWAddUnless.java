package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.lang.linux.cond.RMWReadCondUnless;
import com.dat3m.dartagnan.program.event.lang.linux.cond.RMWStoreCond;
import com.dat3m.dartagnan.program.event.lang.linux.utils.Mo;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

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
    public RMWAddUnless getCopy(){
        return new RMWAddUnless(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public List<Event> compile(Arch target) {
        Preconditions.checkArgument(target == Arch.NONE, "Compilation to " + target + " is not supported for " + getClass().getName());

        Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        RMWReadCondUnless load = Linux.newRMWReadCondUnless(dummy, cmp, address, Mo.RELAXED);
        RMWStoreCond store = Linux.newRMWStoreCond(load, address, new IExprBin(dummy, IOpBin.PLUS, value), Mo.RELAXED);
        Local local = newLocal(resultRegister, new Atom(dummy, COpBin.NEQ, cmp));

        return eventSequence(
                Linux.newConditionalMemoryBarrier(load),
                load,
                store,
                local,
                Linux.newConditionalMemoryBarrier(load)
        );
    }
}