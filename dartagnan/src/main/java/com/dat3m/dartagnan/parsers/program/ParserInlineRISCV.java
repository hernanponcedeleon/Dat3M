package com.dat3m.dartagnan.parsers.program;

import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.exception.UnrecognizedTokenListener;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.InlineRISCVLexer;
import com.dat3m.dartagnan.parsers.InlineRISCVParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorInlineRISCV;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class ParserInlineRISCV {

    private VisitorInlineRISCV visitor;
    private final Function llvmFunction;
    private final Register returnRegister;
    private final ArrayList<Expression> llvmArguments;

    public ParserInlineRISCV(Function function, Register returnRegister, ArrayList<Expression> llvmArguments) {
        this.llvmFunction = function;
        this.returnRegister = returnRegister;
        this.llvmArguments = llvmArguments;
    }

    public List<Event> parse(CharStream charStream) throws ParsingException{
        InlineRISCVLexer lexer = new InlineRISCVLexer(charStream);
        lexer.removeErrorListeners(); // Remove default listeners
        lexer.addErrorListener(new UnrecognizedTokenListener());
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        InlineRISCVParser parser = new InlineRISCVParser(tokenStream);
        parser.removeErrorListeners(); // Remove default listeners
        parser.addErrorListener(new UnrecognizedTokenListener());
        ParserRuleContext parserEntryPoint = parser.asm();
        visitor = new VisitorInlineRISCV(this.llvmFunction,this.returnRegister, this.llvmArguments);
        return (List<Event>) parserEntryPoint.accept(visitor);
    }
}