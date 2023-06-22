package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.core.Event;
import com.google.common.base.Preconditions;

import java.util.List;

public class Thread extends Function {

    public Thread(String name, int id, Event entry){
        super(name, FunctionType.get(TypeFactory.getInstance().getVoidType()), List.of(), id, entry);
        Preconditions.checkArgument(id >= 0, "Invalid thread ID");
        Preconditions.checkNotNull(entry, "Thread entry event must be not null");
        entry.setFunction(this);
    }

    public Thread(int id, Event entry){
        this(String.valueOf(id), id, entry);
    }

    @Override
    public String toString() {
        return String.format("T%d:%s", id, name);
    }
}
