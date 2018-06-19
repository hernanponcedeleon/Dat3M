package dartagnan.parsers;

import dartagnan.program.Program;

public interface ParserInterface {

    Program parse(String inputFilePath) throws Exception;
}
