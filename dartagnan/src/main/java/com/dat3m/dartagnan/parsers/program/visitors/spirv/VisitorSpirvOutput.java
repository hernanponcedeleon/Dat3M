package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.specification.*;

import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.expression.integers.IntCmpOp.*;
import static com.dat3m.dartagnan.program.specification.AbstractAssert.ASSERT_TYPE_FORALL;
import static com.dat3m.dartagnan.program.specification.AbstractAssert.ASSERT_TYPE_NOT_EXISTS;

public class VisitorSpirvOutput extends SpirvBaseVisitor<AbstractAssert> {

    // TODO: Verify that variables in assertions are in the device scope

    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();
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

    private Integer acceptIndexValue(SpirvParser.IndexValueContext ctx) {
        return Integer.parseInt(ctx.ModeHeader_PositiveInteger().getText());
    }

    private Expression acceptAssertionValue(SpirvParser.AssertionValueContext ctx) {
        if (ctx.initBaseValue() != null) {
            return EXPR_FACTORY.parseValue(ctx.initBaseValue().getText(), TYPE_FACTORY.getArchType());
        }
        String name = ctx.varName().getText();
        MemoryObject base = builder.getMemoryObject(name);
        if (base == null) {
            throw new ParsingException("Uninitialized location %s", name);
        }
        if(ctx.indexValue().isEmpty()) {
            return new Location(name, base, 0);
        }
        List<Integer> indexes = new ArrayList<>();
        for (SpirvParser.IndexValueContext index : ctx.indexValue()) {
            indexes.add(acceptIndexValue(index));
        }
        int offset = getOffset(name, indexes);
        String offsetName = name + "[" + String.join("][", indexes.stream().map(Object::toString).toArray(String[]::new)) + "]";
        return new Location(offsetName, base, offset);
    }

    private int getOffset(String name, List<Integer> indexes) {
        Type type = builder.getVariableType(name);
        int offset = 0;
        for (int index : indexes) {
            validateIndex(name, type, index);
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
            throw new ParsingException("Illegal assertion for variable '%s', index not deep enough", name);
        }
        return offset;
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