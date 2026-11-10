package com.dat3m.dartagnan.frontend.llvm;

import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.parsers.LLVMIRLexer;
import com.dat3m.dartagnan.parsers.LLVMIRParser;
import com.dat3m.dartagnan.parsers.LLVMIRParser.*;
import com.dat3m.dartagnan.frontend.ParserInterface;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.*;

public class ParserLlvm implements ParserInterface<Program> {

    @Override
    public Program parse(CharStream charStream) {
        LLVMIRLexer lexer = new LLVMIRLexer(charStream);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LLVMIRParser parser = new LLVMIRParser(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        CompilationUnitContext parserEntryPoint = parser.compilationUnit();
        VisitorLlvm visitor = new VisitorLlvm(parserEntryPoint);

        visitor.visitCompilationUnit(parserEntryPoint);
        // LLVM programs can be compiled to different targets,
        // thus we don't set the architectures.
        return visitor.buildProgram();
    }
}
