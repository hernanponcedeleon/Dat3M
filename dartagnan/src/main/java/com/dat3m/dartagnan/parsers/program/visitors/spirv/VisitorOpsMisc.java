package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.VoidType;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;

import java.util.Set;

public class VisitorOpsMisc extends SpirvBaseVisitor<Expression> {

    private final ProgramBuilder builder;

    public VisitorOpsMisc(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Expression visitOpUndef(SpirvParser.OpUndefContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        if (!(type instanceof VoidType)) {
            Expression expression = builder.makeUndefinedValue(type);
            return builder.addExpression(id, expression);
        }
        throw new ParsingException("Illegal definition '%s': " +
                "OpUndef cannot have void type", id);
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpUndef"
        );
    }
}
