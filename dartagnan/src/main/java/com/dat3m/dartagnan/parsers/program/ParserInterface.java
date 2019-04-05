package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;

public interface ParserInterface {

    Program parse(CharStream charStream);
}
