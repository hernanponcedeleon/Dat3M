package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.StoreBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class End extends StoreBase {

    public End(Expression address) {
        super(address, ExpressionFactory.getInstance().makeZero(TypeFactory.getInstance().getArchType()), MO_SC);
        addTags(Tag.C11.PTHREAD);
    }

    private End(End other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return "end_thread()";
    }

    @Override
    public End getCopy() {
        return new End(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitEnd(this);
    }
}