package com.dat3m.dartagnan.configuration;

import com.google.common.collect.Sets;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.IOException;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionRegistrationTestUtils.assertAllOptionClassesRegisteredForReflection;
import static com.dat3m.dartagnan.configuration.OptionRegistrationTestUtils.findOptionClasses;
import static com.dat3m.dartagnan.configuration.OptionRegistrationTestUtils.registrationMessage;
import static org.junit.Assert.assertTrue;

public class OptionRegistrationTest {

    private static final String DARTAGNAN_PACKAGE = "com.dat3m.dartagnan.";
    private static final String REFLECTION_CONFIG =
            "META-INF/native-image/com.dat3m.dartagnan/dartagnan/reflect-config.json";

    private static Set<Class<?>> optionClasses;

    @BeforeClass
    public static void collectOptionClasses() throws IOException {
        optionClasses = findOptionClasses(OptionInfo.class, DARTAGNAN_PACKAGE);
    }

    @Test
    public void optionInfoContainsExactlyTheOptionClasses() {
        final Set<Class<?>> registeredClasses = OptionInfo.classes()
                .collect(Collectors.toCollection(LinkedHashSet::new));
        final Set<Class<?>> missingClasses = Sets.difference(optionClasses, registeredClasses);
        final Set<Class<?>> unnecessaryClasses = Sets.difference(registeredClasses, optionClasses);
        assertTrue(registrationMessage("OptionInfo", missingClasses, unnecessaryClasses),
                missingClasses.isEmpty() && unnecessaryClasses.isEmpty());
    }

    @Test
    public void allOptionClassesAreRegisteredForReflection() throws IOException {
        assertAllOptionClassesRegisteredForReflection(
                optionClasses, OptionRegistrationTest.class, REFLECTION_CONFIG);
    }
}
