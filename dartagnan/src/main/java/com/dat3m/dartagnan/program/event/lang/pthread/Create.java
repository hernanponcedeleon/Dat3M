package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Create extends Store {

    private final String routine;

    public Create(Expression address, String routine) {
        super(address, ExpressionFactory.getInstance().makeOne(TypeFactory.getInstance().getBooleanType()), MO_SC);
        this.routine = routine;
        addTags(Tag.C11.PTHREAD);
    }

    private Create(Create other){
        super(other);
        this.routine = other.routine;
    }

    @Override
    public String toString() {
        return "pthread_create(" + address + ", " + routine + ")";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Create getCopy(){
        return new Create(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitCreate(this);
    }
}