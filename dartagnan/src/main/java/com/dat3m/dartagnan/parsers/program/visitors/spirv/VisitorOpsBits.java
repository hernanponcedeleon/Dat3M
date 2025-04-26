package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTypes;

import java.util.Set;

public class VisitorOpsBits extends SpirvBaseVisitor<Event> {

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
                Expression expression = HelperTypes.createResultExpression(id, type, op1, op2, op);
                Register register = builder.addRegister(id, typeId);
                Local event = EventFactory.newLocal(register, expression);
                return builder.addEvent(event);
            }
            throw new ParsingException("Illegal definition for '%s', vector expressions must have fixed size", id);
        }
        throw new ParsingException("Illegal definition for '%s', result type doesn't match operand types", id);
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
