package com.dat3m.dartagnan.program.event.lang.dat3m;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.utils.IntegerHelper;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.google.common.base.Preconditions;

import java.math.BigInteger;
import java.util.HashSet;
import java.util.Set;


/*
    This event joins with given thread, i.e., it blocks until the target thread terminates properly.
    - The target thread is specified by a thread id, typically the one returned by DynamicThreadCreate.
    - The type of the return register must be { bvX status, TRet retValue } where TRet may be void if no value is returned.
      The status may indicate success (status == 0) or an error (status != 0).
      The status register shall be large enough to accommodate all error values (bv8 should be sufficient).
    - The return value retValue is only well-defined in the case of success (status == 0).
    - It is possible to join with the same thread multiple times.
 */
public class DynamicThreadJoin extends AbstractEvent implements RegWriter, RegReader, BlockingEvent {

    public enum Status {
        SUCCESS(0),                // The join was successful
        INVALID_TID(1),            // The provided tid does not match with a joinable thread
        INVALID_RETURN_TYPE(2),    // The provided tid is valid, but the return type of that thread does not match
                                             // with the expected return type.
        DETACHED_THREAD(3);        // The provided tid belongs to a non-joinable thread.

        final int errorCode;
        public int getErrorCode() { return errorCode; }
        Status(int errorCode) { this.errorCode = errorCode; }
    }

    protected Register resultRegister;
    protected Expression tid;

    public DynamicThreadJoin(Register resultRegister, Expression tid) {
        Preconditions.checkArgument(resultRegister.getType() instanceof AggregateType aggType
                && aggType.getFields().size() == 2
                && aggType.getFields().get(0).type() instanceof IntegerType intType
                && IntegerHelper.isRepresentable(BigInteger.valueOf(Status.values().length - 1), intType.getBitWidth())
        );
        this.resultRegister = resultRegister;
        this.tid = tid;
    }

    protected DynamicThreadJoin(DynamicThreadJoin other) {
        super(other);
        this.resultRegister = other.resultRegister;
        this.tid = other.tid;
    }

    @Override
    public Register getResultRegister() {
        return this.resultRegister;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.resultRegister = reg;
    }

    public Expression getTid() { return tid; }
    public void setTid(Expression tid) { this.tid = tid; }

    @Override
    protected String defaultString() {
        return String.format("%s <- DynamicThreadJoin(%s)", resultRegister, tid);
    }

    @Override
    public DynamicThreadJoin getCopy() {
        return new DynamicThreadJoin(this);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(tid, Register.UsageType.OTHER, new HashSet<>());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        tid = tid.accept(exprTransformer);
    }
}
