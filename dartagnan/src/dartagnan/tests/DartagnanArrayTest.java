package dartagnan.tests;

import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import dartagnan.Dartagnan;
import dartagnan.parsers.cat.ParserCat;
import dartagnan.parsers.utils.ParsingException;
import dartagnan.program.Program;
import dartagnan.wmm.Wmm;
import org.antlr.v4.runtime.misc.ParseCancellationException;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

public class DartagnanArrayTest {

    public static void main(String[] args) throws IOException{
        Stream<Path> pathError = Files.walk(Paths.get("src/dartagnan/tests/resources/arrays/error"));
        pathError.filter(Files::isRegularFile)
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

        Stream<Path> pathOk = Files.walk(Paths.get("src/dartagnan/tests/resources/arrays/ok"));
        Wmm wmm = new ParserCat().parse("cat/linux-kernel.cat", "sc");

        pathOk.filter(Files::isRegularFile)
                .filter(f -> (f.toString().endsWith("litmus")))
                .forEach(f -> {
                    String test = f.toString();
                    try{
                        Program program = Dartagnan.parseProgram(test);
                        Context ctx = new Context();
                        Solver solver = ctx.mkSolver(ctx.mkTactic(Dartagnan.TACTIC));
                        boolean result = Dartagnan.testProgram(solver, ctx, program, wmm, "sc", 2, true, false);
                        if(!result){
                            throw new RuntimeException("Test " + f.toString() + " must return result true");
                        }
                    } catch (IOException e){
                        e.printStackTrace();
                        throw new RuntimeException(e.getMessage());
                    }
                });
    }
}
