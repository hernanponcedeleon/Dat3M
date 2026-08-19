package com.dat3m.dartagnan.spirv;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.AbstractVerificationTaskSolverTest;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.verification.Task;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.ConfigurationBuilder;
import org.sosy_lab.java_smt.SolverContextFactory;

import java.nio.file.Path;
import java.util.EnumSet;

import static org.junit.Assert.assertEquals;

public abstract class AbstractSpirvTest extends AbstractVerificationTaskSolverTest {

    private final Arch target;
    private final Path programPath;
    private final int bound;
    private final ResultStatus expected;

    protected AbstractSpirvTest(Arch target, String programPath, int bound, ResultStatus expected) {
        this.target = target;
        this.programPath = ResourceHelper.getTestResourcePath(programPath);
        this.bound = bound;
        this.expected = expected;
    }

    protected ConfigurationBuilder additionalOptions(ConfigurationBuilder config) { return config; }

    protected Property getTestedProperty() { return Property.PROGRAM_SPEC; }

    protected ProgressModel.Hierarchy getProgressModel() { return ProgressModel.defaultHierarchy(); }

    @Override
    protected void testSolver(Method method) throws Exception {
        final ConfigurationBuilder config = Configuration.builder()
                .setOption(OptionNames.SOLVER, SolverContextFactory.Solvers.Z3.name())
                .setOption(OptionNames.PHANTOM_REFERENCES, "true");
        Task.TaskBuilder builder = VerificationTask.builder()
                .withConfig(additionalOptions(config).build())
                .withBound(bound)
                .withTarget(target)
                .withProgressModel(getProgressModel());
        final Program program = new ProgramParser().parse(programPath);
        final Wmm mcm = new ParserCat().parse(ResourceHelper.getCatPath(target, null));
        final VerificationTask task = builder.build(program, mcm, EnumSet.of(getTestedProperty()));
        assertEquals(expected, TestHelper.createAndRunSolver(task, Method.EAGER));
    }
}
