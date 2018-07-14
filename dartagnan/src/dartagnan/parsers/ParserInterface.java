package dartagnan.parsers;

import dartagnan.program.Program;

import java.io.IOException;

public interface ParserInterface {

    Program parse(String inputFilePath) throws IOException;
}
