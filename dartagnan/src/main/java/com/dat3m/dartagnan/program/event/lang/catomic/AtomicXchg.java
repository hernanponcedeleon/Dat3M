package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class AtomicXchg extends AtomicAbstract {

    public AtomicXchg(Register register, Expression address, Expression value, String mo) {
        super(address, register, value, mo);
    }

    private AtomicXchg(AtomicXchg other) {
        super(other);
    }

    @Override
    public String toString() {
        return resultRegister + " = atomic_exchange(*" + address + ", " + value + ", " + mo + ")\t### C11";
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.RMW);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AtomicXchg getCopy() {
        return new AtomicXchg(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitAtomicXchg(this);
    }
}