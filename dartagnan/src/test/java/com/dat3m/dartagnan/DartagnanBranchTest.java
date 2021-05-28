package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.google.common.collect.ImmutableMap;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.analysis.Base.runAnalysis;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class DartagnanBranchTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        ImmutableMap<String, Result> expected = readExpectedResults();
        Settings settings = new Settings(Alias.CFIS, 1, 60);

        Wmm linuxWmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/linux-kernel.cat"));
        Wmm aarch64Wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/aarch64.cat"));

        List<Object[]> data = Files.walk(Paths.get(ResourceHelper.TEST_RESOURCE_PATH + "branch/C/"))
                .filter(Files::isRegularFile)
                .filter(f -> (f.toString().endsWith("litmus")))
                .map(f -> new Object[]{f.toString(), expected.get(f.getFileName().toString()), linuxWmm, settings})
                .collect(Collectors.toList());

        data.addAll(Files.walk(Paths.get(ResourceHelper.TEST_RESOURCE_PATH + "branch/AARCH64/"))
                .filter(Files::isRegularFile)
                .filter(f -> (f.toString().endsWith("litmus")))
                .map(f -> new Object[]{f.toString(), expected.get(f.getFileName().toString()), aarch64Wmm, settings})
                .collect(Collectors.toList()));

        return data;
    }

    private static ImmutableMap<String, Result> readExpectedResults() throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(ResourceHelper.TEST_RESOURCE_PATH + "branch/expected.csv"));
        ImmutableMap.Builder<String, Result> builder = new ImmutableMap.Builder<>();
        String str;
        while((str = reader.readLine()) != null){
            String[] line = str.split(",");
            if(line.length == 2){
                builder.put(line[0], Integer.parseInt(line[1]) == 1 ? FAIL : PASS);
            }
        }
        reader.close();
        return builder.build();
    }

    private final String path;
    private final Wmm wmm;
    private final Settings settings;
    private final Result expected;

    public DartagnanBranchTest(String path, Result expected, Wmm wmm, Settings settings) {
        this.path = path;
        this.expected = expected;
        this.wmm = wmm;
        this.settings = settings;
    }

    @Test
    public void test() {
        try{
            Program program = new ProgramParser().parse(new File(path));
            Context ctx = new Context();
            Solver solver = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
            VerificationTask task = new VerificationTask(program, wmm, Arch.NONE, settings);
            assertEquals(expected, runAnalysis(solver, ctx, task));
            ctx.close();
        } catch (IOException e){
            fail("Missing resource file");
        }
    }
}
