package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.google.common.base.Preconditions;

import java.util.List;

public class Thread extends Function {

    public Thread(String name, FunctionType funcType, List<String> parameterNames, int id, ThreadStart entry) {
        super(name, funcType, parameterNames, id,  entry);
        Preconditions.checkArgument(id >= 0, "Invalid thread ID");
        Preconditions.checkNotNull(entry, "Thread entry event must be not null");
    }

    @Override
    public ThreadStart getEntry() {
        return (ThreadStart) entry;
    }

    @Override
    public Label getExit() {
        return (Label) exit;
    }

    @Override
    public String toString() {
        return String.format("T%d:%s", id, name);
    }
}
