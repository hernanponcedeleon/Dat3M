package com.dat3m.dartagnan.exception;

import org.antlr.v4.runtime.ConsoleErrorListener;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;

public class ParserErrorListener extends ConsoleErrorListener {

    public void syntaxError(
            Recognizer<?, ?> recognizer,
            Object offendingSymbol,
            int line,
            int charPositionInLine,
            String msg,
            RecognitionException e
    ) throws ParsingException {
        throw new ParsingException("line " + line + ":" + charPositionInLine + " " + msg);
    }
}