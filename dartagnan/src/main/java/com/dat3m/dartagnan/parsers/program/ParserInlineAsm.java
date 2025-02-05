package com.dat3m.dartagnan.parsers.program;

import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.exception.UnrecognizedTokenListener;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.InlineAsmLexer;
import com.dat3m.dartagnan.parsers.InlineAsmParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorInlineAsm;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class ParserInlineAsm {

    private final VisitorInlineAsm visitor;

<<<<<<< HEAD
    public ParserInlineAsm(Function llvmFunction, Register returnRegister, ArrayList<Expression> llvmArguments) {
        this.visitor = new VisitorInlineAsm(llvmFunction, returnRegister, llvmArguments);
=======
    public ParserInlineAsm(Function function, Register returnRegister,Type returnType,ArrayList<Expression> argumentsRegisterAddresses){
        this.llvmFunction = function;
        this.returnRegister = returnRegister;
        this.returnType = returnType;
        this.argumentsRegisterAddresses = argumentsRegisterAddresses;
>>>>>>> 2d85efd32 (first cleaning pass, public and private, removed getEvents in InlineParser, removed unsupported operators and more consistent names in .g4)
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