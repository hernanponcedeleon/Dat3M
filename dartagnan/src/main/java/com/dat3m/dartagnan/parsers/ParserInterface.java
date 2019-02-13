package com.dat3m.dartagnan.parsers;

import com.dat3m.dartagnan.program.Program;

import java.io.IOException;

public interface ParserInterface {

    Program parse(String inputFilePath) throws IOException;
}
