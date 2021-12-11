package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.program.Program;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;

import java.io.*;

import static com.dat3m.dartagnan.parsers.program.utils.Compilation.compileWithClang;
import static com.dat3m.dartagnan.parsers.program.utils.Compilation.compileWithSmack;

public class ProgramParser {

    private static final String TYPE_LITMUS_AARCH64     = "AARCH64";
    private static final String TYPE_LITMUS_PPC         = "PPC";
    private static final String TYPE_LITMUS_X86         = "X86";
    private static final String TYPE_LITMUS_C           = "C";

    public Program parse(File file) throws Exception {
    	if(file.getPath().endsWith("c")) {
            compileWithClang(file);
            compileWithSmack(file);
            String name = file.getName().substring(0, file.getName().lastIndexOf('.'));
            return new ProgramParser().parse(new File(System.getenv("DAT3M_HOME") + "/output/" + name + ".bpl"));    		
    	}

        Program program;
        try (FileInputStream stream = new FileInputStream(file)) {
            ParserInterface parser = getConcreteParser(file);
            CharStream charStream = CharStreams.fromStream(stream);
            program = parser.parse(charStream);
        }
        program.setName(file.getName());
        return program;
    }

    public Program parse(String raw, String format) throws Exception {
        switch (format) {
        	case "c":
        	case "i":
				File CFile = File.createTempFile("dat3m", ".c");
				CFile.deleteOnExit();
        		String name = CFile.getName().substring(0, CFile.getName().lastIndexOf('.'));
                try (FileWriter writer = new FileWriter(CFile)) {
                    writer.write(raw);
                }
                compileWithClang(CFile);
	            compileWithSmack(CFile);
	            File BplFile = new File(System.getenv("DAT3M_HOME") + "/output/" + name + ".bpl");
	            BplFile.deleteOnExit();
	            Program p = new ProgramParser().parse(BplFile);
	            CFile.delete();
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
        String line;
        try (BufferedReader bufferedReader = new BufferedReader(new FileReader(file))) {
            line = bufferedReader.readLine();
        }
        return line;
    }
}
