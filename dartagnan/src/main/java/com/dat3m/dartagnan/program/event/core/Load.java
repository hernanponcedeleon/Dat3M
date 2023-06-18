package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.List;

public class Load extends AbstractMemoryCoreEvent implements RegWriter {

    protected final Register resultRegister;

    public Load(Register register, Expression address) {
        super(address);
        this.resultRegister = register;
        addTags(Tag.READ);
    }

    protected Load(Load other) {
        super(other);
        this.resultRegister = other.resultRegister;
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public String toString() {
        final MemoryOrder mo = getMetadata(MemoryOrder.class);
        return String.format("%s = load(*%s%s)", resultRegister, address, mo != null ? ", " + mo.value() : "");
    }

    @Override
    public List<MemoryAccess> getMemoryAccesses() {
        return List.of(new MemoryAccess(address, accessType, MemoryAccess.Mode.LOAD));
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Load getCopy() {
        return new Load(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLoad(this);
    }
}