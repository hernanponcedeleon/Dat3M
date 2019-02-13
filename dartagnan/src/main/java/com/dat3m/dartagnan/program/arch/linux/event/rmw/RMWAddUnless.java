package com.dat3m.dartagnan.program.arch.linux.event.rmw;

import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Seq;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.rmw.cond.RMWReadCondUnless;
import com.dat3m.dartagnan.program.event.rmw.cond.RMWStoreCond;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.Thread;

public class RMWAddUnless extends RMWAbstract implements RegWriter, RegReaderData {

    private ExprInterface cmp;

    public RMWAddUnless(IExpr address, Register register, ExprInterface cmp, ExprInterface value) {
        super(address, register, value, "Mb");
        this.dataRegs = new ImmutableSet.Builder<Register>().addAll(value.getRegs()).addAll(cmp.getRegs()).build();
        this.cmp = cmp;
    }

    @Override
    public Thread compile(Arch target) {
        if(target == Arch.NONE) {
            Register dummy = new Register(null, resultRegister.getThreadId());
            RMWReadCondUnless load = new RMWReadCondUnless(dummy, cmp, address, "Relaxed");
            RMWStoreCond store = new RMWStoreCond(load, address, new IExprBin(dummy, IOpBin.PLUS, value), "Relaxed");
            Local local = new Local(resultRegister, new Atom(dummy, COpBin.NEQ, cmp));

            compileBasic(load);
            compileBasic(store);

            Thread result = new Seq(load, new Seq(store, local));
            return insertCondFencesOnMb(result, load);
        }
        return super.compile(target);
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + resultRegister + " := atomic_add_unless" + "(" + address + ", " + value + ", " + cmp + ")";
    }

    @Override
    public RMWAddUnless clone() {
        if(clone == null){
            clone = new RMWAddUnless(address, resultRegister, cmp, value);
            afterClone();
        }
        return (RMWAddUnless)clone;
    }
}
