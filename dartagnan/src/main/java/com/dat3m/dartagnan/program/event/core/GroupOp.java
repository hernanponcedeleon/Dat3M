package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryOp;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.ScopeHierarchy;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.Tag;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.expression.booleans.BoolBinaryOp.AND;
import static com.dat3m.dartagnan.expression.booleans.BoolBinaryOp.OR;

public class GroupOp extends GenericVisibleEvent implements RegWriter, RegReader {

    private final BoolBinaryOp op;
    private final String scope;
    private Register register;
    private Expression expr;

    public GroupOp(String name, BoolBinaryOp op, String scope, Register register, Expression expr) {
        super(name);
        Preconditions.checkArgument(AND == op || OR == op);
        Preconditions.checkArgument(Tag.Vulkan.SUB_GROUP.equals(scope));
        Preconditions.checkArgument(expr.getType() instanceof BooleanType);
        Preconditions.checkArgument(register.getType().equals(expr.getType()));
        this.op = op;
        this.scope = scope;
        this.register = register;
        this.expr = expr;
        addTags(Tag.VISIBLE, Tag.TANGLE);
    }

    private GroupOp(GroupOp other) {
        super(other);
        this.op = other.op;
        this.scope = other.scope;
        this.register = other.register;
        this.expr = other.expr;
        addTags(Tag.VISIBLE, Tag.TANGLE);
    }

    public String getScope() {
        return scope;
    }

    @Override
    public String defaultString() {
        return String.format("%s <- group.%s(%s, %s)", register, op == AND ? "all" : "any" ,name, expr);
    }

    @Override
    public GroupOp getCopy() {
        return new GroupOp(this);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(expr, Register.UsageType.DATA, new HashSet<>());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.expr = expr.accept(exprTransformer);
    }

    @Override
    public Register getResultRegister() {
        return register;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.register = reg;
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitGroupOp(this);
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        ScopeHierarchy hierarchy = getThread().getScopeHierarchy();
        BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
        List<BooleanFormula> conditions = getThread().getProgram().getThreadEvents(GroupOp.class).stream()
                .filter(e -> name.equals(e.getName()))
                .filter(e -> hierarchy.canSyncAtScope(e.getThread().getScopeHierarchy(), scope))
                .map(e -> bmgr.or(
                        bmgr.not(ctx.execution(e)),
                        ctx.getExpressionEncoder().encodeBooleanAt(e.expr, e).formula())
                ).toList();
        BooleanFormula value = op == AND ? bmgr.and(conditions) : bmgr.or(conditions);
        return ctx.getBooleanFormulaManager().and(
                super.encodeExec(ctx),
                bmgr.equivalence((BooleanFormula) ctx.result(this).formula(), value)
        );
    }
}
