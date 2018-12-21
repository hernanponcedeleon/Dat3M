package dartagnan.tests;

import dartagnan.Dartagnan;
import dartagnan.parsers.utils.ParsingException;
import org.antlr.v4.runtime.misc.ParseCancellationException;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

public class DartagnanArrayTest {

    public static void main(String[] args) throws IOException{
        Stream<Path> paths = Files.walk(Paths.get("src/dartagnan/tests/resources/arrays"));
        paths.filter(Files::isRegularFile)
                .filter(f -> (f.toString().endsWith("litmus")))
                .forEach(f -> {
                    String test = f.toString();
                    try {
                        Dartagnan.parseProgram(test);
                        throw new RuntimeException("Parsing " + f.toString() + " must throw ParsingException");
                    } catch (ParseCancellationException | ParsingException e) {
                        // Parsing exception thrown as expected
                    } catch (IOException e){
                        e.printStackTrace();
                    }
                });
    }
}
