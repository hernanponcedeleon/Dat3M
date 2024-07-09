package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.LiteralExpressionBase;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.specification.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.dat3m.dartagnan.expression.integers.IntCmpOp.*;
import static com.dat3m.dartagnan.program.specification.AbstractAssert.ASSERT_TYPE_FORALL;
import static com.dat3m.dartagnan.program.specification.AbstractAssert.ASSERT_TYPE_NOT_EXISTS;

public class VisitorSpirvOutput extends SpirvBaseVisitor<AbstractAssert> {

    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();
    private final Map<Location, Type> locationTypes = new HashMap<>();
    private final ProgramBuilderSpv builder;

    public VisitorSpirvOutput(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public AbstractAssert visitAssertionList(SpirvParser.AssertionListContext ctx) {
        AbstractAssert ast = ctx.assertion().accept(this);
        if (ctx.ModeHeader_AssertionNot() != null) {
            ast.setType(ASSERT_TYPE_NOT_EXISTS);
        } else if (ctx.ModeHeader_AssertionExists() != null) {
            ast.setType(AbstractAssert.ASSERT_TYPE_EXISTS);
        } else if (ctx.ModeHeader_AssertionForall() != null) {
            ast.setType(ASSERT_TYPE_FORALL);
        } else {
            throw new ParsingException("Unrecognised assertion type");
        }
        builder.addAssertion(ast);
        return null;
    }

    @Override
    public AbstractAssert visitAssertion(SpirvParser.AssertionContext ctx) {
        if (ctx.ModeHeader_LPar() != null) {
            if (ctx.assertionValue() != null) {
                return ctx.assertionValue().getText().equals("0") ?
                        new AssertNot(new AssertTrue()) : new AssertTrue();
            } else {
                return ctx.assertion(0).accept(this);
            }
        } else if (ctx.ModeHeader_AssertionAnd() != null) {
            return new AssertCompositeAnd(ctx.assertion(0).accept(this),
                    ctx.assertion(1).accept(this));
        } else if (ctx.ModeHeader_AssertionOr() != null) {
            return new AssertCompositeOr(ctx.assertion(0).accept(this),
                    ctx.assertion(1).accept(this));
        } else if (ctx.assertionBasic() != null) {
            return ctx.assertionBasic().accept(this);
        } else {
            throw new ParsingException("Unrecognised assertion type");
        }
    }

    @Override
    public AbstractAssert visitAssertionBasic(SpirvParser.AssertionBasicContext ctx) {
        Expression expr1 = acceptAssertionValue(ctx.assertionValue(0));
        Expression expr2 = acceptAssertionValue(ctx.assertionValue(1));
        expr1 = normalize(expr1, expr2);
        expr2 = normalize(expr2, expr1);
        if (ctx.assertionCompare().ModeHeader_EqualEqual() != null) {
            return new AssertBasic(expr1, EQ, expr2);
        } else if (ctx.assertionCompare().ModeHeader_NotEqual() != null) {
            return new AssertBasic(expr1, NEQ, expr2);
        } else if (ctx.assertionCompare().ModeHeader_Less() != null) {
            return new AssertBasic(expr1, LT, expr2);
        } else if (ctx.assertionCompare().ModeHeader_LessEqual() != null) {
            return new AssertBasic(expr1, LTE, expr2);
        } else if (ctx.assertionCompare().ModeHeader_Greater() != null) {
            return new AssertBasic(expr1, GT, expr2);
        } else if (ctx.assertionCompare().ModeHeader_GreaterEqual() != null) {
            return new AssertBasic(expr1, GTE, expr2);
        } else {
            throw new ParsingException("Unrecognised comparison operator");
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
            int size = TypeFactory.getInstance().getMemorySizeInBits(otherType);
            IntegerType type = TypeFactory.getInstance().getIntegerType(size);
            return new IntLiteral(type, iValue.getValue());
        }
        throw new ParsingException("Mismatching type assertions are not supported for %s and %s",
                target.getClass().getSimpleName(), other.getClass().getSimpleName());
    }

    private Integer acceptIndexValue(SpirvParser.IndexValueContext ctx) {
        return Integer.parseInt(ctx.ModeHeader_PositiveInteger().getText());
    }

    private Expression acceptAssertionValue(SpirvParser.AssertionValueContext ctx) {
        if (ctx.initBaseValue() != null) {
            return EXPR_FACTORY.parseValue(ctx.initBaseValue().getText(), TYPE_FACTORY.getArchType());
        }
        String name = ctx.varName().getText();
        ScopedPointerVariable base = (ScopedPointerVariable) builder.getExpression(name);
        if (base != null) {
            List<Integer> indexes = ctx.indexValue().stream().map(this::acceptIndexValue).toList();
            return createLocation(base, indexes);
        }
        throw new ParsingException("Uninitialized location %s", name);
    }

    private Location createLocation(ScopedPointerVariable base, List<Integer> indexes) {
        Type type = base.getInnerType();
        int offset = 0;
        for (int index : indexes) {
            validateIndex(base.getId(), type, index);
            if (type instanceof ArrayType arrayType) {
                Type elementType = arrayType.getElementType();
                int byteWidth = TYPE_FACTORY.getMemorySizeInBytes(elementType);
                offset += index * byteWidth;
                type = elementType;
            } else if (type instanceof AggregateType aggregateType) {
                for (int i = 0; i < index; i++) {
                    offset += TYPE_FACTORY.getMemorySizeInBytes(aggregateType.getDirectFields().get(i));
                }
                type = aggregateType.getDirectFields().get(index);
            }
        }
        if (type instanceof ArrayType || type instanceof AggregateType) {
            throw new ParsingException("Illegal assertion for variable '%s', index not deep enough", base.getId());
        }
        String offsetName = indexes.isEmpty() ? base.getId() :
                base.getId() + "[" + String.join("][", indexes.stream().map(Object::toString).toArray(String[]::new)) + "]";
        Location location =  new Location(offsetName, base.getAddress(), offset);
        locationTypes.put(location, type);
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