package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
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

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class VisitorOpsBits extends SpirvBaseVisitor<Event> {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final ProgramBuilder builder;

    public VisitorOpsBits(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Event visitOpShiftLeftLogical(SpirvParser.OpShiftLeftLogicalContext ctx) {
        return visitExpression(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.base().getText(), ctx.shift().getText(), IntBinaryOp.LSHIFT);
    }

    @Override
    public Event visitOpShiftRightLogical(SpirvParser.OpShiftRightLogicalContext ctx) {
        return visitExpression(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.base().getText(), ctx.shift().getText(), IntBinaryOp.RSHIFT);
    }

    @Override
    public Event visitOpShiftRightArithmetic(SpirvParser.OpShiftRightArithmeticContext ctx) {
        return visitExpression(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.base().getText(), ctx.shift().getText(), IntBinaryOp.ARSHIFT);
    }

    @Override
    public Event visitOpBitwiseAnd(SpirvParser.OpBitwiseAndContext ctx) {
        return visitExpression(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.operand1().getText(), ctx.operand2().getText(), IntBinaryOp.AND);
    }

    @Override
    public Event visitOpBitwiseOr(SpirvParser.OpBitwiseOrContext ctx) {
        return visitExpression(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.operand1().getText(), ctx.operand2().getText(), IntBinaryOp.OR);
    }

    @Override
    public Event visitOpBitwiseXor(SpirvParser.OpBitwiseXorContext ctx) {
        return visitExpression(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.operand1().getText(), ctx.operand2().getText(), IntBinaryOp.XOR);
    }

    private Event visitExpression(String id, String typeId, String op1Id, String op2Id, IntBinaryOp op) {
        Type type = builder.getType(typeId);
        Expression op1 = builder.getExpression(op1Id);
        Expression op2 = builder.getExpression(op2Id);
        if (type.equals(op1.getType()) && type.equals(op2.getType())) {
            if (!(type instanceof ArrayType aType) || aType.hasKnownNumElements()) {
                Expression expression = createResultExpression(id, type, op1, op2, op);
                Register register = builder.addRegister(id, typeId);
                Local event = EventFactory.newLocal(register, expression);
                return builder.addEvent(event);
            }
            throw new ParsingException("Illegal definition for '%s', vector expressions must have fixed size", id);
        }
        throw new ParsingException("Illegal definition for '%s', result type doesn't match operand types", id);
    }

    private Expression createResultExpression(String id, Type type, Expression op1, Expression op2, IntBinaryOp op) {
        if (type instanceof BooleanType || type instanceof IntegerType || type instanceof FloatType) {
            return expressions.makeBinary(op1, op, op2);
        }
        if (type instanceof ArrayType aType && op1 instanceof ConstructExpr cop1 && op2 instanceof ConstructExpr cop2) {
            List<Expression> elements = new ArrayList<>();
            for (int i = 0; i < aType.getNumElements(); i++) {
                Expression elementOp1 = cop1.getOperands().get(i);
                Expression elementOp2 = cop2.getOperands().get(i);
                elements.add(expressions.makeBinary(elementOp1, op, elementOp2));
            }
            return expressions.makeConstruct(type, elements);
        }
        throw new ParsingException("Illegal result type in definition of '%s'", id);
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpShiftLeftLogical",
                "OpShiftRightLogical",
                "opShiftRightArithmetic",
                "OpBitwiseAnd",
                "OpBitwiseOr",
                "OpBitwiseXor"
        );
    }
}
