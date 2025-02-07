package com.dat3m.dartagnan.parsers.program;

import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.exception.UnrecognizedTokenListener;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.parsers.InlineAsmLexer;
import com.dat3m.dartagnan.parsers.InlineAsmParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorInlineAsm;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class ParserInlineAsm {

    private VisitorInlineAsm visitor;
    private final Function llvmFunction;
    private final Register returnRegister;
    private final Type returnType;
    private final ArrayList<Expression> argumentsRegisterAddresses;

    public ParserInlineAsm(Function function, Register returnRegister, Type returnType, ArrayList<Expression> argumentsRegisterAddresses) {
        this.llvmFunction = function;
        this.returnRegister = returnRegister;
        this.returnType = returnType;
        this.argumentsRegisterAddresses = argumentsRegisterAddresses;
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
        visitor = new VisitorInlineAsm(this.llvmFunction,this.returnRegister, this.returnType, this.argumentsRegisterAddresses);
        return (List<Event>) parserEntryPoint.accept(visitor);
    }
}