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

public class VisitorSpirvAssertions extends SpirvBaseVisitor<AbstractAssert> {

    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();
    private final ProgramBuilderSpv builder;

    public VisitorSpirvAssertions(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public AbstractAssert visitAssertionFilter(SpirvParser.AssertionFilterContext ctx) {
        return ctx.assertion().accept(this);
    }

    @Override
    public AbstractAssert visitAssertionList(SpirvParser.AssertionListContext ctx) {
        AbstractAssert ast = ctx.assertion().accept(this);
        if (ctx.ModeHeader_AssertionNot() != null) {
            ast.setType(AbstractAssert.ASSERT_TYPE_NOT_EXISTS);
        } else if (ctx.ModeHeader_AssertionExists() != null) {
            ast.setType(AbstractAssert.ASSERT_TYPE_EXISTS);
        } else if (ctx.ModeHeader_AssertionForall() != null) {
            ast.setType(AbstractAssert.ASSERT_TYPE_FORALL);
        } else {
            throw new ParsingException("Unrecognised assertion type");
        }
        return ast;
    }

    @Override
    public AbstractAssert visitAssertionParenthesis(SpirvParser.AssertionParenthesisContext ctx) {
        return ctx.assertion().accept(this);
    }

    @Override
    public AbstractAssert visitAssertionNot(SpirvParser.AssertionNotContext ctx) {
        return new AssertNot(ctx.assertion().accept(this));
    }

    @Override
    public AbstractAssert visitAssertionAnd(SpirvParser.AssertionAndContext ctx) {
        return new AssertCompositeAnd(ctx.assertion(0).accept(this), ctx.assertion(1).accept(this));
    }

    @Override
    public AbstractAssert visitAssertionOr(SpirvParser.AssertionOrContext ctx) {
        return new AssertCompositeOr(ctx.assertion(0).accept(this), ctx.assertion(1).accept(this));
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

    @Override
    public AbstractAssert visitAssertionBoolean(SpirvParser.AssertionBooleanContext ctx) {
        return this.visitHeaderBoolean(ctx.headerBoolean());
    }

    @Override
    public AbstractAssert visitHeaderBoolean(SpirvParser.HeaderBooleanContext ctx) {
        return ctx.ModeHeader_True() != null ? new AssertTrue() : new AssertNot(new AssertTrue());
    }

    private Expression acceptAssertionValue(SpirvParser.AssertionValueContext ctx, boolean right) {
        if (ctx.literalHeaderConstant() != null) {
            return EXPR_FACTORY.parseValue(ctx.literalHeaderConstant().getText(), TYPE_FACTORY.getArchType());
        }
        String name = ctx.varName().getText();
        MemoryObject base = builder.getMemoryObject(name);
        if (base == null) {
            throw new ParsingException("uninitialized location %s", name);
        }
        TerminalNode offset = ctx.ModeHeader_PositiveInteger();
        int o = offset == null ? 0 : Integer.parseInt(offset.getText());
        return right && offset == null ? base : new Location(name, base, o);
    }
}