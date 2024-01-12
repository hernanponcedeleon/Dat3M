package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParserErrorListener;
import com.dat3m.dartagnan.parsers.LitmusAArch64Lexer;
import com.dat3m.dartagnan.parsers.LitmusAArch64Parser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLitmusAArch64;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.DiagnosticErrorListener;
import org.antlr.v4.runtime.ParserRuleContext;

class ParserLitmusAArch64 implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LitmusAArch64Lexer lexer = new LitmusAArch64Lexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LitmusAArch64Parser parser = new LitmusAArch64Parser(tokenStream);
        parser.addErrorListener(new DiagnosticErrorListener(true));
        parser.addErrorListener(new ParserErrorListener());
        ParserRuleContext parserEntryPoint = parser.main();
        VisitorLitmusAArch64 visitor = new VisitorLitmusAArch64();

        return (Program) parserEntryPoint.accept(visitor);
    }
}
