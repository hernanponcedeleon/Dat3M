package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import org.sosy_lab.java_smt.api.BitvectorFormulaManager;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;

import java.util.Map;

public class ExecutionStatus extends Event implements RegWriter {

    private final Register register;
    private Event event;
    private final boolean trackDep;

    public ExecutionStatus(Register register, Event event, boolean trackDep) {
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

    public Event getStatusEvent() {
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
        FormulaManager fmgr = context.getFormulaManager();
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
        int precision = register.getPrecision();
        return bmgr.and(super.encodeExec(context),
                bmgr.implication(context.execution(event),
                        context.equalZero(context.result(this))),
                bmgr.or(context.execution(event),
                        context.equal(context.result(this), bvmgr.makeBitvector(precision, 1))));
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Event getCopy() {
        return new ExecutionStatus(this);
    }

    @Override
    public void updateReferences(Map<Event, Event> updateMapping) {
        this.event = updateMapping.getOrDefault(event, event);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitExecutionStatus(this);
    }
}