package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.program.Program;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import org.antlr.v4.runtime.CharStream;

public class ProgramParser {

    private static final String TYPE_LITMUS_AARCH64     = "AARCH64";
    private static final String TYPE_LITMUS_PPC         = "PPC";
    private static final String TYPE_LITMUS_X86         = "X86";
    private static final String TYPE_LITMUS_C           = "C";

    public Program parse(String inputFilePath) throws IOException {
        ParserInterface parser = null;
        String format = inputFilePath.endsWith("pts") ? "pts" : "litmus";
        parser = parserResolver(readFirstLine(inputFilePath).toUpperCase(), format);
        if(parser != null){
            return parser.parse(inputFilePath);
        }
        throw new ParsingException("Unknown input file type");
    }

    public Program parse(CharStream input, String format) throws IOException {
        ParserInterface parser = null;
        parser = parserResolver(input.toString().toUpperCase(), format);
        if(parser != null){
            return parser.parse(input);
        }
        throw new ParsingException("Unknown input file type");
    }

	public ParserInterface parserResolver(String chooser, String format) {
		ParserInterface parser = null;
		
		if(format.equals("pts")){
            parser = new ParserPorthos();

        } else if(format.equals("litmus")){
            if(chooser.indexOf(TYPE_LITMUS_AARCH64) == 0){
                parser = new ParserLitmusAArch64();
            } else if(chooser.indexOf(TYPE_LITMUS_C) == 0){
                parser = new ParserLitmusC();
            } else if(chooser.indexOf(TYPE_LITMUS_PPC) == 0){
                parser = new ParserLitmusPPC();
            } else if(chooser.indexOf(TYPE_LITMUS_X86) == 0){
                parser = new ParserLitmusX86();
            }
        }
		return parser;
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
