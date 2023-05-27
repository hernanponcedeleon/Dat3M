package com.dat3m.dartagnan.parsers.program.visitors;

import java.math.BigInteger;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.parsers.LitmusAssertionsBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusAssertionsParser;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.specification.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.memory.Location;
import org.antlr.v4.runtime.tree.TerminalNode;

import static com.dat3m.dartagnan.GlobalSettings.getArchPrecision;
import static com.google.common.base.Preconditions.checkState;

public class VisitorLitmusAssertions extends LitmusAssertionsBaseVisitor<AbstractAssert> {

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
        } else if(ctx.AssertionExists() != null || ctx.AssertionFinal() != null){
            ass.setType(AbstractAssert.ASSERT_TYPE_EXISTS);
        } else if(ctx.AssertionForall() != null){
            ass.setType(AbstractAssert.ASSERT_TYPE_FORALL);
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
        ExprInterface expr1 = acceptAssertionValue(ctx.assertionValue(0),false);
        ExprInterface expr2 = acceptAssertionValue(ctx.assertionValue(1),true);
        return new AssertBasic(expr1, ctx.assertionCompare().op, expr2);
    }

    private ExprInterface acceptAssertionValue(LitmusAssertionsParser.AssertionValueContext ctx, boolean right) {
        if(ctx.constant() != null) {
            return new IValue(new BigInteger(ctx.constant().getText()), getArchPrecision());
        }
        String name = ctx.varName().getText();
        if(ctx.threadId() != null) {
            return programBuilder.getOrErrorRegister(ctx.threadId().id,name);
        }
        MemoryObject base = programBuilder.getObject(name);
        checkState(base != null, "uninitialized location %s", name);
        TerminalNode offset = ctx.DigitSequence();
        int o = offset == null ? 0 : Integer.parseInt(offset.getText());
        return right && offset == null ? base : new Location(name, base, o);
    }
}
