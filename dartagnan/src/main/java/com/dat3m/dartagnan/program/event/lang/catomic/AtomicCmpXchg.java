package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.SingleAccessMemoryEvent;
import com.google.common.base.Preconditions;

import java.util.Set;

import static com.dat3m.dartagnan.program.Register.UsageType.ADDR;
import static com.dat3m.dartagnan.program.Register.UsageType.DATA;


// TODO: Add mo-on-failure
// NOTE: We do not inherit from RMWCmpXchgBase because it defines a "expected value" but a C11 CAS
// defines a "expected address".
public class AtomicCmpXchg extends SingleAccessMemoryEvent implements RegWriter {

    private Register resultRegister;
    private Expression expectedAddr;
    private Expression storeValue;
    private boolean isStrong;

    public AtomicCmpXchg(Register register, Expression address, Expression expectedAddr, Expression value, String mo, boolean isStrong) {
        super(address, register.getType(), mo);
        Preconditions.checkArgument(!mo.isEmpty(), "Atomic events cannot have empty memory order");
        this.resultRegister = register;
        this.expectedAddr = expectedAddr;
        this.storeValue = value;
        this.isStrong = isStrong;
        addTags(Tag.WRITE, Tag.READ, Tag.RMW);
    }

    private AtomicCmpXchg(AtomicCmpXchg other) {
        super(other);
        this.resultRegister = other.resultRegister;
        this.expectedAddr = other.expectedAddr;
        this.storeValue = other.storeValue;
        this.isStrong = other.isStrong;
    }

    public Expression getStoreValue() { return storeValue; }

    public boolean isStrong() {
        return this.isStrong;
    }

    public boolean isWeak() {
        return !this.isStrong;
    }

    public Expression getAddressOfExpected() {
        return expectedAddr;
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.resultRegister = reg;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return  Register.collectRegisterReads(storeValue, DATA,
                Register.collectRegisterReads(expectedAddr, ADDR, // note the address dependency here
                        super.getRegisterReads()));
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.RMW);
    }

    @Override
    public String defaultString() {
        final String strongSuffix = isStrong ? "strong" : "weak";
        return String.format("%s := atomic_compare_exchange_%s(*%s, %s, %s, %s)\t### C11",
                resultRegister, strongSuffix, address, expectedAddr, storeValue, mo);
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        super.transformExpressions(exprTransformer);
        this.storeValue = storeValue.accept(exprTransformer);
        this.expectedAddr = expectedAddr.accept(exprTransformer);
    }

    @Override
    public AtomicCmpXchg getCopy() {
        return new AtomicCmpXchg(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitAtomicCmpXchg(this);
    }

}