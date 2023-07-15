package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParserErrorListener;
import com.dat3m.dartagnan.parsers.BoogieLexer;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.program.visitors.boogie.VisitorBoogie;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;

class ParserBoogie implements ParserInterface{

    @Override
    public Program parse(CharStream charStream) {
        BoogieLexer lexer = new BoogieLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        BoogieParser parser = new BoogieParser(tokenStream);
        parser.addErrorListener(new ParserErrorListener());
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorBoogie visitor = new VisitorBoogie();

        Program program = (Program) parserEntryPoint.accept(visitor);
        return program;
    }
}
