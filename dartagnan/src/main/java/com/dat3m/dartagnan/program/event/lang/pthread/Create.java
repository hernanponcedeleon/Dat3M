package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.StoreBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Create extends StoreBase {

    private final String routine;

    public Create(Expression address, String routine) {
        super(address, ExpressionFactory.getInstance().makeOne(TypeFactory.getInstance().getArchType()), MO_SC);
        this.routine = routine;
        addTags(Tag.C11.PTHREAD);
    }

    private Create(Create other) {
        super(other);
        this.routine = other.routine;
    }

    @Override
    public String defaultString() {
        return "pthread_create(" + address + ", " + routine + ")";
    }

    @Override
    public Create getCopy() {
        return new Create(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitCreate(this);
    }
}