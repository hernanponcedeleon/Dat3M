package dartagnan.parsers;

import dartagnan.parsers.utils.ParsingException;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class ParserResolver {

    public static final String TYPE_LITMUS_PPC = "PPC";
    public static final String TYPE_LITMUS_X86 = "X86";
    public static final String TYPE_LITMUS_ARM = "ARM";
    public static final String TYPE_LITMUS_C   = "C";

    public ParserInterface getParser(String inputFilePath) throws IOException {
        if(inputFilePath.endsWith("litmus")){
            String header = readFirstLine(inputFilePath).toUpperCase();

            if(header.indexOf(TYPE_LITMUS_C) == 0){
                return new ParserLitmusC();
            }
            if(header.indexOf(TYPE_LITMUS_PPC) == 0){
                return new ParserLitmusPPC();
            }
            if(header.indexOf(TYPE_LITMUS_X86) == 0){
                return new ParserLitmusX86();
            }
            // TODO: Other parsers
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
