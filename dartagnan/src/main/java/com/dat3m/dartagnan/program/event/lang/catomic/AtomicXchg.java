package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class AtomicXchg extends AtomicAbstract {

    public AtomicXchg(Register register, IExpr address, IExpr value, String mo) {
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
    public ExprInterface getMemValue() {
        return value;
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        // TODO: Once we can return multiple MemoryAccesses, we need to add the LOAD here as well.
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.STORE);
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