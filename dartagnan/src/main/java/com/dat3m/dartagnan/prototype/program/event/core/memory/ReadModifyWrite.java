package com.dat3m.dartagnan.prototype.program.event.core.memory;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.ExpressionKind;
import com.dat3m.dartagnan.prototype.program.event.MemoryAccess;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
// This is used to model RMW/AMO as a single core event. This cannot model CAS.
public abstract class ReadModifyWrite extends AbstractCoreMemoryEvent {

    protected ExpressionKind.IntBinary opCode; // TODO: Can we allow for any binary operator?
    protected Expression operand;

    protected ReadModifyWrite(Expression address, Expression operand, ExpressionKind.IntBinary opCode) {
        super(address, operand.getType(), "");
        this.opCode = opCode;
        this.operand = operand;
    }

    public ExpressionKind.IntBinary getOpCode() {
        return opCode;
    }
    public Expression getOperand() { return operand;}

    @Override
    public MemoryAccess.Mode getAccessMode() { return MemoryAccess.Mode.RMW; }
}
