package com.dat3m.dartagnan.parsers.program;

import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;

<<<<<<< HEAD
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.exception.UnrecognizedTokenListener;
=======
import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.exception.ParsingException;
>>>>>>> ffe9033f5 (better exception handling in parse(), removed useless flag in README, removed useless prints in inlineasm tests)
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.InlineAsmLexer;
import com.dat3m.dartagnan.parsers.InlineAsmParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorInlineAsm;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class ParserInlineAsm {

    private final VisitorInlineAsm visitor;

    public ParserInlineAsm(Function llvmFunction, Register returnRegister, ArrayList<Expression> llvmArguments) {
        this.visitor = new VisitorInlineAsm(llvmFunction, returnRegister, llvmArguments);
    }

    public List<Event> parse(CharStream charStream) throws ParsingException{
        InlineAsmLexer lexer = new InlineAsmLexer(charStream);
        lexer.removeErrorListeners(); // Remove default listeners
        lexer.addErrorListener(new UnrecognizedTokenListener());
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        InlineAsmParser parser = new InlineAsmParser(tokenStream);
        parser.removeErrorListeners(); // Remove default listeners
        parser.addErrorListener(new UnrecognizedTokenListener());
        ParserRuleContext parserEntryPoint = parser.asm();
        return (List<Event>) parserEntryPoint.accept(visitor);
    }
}