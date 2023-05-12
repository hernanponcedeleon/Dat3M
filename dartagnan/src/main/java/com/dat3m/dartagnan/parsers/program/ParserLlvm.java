package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.parsers.LLVMIRLexer;
import com.dat3m.dartagnan.parsers.LLVMIRParser;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorLlvm;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import org.antlr.v4.runtime.BailErrorStrategy;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;

class ParserLlvm implements ParserInterface {

    @Override
    public Program parse(CharStream charStream) {
        LLVMIRLexer lexer = new LLVMIRLexer(charStream);
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        LLVMIRParser parser = new LLVMIRParser(tokenStream);
        parser.setErrorHandler(new BailErrorStrategy());
        ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
        ParserRuleContext parserEntryPoint = parser.compilationUnit();
        VisitorLlvm visitor = new VisitorLlvm(pb);

        Program program = (Program) parserEntryPoint.accept(visitor);
        // LLVM programs can be compiled to different targets,
        // thus we don't set the architectures.
        return program;
    }
}
