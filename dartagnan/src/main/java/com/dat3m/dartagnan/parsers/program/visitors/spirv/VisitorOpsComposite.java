package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;

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
        throw new ParsingException(String.format("Type mismatch in composite extraction for: %s", id));
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
                "OpCompositeInsert"
        );
    }
}
