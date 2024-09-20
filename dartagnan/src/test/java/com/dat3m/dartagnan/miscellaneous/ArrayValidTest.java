package com.dat3m.dartagnan.miscellaneous;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.ProverWithTracker;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

@RunWith(Parameterized.class)
public class ArrayValidTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm wmm = new ParserCat().parse(new File(getRootPath("cat/linux-kernel.cat")));
        try (Stream<Path> fileStream = Files.walk(Paths.get(getTestResourcePath("arrays/ok/")))) {
            return fileStream
                    .filter(Files::isRegularFile)
                    .filter(f -> (f.toString().endsWith("litmus")))
                    .map(f -> new Object[]{f.toString(), wmm})
                    .collect(Collectors.toList());
        }
    }

    private final String path;
    private final Wmm wmm;

    public ArrayValidTest(String path, Wmm wmm) {
        this.path = path;
        this.wmm = wmm;
    }

    @Test
    public void test() {
        try (SolverContext ctx = TestHelper.createContext();
             ProverWithTracker prover = new ProverWithTracker(ctx, "", ProverOptions.GENERATE_MODELS)) {
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = VerificationTask.builder()
                    .withSolverTimeout(60)
                    .withTarget(Arch.LKMM)
                    .build(program, wmm, Property.getDefault());
            AssumeSolver s = AssumeSolver.run(ctx, prover, task);
            assertEquals(PASS, s.getResult());
        } catch (Exception e) {
            fail("Missing resource file");
        }
    }
}
