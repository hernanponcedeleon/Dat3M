package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.specification.*;
import org.antlr.v4.runtime.tree.TerminalNode;

import static com.dat3m.dartagnan.program.specification.AbstractAssert.ASSERT_TYPE_FORALL;
import static com.dat3m.dartagnan.program.specification.AbstractAssert.ASSERT_TYPE_NOT_EXISTS;

public class VisitorSpirvOutput extends SpirvBaseVisitor<AbstractAssert> {

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
        Expression expr1 = acceptAssertionValue(ctx.assertionValue(0), false);
        Expression expr2 = acceptAssertionValue(ctx.assertionValue(1), true);
        if (ctx.assertionCompare().ModeHeader_EqualEqual() != null) {
            return new AssertBasic(expr1, COpBin.EQ, expr2);
        } else if (ctx.assertionCompare().ModeHeader_NotEqual() != null) {
            return new AssertBasic(expr1, COpBin.NEQ, expr2);
        } else if (ctx.assertionCompare().ModeHeader_Less() != null) {
            return new AssertBasic(expr1, COpBin.LT, expr2);
        } else if (ctx.assertionCompare().ModeHeader_LessEqual() != null) {
            return new AssertBasic(expr1, COpBin.LTE, expr2);
        } else if (ctx.assertionCompare().ModeHeader_Greater() != null) {
            return new AssertBasic(expr1, COpBin.GT, expr2);
        } else if (ctx.assertionCompare().ModeHeader_GreaterEqual() != null) {
            return new AssertBasic(expr1, COpBin.GTE, expr2);
        } else {
            throw new ParsingException("Unrecognised comparison operator");
        }
    }

    private Expression acceptAssertionValue(SpirvParser.AssertionValueContext ctx, boolean right) {
        if (ctx.initBaseValue() != null) {
            return EXPR_FACTORY.parseValue(ctx.initBaseValue().getText(), TYPE_FACTORY.getArchType());
        }
        String name = ctx.varName().getText();
        MemoryObject base = builder.getMemoryObject(name);
        if (base == null) {
            throw new ParsingException("Uninitialized location %s", name);
        }
        TerminalNode offset = ctx.ModeHeader_PositiveInteger();
        int o = offset == null ? 0 : Integer.parseInt(offset.getText());
        return right && offset == null ? base : new Location(name, base, o);
    }
}