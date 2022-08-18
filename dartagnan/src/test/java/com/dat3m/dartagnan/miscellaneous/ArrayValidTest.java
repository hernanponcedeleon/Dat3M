package com.dat3m.dartagnan.miscellaneous;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.TwoSolvers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

@RunWith(Parameterized.class)
public class ArrayValidTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/linux-kernel.cat"));
        try (Stream<Path> fileStream = Files.walk(Paths.get(ResourceHelper.TEST_RESOURCE_PATH + "arrays/ok/"))) {
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
             ProverEnvironment prover1 = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS);
             ProverEnvironment prover2 = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
        {
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = VerificationTask.builder()
                    .withSolverTimeout(60)
                    .withTarget(Arch.LKMM)
                    .build(program, wmm, Property.getDefault());
            assertEquals(TwoSolvers.run(ctx, prover1, prover2, task), FAIL);
        } catch (Exception e){
            fail("Missing resource file");
        }
    }
}
