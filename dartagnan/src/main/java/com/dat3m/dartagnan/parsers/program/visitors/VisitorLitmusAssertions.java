package com.dat3m.dartagnan.parsers.program.visitors;

import java.math.BigInteger;

import com.dat3m.dartagnan.asserts.*;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.parsers.LitmusAssertionsBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusAssertionsParser;
import com.dat3m.dartagnan.parsers.LitmusAssertionsVisitor;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.memory.Location;

public class VisitorLitmusAssertions extends LitmusAssertionsBaseVisitor<AbstractAssert>
        implements LitmusAssertionsVisitor<AbstractAssert> {

    private final ProgramBuilder programBuilder;

    public VisitorLitmusAssertions(ProgramBuilder programBuilder){
        this.programBuilder = programBuilder;
    }

    @Override
    public AbstractAssert visitAssertionFilter(LitmusAssertionsParser.AssertionFilterContext ctx){
        return ctx.assertion().accept(this);
    }

    @Override
    public AbstractAssert visitAssertionList(LitmusAssertionsParser.AssertionListContext ctx){
        AbstractAssert ass = ctx.assertion().accept(this);
        if(ctx.AssertionNot() != null) {
            ass.setType(AbstractAssert.ASSERT_TYPE_NOT_EXISTS);
        } else if(ctx.AssertionExists() != null){
            ass.setType(AbstractAssert.ASSERT_TYPE_EXISTS);
        } else if(ctx.AssertionForall() != null){
            ass = new AssertNot(ass);
            ass.setType(AbstractAssert.ASSERT_TYPE_FORALL);
        } else if(ctx.AssertionFinal() != null){
            ass.setType(AbstractAssert.ASSERT_TYPE_FINAL);
        } else {
            throw new ParsingException("Unrecognised assertion type");
        }
        return ass;
    }

    @Override
    public AbstractAssert visitAssertionParenthesis(LitmusAssertionsParser.AssertionParenthesisContext ctx){
        return ctx.assertion().accept(this);
    }

    @Override
    public AbstractAssert visitAssertionNot(LitmusAssertionsParser.AssertionNotContext ctx){
        return new AssertNot(ctx.assertion().accept(this));
    }

    @Override
    public AbstractAssert visitAssertionAnd(LitmusAssertionsParser.AssertionAndContext ctx){
        return new AssertCompositeAnd(ctx.assertion(0).accept(this), ctx.assertion(1).accept(this));
    }

    @Override
    public AbstractAssert visitAssertionOr(LitmusAssertionsParser.AssertionOrContext ctx){
        return new AssertCompositeOr(ctx.assertion(0).accept(this), ctx.assertion(1).accept(this));
    }

    @Override
    public AbstractAssert visitAssertionBasic(LitmusAssertionsParser.AssertionBasicContext ctx){
        ExprInterface expr1 = acceptAssertionValue(ctx.assertionValue(0));
        ExprInterface expr2 = acceptAssertionValue(ctx.assertionValue(1));
        if(expr2 instanceof Location){
            expr2 = ((Location) expr2).getAddress();
        }
        return new AssertBasic(expr1, ctx.assertionCompare().op, expr2);
    }

    private ExprInterface acceptAssertionValue(LitmusAssertionsParser.AssertionValueContext ctx){
        if(ctx.constant() != null){
            return new IConst(new BigInteger(ctx.constant().getText()), -1);
        }
        if(ctx.threadId() != null){
            return programBuilder.getOrErrorRegister(ctx.threadId().id, ctx.varName().getText());
        }
        return programBuilder.getOrErrorLocation(ctx.getText());
    }
}
