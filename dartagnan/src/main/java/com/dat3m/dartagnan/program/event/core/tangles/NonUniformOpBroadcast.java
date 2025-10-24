package com.dat3m.dartagnan.program.event.core.tangles;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.ExpressionEncoder;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.ThreadGrid;
import com.dat3m.dartagnan.program.Entrypoint.Grid;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.ScopeHierarchy;
import com.dat3m.dartagnan.program.event.EventVisitor;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.expression.tangles.TangleType.BROADCAST;

public class NonUniformOpBroadcast extends NonUniformOpBase {

    private Expression id;

    public NonUniformOpBroadcast(String instanceId, String execScope, Register register, Expression expr, Expression id) {
        super(instanceId, execScope, BROADCAST, register, expr);
        this.id = id;
    }

    private NonUniformOpBroadcast(NonUniformOpBroadcast other) {
        super(other);
        this.id = other.id;
    }

    @Override
    public NonUniformOpBroadcast getCopy() {
        return new NonUniformOpBroadcast(this);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(id, Register.UsageType.DATA, super.getRegisterReads());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        super.transformExpressions(exprTransformer);
        this.id = id.accept(exprTransformer);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitNonUniformOpBroadcast(this);
    }

    @Override
    public String defaultString() {
        return String.format("%s <- group.%s(%s, %s, %s)", register, type, instanceId, expr, id);
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        ScopeHierarchy hierarchy = getThread().getScopeHierarchy();
        ThreadGrid grid = ((Grid) getThread().getProgram().getEntrypoint()).threadGrid();
        BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
        ExpressionEncoder encoder = ctx.getExpressionEncoder();
        Expression broadcastResult = encoder.makeVariable(String.format("broadcast_result_%s", getName()), expr.getType());
        List<BooleanFormula> conditions = getThread().getProgram().getThreadEvents(NonUniformOpBroadcast.class).stream()
                .filter(e -> getInstanceId().equals(e.getInstanceId()))
                .filter(e -> hierarchy.canSyncAtScope(e.getThread().getScopeHierarchy(), execScope))
                .map(e -> bmgr.or(
                        bmgr.not(bmgr.and(ctx.execution(e), broadcastElected(ctx, e))),
                        encoder.equal(broadcastResult, encoder.encodeAt(e.expr, e))))
                .toList();
        return bmgr.and(
                super.encodeExec(ctx),
                bmgr.and(conditions),
                // TODO is grid.thId the one we need to use?
                bmgr.equivalence(broadcastElected(ctx, this), encoder.equal(encoder.encodeAt(id, this), ExpressionFactory.getInstance().makeValue(grid.thId(getThread().getId()), (IntegerType) id.getType()))),
                encoder.equal(ctx.result(this), broadcastResult)
        );
    }

    public Expression getId() {
        return id;
    }

    private BooleanFormula broadcastElected(EncodingContext ctx, NonUniformOpBase e) {
        return ctx.getBooleanFormulaManager().makeVariable(String.format("elected_%s(%d)", e.getName(), e.getGlobalId()));
    }

}
