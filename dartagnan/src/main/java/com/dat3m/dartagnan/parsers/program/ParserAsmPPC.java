package com.dat3m.dartagnan.parsers.program;

import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.exception.UnrecognizedTokenListener;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.AsmPPCLexer;
import com.dat3m.dartagnan.parsers.AsmPPCParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorAsmPPC;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class ParserAsmPPC extends ParserAsm{

    private final VisitorAsmPPC visitor;

    public ParserAsmPPC(Function llvmFunction, Register returnRegister, ArrayList<Expression> llvmArguments) {
        this.visitor = new VisitorAsmPPC(llvmFunction, returnRegister, llvmArguments);
    }

    @Override
    public List<Event> parse(CharStream charStream) throws ParsingException, UnsupportedOperationException{
        AsmPPCLexer lexer = new AsmPPCLexer(charStream);
        lexer.removeErrorListeners(); // Remove default listeners
        lexer.addErrorListener(new UnrecognizedTokenListener());
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        AsmPPCParser parser = new AsmPPCParser(tokenStream);
        parser.removeErrorListeners(); // Remove default listeners
        parser.addErrorListener(new UnrecognizedTokenListener());
        ParserRuleContext parserEntryPoint = parser.asm();
        return (List<Event>) parserEntryPoint.accept(visitor);
    }
}