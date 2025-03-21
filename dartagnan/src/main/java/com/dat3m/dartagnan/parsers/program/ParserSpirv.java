package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.parsers.*;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorSpirv;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.*;

public class ParserSpirv implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        SpirvLexer lexer = new SpirvLexer(charStream);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        SpirvParser parser = new SpirvParser(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        parser.addErrorListener(new DiagnosticErrorListener(true));
        ParserRuleContext parserEntryPoint = parser.spv();
        VisitorSpirv visitor = new VisitorSpirv();

        return parserEntryPoint.accept(visitor);
    }
}
