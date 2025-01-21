package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.parsers.SqlApplicationLexer;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorSqlApplication;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.DiagnosticErrorListener;
import org.antlr.v4.runtime.ParserRuleContext;

class ParserSqlApplication implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        SqlApplicationLexer lexer = new SqlApplicationLexer(charStream);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        SqlApplication parser = new SqlApplication(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        ParserRuleContext parserEntryPoint = parser.application();
        VisitorSqlApplication visitor = new VisitorSqlApplication();

        // C programs can be compiled to different targets,
        // thus we don't set the architectures.
        return (Program) parserEntryPoint.accept(visitor);
    }
}
