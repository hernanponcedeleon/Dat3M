package dartagnan.parsers.utils;

import dartagnan.asserts.AbstractAssert;
import dartagnan.parsers.LitmusAssertionsLexer;
import dartagnan.parsers.LitmusAssertionsParser;
import dartagnan.parsers.visitors.VisitorLitmusAssertions;
import org.antlr.v4.runtime.*;

public class AssertionHelper {

    public static AbstractAssert parseAssertionList(ProgramBuilder programBuilder, String text){
        CharStream charStream = CharStreams.fromString(text);
        LitmusAssertionsLexer lexer = new LitmusAssertionsLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        LitmusAssertionsParser parser = new LitmusAssertionsParser(tokenStream);
        parser.setErrorHandler(new BailErrorStrategy());
        ParserRuleContext parserEntryPoint = parser.assertionList();
        return parserEntryPoint.accept(new VisitorLitmusAssertions(programBuilder));
    }

    public static AbstractAssert parseAssertionFilter(ProgramBuilder programBuilder, String text){
        CharStream charStream = CharStreams.fromString(text);
        LitmusAssertionsLexer lexer = new LitmusAssertionsLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        LitmusAssertionsParser parser = new LitmusAssertionsParser(tokenStream);
        parser.setErrorHandler(new BailErrorStrategy());
        ParserRuleContext parserEntryPoint = parser.assertionFilter();
        return parserEntryPoint.accept(new VisitorLitmusAssertions(programBuilder));
    }
}
