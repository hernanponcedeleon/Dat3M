package com.dat3m.dartagnan.drunner;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.encoding.ProverWithTracker;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class ModelTest extends AbstractTest {

    private static final boolean PRINT_EVENTS = true;

    private final String modelPath = getRootPath("cat/spirv-experiment.cat");
    private final String programPath;
    private final Result expected;

    public ModelTest(String file, Result expectedRace, Result expectedRaceFilter, Result expected) {
        this.programPath = Path.of(basePath, "spirv-verification", file + ".spv.dis").toString();
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}, {3}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSunwg-WdvRelSunwg_RdvAcqSunwg-RdvAcqSunwg",PASS,PASS,PASS},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSun-WdvRelSunwg_RdvAcqSunwg-RdvAcqSun",PASS,PASS,PASS},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSwg-WdvRelSunwg_RdvAcqSunwg-RdvAcqSwg",PASS,PASS,PASS},
                {"/atomic/mp/semsc/mp-[diff-wg]-[sb-sb]_WdvRx-WdvRelSunwg_RdvAcqSunwg-RdvRx",PASS,PASS,PASS},
                {"/atomic/mp/semsc/mp-[diff-wg]-[sb-sb]_WdvRx-WdvRelSun_RdvAcqSun-RdvRx",PASS,PASS,PASS},
                {"/atomic/mp/semscavvis/mp-[diff-wg]-[sb-sb]_WdvRx-WdvRelSunSav_RdvAcqSunSvis-RdvRx",PASS,PASS,PASS},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSun-WdvRelSun_RdvAcqSun-RdvAcqSun",PASS,PASS,PASS},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSwg-WdvRelSun_RdvAcqSun-RdvAcqSwg",PASS,PASS,PASS}, //
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSunwg-WdvRelSun_RdvAcqSun-RdvAcqSunwg",PASS,PASS,PASS},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WdvRelSunSav-WdvRelSunSav_RdvAcqSunSvis-RdvAcqSunSvis",PASS,PASS,PASS},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WdvRelSwgSav-WdvRelSunSav_RdvAcqSunSvis-RdvAcqSwgSvis",PASS,PASS,PASS},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSun-WdvRelSunSav_RdvAcqSunSvis-RdvAcqSun",PASS,PASS,PASS},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSunSav-WdvRelSun_RdvAcqSun-RdvAcqSunSvis",PASS,PASS,PASS},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSwg-WdvRelSunSav_RdvAcqSunSvis-RdvAcqSwg",PASS,PASS,PASS},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSwgSav-WdvRelSun_RdvAcqSun-RdvAcqSwgSvis",PASS,PASS,PASS},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSwg-WdvRelSwg_RdvAcqSwg-RdvAcqSwg",PASS,PASS,FAIL}, //
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSunwg-WdvRelSwg_RdvAcqSwg-RdvAcqSunwg",PASS,PASS,FAIL},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WdvRelSwgSav-WdvRelSwgSav_RdvAcqSwgSvis-RdvAcqSwgSvis",PASS,PASS,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSwg-WdvRelSwgSav_RdvAcqSwgSvis-RdvAcqSwg",PASS,PASS,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSwgSav-WdvRelSwg_RdvAcqSwg-RdvAcqSwgSvis",PASS,PASS,FAIL},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WdvRelSunSav-WdvRelSwgSav_RdvAcqSwgSvis-RdvAcqSunSvis",PASS,PASS,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSunSav-WdvRelSwg_RdvAcqSwg-RdvAcqSunSvis",PASS,PASS,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSun-WdvRelSwg_RdvAcqSwg-RdvAcqSun",PASS,PASS,FAIL}, //
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSun-WdvRelSwgSav_RdvAcqSwgSvis-RdvAcqSun",PASS,PASS,FAIL},
                {"/atomic/mp/semsc/mp-[diff-wg]-[sb-sb]_WdvRx-WdvRelSwg_RdvAcqSwg-RdvRx",PASS,PASS,FAIL},
                {"/atomic/mp/semscavvis/mp-[diff-wg]-[sb-sb]_WdvRx-WdvRelSwgSav_RdvAcqSwgSvis-RdvRx",PASS,PASS,FAIL},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WwgRelSunSav-WdvRelSunSav_RdvAcqSunSvis-RwgAcqSunSvis",FAIL,PASS,PASS},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WwgRelSwgSav-WdvRelSunSav_RdvAcqSunSvis-RwgAcqSwgSvis",FAIL,PASS,PASS},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSun-WdvRelSunSav_RdvAcqSunSvis-RwgAcqSun",FAIL,PASS,PASS},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSwg-WdvRelSunSav_RdvAcqSunSvis-RwgAcqSwg",FAIL,PASS,PASS},
                {"/atomic/mp/semscavvis/mp-[diff-wg]-[sb-sb]_WwgRx-WdvRelSunSav_RdvAcqSunSvis-RwgRx",FAIL,PASS,PASS},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WwgRelSunSav-WdvRelSwgSav_RdvAcqSwgSvis-RwgAcqSunSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSunSav-WdvRelSun_RdvAcqSun-RwgAcqSunSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSunSav-WdvRelSwg_RdvAcqSwg-RwgAcqSunSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc/mp-[diff-wg]-[sb-sb]_WwgRx-WdvRelSunwg_RdvAcqSunwg-RwgRx",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc/mp-[diff-wg]-[sb-sb]_WwgRx-WdvRelSun_RdvAcqSun-RwgRx",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc/mp-[diff-wg]-[sb-sb]_WwgRx-WdvRelSwg_RdvAcqSwg-RwgRx",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSun-WdvRelSun_RdvAcqSun-RwgAcqSun",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSun-WdvRelSwg_RdvAcqSwg-RwgAcqSun",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSwg-WdvRelSun_RdvAcqSun-RwgAcqSwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSwg-WdvRelSwg_RdvAcqSwg-RwgAcqSwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSun-WdvRelSunwg_RdvAcqSunwg-RwgAcqSun",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSunwg-WdvRelSun_RdvAcqSun-RwgAcqSunwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSunwg-WdvRelSunwg_RdvAcqSunwg-RwgAcqSunwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSunwg-WdvRelSwg_RdvAcqSwg-RwgAcqSunwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSwg-WdvRelSunwg_RdvAcqSunwg-RwgAcqSwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis/mp-[diff-wg]-[sb-sb]_WwgRx-WdvRelSwgSav_RdvAcqSwgSvis-RwgRx",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WwgRelSwgSav-WdvRelSwgSav_RdvAcqSwgSvis-RwgAcqSwgSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSun-WdvRelSwgSav_RdvAcqSwgSvis-RwgAcqSun",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSwg-WdvRelSwgSav_RdvAcqSwgSvis-RwgAcqSwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSwgSav-WdvRelSun_RdvAcqSun-RwgAcqSwgSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSwgSav-WdvRelSwg_RdvAcqSwg-RwgAcqSwgSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc/mp-[diff-wg]-[sb-sb]_WdvRx-WwgRelSunwg_RwgAcqSunwg-RdvRx",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc/mp-[diff-wg]-[sb-sb]_WdvRx-WwgRelSun_RwgAcqSun-RdvRx",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc/mp-[diff-wg]-[sb-sb]_WdvRx-WwgRelSwg_RwgAcqSwg-RdvRx",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis/mp-[diff-wg]-[sb-sb]_WdvRx-WwgRelSunSav_RwgAcqSunSvis-RdvRx",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis/mp-[diff-wg]-[sb-sb]_WdvRx-WwgRelSwgSav_RwgAcqSwgSvis-RdvRx",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSun-WwgRelSun_RwgAcqSun-RdvAcqSun",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSun-WwgRelSwg_RwgAcqSwg-RdvAcqSun",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSwg-WwgRelSun_RwgAcqSun-RdvAcqSwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSwg-WwgRelSwg_RwgAcqSwg-RdvAcqSwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSun-WwgRelSunwg_RwgAcqSunwg-RdvAcqSun",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSunwg-WwgRelSun_RwgAcqSun-RdvAcqSunwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSunwg-WwgRelSunwg_RwgAcqSunwg-RdvAcqSunwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSunwg-WwgRelSwg_RwgAcqSwg-RdvAcqSunwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WdvRelSwg-WwgRelSunwg_RwgAcqSunwg-RdvAcqSwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WdvRelSunSav-WwgRelSunSav_RwgAcqSunSvis-RdvAcqSunSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WdvRelSunSav-WwgRelSwgSav_RwgAcqSwgSvis-RdvAcqSunSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WdvRelSwgSav-WwgRelSunSav_RwgAcqSunSvis-RdvAcqSwgSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WdvRelSwgSav-WwgRelSwgSav_RwgAcqSwgSvis-RdvAcqSwgSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSun-WwgRelSunSav_RwgAcqSunSvis-RdvAcqSun",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSun-WwgRelSwgSav_RwgAcqSwgSvis-RdvAcqSun",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSunSav-WwgRelSun_RwgAcqSun-RdvAcqSunSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSunSav-WwgRelSwg_RwgAcqSwg-RdvAcqSunSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSwg-WwgRelSunSav_RwgAcqSunSvis-RdvAcqSwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSwg-WwgRelSwgSav_RwgAcqSwgSvis-RdvAcqSwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSwgSav-WwgRelSun_RwgAcqSun-RdvAcqSwgSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WdvRelSwgSav-WwgRelSwg_RwgAcqSwg-RdvAcqSwgSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc/mp-[diff-wg]-[sb-sb]_WwgRx-WwgRelSunwg_RwgAcqSunwg-RwgRx",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc/mp-[diff-wg]-[sb-sb]_WwgRx-WwgRelSun_RwgAcqSun-RwgRx",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc/mp-[diff-wg]-[sb-sb]_WwgRx-WwgRelSwg_RwgAcqSwg-RwgRx",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis/mp-[diff-wg]-[sb-sb]_WwgRx-WwgRelSunSav_RwgAcqSunSvis-RwgRx",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis/mp-[diff-wg]-[sb-sb]_WwgRx-WwgRelSwgSav_RwgAcqSwgSvis-RwgRx",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSun-WwgRelSun_RwgAcqSun-RwgAcqSun",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSun-WwgRelSwg_RwgAcqSwg-RwgAcqSun",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSwg-WwgRelSun_RwgAcqSun-RwgAcqSwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSwg-WwgRelSwg_RwgAcqSwg-RwgAcqSwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSun-WwgRelSunwg_RwgAcqSunwg-RwgAcqSun",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSunwg-WwgRelSun_RwgAcqSun-RwgAcqSunwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSunwg-WwgRelSunwg_RwgAcqSunwg-RwgAcqSunwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSunwg-WwgRelSwg_RwgAcqSwg-RwgAcqSunwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semsc2/mp-[diff-wg]-[sb-sb]_WwgRelSwg-WwgRelSunwg_RwgAcqSunwg-RwgAcqSwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WwgRelSunSav-WwgRelSunSav_RwgAcqSunSvis-RwgAcqSunSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WwgRelSunSav-WwgRelSwgSav_RwgAcqSwgSvis-RwgAcqSunSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WwgRelSwgSav-WwgRelSunSav_RwgAcqSunSvis-RwgAcqSwgSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis2/mp-[diff-wg]-[sb-sb]_WwgRelSwgSav-WwgRelSwgSav_RwgAcqSwgSvis-RwgAcqSwgSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSun-WwgRelSunSav_RwgAcqSunSvis-RwgAcqSun",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSun-WwgRelSwgSav_RwgAcqSwgSvis-RwgAcqSun",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSunSav-WwgRelSun_RwgAcqSun-RwgAcqSunSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSunSav-WwgRelSwg_RwgAcqSwg-RwgAcqSunSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSwg-WwgRelSunSav_RwgAcqSunSvis-RwgAcqSwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSwg-WwgRelSwgSav_RwgAcqSwgSvis-RwgAcqSwg",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSwgSav-WwgRelSun_RwgAcqSun-RwgAcqSwgSvis",FAIL,FAIL,FAIL},
                {"/atomic/mp/semscavvis3/mp-[diff-wg]-[sb-sb]_WwgRelSwgSav-WwgRelSwg_RwgAcqSwg-RwgAcqSwgSvis",FAIL,FAIL,FAIL},
        });
    }

    @Test
    public void testAllSolvers() throws Exception {
        try (SolverContext ctx = mkCtx(); ProverWithTracker prover = mkProver(ctx)) {
            VerificationTask task = mkTask();
            AssumeSolver s = AssumeSolver.run(ctx, prover, task);
            printProgramEvents(programPath, task.getProgram());
            if (s.hasModel()) {
                for (String assignment : prover.getModel().asList()
                        .stream().map(Model.ValueAssignment::toString).sorted().toList()) {
                    System.out.println(assignment);
                }
            }
            assertEquals(expected, s.getResult());
        }

        /*
        try (SolverContext ctx = mkCtx(); ProverWithTracker prover = mkProver(ctx)) {
            assertEquals(expected, AssumeSolver.run(ctx, prover, mkTask()).getResult());
        }*/
    }

    private SolverContext mkCtx() throws InvalidConfigurationException {
        Configuration cfg = Configuration.builder().build();
        return SolverContextFactory.createSolverContext(
                cfg,
                BasicLogManager.create(cfg),
                ShutdownManager.create().getNotifier(),
                SolverContextFactory.Solvers.Z3);
    }

    private ProverWithTracker mkProver(SolverContext ctx) {
        return new ProverWithTracker(ctx, "", SolverContext.ProverOptions.GENERATE_MODELS);
    }

    private VerificationTask mkTask() throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(Configuration.builder().build())
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(PROGRAM_SPEC));
    }

    private void printProgramEvents(String path, Program program) {
        if (PRINT_EVENTS) {
            System.out.println(path);
            System.out.println(new Printer().setShowInitThreads(true).setMode(Printer.Mode.THREADS).print(program));
            program.getThreads().stream()
                    .flatMap(t -> t.getEvents().stream())
                    .map(e -> e.getGlobalId() + " " + e.getTags())
                    .forEach(System.out::println);
        }
    }
}
