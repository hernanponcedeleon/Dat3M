package com.dat3m.dartagnan.parsers.program;

import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.exception.UnrecognizedTokenListener;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.ArmLexer;
import com.dat3m.dartagnan.parsers.ArmParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorArm;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class ParserArm extends ParserAsm{

    private final VisitorArm visitor;

    public ParserArm(Function llvmFunction, Register returnRegister, ArrayList<Expression> llvmArguments) {
        this.visitor = new VisitorArm(llvmFunction, returnRegister, llvmArguments);
    }
    
    @Override
    public List<Event> parse(CharStream charStream) throws ParsingException{
        ArmLexer lexer = new ArmLexer(charStream);
        lexer.removeErrorListeners(); // Remove default listeners
        lexer.addErrorListener(new UnrecognizedTokenListener());
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        ArmParser parser = new ArmParser(tokenStream);
        parser.removeErrorListeners(); // Remove default listeners
        parser.addErrorListener(new UnrecognizedTokenListener());
        ParserRuleContext parserEntryPoint = parser.asm();
        return (List<Event>) parserEntryPoint.accept(visitor);
    }
}