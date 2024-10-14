package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.io.File;
import java.util.EnumSet;
import java.util.LinkedList;
import java.util.List;

import static com.dat3m.dartagnan.configuration.OptionNames.ENABLE_EXTENDED_RELATION_ANALYSIS;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.verification.solving.ModelChecker.*;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.LOC;
import static org.junit.Assert.assertEquals;

public class AliasTest {

    private final String testPath = getTestResourcePath("libvsync/bounded_mpmc_check_empty-opt.ll");
    private final String modelPath = "cat/c11.cat";
    private final Arch target = Arch.C11;

    @Test
    public void test() throws Exception {
        Program program = new ProgramParser().parse(new File(testPath));
        Wmm wmm = new ParserCat().parse(new File(getRootPath(modelPath)));
        Configuration baseConfig = Configuration.builder().build();
        VerificationTask baseTask = createTask(program, wmm, baseConfig);
        wmm.configureAll(baseTask.getConfig());
        preprocessProgram(baseTask, baseTask.getConfig());

        Relation loc = wmm.getRelation(LOC);
        Configuration config = Configuration.builder()
                .setOption(ENABLE_EXTENDED_RELATION_ANALYSIS, "false")
                .build();

        List<Integer> sizes = new LinkedList<>();
        for (int i = 0; i < 10; i++) {
            Context nativeContext = Context.create();
            VerificationTask nativeTask = createTask(program, wmm, config);
            performStaticProgramAnalyses(nativeTask, nativeContext, nativeTask.getConfig());
            performStaticWmmAnalyses(nativeTask, nativeContext, nativeTask.getConfig());
            RelationAnalysis nativeRa = nativeContext.get(RelationAnalysis.class);
            sizes.add(nativeRa.getKnowledge(loc).getMaySet().size());
        }
        for (int i = 1; i < 10; i++) {
            assertEquals(sizes.get(i - 1), sizes.get(i));
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
