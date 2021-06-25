package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.program.Program;

import static com.dat3m.dartagnan.parsers.program.utils.Compilation.compile;

import java.io.*;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;

public class ProgramParser {

    private static final String TYPE_LITMUS_AARCH64     = "AARCH64";
    private static final String TYPE_LITMUS_PPC         = "PPC";
    private static final String TYPE_LITMUS_X86         = "X86";
    private static final String TYPE_LITMUS_C           = "C";

    public Program parse(File file) throws IOException {
    	if(file.getPath().endsWith("c")) {
            // First time we compiler with standard atomic header to catch compilation problems
            compile(file, false);
            // Then we use our own headers
            compile(file, true);
            String name = file.getName().substring(0, file.getName().lastIndexOf('.'));
            return new ProgramParser().parse(new File(System.getenv().get("DAT3M_HOME") + "/output/" + name + ".bpl"));    		
    	}
        FileInputStream stream = new FileInputStream(file);
        ParserInterface parser = getConcreteParser(file);
        CharStream charStream = CharStreams.fromStream(stream);
        Program program = parser.parse(charStream);
        stream.close();
        program.setName(file.getName());
        return program;
    }

    public Program parse(String raw, String format) throws IOException {
        switch (format) {
        	case "c":
				File CFile = File.createTempFile("dat3m", ".c");
        		String name = CFile.getName().substring(0, CFile.getName().lastIndexOf('.'));
			    FileWriter writer = new FileWriter(CFile);
			    writer.write(raw);
			    writer.close();
	            // First time we compiler with standard atomic header to catch compilation problems
	            compile(CFile, false);
	            // Then we use our own headers
	            compile(CFile, true);
	            File BplFile = new File(System.getenv().get("DAT3M_HOME") + "/output/" + name + ".bpl");
	            Program p = new ProgramParser().parse(BplFile);
	            BplFile.delete();
	            return p;
            case "bpl":
                return new ParserBoogie().parse(CharStreams.fromString(raw));
            case "litmus":
                return getConcreteLitmusParser(raw.toUpperCase()).parse(CharStreams.fromString(raw));
        }
        throw new ParsingException("Unknown input file type");
    }

    private ParserInterface getConcreteParser(File file) throws IOException {
        String name = file.getName();
        String format = name.substring(name.lastIndexOf(".") + 1);
        switch (format) {
            case "bpl":
                return new ParserBoogie();
            case "litmus":
                return getConcreteLitmusParser(readFirstLine(file).toUpperCase());
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

    private String readFirstLine(File file) throws IOException{
        FileReader fileReader = new FileReader(file);
        BufferedReader bufferedReader = new BufferedReader(fileReader);
        String line = bufferedReader.readLine();
        fileReader.close();
        return line;
    }
}
