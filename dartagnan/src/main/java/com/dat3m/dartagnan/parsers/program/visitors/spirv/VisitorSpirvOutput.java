package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.LiteralExpressionBase;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.dat3m.dartagnan.expression.integers.IntCmpOp.*;
import static com.dat3m.dartagnan.program.Program.SpecificationType.*;

public class VisitorSpirvOutput extends SpirvBaseVisitor<Expression> {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final Map<Location, Type> locationTypes = new HashMap<>();
    private final ProgramBuilder builder;
    private Program.SpecificationType type;
    private Expression assertion;

    public VisitorSpirvOutput(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Expression visitSpvHeaders(SpirvParser.SpvHeadersContext ctx) {
        for (SpirvParser.SpvHeaderContext header : ctx.spvHeader()) {
            if (header.outputHeader() != null && header.outputHeader().assertionList() != null) {
                visitAssertionList(header.outputHeader().assertionList());
            }
        }
        if (type == null) {
            type = FORALL;
            assertion = ExpressionFactory.getInstance().makeTrue();
        }
        builder.setSpecification(type, assertion);
        return null;
    }

    @Override
    public Expression visitAssertionList(SpirvParser.AssertionListContext ctx) {
        Program.SpecificationType parsedType = parseType(ctx);
        Expression parsedAssertion = ctx.assertion().accept(this);
        appendAssertion(parsedType, parsedAssertion);
        return null;
    }

    @Override
    public Expression visitAssertionParenthesis(SpirvParser.AssertionParenthesisContext ctx) {
        return ctx.assertion().accept(this);
    }

    @Override
    public Expression visitAssertionNot(SpirvParser.AssertionNotContext ctx) {
        return expressions.makeNot(ctx.assertion().accept(this));
    }

    @Override
    public Expression visitAssertionAnd(SpirvParser.AssertionAndContext ctx) {
        return expressions.makeAnd(ctx.assertion(0).accept(this), ctx.assertion(1).accept(this));
    }

    @Override
    public Expression visitAssertionOr(SpirvParser.AssertionOrContext ctx) {
        return expressions.makeOr(ctx.assertion(0).accept(this), ctx.assertion(1).accept(this));
    }

    @Override
    public Expression visitAssertionBasic(SpirvParser.AssertionBasicContext ctx) {
        Expression expr1 = ctx.assertionValue(0).accept(this);
        Expression expr2 = ctx.assertionValue(1).accept(this);
        IntCmpOp op = parseOperand(ctx.assertionCompare());
        expr1 = normalize(expr1, expr2);
        expr2 = normalize(expr2, expr1);
        return expressions.makeBinary(expr1, op, expr2);
    }

    @Override
    public Expression visitAssertionValue(SpirvParser.AssertionValueContext ctx) {
        if (ctx.initBaseValue() != null) {
            return expressions.parseValue(ctx.initBaseValue().getText(), types.getArchType());
        }
        String name = ctx.varName().getText();
        ScopedPointerVariable base = (ScopedPointerVariable) builder.getExpression(name);
        if (base != null) {
            List<Integer> indexes = ctx.indexValue().stream()
                    .map(c -> Integer.parseInt(c.ModeHeader_PositiveInteger().getText()))
                    .toList();
            return createLocation(base, indexes);
        }
        throw new ParsingException("Uninitialized location %s", name);
    }

    private void appendAssertion(Program.SpecificationType newType, Expression expression) {
        if (assertion == null) {
            type = newType;
            assertion = expression;
        } else if (newType.equals(type)) {
            if (type.equals(FORALL)) {
                assertion = ExpressionFactory.getInstance().makeAnd(assertion, expression);
            } else if (type.equals(NOT_EXISTS)) {
                assertion = ExpressionFactory.getInstance().makeOr(assertion, expression);
            } else {
                throw new ParsingException("Multiline assertion is not supported for type " + newType);
            }
        } else {
            throw new ParsingException("Mixed assertion type is not supported");
        }
    }

    private Expression normalize(Expression target, Expression other) {
        Type targetType = target instanceof Location ? locationTypes.get(target) : target.getType();
        Type otherType = other instanceof Location ? locationTypes.get(other) : other.getType();
        if (targetType.equals(otherType)) {
            return target;
        }
        if (target instanceof Location && other instanceof LiteralExpressionBase<?>) {
            return target;
        }
        if (target instanceof IntLiteral iValue && other instanceof Location) {
            int size = types.getMemorySizeInBits(otherType);
            IntegerType newType = types.getIntegerType(size);
            return new IntLiteral(newType, iValue.getValue());
        }
        throw new ParsingException("Mismatching type assertions are not supported for %s and %s",
                target.getClass().getSimpleName(), other.getClass().getSimpleName());
    }

    private Program.SpecificationType parseType(SpirvParser.AssertionListContext ctx) {
        if (ctx.ModeHeader_AssertionNot() != null) {
            return NOT_EXISTS;
        }
        if (ctx.ModeHeader_AssertionExists() != null) {
            return EXISTS;
        }
        if (ctx.ModeHeader_AssertionForall() != null) {
            return FORALL;
        }
        throw new ParsingException("Unrecognised assertion type");
    }

    private IntCmpOp parseOperand(SpirvParser.AssertionCompareContext ctx) {
        if (ctx.ModeHeader_EqualEqual() != null) {
            return EQ;
        }
        if (ctx.ModeHeader_NotEqual() != null) {
            return NEQ;
        }
        if (ctx.ModeHeader_Less() != null) {
            return LT;
        }
        if (ctx.ModeHeader_LessEqual() != null) {
            return LTE;
        }
        if (ctx.ModeHeader_Greater() != null) {
            return GT;
        }
        if (ctx.ModeHeader_GreaterEqual() != null) {
            return GTE;
        }
        throw new ParsingException("Unrecognised comparison operator");
    }

    private Location createLocation(ScopedPointerVariable base, List<Integer> indexes) {
        Type newType = base.getInnerType();
        int offset = 0;
        for (int index : indexes) {
            validateIndex(base.getId(), newType, index);
            if (newType instanceof ArrayType arrayType) {
                Type elementType = arrayType.getElementType();
                int byteWidth = types.getMemorySizeInBytes(elementType);
                offset += index * byteWidth;
                newType = elementType;
            } else if (newType instanceof AggregateType aggregateType) {
                for (int i = 0; i < index; i++) {
                    offset += types.getMemorySizeInBytes(aggregateType.getDirectFields().get(i));
                }
                newType = aggregateType.getDirectFields().get(index);
            }
        }
        if (newType instanceof ArrayType || newType instanceof AggregateType) {
            throw new ParsingException("Illegal assertion for variable '%s', index not deep enough", base.getId());
        }
        String offsetName = indexes.isEmpty() ? base.getId() :
                base.getId() + "[" + String.join("][", indexes.stream().map(Object::toString).toArray(String[]::new)) + "]";
        Location location = new Location(offsetName, newType, base.getAddress(), offset);
        locationTypes.put(location, newType);
        return location;
    }

    private void validateIndex(String name, Type type, int index) {
        if (type instanceof ArrayType arrayType) {
            if (index >= arrayType.getNumElements()) {
                throw new ParsingException("Illegal assertion for variable '%s', index out of bounds", name);
            }
        } else if (type instanceof AggregateType aggregateType) {
            if (index >= aggregateType.getDirectFields().size()) {
                throw new ParsingException("Illegal assertion for variable '%s', index out of bounds", name);
            }
        } else {
            throw new ParsingException("Illegal assertion for variable '%s', index too deep", name);
        }
    }
}