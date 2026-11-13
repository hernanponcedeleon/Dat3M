package com.dat3m.dartagnan.program.event.lang.dat3m;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.common.CallBase;
import com.google.common.base.Preconditions;

import java.util.List;
import java.util.Set;

/*
    This event dynamically spawns a single thread when executed.
    - The spawned thread executes the given function with the given set of arguments
    - Writes the spawned thread's id into the return register.
    - Optionally, also stores the spawned thread's id at the given tid address (e.g., the pthread_t* of pthread_create).
      This store happens before the thread is spawned, so the spawned thread (and any thread synchronizing with it)
      observes the id.
 */
public class DynamicThreadCreate extends CallBase implements RegWriter {

    protected Register tidRegister;
    protected Expression tidAddress; // Nullable

    public DynamicThreadCreate(Register tidRegister, FunctionType funcType, Expression funcPtr, List<Expression> arguments) {
        this(tidRegister, null, funcType, funcPtr, arguments);
    }

    public DynamicThreadCreate(Register tidRegister, Expression tidAddress, FunctionType funcType, Expression funcPtr,
                               List<Expression> arguments) {
        Preconditions.checkArgument(tidRegister.getType() instanceof IntegerType);
        super(funcType, funcPtr, arguments);
        this.tidRegister = Preconditions.checkNotNull(tidRegister);
        this.tidAddress = tidAddress;
    }

    protected DynamicThreadCreate(DynamicThreadCreate other) {
        super(other);
        this.tidRegister = other.tidRegister;
        this.tidAddress = other.tidAddress;
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

    public boolean hasTidAddress() { return tidAddress != null; }
    public Expression getTidAddress() { return tidAddress; }

    @Override
    public Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> regReads = super.getRegisterReads();
        if (tidAddress != null) {
            Register.collectRegisterReads(tidAddress, Register.UsageType.ADDR, regReads);
        }
        return regReads;
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        super.transformExpressions(exprTransformer);
        if (tidAddress != null) {
            tidAddress = tidAddress.accept(exprTransformer);
        }
    }

    @Override
    protected String defaultString() {
        final String func = isDirectCall() ? getDirectCallTarget().getName() : getCallTarget().toString();
        final String store = tidAddress != null ? String.format(", tidAddress=%s", tidAddress) : "";
        return String.format("%s = DynamicThreadCreate(func=%s, args={ %s }%s)",
                getResultRegister(), func, argumentsToString(), store);
    }

    @Override
    public DynamicThreadCreate getCopy() {
        return new DynamicThreadCreate(this);
    }
}
