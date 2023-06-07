package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class Load extends AbstractMemoryEvent implements RegWriter {

    protected final Register resultRegister;

    public Load(Register register, Expression address, String mo) {
        super(address, mo);
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
        return resultRegister + " = load(*" + address + (!mo.isEmpty() ? ", " + mo : "") + ")";
    }

    @Override
    public Expression getMemValue() {
        return resultRegister;
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