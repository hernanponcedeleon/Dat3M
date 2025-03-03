package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTypes;

import java.util.List;
import java.util.Set;

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
        if (type instanceof ScopedPointerType scopedPointerType) {
            Type pointedType = scopedPointerType.getPointedType();
            if (TypeFactory.isStaticTypeOf(element.getType(), pointedType)) {
                builder.addExpression(id, element);
                return null;
            }
        }
        throw new ParsingException(String.format("Type mismatch in composite extraction for: %s", id));
    }

    private Expression getElement(Expression base, List<Integer> indexes, String id) {
        try {
            return ExpressionFactory.getInstance().makeExtract(base, indexes);
        } catch (Exception e) {
            throw new ParsingException(String.format("Index out of bounds in OpCompositeExtract for '%s'", id));
        }
    }

    @Override
    public Void visitOpCompositeInsert(SpirvParser.OpCompositeInsertContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        String compositeId = ctx.composite().getText();
        String objectId = ctx.object().getText();
        Type resultType = builder.getType(typeId);
        Expression compositeExpr = builder.getExpression(compositeId);
        Expression objectExpr = builder.getExpression(objectId);
        Type compositeType = compositeExpr.getType();

        if (!compositeType.equals(resultType)) {
            throw new ParsingException("Type mismatch in OpCompositeInsert, " +
                    "result '%s' and composite '%s' must be the same for id '%s'", typeId, compositeId, id);
        }

        List<Integer> intIndexes = ctx.indexesLiteralInteger().stream()
                .map(c -> Integer.parseInt(c.getText()))
                .toList();

        Type memberType = HelperTypes.getMemberType(id, compositeType, intIndexes);
        if (!memberType.equals(objectExpr.getType())) {
            throw new ParsingException("Type mismatch in OpCompositeInsert, " +
                    "object '%s' and member '%s' must be the same for id '%s'", objectId, compositeId, id);
        }

        Expression copy = expressions.makeInsert(compositeExpr, objectExpr, intIndexes);
        builder.addExpression(id, copy);
        return null;
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpCompositeExtract",
                "OpCompositeInsert"
        );
    }
}
