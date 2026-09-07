package com.dat3m.dartagnan.llvm;

import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.verification.ResultStatus;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Arch.C11;
import static com.dat3m.dartagnan.configuration.ProgressModel.*;
import static com.dat3m.dartagnan.verification.ResultStatus.FAIL;
import static com.dat3m.dartagnan.verification.ResultStatus.PASS;

@RunWith(Parameterized.class)
public class CProgressTest extends AbstractCTest {

    protected ProgressModel progressModel;

    public CProgressTest(String name, ProgressModel progressModel, ResultStatus expected) {
        super(name, C11, expected);
        this.progressModel = progressModel;
    }

    @Override
    protected String getProgramPathPrefix() {
        return "progress/";
    }

    @Override
    protected ProgressModel.Hierarchy getProgressModel() { return uniform(progressModel); }

    @Override
    protected String getWmmName() { return "imm"; }

    @Override
    protected EnumSet<Property> getProperty() { return EnumSet.of(Property.TERMINATION); }

    @Override
    protected long getTimeout() {
        return 10000;
    }

    @Parameterized.Parameters(name = "{index}: {0}, progress={1}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"progressFair", FAIR, PASS},
                {"progressFair", HSA, FAIL},
                {"progressFair", OBE, FAIL},
                {"progressFair", UNFAIR, FAIL},
                // ---------------------------
                {"progressHSA", FAIR, PASS},
                {"progressHSA", HSA, PASS},
                {"progressHSA", OBE, FAIL},
                {"progressHSA", UNFAIR, FAIL},
                // ---------------------------
                {"progressOBE", FAIR, PASS},
                {"progressOBE", HSA, FAIL},
                {"progressOBE", OBE, PASS},
                {"progressOBE", UNFAIR, FAIL},
                // ---------------------------
                {"progressOBE-HSA", FAIR, PASS},
                {"progressOBE-HSA", HSA, PASS},
                {"progressOBE-HSA", OBE, PASS},
                {"progressOBE-HSA", UNFAIR, FAIL},
                // ---------------------------
                {"progressUnfair", FAIR, PASS},
                {"progressUnfair", HSA, PASS},
                {"progressUnfair", OBE, PASS},
                {"progressUnfair", UNFAIR, PASS},
        });
    }
}