package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import org.sosy_lab.java_smt.api.*;

import java.util.Map;

public class ExecutionStatus extends AbstractEvent implements RegWriter {

    private final Register register;
    private AbstractEvent event;
    private final boolean trackDep;

    public ExecutionStatus(Register register, AbstractEvent event, boolean trackDep) {
        this.register = register;
        this.event = event;
        this.trackDep = trackDep;
    }

    protected ExecutionStatus(ExecutionStatus other) {
        super(other);
        this.register = other.register;
        this.event = other.event;
        this.trackDep = other.trackDep;
    }

    @Override
    public Register getResultRegister() {
        return register;
    }

    public AbstractEvent getStatusEvent() {
        return event;
    }

    public boolean doesTrackDep() {
        return trackDep;
    }

    @Override
    public String toString() {
        return register + " <- status(" + event.toString() + ")";
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext context) {
        FormulaManager formulaManager = context.getFormulaManager();
        BooleanFormulaManager booleanFormulaManager = context.getBooleanFormulaManager();
        Type type = register.getType();
        BooleanFormula eventExecuted = context.execution(event);
        Formula result = context.result(this);
        if (type instanceof IntegerType integerType) {
            Formula one;
            if (integerType.isMathematical()) {
                IntegerFormulaManager integerFormulaManager = formulaManager.getIntegerFormulaManager();
                one = integerFormulaManager.makeNumber(1);
            } else {
                BitvectorFormulaManager bitvectorFormulaManager = formulaManager.getBitvectorFormulaManager();
                int bitWidth = integerType.getBitWidth();
                one = bitvectorFormulaManager.makeBitvector(1, bitWidth);
            }
            return booleanFormulaManager.and(super.encodeExec(context),
                    booleanFormulaManager.implication(eventExecuted,
                            context.equalZero(result)),
                    booleanFormulaManager.or(eventExecuted,
                            context.equal(result, one)));
        }
        throw new UnsupportedOperationException(String.format("Encoding ExecutionStatus on type %s.", type));
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AbstractEvent getCopy() {
        return new ExecutionStatus(this);
    }

    @Override
    public void updateReferences(Map<AbstractEvent, AbstractEvent> updateMapping) {
        this.event = updateMapping.getOrDefault(event, event);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitExecutionStatus(this);
    }
}