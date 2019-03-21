package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.program.Program;

import java.io.IOException;

import org.antlr.v4.runtime.CharStream;

public interface ParserInterface {

    Program parse(String inputFilePath) throws IOException;
    
    Program parse(CharStream charStream) throws IOException;
}
