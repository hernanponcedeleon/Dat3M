package com.dat3m.dartagnan.program.event.core.tangles;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.tangles.TangleType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.ScopeHierarchy;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.List;

import static com.dat3m.dartagnan.expression.tangles.TangleType.ALL;
import static com.dat3m.dartagnan.expression.tangles.TangleType.ANY;

public class NonUniformOpBool extends NonUniformOpBase {

    public NonUniformOpBool(String instanceId, String execScope, TangleType op, Register register, Expression expr) {
        super(instanceId, execScope, op, register, expr);
        Preconditions.checkArgument(ALL == op || ANY == op);
    }

    private NonUniformOpBool(NonUniformOpBool other) {
        super(other);
    }

    @Override
    public NonUniformOpBool getCopy() {
        return new NonUniformOpBool(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitNonUniformOpBool(this);
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        ScopeHierarchy hierarchy = getThread().getScopeHierarchy();
        BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
        List<BooleanFormula> conditions = getThread().getProgram().getThreadEvents(NonUniformOpBool.class).stream()
                .filter(e -> getInstanceId().equals(e.getInstanceId()))
                .filter(e -> hierarchy.canSyncAtScope(e.getThread().getScopeHierarchy(), execScope))
                .map(e -> bmgr.or(
                        bmgr.not(ctx.execution(e)),
                        ctx.getExpressionEncoder().encodeBooleanAt(e.expr, e).formula()))
                .toList();
        BooleanFormula value = type == ALL ? bmgr.and(conditions) : bmgr.or(conditions);
        return ctx.getBooleanFormulaManager().and(
                super.encodeExec(ctx),
                bmgr.equivalence((BooleanFormula) ctx.result(this).formula(), value)
        );
    }
}
