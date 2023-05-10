package com.dat3m.dartagnan.parsers.program.utils;

import com.dat3m.dartagnan.parsers.LitmusAssertionsLexer;
import com.dat3m.dartagnan.parsers.LitmusAssertionsParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusAssertions;
import org.antlr.v4.runtime.*;

public class AssertionHelper {

    public static void parseAssertion(ProgramBuilder programBuilder, String text){
        CharStream charStream = CharStreams.fromString(text);
        LitmusAssertionsLexer lexer = new LitmusAssertionsLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        LitmusAssertionsParser parser = new LitmusAssertionsParser(tokenStream);
        ParserRuleContext parserEntryPoint = parser.assertionList();
        parserEntryPoint.accept(new VisitorLitmusAssertions(programBuilder));
    }
}
