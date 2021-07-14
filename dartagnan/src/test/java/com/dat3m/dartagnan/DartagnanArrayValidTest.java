package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.SolverContext;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.analysis.Base.runAnalysis;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class DartagnanArrayValidTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/linux-kernel.cat"));
        Settings settings = new Settings(Alias.CFIS, 1, 60);
        return Files.walk(Paths.get(ResourceHelper.TEST_RESOURCE_PATH + "arrays/ok/"))
                .filter(Files::isRegularFile)
                .filter(f -> (f.toString().endsWith("litmus")))
                .map(f -> new Object[]{f.toString(), wmm, settings})
                .collect(Collectors.toList());
    }

    private final String path;
    private final Wmm wmm;
    private final Settings settings;
    private SolverContext ctx;

    public DartagnanArrayValidTest(String path, Wmm wmm, Settings settings) {
        this.path = path;
        this.wmm = wmm;
        this.settings = settings;
    }

    private void initSolverContext() throws Exception {
        Configuration config = Configuration.builder().build();
        ctx = SolverContextFactory.createSolverContext(
                config, 
                BasicLogManager.create(config), 
                ShutdownManager.create().getNotifier(), 
                Solvers.Z3);
    }
    
    @Test
    public void test() {
        try{
            Program program = new ProgramParser().parse(new File(path));
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            initSolverContext();
            assertEquals(runAnalysis(ctx, task), FAIL);
            ctx.close();
        } catch (Exception e){
            fail("Missing resource file");
        }
    }
}
