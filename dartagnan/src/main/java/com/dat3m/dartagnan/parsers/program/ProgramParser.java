package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;

import java.io.*;

public class ProgramParser {

    private static final String TYPE_LITMUS_AARCH64     = "AARCH64";
    private static final String TYPE_LITMUS_PPC         = "PPC";
    private static final String TYPE_LITMUS_X86         = "X86";
    private static final String TYPE_LITMUS_C           = "C";

    public Program parse(String inputFilePath) throws IOException {
        ParserInterface parser = getConcreteParser(inputFilePath);
        File file = new File(inputFilePath);
        FileInputStream stream = new FileInputStream(file);
        CharStream charStream = CharStreams.fromStream(stream);
        Program program = parser.parse(charStream);
        stream.close();
        program.setName(inputFilePath);
        return program;
    }

    public Program parse(String raw, String format) {
        if(format.equals("pts")){
            return new ParserPorthos().parse(CharStreams.fromString(raw));
        } else if(format.equals("litmus")){
            return getConcreteLitmusParser(raw).parse(CharStreams.fromString(raw));
        }
        throw new ParsingException("Unknown input file type");
    }

    private ParserInterface getConcreteParser(String inputFilePath) throws IOException {
        if(inputFilePath.endsWith("pts")){
            return new ParserPorthos();
        } else if(inputFilePath.endsWith("litmus")){
            return getConcreteLitmusParser(readFirstLine(inputFilePath).toUpperCase());
        }
        throw new ParsingException("Unknown input file type");
    }

    private ParserInterface getConcreteLitmusParser(String programText){
        if(programText.indexOf(TYPE_LITMUS_AARCH64) == 0){
            return new ParserLitmusAArch64();
        } else if(programText.indexOf(TYPE_LITMUS_C) == 0){
            return new ParserLitmusC();
        } else if(programText.indexOf(TYPE_LITMUS_PPC) == 0){
            return new ParserLitmusPPC();
        } else if(programText.indexOf(TYPE_LITMUS_X86) == 0){
            return new ParserLitmusX86();
        }
        throw new ParsingException("Unknown input file type");
    }

    private String readFirstLine(String inputFilePath) throws IOException{
        File file = new File(inputFilePath);
        FileReader fileReader = new FileReader(file);
        BufferedReader bufferedReader = new BufferedReader(fileReader);
        String line = bufferedReader.readLine();
        fileReader.close();
        return line;
    }
}
