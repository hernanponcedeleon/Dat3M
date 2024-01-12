package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParserErrorListener;
import com.dat3m.dartagnan.parsers.*;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorSpirv;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.DiagnosticErrorListener;
import org.antlr.v4.runtime.ParserRuleContext;

public class ParserSpirv implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        SpirvLexer lexer = new SpirvLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        SpirvParser parser = new SpirvParser(tokenStream);
        parser.addErrorListener(new DiagnosticErrorListener(true));
        parser.addErrorListener(new ParserErrorListener());
        ParserRuleContext parserEntryPoint = parser.spv();
        VisitorSpirv visitor = new VisitorSpirv();

        parserEntryPoint.accept(visitor);
        return visitor.buildProgram();
    }
}
