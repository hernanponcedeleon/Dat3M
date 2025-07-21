package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusAssertionsBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusAssertionsLexer;
import com.dat3m.dartagnan.parsers.LitmusAssertionsParser;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.memory.FinalMemoryValue;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.misc.Interval;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.math.BigInteger;

import static com.dat3m.dartagnan.program.Program.SpecificationType.*;
import static com.google.common.base.Preconditions.checkState;

class VisitorLitmusAssertions extends LitmusAssertionsBaseVisitor<Expression> {

    private final ProgramBuilder programBuilder;
    private final TypeFactory types;
    private final ExpressionFactory expressions;
    private final IntegerType archType;

    private VisitorLitmusAssertions(ProgramBuilder programBuilder) {
        this.programBuilder = programBuilder;
        this.types = programBuilder.getTypeFactory();
        this.expressions = programBuilder.getExpressionFactory();
        this.archType = programBuilder.getTypeFactory().getArchType();
    }

    static void parseAssertions(
            ProgramBuilder programBuilder,
            ParserRuleContext listContext,
            ParserRuleContext filterContext) {
        parseAssertions(programBuilder, listContext, false);
        parseAssertions(programBuilder, filterContext, true);
    }

    private static void parseAssertions(ProgramBuilder programBuilder, ParserRuleContext ctx, boolean filter) {
        if (ctx == null) {
            return;
        }
        int a = ctx.getStart().getStartIndex();
        int b = ctx.getStop().getStopIndex();
        String text = ctx.getStart().getInputStream().getText(new Interval(a, b));
        CharStream charStream = CharStreams.fromString(text);
        LitmusAssertionsLexer lexer = new LitmusAssertionsLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        LitmusAssertionsParser parser = new LitmusAssertionsParser(tokenStream);
        ParserRuleContext parserEntryPoint = filter ? parser.assertionFilter() : parser.assertionList();
        parserEntryPoint.accept(new VisitorLitmusAssertions(programBuilder));
    }

    @Override
    public Expression visitAssertionFilter(LitmusAssertionsParser.AssertionFilterContext ctx) {
        programBuilder.setAssertFilter(ctx.assertion().accept(this));
        return null;
    }

    @Override
    public Expression visitAssertionList(LitmusAssertionsParser.AssertionListContext ctx) {
        Expression ass = ctx.assertion().accept(this);
        if (ctx.AssertionNot() != null) {
            programBuilder.setAssert(NOT_EXISTS, ass);
        } else if (ctx.AssertionExists() != null || ctx.AssertionFinal() != null) {
            programBuilder.setAssert(EXISTS, ass);
        } else if (ctx.AssertionForall() != null) {
            programBuilder.setAssert(FORALL, ass);
        } else {
            throw new ParsingException("Unrecognised assertion type");
        }
        return ass;
    }

    @Override
    public Expression visitAssertionParenthesis(LitmusAssertionsParser.AssertionParenthesisContext ctx) {
        return ctx.assertion().accept(this);
    }

    @Override
    public Expression visitAssertionNot(LitmusAssertionsParser.AssertionNotContext ctx) {
        return expressions.makeNot(ctx.assertion().accept(this));
    }

    @Override
    public Expression visitAssertionAnd(LitmusAssertionsParser.AssertionAndContext ctx) {
        return expressions.makeAnd(ctx.assertion(0).accept(this), ctx.assertion(1).accept(this));
    }

    @Override
    public Expression visitAssertionOr(LitmusAssertionsParser.AssertionOrContext ctx) {
        return expressions.makeOr(ctx.assertion(0).accept(this), ctx.assertion(1).accept(this));
    }

    @Override
    public Expression visitAssertionBasic(LitmusAssertionsParser.AssertionBasicContext ctx) {
        final Expression lhs = acceptAssertionValue(ctx.assertionValue(0), false);
        final Expression rhs = acceptAssertionValue(ctx.assertionValue(1), true);
        final Expression expr1 = expressions.makeIntegerCast(lhs, archType, false);
        final Expression expr2 = expressions.makeIntegerCast(rhs, archType, false);
        return expressions.makeIntCmp(expr1, ctx.assertionCompare().op, expr2);
    }

    private Expression acceptAssertionValue(LitmusAssertionsParser.AssertionValueContext ctx, boolean right) {
        LitmusAssertionsParser.ConstantContext constant = ctx.constant();
        if (constant != null) {
            if (constant.hex != null) {
                return expressions.makeValue(new BigInteger(constant.hex.getText().substring(2), 16), archType);
            }
            return expressions.parseValue(constant.getText(), archType);
        }
        String name = ctx.varName().getText();
        if (ctx.threadId() != null) {
            return programBuilder.getOrErrorRegister(ctx.threadId().id, name);
        }
        MemoryObject base = programBuilder.getMemoryObject(name);
        checkState(base != null, "uninitialized location %s", name);
        TerminalNode offset = ctx.DigitSequence();
        int o = offset == null ? 0 : Integer.parseInt(offset.getText());
        final IntegerType type = types.getIntegerType(Math.min(64, 8 * base.getKnownSize()));
        return right && offset == null ? base : new FinalMemoryValue(name, type, base, o);
    }
}
