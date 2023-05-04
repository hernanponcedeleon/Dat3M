package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.parsers.LitmusCLexer;
import com.dat3m.dartagnan.parsers.LitmusCParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusC;
import com.dat3m.dartagnan.program.Program;

import org.antlr.v4.runtime.*;

class ParserLitmusC implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusCLexer lexer = new LitmusCLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusCParser parser = new LitmusCParser(tokenStream);
        parser.setErrorHandler(new BailErrorStrategy());
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusC visitor = new VisitorLitmusC();
        return (Program) parserEntryPoint.accept(visitor);
    }
}
