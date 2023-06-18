package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.common.SingleAccessMemoryEvent;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_ACQUIRE;
import static com.dat3m.dartagnan.program.event.Tag.C11.MO_ACQUIRE_RELEASE;
import static com.dat3m.dartagnan.program.event.Tag.WRITE;

public class LlvmStore extends SingleAccessMemoryEvent {

    private Expression value;

    public LlvmStore(Expression address, Expression value, String mo){
        super(address, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "LLVM events cannot have empty memory order");
        Preconditions.checkArgument(!mo.equals(MO_ACQUIRE) && !mo.equals(MO_ACQUIRE_RELEASE),
                getClass().getName() + " cannot have memory order: " + mo);
        this.value = value;
        addTags(WRITE);
    }

    private LlvmStore(LlvmStore other) {
        super(other);
        this.value = other.value;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(value, Register.UsageType.DATA, super.getRegisterReads());
    }

    @Override
    public String toString() {
        return "llvm_store(*" + address + ", " + value + ", " + mo + ")\t### LLVM";
    }

    public Expression getMemValue() {
    	return value;
    }

    public void setMemValue(Expression value){
        this.value = value;
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        // TODO: Once we can return multiple MemoryAccesses, we need to add the LOAD here as well.
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.STORE);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public LlvmStore getCopy() {
        return new LlvmStore(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLlvmStore(this);
    }
}