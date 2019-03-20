package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.program.Program;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class ProgramParser {

    private static final String TYPE_LITMUS_AARCH64     = "AARCH64";
    private static final String TYPE_LITMUS_PPC         = "PPC";
    private static final String TYPE_LITMUS_X86         = "X86";
    private static final String TYPE_LITMUS_C           = "C";

    public Program parse(String inputFilePath) throws IOException {
        ParserInterface parser = null;

        if(inputFilePath.endsWith("pts")){
            parser = new ParserPorthos();

        } else if(inputFilePath.endsWith("litmus")){
            String header = readFirstLine(inputFilePath).toUpperCase();
            if(header.indexOf(TYPE_LITMUS_AARCH64) == 0){
                parser = new ParserLitmusAArch64();
            } else if(header.indexOf(TYPE_LITMUS_C) == 0){
                parser = new ParserLitmusC();
            } else if(header.indexOf(TYPE_LITMUS_PPC) == 0){
                parser = new ParserLitmusPPC();
            } else if(header.indexOf(TYPE_LITMUS_X86) == 0){
                parser = new ParserLitmusX86();
            }
        }

        if(parser != null){
            return parser.parse(inputFilePath);
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
