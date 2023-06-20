package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class AtomicFetchOp extends AtomicAbstract {

    private final IOpBin op;

    public AtomicFetchOp(Register register, Expression address, Expression value, IOpBin op, String mo) {
        super(address, register, value, mo);
        this.op = op;
    }

    private AtomicFetchOp(AtomicFetchOp other) {
        super(other);
        this.op = other.op;
    }

    @Override
    public String defaultString() {
        return resultRegister + " = atomic_fetch_" + op.toLinuxName() +
                "(*" + address + ", " + value + ", " + mo + ")\t### C11";
    }

    public IOpBin getOp() {
        return op;
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.RMW);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AtomicFetchOp getCopy() {
        return new AtomicFetchOp(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitAtomicFetchOp(this);
    }
}