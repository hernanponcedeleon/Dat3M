package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.memory.FinalMemoryValue;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.expression.integers.IntCmpOp.*;
import static com.dat3m.dartagnan.expression.utils.ExpressionHelper.extractType;
import static com.dat3m.dartagnan.program.Program.SpecificationType.*;

public class VisitorSpirvOutput extends SpirvBaseVisitor<Expression> {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final ProgramBuilder builder;
    private Program.SpecificationType type;
    private Expression condition;
    private Expression filter;

    public VisitorSpirvOutput(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Expression visitSpvHeaders(SpirvParser.SpvHeadersContext ctx) {
        for (SpirvParser.SpvHeaderContext header : ctx.spvHeader()) {
            if (header.outputHeader() != null && header.outputHeader().assertionList() != null) {
                visitAssertionList(header.outputHeader().assertionList());
            } else if (header.filterHeader() != null && header.filterHeader().assertion() != null) {
                visitFilterHeader(header.filterHeader());
            }
        }
        if (type == null) {
            type = FORALL;
            condition = expressions.makeTrue();
        }
        builder.setSpecification(type, condition);
        if (filter != null) {
            builder.setFilterSpecification(filter);
        }
        return null;
    }

    @Override
    public Expression visitFilterHeader(SpirvParser.FilterHeaderContext ctx) {
        if (filter != null) {
            throw new ParsingException("Multiline filters are not supported");
        }
        filter = ctx.assertion().accept(this);
        return null;
    }

    @Override
    public Expression visitAssertionList(SpirvParser.AssertionListContext ctx) {
        Program.SpecificationType parsedType = parseType(ctx);
        Expression parsedAssertion = ctx.assertion().accept(this);
        if (condition == null) {
            type = parsedType;
            condition = parsedAssertion;
            return parsedAssertion;
        }
        if (parsedType.equals(type)) {
            if (type.equals(FORALL)) {
                condition = expressions.makeAnd(condition, parsedAssertion);
                return parsedAssertion;
            }
            if (type.equals(NOT_EXISTS)) {
                condition = expressions.makeOr(condition, parsedAssertion);
                return parsedAssertion;
            }
            throw new ParsingException("Multiline assertion is not supported for type " + parsedType);
        }
        throw new ParsingException("Mixed assertion type is not supported");
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
    // TODO: Use GEPExpression in FinalMemoryValue
    public Expression visitAssertionValue(SpirvParser.AssertionValueContext ctx) {
        if (ctx.initBaseValue() != null) {
            return expressions.parseValue(ctx.initBaseValue().getText(), types.getArchType());
        }
        String id = ctx.varName().getText();
        MemoryObject base = getMemoryObject(id);
        Type resultType = ((PointerType) base.getType()).getPointedType();
        int offset = 0;
        if (!ctx.indexValue().isEmpty()) {
            LinkedList<String> idxStr = ctx.indexValue().stream()
                    .map(i -> i.ModeHeader_PositiveInteger().getText())
                    .collect(Collectors.toCollection(LinkedList::new));
            id += "[" + String.join("][", idxStr) + "]";
            if (Arch.OPENCL.equals(builder.getArch())) {
                String first = idxStr.removeFirst();
                offset = Integer.parseInt(first) * types.getMemorySizeInBytes(resultType);
            }
            List<Integer> idxInt = idxStr.stream().map(Integer::parseInt).toList();
            offset = getMemberOffset(base.getName(), offset, resultType, idxInt);
            resultType = extractType(resultType, idxInt);
            if (resultType instanceof ArrayType || resultType instanceof AggregateType) {
                throw new ParsingException("Index is not deep enough for '%s'", id);
            }
        }
        return new FinalMemoryValue(id, resultType, base, offset);
    }

    private Expression normalize(Expression target, Expression other) {
        Type targetType = target.getType();
        Type otherType = other.getType();
        if (targetType.equals(otherType)) {
            return target;
        }
        if (target instanceof FinalMemoryValue && other.getKind() == Other.LITERAL) {
            return target;
        }
        if (target instanceof IntLiteral iValue && other instanceof FinalMemoryValue) {
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

    private MemoryObject getMemoryObject(String id) {
        for (MemoryObject memObj : builder.getMemoryObjects()) {
            if (id.equals(memObj.getName())) {
                return memObj;
            }
        }
        throw new ParsingException("Annotation refers to an undefined expression '%s'", id);
    }

    public int getMemberOffset(String id, int offset, Type type, List<Integer> indexes) {
        if (!indexes.isEmpty()) {
            id += "[" + indexes.get(0) + "]";
            if (type instanceof ArrayType aType) {
                return getArrayMemberOffset(id, offset, aType, indexes);
            }
            if (type instanceof AggregateType aType) {
                return getStructMemberOffset(id, offset, aType, indexes);
            }
            throw new ParsingException("Index is too deep for '%s'", id);
        }
        return offset;
    }

    private int getArrayMemberOffset(String id, int offset, ArrayType type, List<Integer> indexes) {
        int index = indexes.get(0);
        if (index >= 0) {
            if (type.getNumElements() < 0 || index < type.getNumElements()) {
                Type elType = type.getElementType();
                offset += types.getOffsetInBytes(type, index);
                return getMemberOffset(id, offset, elType, indexes.subList(1, indexes.size()));
            }
            throw new ParsingException("Index is out of bounds for '%s'", id);
        }
        throw new ParsingException("Index is negative for '%s'", id);
    }

    private int getStructMemberOffset(String id, int offset, AggregateType type, List<Integer> indexes) {
        int index = indexes.get(0);
        if (index >= 0) {
            if (index < type.getFields().size()) {
                offset += type.getFields().get(index).offset();
                Type elType = type.getFields().get(index).type();
                return getMemberOffset(id, offset, elType, indexes.subList(1, indexes.size()));
            }
            throw new ParsingException("Index is out of bounds for '%s'", id);
        }
        throw new ParsingException("Index is negative for '%s'", id);
    }
}
