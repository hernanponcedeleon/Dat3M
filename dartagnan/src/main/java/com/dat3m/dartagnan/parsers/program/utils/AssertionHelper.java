package com.dat3m.dartagnan.parsers.program.utils;

import com.dat3m.dartagnan.program.specification.AbstractAssert;
import com.dat3m.dartagnan.parsers.LitmusAssertionsLexer;
import com.dat3m.dartagnan.parsers.LitmusAssertionsParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusAssertions;
import org.antlr.v4.runtime.*;

public class AssertionHelper {

    public static AbstractAssert parseAssertionList(ProgramBuilder programBuilder, String text){
        CharStream charStream = CharStreams.fromString(text);
        LitmusAssertionsLexer lexer = new LitmusAssertionsLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        LitmusAssertionsParser parser = new LitmusAssertionsParser(tokenStream);
        ParserRuleContext parserEntryPoint = parser.assertionList();
        return parserEntryPoint.accept(new VisitorLitmusAssertions(programBuilder));
    }

    public static AbstractAssert parseAssertionFilter(ProgramBuilder programBuilder, String text){
        CharStream charStream = CharStreams.fromString(text);
        LitmusAssertionsLexer lexer = new LitmusAssertionsLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        LitmusAssertionsParser parser = new LitmusAssertionsParser(tokenStream);
        ParserRuleContext parserEntryPoint = parser.assertionFilter();
        AbstractAssert filter = parserEntryPoint.accept(new VisitorLitmusAssertions(programBuilder));
        filter.setType(AbstractAssert.ASSERT_TYPE_FORALL);
        return filter;
    }
}
