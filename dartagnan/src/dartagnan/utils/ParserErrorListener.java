package dartagnan.utils;

import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.ATNConfigSet;
import org.antlr.v4.runtime.dfa.DFA;

/*
 * By default, antlr4 ignores some parsing errors, which might is execution of incorrectly parsed tests.
 * This listener is used to check for such errors, and throw an exception if one occurred.
 */
public class ParserErrorListener extends BaseErrorListener implements ANTLRErrorListener {

    private boolean error = false;

    public boolean hasError(){
        return error;
    }

    public void syntaxError(Recognizer<?, ?> var1, Object var2, int var3, int var4, String var5, RecognitionException var6){
        error = true;
    }

    public void reportContextSensitivity(Parser var1, DFA var2, int var3, int var4, int var5, ATNConfigSet var6){
        error = true;
    }
}