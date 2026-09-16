package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.floats.FloatBinaryOp;
import com.dat3m.dartagnan.expression.floats.FloatUnaryOp;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntUnaryOp;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.FloatType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTypes;

import java.util.List;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.*;
import static com.dat3m.dartagnan.expression.integers.IntUnaryOp.MINUS;

public class VisitorOpsArithmetic extends SpirvBaseVisitor<Event> {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final ProgramBuilder builder;

    public VisitorOpsArithmetic(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Event visitOpSNegate(SpirvParser.OpSNegateContext ctx) {
        return visitIntegerUnExpression(ctx.idResult(), ctx.idResultType(), ctx.operand(), MINUS);
    }

    @Override
    public Event visitOpFNegate(SpirvParser.OpFNegateContext ctx) {
        return visitFloatUnExpression(ctx.idResult(), ctx.idResultType(), ctx.operand(), FloatUnaryOp.NEG);
    }

    @Override
    public Event visitOpIAdd(SpirvParser.OpIAddContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), ADD);
    }

    @Override
    public Event visitOpFAdd(SpirvParser.OpFAddContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatBinaryOp.FADD);
    }

    @Override
    public Event visitOpISub(SpirvParser.OpISubContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), SUB);
    }

    @Override
    public Event visitOpFSub(SpirvParser.OpFSubContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatBinaryOp.FSUB);
    }

    @Override
    public Event visitOpIMul(SpirvParser.OpIMulContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), MUL);
    }

    @Override
    public Event visitOpFMul(SpirvParser.OpFMulContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatBinaryOp.FMUL);
    }

    @Override
    public Event visitOpUDiv(SpirvParser.OpUDivContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), UDIV);
    }

    @Override
    public Event visitOpSDiv(SpirvParser.OpSDivContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), DIV);
    }

    @Override
    public Event visitOpFDiv(SpirvParser.OpFDivContext ctx) {
        return visitFloatBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), FloatBinaryOp.FDIV);
    }

    @Override
    public Event visitOpUMod(SpirvParser.OpUModContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), UREM);
    }

    @Override
    public Event visitOpSRem(SpirvParser.OpSRemContext ctx) {
        return visitIntegerBinExpression(ctx.idResult(), ctx.idResultType(), ctx.operand1(), ctx.operand2(), SREM);
    }

    private Event visitIntegerUnExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.OperandContext opCtx,
            IntUnaryOp op
    ) {
        String id = idCtx.getText();
        return forType(id, typeCtx.getText(), iType -> {
            Expression left = builder.getExpression(opCtx.getText());
            if (iType.equals(left.getType())) {
                return expressions.makeUnary(op, left);
            }
            throw new ParsingException("Illegal definition for '%s', " +
                    "types do not match: '%s' is '%s' and '%s' is '%s'",
                    id, opCtx.getText(), left.getType(), typeCtx.getText(), iType);
        });
    }

    private Event visitFloatUnExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.OperandContext opCtx,
            FloatUnaryOp op
    ) {
        String id = idCtx.getText();
        Expression operand = builder.getExpression(opCtx.getText());
        return forFloatType(id, typeCtx.getText(), List.of(operand),
                operands -> expressions.makeFloatUnary(op, operands.get(0)));
    }

    private Event visitFloatBinExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.Operand1Context op1Ctx,
            SpirvParser.Operand2Context op2Ctx,
            FloatBinaryOp op
    ) {
        String id = idCtx.getText();
        Expression op1 = builder.getExpression(op1Ctx.getText());
        Expression op2 = builder.getExpression(op2Ctx.getText());
        return forFloatType(id, typeCtx.getText(), List.of(op1, op2),
                operands -> expressions.makeFloatBinary(operands.get(0), op, operands.get(1)));
    }

    private Event forFloatType(
            String id,
            String typeId,
            List<Expression> operands,
            Function<List<Expression>, Expression> expressionBuilder
    ) {
        Type type = builder.getType(typeId);
        validateFloatOperands(id, type, operands);
        Expression result;
        if (type instanceof FloatType) {
            result = expressionBuilder.apply(operands);
        } else {
            ArrayType arrayType = (ArrayType) type;
            List<Expression> elements = IntStream.range(0, arrayType.getNumElements())
                    .mapToObj(index -> expressionBuilder.apply(operands.stream()
                            .map(operand -> getElement(operand, index))
                            .toList()))
                    .toList();
            result = expressions.makeArray(arrayType, elements);
        }
        Register register = builder.addRegister(id, type);
        return builder.addEvent(EventFactory.newLocal(register, result));
    }

    private void validateFloatOperands(String id, Type resultType, List<Expression> operands) {
        boolean isFloatScalar = resultType instanceof FloatType;
        boolean isFloatVector = resultType instanceof ArrayType arrayType
                && arrayType.hasKnownNumElements()
                && arrayType.getElementType() instanceof FloatType;
        if ((!isFloatScalar && !isFloatVector)
                || operands.stream().anyMatch(operand -> !resultType.equals(operand.getType()))) {
            throw new ParsingException("Illegal floating-point definition for '%s': result and operand types must match", id);
        }
    }

    private Expression getElement(Expression expression, int index) {
        return expression instanceof ConstructExpr
                ? expression.getOperands().get(index)
                : expressions.makeExtract(expression, index);
    }

    private Event visitIntegerBinExpression(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.Operand1Context op1Ctx,
            SpirvParser.Operand2Context op2Ctx,
            IntBinaryOp op
    ) {
        String id = idCtx.getText();
        String typeId = typeCtx.getText();
        Type type = builder.getType(typeId);
        Expression op1 = builder.getExpression(op1Ctx.getText());
        Expression op2 = builder.getExpression(op2Ctx.getText());
        if (type.equals(op1.getType()) && op1.getType().equals(op2.getType())) {
            if (!(type instanceof ArrayType aType) || aType.hasKnownNumElements()) {
                Expression expression = HelperTypes.createResultExpression(id, type, op1, op2, op);
                Register register = builder.addRegister(id, typeId);
                Local event = EventFactory.newLocal(register, expression);
                return builder.addEvent(event);
            }
            throw new ParsingException("Illegal definition for '%s', vector expressions must have fixed size", id);
        }
        throw new ParsingException("Illegal definition for '%s', " +
                    "types do not match: '%s' is '%s', '%s' is '%s' and '%s' is '%s'",
                    id, op1Ctx.getText(), op1.getType(), op2Ctx.getText(), op2.getType(),
                    typeCtx.getText(), type);
    }

    private Event forType(String id, String typeId, Function<IntegerType, Expression> f) {
        Type type = builder.getType(typeId);
        if (type instanceof IntegerType iType) {
            Register register = builder.addRegister(id, typeId);
            Local event = EventFactory.newLocal(register, f.apply(iType));
            return builder.addEvent(event);
        }
        if (type instanceof ArrayType) {
            throw new ParsingException("Unsupported result type for '%s', " +
                    "vector types are not supported", id);
        }
        throw new ParsingException("Illegal result type for '%s'", id);
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpSNegate",
                "OpFNegate",
                "OpIAdd",
                "OpFAdd",
                "OpISub",
                "OpFSub",
                "OpIMul",
                "OpFMul",
                "OpUDiv",
                "OpSDiv",
                "OpFDiv",
                "OpUMod",
                "OpSRem"
        );
    }
}
