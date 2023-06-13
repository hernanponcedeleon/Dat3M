package com.dat3m.dartagnan.program.event.arch.tso;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.common.SingleAccessMemoryEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.*;

public class Xchg extends SingleAccessMemoryEvent implements RegWriter {

    private final Register resultRegister;

    public Xchg(MemoryObject address, Register register) {
        super(address, "");
        this.resultRegister = register;
        addTags(READ, WRITE, TSO.ATOM);
    }

    private Xchg(Xchg other){
        super(other);
        this.resultRegister = other.resultRegister;
    }

    @Override
    public Register getResultRegister(){
        return resultRegister;
    }

    @Override
    public Set<Register.Read> getRegisterReads(){
        return Register.collectRegisterReads(resultRegister, Register.UsageType.DATA, super.getRegisterReads());
    }

    @Override
    public String defaultString() {
        return "xchg(*" + address + ", " + resultRegister + ")";
    }

    public Expression getMemValue(){
        return resultRegister;
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.RMW);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Xchg getCopy(){
        return new Xchg(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitXchg(this);
    }
}