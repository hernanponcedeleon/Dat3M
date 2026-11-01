package com.dat3m.dartagnan.task.exploration;

import com.dat3m.dartagnan.expression.misc.NamedExpression;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.LeafExpression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.AggregateCmpExpr;
import com.dat3m.dartagnan.expression.aggregates.AggregateCmpOp;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.aggregates.ExtractExpr;
import com.dat3m.dartagnan.expression.aggregates.InsertExpr;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryExpr;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.memory.*;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.utils.IntegerHelper;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.FinalMemoryValue;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.ThreadCreation;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.task.exploration.Values.*;

/*
    Evaluates IR expressions over concrete values.
 */
public final class ConcreteEvaluator implements ExpressionVisitor<Object> {

    public interface Environment {
        Object getRegisterValue(Register register);

        BigInteger getAddress(MemoryObject memoryObject);

        default Object getFinalMemoryValue(FinalMemoryValue value) {
            throw new UnsupportedOperationException("Final memory values are only available at the end of executions.");
        }
    }

    private final Environment env;

    public ConcreteEvaluator(Environment env) {
        this.env = env;
    }

    public Object evaluate(Expression expr) {
        return expr.accept(this);
    }

    public boolean evaluateBoolean(Expression expr) {
        return asBoolean(evaluate(expr));
    }

    public BigInteger evaluateInteger(Expression expr) {
        return asInteger(evaluate(expr));
    }

    private BigInteger integer(Expression expr) {
        return asInteger(expr.accept(this));
    }

    // ------------------------------------------------------------------------------------------------
    // Leaves

    @Override
    public Object visitExpression(Expression expr) {
        throw new UnsupportedOperationException(String.format(
                "Exploration does not support expression '%s' of kind %s.", expr, expr.getClass().getSimpleName()));
    }

    @Override
    public Object visitLeafExpression(LeafExpression expr) {
        if (expr instanceof ThreadCreation.TIdExpr) {
            throw new UnsupportedOperationException("Unresolved thread id expression " + expr);
        }
        return visitExpression(expr);
    }

    @Override
    public Object visitIntLiteral(IntLiteral lit) {
        return Values.normalize(lit.getValue(), lit.getType().getBitWidth());
    }

    @Override
    public Object visitBoolLiteral(BoolLiteral lit) {
        return lit.getValue();
    }

    @Override
    public Object visitRegister(Register reg) {
        return env.getRegisterValue(reg);
    }

    @Override
    public Object visitMemoryObject(MemoryObject memObj) {
        return env.getAddress(memObj);
    }

    @Override
    public Object visitNamedExpression(NamedExpression expr) {
        // A named expression (e.g. a register in a litmus specification) evaluates to its operand.
        return expr.getOperand().accept(this);
    }

    @Override
    public Object visitNonDetValue(com.dat3m.dartagnan.program.misc.NonDetValue nonDet) {
        return Values.UNDEFINED;
    }

    @Override
    public Object visitFinalMemoryValue(FinalMemoryValue val) {
        return env.getFinalMemoryValue(val);
    }

    // ------------------------------------------------------------------------------------------------
    // Booleans

    @Override
    public Object visitBoolBinaryExpression(BoolBinaryExpr expr) {
        final boolean l = asBoolean(expr.getLeft().accept(this));
        return switch (expr.getKind()) {
            case AND -> l && asBoolean(expr.getRight().accept(this));
            case OR -> l || asBoolean(expr.getRight().accept(this));
            case IFF -> l == asBoolean(expr.getRight().accept(this));
        };
    }

    @Override
    public Object visitBoolUnaryExpression(BoolUnaryExpr expr) {
        return !asBoolean(expr.getOperand().accept(this));
    }

    @Override
    public Object visitITEExpression(ITEExpr expr) {
        return asBoolean(expr.getCondition().accept(this))
                ? expr.getTrueCase().accept(this)
                : expr.getFalseCase().accept(this);
    }

    // ------------------------------------------------------------------------------------------------
    // Integers

    @Override
    public Object visitIntBinaryExpression(IntBinaryExpr expr) {
        final int width = expr.getType().getBitWidth();
        final BigInteger l = integer(expr.getLeft());
        final BigInteger r = integer(expr.getRight());
        if (r.signum() == 0 && switch (expr.getKind()) {
            case DIV, UDIV, SREM, UREM -> true;
            default -> false;
        }) {
            // Division by zero: we follow the SMT-LIB semantics.
            return switch (expr.getKind()) {
                case UDIV -> Values.normalize(BigInteger.ONE.negate(), width);
                case DIV -> Values.normalize(
                        IntegerHelper.normalizeSigned(l, width).signum() < 0 ? BigInteger.ONE : BigInteger.ONE.negate(), width);
                default -> l;
            };
        }
        return Values.normalize(expr.getKind().apply(l, r, width), width);
    }

    @Override
    public Object visitIntCmpExpression(IntCmpExpr expr) {
        final int width = ((com.dat3m.dartagnan.expression.type.IntegerType) expr.getLeft().getType()).getBitWidth();
        final BigInteger l = integer(expr.getLeft());
        final BigInteger r = integer(expr.getRight());
        return switch (expr.getKind()) {
            case EQ -> IntegerHelper.equals(l, r, width);
            case NEQ -> !IntegerHelper.equals(l, r, width);
            case LT -> IntegerHelper.scmp(l, r, width) < 0;
            case LTE -> IntegerHelper.scmp(l, r, width) <= 0;
            case GT -> IntegerHelper.scmp(l, r, width) > 0;
            case GTE -> IntegerHelper.scmp(l, r, width) >= 0;
            case ULT -> IntegerHelper.ucmp(l, r, width) < 0;
            case ULTE -> IntegerHelper.ucmp(l, r, width) <= 0;
            case UGT -> IntegerHelper.ucmp(l, r, width) > 0;
            case UGTE -> IntegerHelper.ucmp(l, r, width) >= 0;
        };
    }

    @Override
    public Object visitIntUnaryExpression(IntUnaryExpr expr) {
        final int width = expr.getType().getBitWidth();
        final BigInteger v = integer(expr.getOperand());
        final BigInteger res = switch (expr.getKind()) {
            case MINUS -> IntegerHelper.neg(v, width);
            case NOT -> IntegerHelper.not(v, width);
            case CTPOP -> IntegerHelper.bitCount(v, width);
            case CTLZ -> IntegerHelper.ctlz(v, width);
            case CTTZ -> IntegerHelper.cttz(v, width);
        };
        return Values.normalize(res, width);
    }

    @Override
    public Object visitIntSizeCastExpression(IntSizeCast expr) {
        final int source = expr.getSourceType().getBitWidth();
        final int target = expr.getTargetType().getBitWidth();
        final BigInteger v = integer(expr.getOperand());
        final BigInteger res;
        if (target > source) {
            res = IntegerHelper.extend(v, source, target, expr.preservesSign());
        } else {
            res = IntegerHelper.truncate(v, target);
        }
        return Values.normalize(res, target);
    }

    @Override
    public Object visitIntExtract(IntExtract expr) {
        final BigInteger v = integer(expr.getOperand());
        return extractBits(v, expr.getLowBit(), expr.getHighBit());
    }

    @Override
    public Object visitIntConcat(IntConcat expr) {
        return concat(expr.getOperands());
    }

    private static BigInteger extractBits(BigInteger v, int low, int high) {
        final int size = high - low + 1;
        return v.shiftRight(low).and(BigInteger.ONE.shiftLeft(size).subtract(BigInteger.ONE));
    }

    private BigInteger concat(List<? extends Expression> operands) {
        // The first operand provides the lowest bits.
        BigInteger result = BigInteger.ZERO;
        int offset = 0;
        for (Expression op : operands) {
            final int width = bitWidth(op.getType());
            result = result.or(Values.normalize(integer(op), width).shiftLeft(offset));
            offset += width;
        }
        return result;
    }

    // ------------------------------------------------------------------------------------------------
    // Memory values (we only support integer-like memory values)

    @Override
    public Object visitToMemoryCastExpression(ToMemoryCast expr) {
        final Object v = expr.getOperand().accept(this);
        if (v instanceof List<?>) {
            throw new UnsupportedOperationException("Exploration does not support aggregates in memory: " + expr);
        }
        return Values.normalize(asInteger(v), expr.getTargetType().getBitWidth());
    }

    @Override
    public Object visitFromMemoryCastExpression(FromMemoryCast expr) {
        return convert(expr.getOperand().accept(this), expr.getTargetType());
    }

    @Override
    public Object visitMemoryConcatExpression(MemoryConcat expr) {
        return concat(expr.getOperands());
    }

    @Override
    public Object visitMemoryExtractExpression(MemoryExtract expr) {
        return extractBits(integer(expr.getOperand()), expr.getLowBit(), expr.getHighBit());
    }

    @Override
    public Object visitMemoryEqualExpression(MemoryEqualExpr expr) {
        return integer(expr.getLeft()).equals(integer(expr.getRight()));
    }

    @Override
    public Object visitMemoryExtendExpression(MemoryExtend expr) {
        return integer(expr.getOperand());
    }

    // ------------------------------------------------------------------------------------------------
    // Aggregates

    @Override
    public Object visitConstructExpression(ConstructExpr construct) {
        final List<Object> values = new ArrayList<>();
        for (Expression op : construct.getOperands()) {
            values.add(op.accept(this));
        }
        return List.copyOf(values);
    }

    @Override
    public Object visitExtractExpression(ExtractExpr extract) {
        Object value = extract.getOperand().accept(this);
        for (int index : extract.getIndices()) {
            value = ((List<?>) value).get(index);
        }
        return value;
    }

    @Override
    public Object visitInsertExpression(InsertExpr insert) {
        final Object aggregate = insert.getAggregate().accept(this);
        final Object value = insert.getInsertedValue().accept(this);
        return insertAt(aggregate, insert.getIndices(), 0, value);
    }

    private static Object insertAt(Object aggregate, List<Integer> indices, int depth, Object value) {
        if (depth == indices.size()) {
            return value;
        }
        final List<Object> copy = new ArrayList<>((List<?>) aggregate);
        final int index = indices.get(depth);
        copy.set(index, insertAt(copy.get(index), indices, depth + 1, value));
        return List.copyOf(copy);
    }

    @Override
    public Object visitAggregateCmpExpression(AggregateCmpExpr expr) {
        final boolean equal = expr.getLeft().accept(this).equals(expr.getRight().accept(this));
        return expr.getKind() == AggregateCmpOp.EQ ? equal : !equal;
    }

    // ------------------------------------------------------------------------------------------------

    public static Object zeroOf(Type type) {
        return type instanceof BooleanType ? Boolean.FALSE : zero(type);
    }
}
