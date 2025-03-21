package com.dat3m.dartagnan.litmus.comparison;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.utils.rules.Provider;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.EnumSet;

@RunWith(Parameterized.class)
public class C11AndOpenCLRaceTest extends C11AndOpenCLTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("litmus/OPENCL/portedFromC11/");
    }

    public C11AndOpenCLRaceTest(String path) {
        super(path);
    }

    @Override
    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return Provider.fromSupplier(() -> EnumSet.of(Property.CAT_SPEC));
    }
}
