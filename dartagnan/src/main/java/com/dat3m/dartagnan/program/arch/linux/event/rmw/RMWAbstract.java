package com.dat3m.dartagnan.program.arch.linux.event.rmw;

import com.google.common.collect.ImmutableSet;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Seq;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.rmw.cond.FenceCond;
import com.dat3m.dartagnan.program.event.rmw.cond.RMWReadCond;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;
import com.dat3m.dartagnan.program.Thread;

public abstract class RMWAbstract extends MemEvent implements RegWriter, RegReaderData {

    protected Register resultRegister;
    protected ExprInterface value;

    ImmutableSet<Register> dataRegs;

    RMWAbstract(IExpr address, Register register, ExprInterface value, String atomic) {
        this.address = address;
        this.resultRegister = register;
        this.value = value;
        this.atomic = atomic;
        this.condLevel = 0;
        this.dataRegs = value.getRegs();
        addFilters(EType.ANY, EType.MEMORY, EType.READ, EType.WRITE, EType.RMW);
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
    }

    @Override
    public Thread compile(String target) {
        throw new RuntimeException("Compilation to " + target + " is not supported for " + this.getClass().getName() + " " + atomic);
    }

    String getLoadMO(){
        return atomic.equals("Acquire") ? "Acquire" : "Relaxed";
    }

    String getStoreMO(){
        return atomic.equals("Release") ? "Release" : "Relaxed";
    }

    Thread insertFencesOnMb(Thread result){
        if (atomic.equals("Mb")) {
            return new Seq(new Fence("Mb"), new Seq(result, new Fence("Mb")));
        }
        return result;
    }

    Thread insertCondFencesOnMb(Thread result, RMWReadCond load){
        if (atomic.equals("Mb")) {
            return new Seq(new FenceCond(load, "Mb"), new Seq(result, new FenceCond(load, "Mb")));
        }
        return result;
    }

    Thread copyFromDummyToResult(Thread result, Register dummy){
        if (dummy != resultRegister) {
            return new Seq(result, new Local(resultRegister, dummy));
        }
        return result;
    }

    void compileBasic(MemEvent event){
        event.setHLId(hlId);
        event.setCondLevel(condLevel);
    }

    String atomicToText(String atomic){
        switch (atomic){
            case "Relaxed":
                return "_relaxed";
            case "Acquire":
                return "_acquire";
            case "Release":
                return "_release";
            case "Mb":
                return "";
            default:
                throw new RuntimeException("Unrecognised memory order " + atomic + " in " + this.getClass().getName());
        }
    }
}
