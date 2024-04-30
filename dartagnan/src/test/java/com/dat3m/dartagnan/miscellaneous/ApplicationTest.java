package com.dat3m.dartagnan.miscellaneous;

import com.dat3m.dartagnan.Dartagnan;
import org.junit.Test;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import static com.dat3m.dartagnan.configuration.Method.*;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.configuration.Property.DATARACEFREEDOM;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;

public class ApplicationTest {

    @Test
    public void Assume() throws Exception {
        Dartagnan.main(createAndFillOptions(PROGRAM_SPEC.asStringOption(),
                EAGER.asStringOption(),
                Solvers.Z3.toString()));
    }

    @Test
    public void CAAT() throws Exception {
        Dartagnan.main(createAndFillOptions(PROGRAM_SPEC.asStringOption(),
                LAZY.asStringOption(),
                Solvers.Z3.toString()));
    }

    @Test
    public void Races() throws Exception {
        Dartagnan.main(createAndFillOptions(DATARACEFREEDOM.asStringOption(),
                EAGER.asStringOption(),
                Solvers.Z3.toString()));
    }

    @Test
    public void Validation() throws Exception {
        String[] options = new String[3];

        options[0] = getTestResourcePath("witness/lazy01-for-witness.ll");
        options[1] = getRootPath("cat/svcomp.cat");
        options[2] = String.format("--%s=%s", VALIDATE, getTestResourcePath("witness/lazy01.graphml"));

        Dartagnan.main(options);
    }

    @Test
    public void Litmus() throws Exception {
        String[] options = new String[2];

        options[0] = getRootPath("litmus/X86/2+2W.litmus");
        options[1] = getRootPath("cat/tso.cat");

        Dartagnan.main(options);
    }

    @Test(expected = IllegalArgumentException.class)
    public void WrongProgramFormat() throws Exception {
        String[] options = new String[1];

        options[0] = getTestResourcePath("witness/lazy01-for-witness.bc");

        Dartagnan.main(options);
    }

    @Test(expected = IllegalArgumentException.class)
    public void WrongCATFormat() throws Exception {
        String[] options = new String[2];

        options[0] = getTestResourcePath("witness/lazy01-for-witness.ll");
        options[1] = getRootPath("cat/linux-kernel.bell");

        Dartagnan.main(options);
    }

    @Test(expected = InvalidConfigurationException.class)
    public void UnsupportedAnalysis() throws Exception {
        Dartagnan.main(createAndFillOptions("unsupported-analysis",
                EAGER.asStringOption(),
                Solvers.Z3.toString()));
    }

    @Test(expected = InvalidConfigurationException.class)
    public void UnsupportedMethod() throws Exception {
        Dartagnan.main(createAndFillOptions(PROGRAM_SPEC.asStringOption(),
                "unsupported-method",
                Solvers.Z3.toString()));
    }

    @Test(expected = InvalidConfigurationException.class)
    public void UnsupportedSolver() throws Exception {
        Dartagnan.main(createAndFillOptions(PROGRAM_SPEC.asStringOption(),
                EAGER.asStringOption(),
                "unsupported-solver"));
    }

    private String[] createAndFillOptions(String property, String method, String solver) {
        String[] dartagnanOptions = new String[6];

        dartagnanOptions[0] = getTestResourcePath("locks/ttas.ll");
        dartagnanOptions[1] = getRootPath("cat/svcomp.cat");
        dartagnanOptions[2] = String.format("--%s=%s", BOUND, 2);
        dartagnanOptions[3] = String.format("--%s=%s", PROPERTY, property);
        dartagnanOptions[4] = String.format("--%s=%s", METHOD, method);
        dartagnanOptions[5] = String.format("--%s=%s", SOLVER, solver);

        return dartagnanOptions;
    }
}
