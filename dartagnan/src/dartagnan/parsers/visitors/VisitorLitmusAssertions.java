package dartagnan.parsers.visitors;

import dartagnan.asserts.*;
import dartagnan.expression.IConst;
import dartagnan.expression.IntExprInterface;
import dartagnan.parsers.LitmusAssertionsBaseVisitor;
import dartagnan.parsers.LitmusAssertionsVisitor;
import dartagnan.parsers.LitmusAssertionsParser;
import dartagnan.parsers.utils.ParsingException;
import dartagnan.parsers.utils.ProgramBuilder;
import dartagnan.program.memory.Location;

public class VisitorLitmusAssertions extends LitmusAssertionsBaseVisitor<AbstractAssert>
        implements LitmusAssertionsVisitor<AbstractAssert> {

    private ProgramBuilder programBuilder;

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
        IntExprInterface expr1 = acceptAssertionValue(ctx.assertionValue(0));
        IntExprInterface expr2 = acceptAssertionValue(ctx.assertionValue(1));
        if(expr2 instanceof Location){
            expr2 = ((Location) expr2).getAddress();
        }
        return new AssertBasic(expr1, ctx.assertionCompare().op, expr2);
    }

    private IntExprInterface acceptAssertionValue(LitmusAssertionsParser.AssertionValueContext ctx){
        if(ctx.constant() != null){
            return new IConst(Integer.parseInt(ctx.constant().getText()));
        }
        if(ctx.threadId() != null){
            return programBuilder.getOrErrorRegister(ctx.threadId().id, ctx.varName().getText());
        }
        return programBuilder.getOrErrorLocation(ctx.getText());
    }
}
