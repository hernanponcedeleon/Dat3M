package com.dat3m.svcomp;

import org.junit.BeforeClass;
import org.junit.Test;

import java.io.IOException;
import java.util.Set;

import static com.dat3m.dartagnan.configuration.OptionRegistrationTestUtils.assertAllOptionClassesRegisteredForReflection;
import static com.dat3m.dartagnan.configuration.OptionRegistrationTestUtils.findOptionClasses;

public class OptionRegistrationTest {

    private static final String SVCOMP_PACKAGE = "com.dat3m.svcomp.";
    private static final String REFLECTION_CONFIG =
            "META-INF/native-image/com.dat3m.svcomp/svcomp/reflect-config.json";

    private static Set<Class<?>> optionClasses;

    @BeforeClass
    public static void collectOptionClasses() throws IOException {
        optionClasses = findOptionClasses(SVCOMPRunner.class, SVCOMP_PACKAGE);
    }

    @Test
    public void allOptionClassesAreRegisteredForReflection() throws IOException {
        assertAllOptionClassesRegisteredForReflection(
                optionClasses, OptionRegistrationTest.class, REFLECTION_CONFIG);
    }
}
