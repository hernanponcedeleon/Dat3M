package com.dat3m.dartagnan.program.event.lang.dat3m;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.common.CallBase;
import com.google.common.base.Preconditions;

import java.util.List;

/*
    This event dynamically spawns a single thread when executed.
    - The spawned thread executes the given function with the given set of arguments
    - Writes the spawned thread's id into the return register.
 */
public class DynamicThreadCreate extends CallBase implements RegWriter {

    protected Register tidRegister;
    protected Thread.Type threadType;

    public DynamicThreadCreate(Register tidRegister, FunctionType funcType, Expression funcPtr, List<Expression> arguments) {
        super(funcType, funcPtr, arguments);
        Preconditions.checkArgument(tidRegister.getType() instanceof IntegerType);
        this.tidRegister = Preconditions.checkNotNull(tidRegister);
        this.threadType = Thread.Type.STANDARD;
    }

    protected DynamicThreadCreate(DynamicThreadCreate other) {
        super(other);
        this.tidRegister = other.tidRegister;
        this.threadType = other.threadType;
    }

    @Override
    public Register getResultRegister() {
        return tidRegister;
    }

    @Override
    public void setResultRegister(Register reg) {
        Preconditions.checkArgument(reg.getType() instanceof IntegerType);
        this.tidRegister = Preconditions.checkNotNull(reg);
    }

    public Thread.Type getThreadType() { return threadType; }
    public void setThreadType(Thread.Type type) { this.threadType = type; }

    @Override
    protected String defaultString() {
        final String func = isDirectCall() ? getDirectCallTarget().getName() : getCallTarget().toString();
        return String.format("%s <- DynamicThreadCreate(func=%s, type=%s args={ %s })", getResultRegister(), func, getThreadType(), argumentsToString());
    }

    @Override
    public DynamicThreadCreate getCopy() {
        return new DynamicThreadCreate(this);
    }
}
