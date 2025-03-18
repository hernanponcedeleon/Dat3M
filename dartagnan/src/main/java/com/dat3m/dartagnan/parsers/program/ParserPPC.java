package com.dat3m.dartagnan.parsers.program;

import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.exception.UnrecognizedTokenListener;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.PPCLexer;
import com.dat3m.dartagnan.parsers.PPCParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorPPC;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class ParserPPC {

    private final VisitorPPC visitor;

    public ParserPPC(Function llvmFunction, Register returnRegister, ArrayList<Expression> llvmArguments) {
        this.visitor = new VisitorPPC(llvmFunction, returnRegister, llvmArguments);
    }

    public List<Event> parse(CharStream charStream) throws ParsingException, ProgramProcessingException {
        PPCLexer lexer = new PPCLexer(charStream);
        lexer.removeErrorListeners(); // Remove default listeners
        lexer.addErrorListener(new UnrecognizedTokenListener());
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        PPCParser parser = new PPCParser(tokenStream);
        parser.removeErrorListeners(); // Remove default listeners
        parser.addErrorListener(new UnrecognizedTokenListener());
        ParserRuleContext parserEntryPoint = parser.asm();
        return (List<Event>) parserEntryPoint.accept(visitor);
    }
}