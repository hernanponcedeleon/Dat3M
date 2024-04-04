package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.SpecId;
import com.dat3m.dartagnan.program.Register;
import org.antlr.v4.runtime.RuleContext;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class VisitorOpsConstant extends SpirvBaseVisitor<Expression> {

    private static final ExpressionFactory FACTORY = ExpressionFactory.getInstance();

    private final ProgramBuilderSpv builder;
    private final SpecId specIdDecorator;
    private final BuiltIn builtInDecorator;

    public VisitorOpsConstant(ProgramBuilderSpv builder) {
        this.builder = builder;
        this.specIdDecorator = (SpecId) builder.getDecoration(DecorationType.SPEC_ID);
        this.builtInDecorator = (BuiltIn) builder.getDecoration(DecorationType.BUILT_IN);
    }

    @Override
    public Expression visitOpConstantTrue(SpirvParser.OpConstantTrueContext ctx) {
        return builder.addConstant(ctx.idResult().getText(), FACTORY.makeTrue());
    }

    @Override
    public Expression visitOpSpecConstantTrue(SpirvParser.OpSpecConstantTrueContext ctx) {
        String id = ctx.idResult().getText();
        return builder.addSpecConstant(id, makeBooleanSpecConstant(id, true));
    }

    @Override
    public Expression visitOpConstantFalse(SpirvParser.OpConstantFalseContext ctx) {
        return builder.addConstant(ctx.idResult().getText(), FACTORY.makeFalse());
    }

    @Override
    public Expression visitOpSpecConstantFalse(SpirvParser.OpSpecConstantFalseContext ctx) {
        String id = ctx.idResult().getText();
        return builder.addSpecConstant(id, makeBooleanSpecConstant(id, false));
    }

    @Override
    public Expression visitOpConstant(SpirvParser.OpConstantContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        String value = ctx.valueLiteralContextDependentNumber().getText();
        return builder.addConstant(id, makeConstant(type, value));
    }

    @Override
    public Expression visitOpSpecConstant(SpirvParser.OpSpecConstantContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        String value = specIdDecorator.getValue(id);
        if (value == null) {
            value = ctx.valueLiteralContextDependentNumber().getText();
        }
        return builder.addSpecConstant(id, makeConstant(type, value));
    }

    @Override
    public Expression visitOpConstantComposite(SpirvParser.OpConstantCompositeContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        List<String> elementIds = ctx.constituents().stream().map(RuleContext::getText).toList();
        for (String elementId : elementIds) {
            if (builder.isSpecConstant(elementId)) {
                throw new ParsingException("Reference to spec constant '%s' " +
                        "from base composite constant '%s'", elementId, id);
            }
        }
        if (builtInDecorator.hasDecoration(id, "WorkgroupSize")) {
            Expression value = makeConstantComposite(id, type, elementIds);
            value = builtInDecorator.decorate(id, value, type);
            return builder.addSpecConstant(id, value);
        } else {
            return builder.addConstant(id, makeConstantComposite(id, type, elementIds));
        }
    }

    @Override
    public Expression visitOpSpecConstantComposite(SpirvParser.OpSpecConstantCompositeContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        List<String> elementIds = ctx.constituents().stream().map(RuleContext::getText).toList();
        for (String elementId : elementIds) {
            if (!builder.isSpecConstant(elementId)) {
                throw new ParsingException("Reference to base constant '%s' " +
                        "from spec composite constant '%s'", elementId, id);
            }
        }
        if (builtInDecorator.hasDecoration(id, "WorkgroupSize")) {
            Expression value = makeConstantComposite(id, type, elementIds);
            value = builtInDecorator.decorate(id, value, type);
            return builder.addSpecConstant(id, value);
        } else {
            return builder.addSpecConstant(id, makeConstantComposite(id, type, elementIds));
        }
    }

    @Override
    public Expression visitOpConstantNull(SpirvParser.OpConstantNullContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        if (type instanceof BooleanType) {
            Expression expression = FACTORY.makeFalse();
            return builder.addExpression(id, expression);
        }
        if (type instanceof IntegerType iType) {
            Expression expression = FACTORY.makeZero(iType);
            return builder.addExpression(id, expression);
        }
        throw new ParsingException("Illegal NULL constant type '%s'", type);
    }

    // Special handling for OpSpecConstantOp (wrapper for another Op)
    public Type visitOpSpecConstantOp(Register register) {
        // TODO: Implementation
        return register.getType();
    }

    private Expression makeBooleanSpecConstant(String id, boolean value) {
        String decoration = specIdDecorator.getValue(id);
        if (decoration != null) {
            value = !"0".equals(decoration);
        }
        if (value) {
            return FACTORY.makeTrue();
        }
        return FACTORY.makeFalse();
    }

    private Expression makeConstant(Type type, String value) {
        if (type instanceof IntegerType iType) {
            long intValue = Long.parseLong(value);
            return FACTORY.makeValue(intValue, iType);
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
        List<Type> elementTypes = type.getDirectFields();
        if (elementTypes.size() != elementIds.size()) {
            throw new ParsingException("Mismatching number of elements in the composite constant '%s', " +
                    "expected %d elements but received %d elements", id, elementTypes.size(), elementIds.size());
        }
        List<Expression> elements = new ArrayList<>();
        for (int i = 0; i < elementTypes.size(); i++) {
            Expression expression = builder.getExpression(elementIds.get(i));
            if (!expression.getType().equals(elementTypes.get(i))) {
                throw new ParsingException("Mismatching type of a composite constant '%s' element '%s', " +
                        "expected '%s' but received '%s'", id, elementIds.get(i),
                        elementTypes.get(i), expression.getType());
            }
            elements.add(expression);
        }
        return ExpressionFactory.getInstance().makeConstruct(elements);
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
        return FACTORY.makeArray(elementType, elements, true);
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
