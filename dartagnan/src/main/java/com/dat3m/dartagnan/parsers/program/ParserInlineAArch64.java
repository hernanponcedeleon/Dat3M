package com.dat3m.dartagnan.parsers.program;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.DiagnosticErrorListener;
import org.antlr.v4.runtime.ParserRuleContext;

import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.parsers.InlineAArch64Lexer;
import com.dat3m.dartagnan.parsers.InlineAArch64Parser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorInlineAArch64;
import com.dat3m.dartagnan.program.Program;

public class ParserInlineAArch64 implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        InlineAArch64Lexer lexer = new InlineAArch64Lexer(charStream);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        InlineAArch64Parser parser = new InlineAArch64Parser(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        ParserRuleContext parserEntryPoint = parser.asm();
        VisitorInlineAArch64 visitor = new VisitorInlineAArch64();
        return (Program) parserEntryPoint.accept(visitor);
    }
}