package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;

import java.util.List;
import java.util.Set;

public class VisitorOpsComposite extends SpirvBaseVisitor<Void> {

    private final ProgramBuilder builder;

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
            if (pointedType == element.getType() || TypeFactory.isStaticTypeOf(element.getType(), pointedType)) {
                builder.addExpression(id, element);
                return null;
            }
        }
        throw new ParsingException(String.format("Type mismatch in composite extraction for: %s", id));
    }

    private Expression getElement(Expression compositeExpression, List<Integer> indexes, String id) {
        Expression element = compositeExpression;
        for (Integer index : indexes) {
            if (!(element instanceof ConstructExpr)) {
                throw new ParsingException(String.format("Element is not a ConstructExpr at index: %d for: %s", index, id));
            }
            List<Expression> operands = element.getOperands();
            if (index >= operands.size()) {
                throw new ParsingException(String.format("Index out of bounds: %d for: %s", index, id));
            }
            element = operands.get(index);
        }
        return element;
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpCompositeExtract"
        );
    }
}
