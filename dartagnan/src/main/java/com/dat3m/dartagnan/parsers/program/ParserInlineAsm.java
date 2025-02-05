package com.dat3m.dartagnan.parsers.program;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.DiagnosticErrorListener;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.parsers.InlineAsmLexer;
import com.dat3m.dartagnan.parsers.InlineAsmParser;
import com.dat3m.dartagnan.parsers.program.visitors.VisitorInlineAsm;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;

public class ParserInlineAsm {

    private VisitorInlineAsm visitor;
    private final Function llvmFunction;
    private final Register returnRegister;
    private final Type returnType;
    private final ArrayList<Expression> argumentsRegisterAddresses;
    private static final Logger logger = LogManager.getLogger(ParserInlineAsm.class);
    private final Program program;

    public class UnrecognizedTokenListener extends BaseErrorListener {

        private boolean errorOccurred = false;

        @Override
        public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol,
                int line, int charPositionInLine, String msg, RecognitionException e) {
            logger.warn("Syntax error: " + msg);
            logger.warn("offending Symbol is " + offendingSymbol);
            logger.warn("at " + line);
            logger.warn("char position " + charPositionInLine);
            this.errorOccurred = true;
        }

        public boolean hasErrorOccurred() {
            return this.errorOccurred;
        }
    }

    public ParserInlineAsm(Function function, Register returnRegister, Type returnType, ArrayList<Expression> argumentsRegisterAddresses, Program program) {
        this.llvmFunction = function;
        this.returnRegister = returnRegister;
        this.returnType = returnType;
        this.argumentsRegisterAddresses = argumentsRegisterAddresses;
        this.program = program;
    }

    public List<Event> parse(CharStream charStream) {
        InlineAsmLexer lexer = new InlineAsmLexer(charStream);
        lexer.removeErrorListeners();
        UnrecognizedTokenListener errorListener = new UnrecognizedTokenListener();
        lexer.addErrorListener(new DiagnosticErrorListener(true));

        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        InlineAsmParser parser = new InlineAsmParser(tokenStream);
        parser.removeErrorListeners();
        parser.addErrorListener(errorListener);

        ParserRuleContext parserEntryPoint = parser.asm();

        if (errorListener.hasErrorOccurred()) {
            logger.warn("UNRECOGNIZED TOKEN FOUND");
            Event event = EventFactory.newLocal(this.returnRegister, this.program.newConstant(returnType));
            return new ArrayList(Arrays.asList(event));
        }
        visitor = new VisitorInlineAsm(this.llvmFunction, this.returnRegister, this.returnType, this.argumentsRegisterAddresses);
        return (List<Event>) parserEntryPoint.accept(visitor);
    }
}