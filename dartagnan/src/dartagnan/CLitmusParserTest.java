package dartagnan;

import com.microsoft.z3.Z3Exception;
import dartagnan.parsers.ParserInterface;
import dartagnan.parsers.ParserLitmusC;
import dartagnan.parsers.ParserResolver;
import dartagnan.program.Program;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

public class CLitmusParserTest {

    public static void main(String[] args) throws Z3Exception, IOException {
        ParserResolver parserResolver = new ParserResolver();

        try(Stream<Path> paths = Files.walk(Paths.get("litmus/C"))){
            paths
                    .filter(Files::isRegularFile)
                    .filter(f -> (f.toString().endsWith("litmus")))
                    .forEach(f -> {
                        String inputFilePath = f.toString();

                        try{
                            ParserInterface parser = null;
                            try{
                                parser = parserResolver.getParser(inputFilePath);
                            } catch (Exception e){
                                e.printStackTrace();
                            }

                            if(parser instanceof ParserLitmusC){
                                Program program = parser.parse(inputFilePath);
                                System.out.println(inputFilePath);
                            }

                        } catch (Exception e){
                            System.err.println(inputFilePath);
                        }
                    });

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}
