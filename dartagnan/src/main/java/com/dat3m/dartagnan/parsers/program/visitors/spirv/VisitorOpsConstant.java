package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.program.Register;
import org.antlr.v4.runtime.RuleContext;

import java.util.*;

import static com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType.BUILT_IN;

public class VisitorOpsConstant extends SpirvBaseVisitor<Expression> {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final Set<String> specConstants = new HashSet<>();
    private final ProgramBuilder builder;
    private final BuiltIn builtIn;

    public VisitorOpsConstant(ProgramBuilder builder) {
        this.builder = builder;
        this.builtIn = (BuiltIn) builder.getDecorationsBuilder().getDecoration(BUILT_IN);
    }

    @Override
    public Expression visitOpConstantTrue(SpirvParser.OpConstantTrueContext ctx) {
        return builder.addExpression(ctx.idResult().getText(), expressions.makeTrue());
    }

    @Override
    public Expression visitOpSpecConstantTrue(SpirvParser.OpSpecConstantTrueContext ctx) {
        String id = ctx.idResult().getText();
        specConstants.add(id);
        return builder.addExpression(id, makeBooleanSpecConstant(id, true));
    }

    @Override
    public Expression visitOpConstantFalse(SpirvParser.OpConstantFalseContext ctx) {
        return builder.addExpression(ctx.idResult().getText(), expressions.makeFalse());
    }

    @Override
    public Expression visitOpSpecConstantFalse(SpirvParser.OpSpecConstantFalseContext ctx) {
        String id = ctx.idResult().getText();
        specConstants.add(id);
        return builder.addExpression(id, makeBooleanSpecConstant(id, false));
    }

    @Override
    public Expression visitOpConstant(SpirvParser.OpConstantContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        String value = ctx.valueLiteralContextDependentNumber().getText();
        return builder.addExpression(id, makeConstant(type, value));
    }

    @Override
    public Expression visitOpSpecConstant(SpirvParser.OpSpecConstantContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        if (type instanceof IntegerType iType) {
            Integer input = getInputValue(id);
            if (input != null) {
                specConstants.add(id);
                return builder.addExpression(id, expressions.makeValue(input, iType));
            }
            specConstants.add(id);
            String value = ctx.valueLiteralContextDependentNumber().getText();
            return builder.addExpression(id, expressions.makeValue(Long.parseLong(value), iType));
        }
        throw new ParsingException("Illegal constant type '%s'", type);
    }

    @Override
    public Expression visitOpConstantComposite(SpirvParser.OpConstantCompositeContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        List<String> elementIds = ctx.constituents().stream().map(RuleContext::getText).toList();
        for (String elementId : elementIds) {
            if (specConstants.contains(elementId)) {
                throw new ParsingException("Reference to spec constant '%s' " +
                        "from base composite constant '%s'", elementId, id);
            }
        }
        return builder.addExpression(id, makeConstantComposite(id, type, elementIds));
    }

    @Override
    public Expression visitOpSpecConstantComposite(SpirvParser.OpSpecConstantCompositeContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        List<String> elementIds = ctx.constituents().stream().map(RuleContext::getText).toList();
        for (String elementId : elementIds) {
            if (!specConstants.contains(elementId)) {
                throw new ParsingException("Reference to base constant '%s' " +
                        "from spec composite constant '%s'", elementId, id);
            }
        }
        Expression value = builtIn.getDecoration(id, type);
        if (value == null) {
            value = makeConstantComposite(id, type, elementIds);
        }
        specConstants.add(id);
        return builder.addExpression(id, value);
    }

    @Override
    public Expression visitOpConstantNull(SpirvParser.OpConstantNullContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        Type type = builder.getType(typeId);
        Expression expression = getConstantNullExpression(typeId, type);
        return builder.addExpression(id, expression);
    }

    private Expression getConstantNullExpression(String typeId, Type type) {
        if (type instanceof ArrayType arrayType) {
            if (!arrayType.hasKnownNumElements()) {
                throw new ParsingException("Cannot create NULL constant for '%s' with unknown size array type", typeId);
            }
            Expression exp = getConstantNullExpression(typeId, arrayType.getElementType());
            List<Expression> elements = Collections.nCopies(arrayType.getNumElements(), exp);
            return expressions.makeArray(arrayType, elements);
        }
        if (type instanceof AggregateType aggregateType) {
            List<Expression> elements = new ArrayList<>();
            for (TypeOffset field : aggregateType.getFields()) {
                elements.add(getConstantNullExpression(typeId, field.type()));
            }
            return expressions.makeConstruct(aggregateType, elements);
        }
        if (type instanceof BooleanType) {
            return expressions.makeFalse();
        }
        if (type instanceof IntegerType iType) {
            return expressions.makeZero(iType);
        }
        throw new ParsingException("Unsupported NULL constant type '%s'", typeId);
    }

    public void visitOpSpecConstantOp(Register register) {
        // TODO: Implementation
        // Special handling for OpSpecConstantOp (wrapper for another Op)
        throw new ParsingException("Unsupported instruction OpSpecConstantOp");
    }

    private Expression makeBooleanSpecConstant(String id, boolean value) {
        Integer input = getInputValue(id);
        if (input != null) {
            value = input != 0;
        }
        if (value) {
            return expressions.makeTrue();
        }
        return expressions.makeFalse();
    }

    private Expression makeConstant(Type type, String value) {
        if (type instanceof IntegerType iType) {
            long intValue = Long.parseLong(value);
            return expressions.makeValue(intValue, iType);
        }
        throw new ParsingException("Illegal constant type '%s'", type);
    }

    private Expression makeConstantComposite(String id, Type type, List<String> elementIds) {
        if (type instanceof AggregateType aType) {
            return makeConstantStruct(id, aType, elementIds);
        } else if (type instanceof ArrayType aType) {
            return makeConstantArray(id, aType, elementIds);
        } else {
            throw new ParsingException("Illegal type '%s' for composite constant '%s'", type, id);
        }
    }

    private Expression makeConstantStruct(String id, AggregateType type, List<String> elementIds) {
        List<TypeOffset> elementTypes = type.getFields();
        if (elementTypes.size() != elementIds.size()) {
            throw new ParsingException("Mismatching number of elements in the composite constant '%s', " +
                    "expected %d elements but received %d elements", id, elementTypes.size(), elementIds.size());
        }
        List<Expression> elements = new ArrayList<>();
        for (int i = 0; i < elementTypes.size(); i++) {
            Expression expression = builder.getExpression(elementIds.get(i));
            if (!expression.getType().equals(elementTypes.get(i).type())) {
                throw new ParsingException("Mismatching type of a composite constant '%s' element '%s', " +
                        "expected '%s' but received '%s'", id, elementIds.get(i),
                        elementTypes.get(i).type(), expression.getType());
            }
            elements.add(expression);
        }
        return expressions.makeConstruct(type, elements);
    }

    private Expression makeConstantArray(String id, ArrayType type, List<String> elementIds) {
        if (type.getNumElements() != elementIds.size()) {
            throw new ParsingException("Mismatching number of elements in the composite constant '%s', " +
                    "expected %d elements but received %d elements", id, type.getNumElements(), elementIds.size());
        }
        Type elementType = type.getElementType();
        List<Expression> elements = new ArrayList<>();
        for (String elementId : elementIds) {
            Expression expression = builder.getExpression(elementId);
            if (!expression.getType().equals(elementType)) {
                throw new ParsingException("Mismatching type of a composite constant '%s' element '%s', " +
                        "expected '%s' but received '%s'", id, elementId,
                        elementType, expression.getType());
            }
            elements.add(expression);
        }
        return expressions.makeArray(type, elements);
    }

    private Integer getInputValue(String id) {
        if (builder.hasInput(id)) {
            Expression expr = builder.getInput(id);
            if (expr instanceof IntLiteral iExpr) {
                return iExpr.getValueAsInt();
            }
            throw new ParsingException("Unexpected input for SpecConstant '%s', " +
                    "expected integer but received '%s'", id, expr.getType());
        }
        return null;
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpConstantTrue",
                "OpConstantFalse",
                "OpConstant",
                "OpConstantComposite",
                "OpConstantNull",
                "OpSpecConstantTrue",
                "OpSpecConstantFalse",
                "OpSpecConstant",
                "OpSpecConstantComposite"
        );
    }
}
