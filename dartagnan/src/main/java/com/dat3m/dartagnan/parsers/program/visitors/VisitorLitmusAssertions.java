package com.dat3m.dartagnan.parsers.program.visitors;

import java.math.BigInteger;

import com.dat3m.dartagnan.asserts.*;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.LastValueInterface;
import com.dat3m.dartagnan.parsers.LitmusAssertionsBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusAssertionsParser;
import com.dat3m.dartagnan.parsers.LitmusAssertionsVisitor;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.memory.Location;
import org.antlr.v4.runtime.tree.TerminalNode;

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
        LastValueInterface expr1;
        LitmusAssertionsParser.AssertionValueContext left = ctx.assertionValue(0);
        if(left.constant() != null) {
            expr1 = new IConst(new BigInteger(left.constant().getText()), -1);
        } else if(left.threadId() != null) {
            expr1 = programBuilder.getOrErrorRegister(left.threadId().id, left.varName().getText());
        } else {
            LitmusAssertionsParser.VarNameContext name = left.varName();
            Address base = programBuilder.getLocation(name.getText());
            if(base == null) {
                throw new IllegalStateException("Location " + name.getText() + " has not been initialised");
            }
            TerminalNode offset = left.DigitSequence();
            expr1 = new Location(name.getText(),base,offset==null?0:Integer.parseInt(offset.getText()));
        }
        LastValueInterface expr2;
        LitmusAssertionsParser.AssertionValueContext right = ctx.assertionValue(1);
        if(right.constant() != null) {
            expr2 = new IConst(new BigInteger(right.constant().getText()), -1);
        } else if(right.threadId() != null) {
            expr2 = programBuilder.getOrErrorRegister(right.threadId().id, right.varName().getText());
        } else {
            LitmusAssertionsParser.VarNameContext name = right.varName();
            Address base = programBuilder.getLocation(name.getText());
            if(base == null) {
                throw new IllegalStateException("Location " + name.getText() + " has not been initialised");
            }
            TerminalNode offset = right.DigitSequence();
            expr2 = offset==null?base:new Location(name.getText(),base,Integer.parseInt(offset.getText()));
        }
        return new AssertBasic(expr1, ctx.assertionCompare().op, expr2);
    }
}
