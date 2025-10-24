package com.dat3m.dartagnan.program.event.core.tangles;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.ExpressionEncoder;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.tangles.TangleType;
import com.dat3m.dartagnan.expression.tangles.GroupOp;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.ScopeHierarchy;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.function.BinaryOperator;
import java.util.function.Predicate;

import static com.dat3m.dartagnan.expression.tangles.TangleType.*;

public class NonUniformOpArithmetic extends NonUniformOpBase {

    final GroupOp operation;

    public NonUniformOpArithmetic(String instanceId, String execScope, TangleType op, Register register, Expression expr, GroupOp operation) {
        super(instanceId, execScope, op, register, expr);
        Preconditions.checkArgument(IADD == op || IMUL == op || IAND == op || IOR == op || IXOR == op);
        this.operation = operation;
    }

    private NonUniformOpArithmetic(NonUniformOpArithmetic other) {
        super(other);
        this.operation = other.operation;
    }

    public GroupOp getGroupOperation() {
        return operation;
    }

    @Override
    public String defaultString() {
        return String.format("%s <- group.%s.%s(%s, %s)", register, type, operation, instanceId, expr);
    }

    @Override
    public NonUniformOpArithmetic getCopy() {
        return new NonUniformOpArithmetic(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitNonUniformOpArithmetic(this);
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        // TODO implement operations other than reduce
        ScopeHierarchy hierarchy = getThread().getScopeHierarchy();
        ExpressionEncoder encoder = ctx.getExpressionEncoder();
        ExpressionFactory exprs = ExpressionFactory.getInstance();
        Expression identity;
        switch (type) {
            case IADD: case IOR:  case IXOR:
                identity = exprs.makeValue(0, (IntegerType) expr.getType());
                break;
            case IMUL:
                identity = exprs.makeValue(1, (IntegerType) expr.getType());
                break;
            case IAND:
                IntegerType iType = (IntegerType) expr.getType();
                identity = exprs.makeValue(iType.getMaximumValue(true), iType);
                break;
            default:
                throw new UnsupportedOperationException("Unsupported operation " + type);
        };
        BinaryOperator<Expression> reducer = (a, b) -> {
            switch (type) {
                case IADD:
                    return exprs.makeAdd(a, b);
                case IMUL:
                    return exprs.makeMul(a, b);
                case IAND:
                    return exprs.makeIntAnd(a, b);
                case IOR:
                    return exprs.makeIntOr(a, b);
                case IXOR:
                    return exprs.makeIntXor(a, b);
                default:
                    throw new UnsupportedOperationException("Unsupported operation " + type);
            }
        };
        Predicate<Event> filterCond = e -> {
            switch (operation) {
                case INCLUSIVESCAN:
                    return e.getThread().getId() <= getThread().getId();
                case EXCLUSIVESCAN:
                    return e.getThread().getId() < getThread().getId();
                case REDUCE:
                    return true;
                default:
                    throw new UnsupportedOperationException("Unsupported operation " + operation);
            }
        };
        Expression sum = getThread().getProgram().getThreadEvents(NonUniformOpArithmetic.class).stream()
                .filter(filterCond)
                .filter(e -> getInstanceId().equals(e.getInstanceId()))
                .filter(e -> hierarchy.canSyncAtScope(e.getThread().getScopeHierarchy(), execScope))
                .map(e -> exprs.makeITE(encoder.wrap(ctx.execution(e)),
                            ctx.getExpressionEncoder().encodeAt(e.expr, e),
                            identity))
                .reduce(identity, reducer);
        return ctx.getBooleanFormulaManager().and(
                super.encodeExec(ctx),
                encoder.equal(ctx.result(this), sum)
        );
    }
}
