package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;

import java.util.List;
import java.util.Set;
import java.util.ArrayList;

public class VisitorOpsComposite extends SpirvBaseVisitor<Void> {

    private final ProgramBuilder builder;
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();

    public VisitorOpsComposite(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Void visitOpCompositeExtract(SpirvParser.OpCompositeExtractContext ctx) {
        String id = ctx.idResult().getText();
        Expression compositeExpression = builder.getExpression(ctx.composite().getText());
        Type type = builder.getType(ctx.idResultType().getText());
        List<Integer> indexes = ctx.indexesLiteralInteger().stream()
                .map(SpirvParser.IndexesLiteralIntegerContext::getText)
                .map(Integer::parseInt)
                .toList();
        Expression element = getElement(compositeExpression, indexes, id);
        if (type.equals(element.getType())) {
            builder.addExpression(id, element);
            return null;
        }
        throw new ParsingException(String.format("Type mismatch in composite extraction for: %s", id));
    }

    @Override
    public Void visitOpCompositeConstruct(SpirvParser.OpCompositeConstructContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        if (!(type instanceof AggregateType || type instanceof ArrayType)) {
            throw new ParsingException(String.format("Result type of CompositeConstruct must be a composite. Offending id: '%s'", id));
        }
        if (type instanceof AggregateType aggregateType) {
            final List<Expression> elements = new ArrayList<>(aggregateType.getFields().size());
            for (SpirvParser.ConstituentsContext vCtx : ctx.constituents()) {
                String idCtx = vCtx.idRef().getText();
                elements.add(builder.getExpression(idCtx));
            }
            try {
                builder.addExpression(id, expressions.makeConstruct(type, elements));
            } catch (Exception e) {
                throw new ParsingException(String.format("%s Offending id: '%s'", e.getMessage(), id));
            }
        }
        if (type instanceof ArrayType arrayType) {
            final List<Expression> elements = new ArrayList<>(arrayType.getNumElements());
            for (SpirvParser.ConstituentsContext vCtx : ctx.constituents()) {
                String idCtx = vCtx.idRef().getText();
                Expression elem = builder.getExpression(idCtx);
                if (elem.getType().equals(type)) {
                    elements.addAll(elem.getOperands());
                } else {
                    elements.add(elem);
                }
            }
            try {
                builder.addExpression(id, expressions.makeArray(arrayType.getElementType(), elements, true));
            } catch (Exception e) {
                throw new ParsingException(String.format("%s Offending id: '%s'", e.getMessage(), id));
            }
        }
        return null;
    }

    private Expression getElement(Expression base, List<Integer> indexes, String id) {
        try {
            return expressions.makeExtract(base, indexes);
        } catch (Exception e) {
            throw new ParsingException(String.format("Index out of bounds in OpCompositeExtract for '%s'", id));
        }
    }

    @Override
    public Void visitOpCompositeInsert(SpirvParser.OpCompositeInsertContext ctx) {
        String id = ctx.idResult().getText();
        Expression compositeExpression = builder.getExpression(ctx.composite().getText());
        Expression objectExpr = builder.getExpression(ctx.object().getText());
        Type type = builder.getType(ctx.idResultType().getText());
        List<Integer> indexes = ctx.indexesLiteralInteger().stream()
                .map(SpirvParser.IndexesLiteralIntegerContext::getText)
                .map(Integer::parseInt)
                .toList();
        Expression insertion = getInsertion(compositeExpression, objectExpr, indexes, id);
        if (TypeFactory.isStaticTypeOf(compositeExpression.getType(), type)) {
            builder.addExpression(id, insertion);
            return null;
        }
        throw new ParsingException("Type mismatch in composite insert for '%s'", id);
    }

    @Override
    public Void visitOpVectorShuffle(SpirvParser.OpVectorShuffleContext ctx) {
        String id = ctx.idResult().getText();
        String v1Id = ctx.vector1().getText();
        Expression v1 = builder.getExpression(v1Id);
        String v2Id = ctx.vector2().getText();
        Expression v2 = builder.getExpression(v2Id);
        List<Integer> components = ctx.components().stream()
            .map(SpirvParser.ComponentsContext::getText)
            .map(Integer::parseInt)
            .toList();
        Type type = builder.getType(ctx.idResultType().getText());
        if (!(type instanceof ArrayType aType)) {
            throw new ParsingException("Return type %s of OpVectorShuffle '%s' is not a vector", type, id);
        }
        Type eType = aType.getElementType();
        if (!(v1.getType() instanceof ArrayType aType1) || !(v2.getType() instanceof ArrayType aType2)) {
            throw new ParsingException("Parameter of OpVectorShuffle '%s' is not a vector", id);
        }
        if (!eType.equals(aType1.getElementType()) || !eType.equals(aType2.getElementType())) {
            throw new ParsingException("Type mismatch in OpVectorShuffle '%s' between result type and components", id);
        }
        if (aType.getNumElements() != components.size()) {
            throw new ParsingException("Size mismatch in OpVectorShuffle '%s' between result type %s and components %s", id, aType, components);
        }
        int s1 = aType1.getNumElements();
        int s2 = aType2.getNumElements();
        List<Expression> concat = new ArrayList<>();
        for (Integer index : components) {
            if (index >= 0 && index < s1) {
                concat.add(v1.getOperands().get(index));
            } else if (index >= s1 && index < s1 + s2) {
                concat.add(v2.getOperands().get(index - s1));
            } else {
                throw new ParsingException("Index %s out of bounds in OpVectorShuffle '%s'", index, id);
            }
        }
        builder.addExpression(id, expressions.makeArray(aType1.getElementType(), concat, true));
        return null;
    }

    private Expression getInsertion(Expression compositeExpr, Expression objectExpr, List<Integer> indexes, String id) {
        try {
            return expressions.makeInsert(compositeExpr, objectExpr, indexes);
        } catch (Exception e) {
            throw new ParsingException("Element type mismatch or index out of bounds in OpCompositeInsert for '%s'", id);
        }
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpCompositeExtract",
                "OpCompositeInsert",
                "OpVectorShuffle",
                "OpCompositeConstruct"
        );
    }
}
