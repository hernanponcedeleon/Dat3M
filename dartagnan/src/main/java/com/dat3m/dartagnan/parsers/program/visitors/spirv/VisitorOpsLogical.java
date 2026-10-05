package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryOp;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryOp;
import com.dat3m.dartagnan.expression.floats.FloatCmpOp;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.FloatType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Local;

import java.util.List;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.expression.utils.ExpressionHelper.isScalar;

public class VisitorOpsLogical extends SpirvBaseVisitor<Event> {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final ProgramBuilder builder;

    public VisitorOpsLogical(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Event visitOpLogicalOr(SpirvParser.OpLogicalOrContext ctx) {
        return visitLogicalBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), BoolBinaryOp.OR);
    }

    @Override
    public Event visitOpLogicalAnd(SpirvParser.OpLogicalAndContext ctx) {
        return visitLogicalBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), BoolBinaryOp.AND);
    }

    @Override
    public Event visitOpLogicalNot(SpirvParser.OpLogicalNotContext ctx) {
        return visitLogicalUnExpression(ctx.idResult(), ctx.idResultType(), ctx.operand(), BoolUnaryOp.NOT);
    }

    @Override
    public Event visitOpSelect(SpirvParser.OpSelectContext ctx) {
        String id = ctx.idResult().getText();
        Expression cond = getOperandBoolean(id, ctx.condition().getText());
        Expression op1 = builder.getExpression(ctx.object1().getText());
        Expression op2 = builder.getExpression(ctx.object2().getText());
        Type type = builder.getType(ctx.idResultType().getText());
        Register register = builder.addRegister(id, ctx.idResultType().getText());
        if (!op1.getType().equals(type) || !op2.getType().equals(type)) {
            throw new ParsingException("Illegal definition for '%s', " +
                    "expected two operands type '%s but received '%s' and '%s'",
                    id, type, op1.getType(), op2.getType());
        }
        if (isScalar(op1.getType())) {
            return builder.addEvent(EventFactory.newLocal(register, expressions.makeITE(cond, op1, op2)));
        }
        throw new ParsingException("Illegal definition for '%s', " +
                "operands must be scalar values", id);
    }

    @Override
    public Event visitOpIEqual(SpirvParser.OpIEqualContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.EQ);
    }

    @Override
    public Event visitOpINotEqual(SpirvParser.OpINotEqualContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.NEQ);
    }

    @Override
    public Event visitOpUGreaterThan(SpirvParser.OpUGreaterThanContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.UGT);
    }

    @Override
    public Event visitOpSGreaterThan(SpirvParser.OpSGreaterThanContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.GT);
    }

    @Override
    public Event visitOpUGreaterThanEqual(SpirvParser.OpUGreaterThanEqualContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.UGTE);
    }

    @Override
    public Event visitOpSGreaterThanEqual(SpirvParser.OpSGreaterThanEqualContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.GTE);
    }

    @Override
    public Event visitOpULessThan(SpirvParser.OpULessThanContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.ULT);
    }

    @Override
    public Event visitOpSLessThan(SpirvParser.OpSLessThanContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.LT);
    }

    @Override
    public Event visitOpULessThanEqual(SpirvParser.OpULessThanEqualContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.ULTE);
    }

    @Override
    public Event visitOpSLessThanEqual(SpirvParser.OpSLessThanEqualContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), IntCmpOp.LTE);
    }

    @Override
    public Event visitOpFOrdEqual(SpirvParser.OpFOrdEqualContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatCmpOp.OEQ);
    }

    @Override
    public Event visitOpFUnordEqual(SpirvParser.OpFUnordEqualContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatCmpOp.UEQ);
    }

    @Override
    public Event visitOpFOrdNotEqual(SpirvParser.OpFOrdNotEqualContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatCmpOp.ONEQ);
    }

    @Override
    public Event visitOpFUnordNotEqual(SpirvParser.OpFUnordNotEqualContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatCmpOp.UNEQ);
    }

    @Override
    public Event visitOpFOrdLessThan(SpirvParser.OpFOrdLessThanContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatCmpOp.OLT);
    }

    @Override
    public Event visitOpFUnordLessThan(SpirvParser.OpFUnordLessThanContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatCmpOp.ULT);
    }

    @Override
    public Event visitOpFOrdGreaterThan(SpirvParser.OpFOrdGreaterThanContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatCmpOp.OGT);
    }

    @Override
    public Event visitOpFUnordGreaterThan(SpirvParser.OpFUnordGreaterThanContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatCmpOp.UGT);
    }

    @Override
    public Event visitOpFOrdLessThanEqual(SpirvParser.OpFOrdLessThanEqualContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatCmpOp.OLTE);
    }

    @Override
    public Event visitOpFUnordLessThanEqual(SpirvParser.OpFUnordLessThanEqualContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatCmpOp.ULTE);
    }

    @Override
    public Event visitOpFOrdGreaterThanEqual(SpirvParser.OpFOrdGreaterThanEqualContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatCmpOp.OGTE);
    }

    @Override
    public Event visitOpFUnordGreaterThanEqual(SpirvParser.OpFUnordGreaterThanEqualContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatCmpOp.UGTE);
    }

    private Event visitLogicalUnExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.OperandContext opCtx,
            BoolUnaryOp op) {
        String id = idCtx.getText();
        return forType(id, typeCtx.getText(), bType -> {
            Expression operand = getOperandBoolean(id, opCtx.getText());
            return expressions.makeUnary(op, operand);
        });
    }

    private Event visitLogicalBinExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.Operand1Context op1Ctx,
            SpirvParser.Operand2Context op2Ctx,
            BoolBinaryOp op) {
        String id = idCtx.getText();
        return forType(id, typeCtx.getText(), bType -> {
            Expression op1 = getOperandBoolean(id, op1Ctx.getText());
            Expression op2 = getOperandBoolean(id, op2Ctx.getText());
            return expressions.makeBinary(op1, op, op2);
        });
    }

    private Event visitIntegerBinExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.Operand1Context op1Ctx,
            SpirvParser.Operand2Context op2Ctx,
            IntCmpOp op) {
        String id = idCtx.getText();
        return forType(id, typeCtx.getText(), bType -> {
            Expression op1 = getOperandInteger(id, op1Ctx.getText());
            Expression op2 = getOperandInteger(id, op2Ctx.getText());
            if (op1.getType().equals(op2.getType())) {
                return expressions.makeIntCmp(op1, op, op2);
            }
            throw new ParsingException("Illegal definition for '%s', " +
                    "operands have different types: '%s' is '%s' and '%s' is '%s'",
                    id, op1Ctx.getText(), op1.getType(), op2Ctx.getText(), op2.getType());
        });
    }

    private Event visitFloatBinExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.Operand1Context op1Ctx,
            SpirvParser.Operand2Context op2Ctx,
            FloatCmpOp op
    ) {
        String id = idCtx.getText();
        Type resultType = builder.getType(typeCtx.getText());
        Expression op1 = builder.getExpression(op1Ctx.getText());
        Expression op2 = builder.getExpression(op2Ctx.getText());
        if (!op1.getType().equals(op2.getType())) {
            throw new ParsingException("Illegal floating-point comparison for '%s': operand types must match", id);
        }

        Expression result;
        if (resultType instanceof BooleanType && op1.getType() instanceof FloatType) {
            result = expressions.makeFloatCmp(op1, op, op2);
        } else if (resultType instanceof ArrayType resultArray
                && resultArray.hasKnownNumElements()
                && resultArray.getElementType() instanceof BooleanType
                && op1.getType() instanceof ArrayType operandArray
                && operandArray.hasKnownNumElements()
                && operandArray.getElementType() instanceof FloatType
                && resultArray.getNumElements() == operandArray.getNumElements()) {
            List<Expression> elements = IntStream.range(0, resultArray.getNumElements())
                    .mapToObj(index -> expressions.makeFloatCmp(
                            getElement(op1, index), op, getElement(op2, index)))
                    .toList();
            result = expressions.makeArray(resultArray, elements);
        } else {
            throw new ParsingException("Illegal floating-point comparison for '%s': incompatible result and operand types", id);
        }

        Register register = builder.addRegister(id, resultType);
        return builder.addEvent(EventFactory.newLocal(register, result));
    }

    private Expression getElement(Expression expression, int index) {
        return expression instanceof ConstructExpr
                ? expression.getOperands().get(index)
                : expressions.makeExtract(expression, index);
    }

    private Event forType(String id, String typeId, Function<BooleanType, Expression> f) {
        Type type = builder.getType(typeId);
        Register register = builder.addRegister(id, typeId);
        if (type instanceof BooleanType bType) {
            Local event = EventFactory.newLocal(register, f.apply(bType));
            return builder.addEvent(event);
        }
        if (type instanceof ArrayType) {
            throw new ParsingException("Unsupported result type for '%s', " +
                    "vector types are not supported", id);
        }
        throw new ParsingException("Illegal result type for '%s'", id);
    }

    private Expression getOperandBoolean(String id, String opId) {
        Expression op = builder.getExpression(opId);
        if (op.getType() instanceof BooleanType) {
            return op;
        }
        throw new ParsingException("Illegal definition for '%s', " +
                "operand '%s' must be a boolean", id, opId);
    }

    private Expression getOperandInteger(String id, String opId) {
        Expression op = builder.getExpression(opId);
        if (op.getType() instanceof IntegerType) {
            return op;
        }
        throw new ParsingException("Illegal definition for '%s', " +
                "operand '%s' must be an integer", id, opId);
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpLogicalOr",
                "OpLogicalAnd",
                "OpLogicalNot",
                "OpSelect",
                "OpIEqual",
                "OpINotEqual",
                "OpUGreaterThan",
                "OpSGreaterThan",
                "OpUGreaterThanEqual",
                "OpSGreaterThanEqual",
                "OpULessThan",
                "OpSLessThan",
                "OpULessThanEqual",
                "OpSLessThanEqual",
                "OpFOrdEqual",
                "OpFUnordEqual",
                "OpFOrdNotEqual",
                "OpFUnordNotEqual",
                "OpFOrdLessThan",
                "OpFUnordLessThan",
                "OpFOrdGreaterThan",
                "OpFUnordGreaterThan",
                "OpFOrdLessThanEqual",
                "OpFUnordLessThanEqual",
                "OpFOrdGreaterThanEqual",
                "OpFUnordGreaterThanEqual"
        );
    }
}
