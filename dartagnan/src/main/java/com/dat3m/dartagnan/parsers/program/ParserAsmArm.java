package com.dat3m.dartagnan.parsers.program;

import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.exception.UnrecognizedTokenListener;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.AsmArmLexer;
import com.dat3m.dartagnan.parsers.AsmArmParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorAsmArm;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class ParserAsmArm extends ParserAsm{

    private final VisitorAsmArm visitor;

    public ParserAsmArm(Function llvmFunction, Register returnRegister, ArrayList<Expression> llvmArguments) {
        this.visitor = new VisitorAsmArm(llvmFunction, returnRegister, llvmArguments);
    }
    
    @Override
    public List<Event> parse(CharStream charStream) throws ParsingException, UnsupportedOperationException{
        AsmArmLexer lexer = new AsmArmLexer(charStream);
        lexer.removeErrorListeners(); // Remove default listeners
        lexer.addErrorListener(new UnrecognizedTokenListener());
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        AsmArmParser parser = new AsmArmParser(tokenStream);
        parser.removeErrorListeners(); // Remove default listeners
        parser.addErrorListener(new UnrecognizedTokenListener());
        ParserRuleContext parserEntryPoint = parser.asm();
        return (List<Event>) parserEntryPoint.accept(visitor);
    }
}