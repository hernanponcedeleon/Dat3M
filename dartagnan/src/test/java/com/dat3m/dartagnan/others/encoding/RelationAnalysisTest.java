package com.dat3m.dartagnan.others.encoding;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.RelationAnalysisMethod;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.SolverContext;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.LinkedList;
import java.util.List;

import static com.dat3m.dartagnan.configuration.Alias.FIELD_SENSITIVE;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.verification.solving.ModelChecker.*;
import static org.junit.Assert.assertEquals;
import static org.sosy_lab.java_smt.SolverContextFactory.createSolverContext;

@RunWith(Parameterized.class)
public class RelationAnalysisTest {

    private final String testPath;
    private final String modelPath;
    private final Arch target;

    public RelationAnalysisTest(String testPath, String modelPath, Arch target) {
        this.testPath = testPath;
        this.modelPath = modelPath;
        this.target = target;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                { "litmus/AARCH64", "cat/aarch64.cat", Arch.ARM8 },
                { "litmus/C11", "cat/c11.cat", Arch.C11 },
                { "litmus/PTX/Manual", "cat/ptx-v7.5.cat", Arch.PTX },
                { "litmus/PTX/Memalloy", "cat/ptx-v7.5.cat", Arch.PTX },
                { "litmus/PTX/Nvidia", "cat/ptx-v7.5.cat", Arch.PTX },
                { "litmus/VULKAN/Data-Race", "cat/spirv.cat", Arch.VULKAN },
                { "litmus/VULKAN/Kronos-Group", "cat/spirv.cat", Arch.VULKAN },
                { "litmus/VULKAN/Manual", "cat/spirv.cat", Arch.VULKAN },
                { "litmus/X86", "cat/tso.cat", Arch.TSO },

                { "dartagnan/src/test/resources/lfds", "cat/c11.cat", Arch.C11 },
                { "dartagnan/src/test/resources/locks", "cat/c11.cat", Arch.C11 },
                { "dartagnan/src/test/resources/libvsync", "cat/c11.cat", Arch.C11 },
                // Requires new alias analysis, but we cannot enable it due to
                // https://github.com/hernanponcedeleon/Dat3M/issues/746
                //{ "dartagnan/src/test/resources/miscellaneous", "cat/c11.cat", Arch.C11 },

                { "dartagnan/src/test/resources/lfds", "cat/imm.cat", Arch.C11 },
                { "dartagnan/src/test/resources/locks", "cat/imm.cat", Arch.C11 },
                { "dartagnan/src/test/resources/libvsync", "cat/imm.cat", Arch.C11 },
                // Requires new alias analysis, but we cannot enable it due to
                // https://github.com/hernanponcedeleon/Dat3M/issues/746
                //{ "dartagnan/src/test/resources/miscellaneous", "cat/imm.cat", Arch.C11 },

                { "dartagnan/src/test/resources/lfds", "cat/vmm.cat", Arch.C11 },
                { "dartagnan/src/test/resources/locks", "cat/vmm.cat", Arch.C11 },
                { "dartagnan/src/test/resources/libvsync", "cat/vmm.cat", Arch.C11 },
                // Requires new alias analysis, but we cannot enable it due to
                // https://github.com/hernanponcedeleon/Dat3M/issues/746
                //{ "dartagnan/src/test/resources/miscellaneous", "cat/vmm.cat", Arch.C11 },

                { "dartagnan/src/test/resources/lfds", "cat/rc11.cat", Arch.C11 },
                { "dartagnan/src/test/resources/locks", "cat/rc11.cat", Arch.C11 },
                { "dartagnan/src/test/resources/libvsync", "cat/rc11.cat", Arch.C11 },
                // Requires new alias analysis, but we cannot enable it due to
                // https://github.com/hernanponcedeleon/Dat3M/issues/746
                //{ "dartagnan/src/test/resources/miscellaneous", "cat/rc11.cat", Arch.C11 },

                { "dartagnan/src/test/resources/lfds", "cat/aarch64.cat", Arch.ARM8 },
                { "dartagnan/src/test/resources/locks", "cat/aarch64.cat", Arch.ARM8 },
                { "dartagnan/src/test/resources/libvsync", "cat/aarch64.cat", Arch.ARM8 },
                // Requires new alias analysis, but we cannot enable it due to
                // https://github.com/hernanponcedeleon/Dat3M/issues/746
                //{ "dartagnan/src/test/resources/miscellaneous", "cat/aarch64.cat", Arch.ARM8 },

                { "dartagnan/src/test/resources/lfds", "cat/tso.cat", Arch.TSO },
                { "dartagnan/src/test/resources/locks", "cat/tso.cat", Arch.TSO },
                { "dartagnan/src/test/resources/libvsync", "cat/tso.cat", Arch.TSO },
                // Requires new alias analysis, but we cannot enable it due to
                // https://github.com/hernanponcedeleon/Dat3M/issues/746
                //{ "dartagnan/src/test/resources/miscellaneous", "cat/tso.cat", Arch.TSO },

                { "dartagnan/src/test/resources/lfds", "cat/riscv.cat", Arch.RISCV },
                { "dartagnan/src/test/resources/locks", "cat/riscv.cat", Arch.RISCV },
                { "dartagnan/src/test/resources/libvsync", "cat/riscv.cat", Arch.RISCV },
                // Requires new alias analysis, but we cannot enable it due to
                // https://github.com/hernanponcedeleon/Dat3M/issues/746
                //{ "dartagnan/src/test/resources/miscellaneous", "cat/riscv.cat", Arch.RISCV },

                { "dartagnan/src/test/resources/spirv/benchmarks", "cat/spirv.cat", Arch.VULKAN },
        });
    }

    @Test
    public void compareBaseSets() throws Exception {
        for (String program : listFiles(Path.of(getRootPath(testPath)))) {
            doCompareSets(program);
        }
    }

    private List<String> listFiles(Path path) throws IOException {
        List<String> result = new LinkedList<>();
        try (DirectoryStream<Path> files = Files.newDirectoryStream(path)) {
            for (Path file : files) {
                if (Files.isDirectory(file)) {
                    result.addAll(listFiles(file.toAbsolutePath()));
                } else {
                    String filePath = file.toAbsolutePath().toString();
                    if (filePath.endsWith(".litmus") || filePath.endsWith(".ll") || filePath.endsWith(".spv.dis")) {
                        result.add(filePath);
                    }
                }
            }
        }
        return result;
    }

    private void doCompareSets(String path) throws Exception {
        try(SolverContext ctx = createSolverContext(SolverContextFactory.Solvers.Z3)) {
            // Base program and consistency model
            Program program = new ProgramParser().parse(new File(path));
            Wmm wmm = new ParserCat().parse(new File(getRootPath(modelPath)));
            Configuration baseConfig = Configuration.builder().build();
            VerificationTask baseTask = createTask(program, wmm, baseConfig);
            wmm.configureAll(baseTask.getConfig());
            preprocessProgram(baseTask, baseTask.getConfig());
            preprocessMemoryModel(baseTask, baseTask.getConfig());

            // Native analysis
            Context nativeContext = Context.create();
            Configuration nativeConfig = Configuration.builder()
                    .setOption(ALIAS_METHOD, FIELD_SENSITIVE.asStringOption())
                    .setOption(ENABLE_EXTENDED_RELATION_ANALYSIS, "false")
                    .build();
            VerificationTask nativeTask = createTask(program, wmm, nativeConfig);
            performStaticProgramAnalyses(nativeTask, nativeContext, nativeTask.getConfig());
            performStaticWmmAnalyses(nativeTask, nativeContext, nativeTask.getConfig());
            RelationAnalysis nativeRa = nativeContext.get(RelationAnalysis.class);

            // Lazy analysis
            Context lazyContext = Context.create();
            Configuration lazyConfig = Configuration.builder()
                    .setOption(ALIAS_METHOD, FIELD_SENSITIVE.asStringOption())
                    .setOption(RELATION_ANALYSIS, RelationAnalysisMethod.LAZY.toString())
                    .build();
            VerificationTask lazyTask = createTask(program, wmm, lazyConfig);
            performStaticProgramAnalyses(lazyTask, lazyContext, lazyTask.getConfig());
            performStaticWmmAnalyses(lazyTask, lazyContext, lazyTask.getConfig());
            RelationAnalysis lazyRa = lazyContext.get(RelationAnalysis.class);

            // Assert may and must sets are equal
            for (Relation relation : nativeTask.getMemoryModel().getRelations()) {
                assertEquals(nativeRa.getKnowledge(relation).getMaySet(),
                        lazyRa.getKnowledge(relation).getMaySet());
                assertEquals(nativeRa.getKnowledge(relation).getMustSet(),
                        lazyRa.getKnowledge(relation).getMustSet());
            }

            // Generate and assert encode sets
            WmmEncoder nativeEncoder = WmmEncoder.withContext(EncodingContext.of(nativeTask, nativeContext, ctx.getFormulaManager()));
            WmmEncoder lazyEncoder = WmmEncoder.withContext(EncodingContext.of(lazyTask, lazyContext, ctx.getFormulaManager()));
            for (Relation relation : nativeTask.getMemoryModel().getRelations()) {
                assertEquals(nativeEncoder.encodeSets.get(relation),
                        lazyEncoder.encodeSets.get(relation));
            }
        }
    }

    private VerificationTask createTask(Program program, Wmm wmm, Configuration config)
            throws InvalidConfigurationException {
        return VerificationTask.builder()
                .withConfig(config)
                .withBound(2)
                .withTarget(target)
                .build(program, wmm, EnumSet.of(PROGRAM_SPEC));
    }
}
