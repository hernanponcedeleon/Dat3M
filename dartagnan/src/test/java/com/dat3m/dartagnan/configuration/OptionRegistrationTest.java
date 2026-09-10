package com.dat3m.dartagnan.configuration;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.Sets;
import com.google.common.reflect.ClassPath;
import org.junit.BeforeClass;
import org.junit.Test;
import org.sosy_lab.common.configuration.Option;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Arrays;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

public class OptionRegistrationTest {

    private static final String DARTAGNAN_PACKAGE = "com.dat3m.dartagnan.";
    private static final String REFLECTION_CONFIG =
            "META-INF/native-image/com.dat3m.dartagnan/dartagnan/reflect-config.json";

    private static Set<Class<?>> optionClasses;

    @BeforeClass
    public static void collectOptionClasses() throws IOException {
        final ClassLoader classLoader = OptionInfo.class.getClassLoader();
        final URL mainCodeSource = OptionInfo.class.getProtectionDomain().getCodeSource().getLocation();

        optionClasses = ClassPath.from(classLoader).getAllClasses().stream()
                .filter(info -> info.getName().startsWith(DARTAGNAN_PACKAGE))
                .map(OptionRegistrationTest::load)
                // The test classes share the package prefix, but are irrelevant for production registration.
                .filter(clazz -> Objects.equals(
                        clazz.getProtectionDomain().getCodeSource().getLocation(), mainCodeSource))
                .filter(OptionRegistrationTest::declaresOption)
                .sorted(Comparator.comparing(Class::getName))
                .collect(Collectors.toCollection(LinkedHashSet::new));
        assertFalse("No classes declaring @Option members were found", optionClasses.isEmpty());
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
        final ClassLoader classLoader = OptionRegistrationTest.class.getClassLoader();
        try (InputStream stream = classLoader.getResourceAsStream(REFLECTION_CONFIG)) {
            assertNotNull("Cannot find " + REFLECTION_CONFIG, stream);
            final JsonNode config = new ObjectMapper().readTree(stream);
            assertTrue(REFLECTION_CONFIG + " must contain a JSON array", config.isArray());
            final Set<String> registeredClasses = new LinkedHashSet<>();
            config.forEach(entry -> registeredClasses.add(entry.path("name").asText()));

            final Set<Class<?>> missingClasses = optionClasses.stream()
                    .filter(clazz -> !registeredClasses.contains(clazz.getName()))
                    .collect(Collectors.toCollection(LinkedHashSet::new));
            assertTrue(registrationMessage(
                            "the native-image reflection configuration", missingClasses, Set.of()),
                    missingClasses.isEmpty());
        }
    }

    private static Class<?> load(ClassPath.ClassInfo info) {
        try {
            return info.load();
        } catch (LinkageError e) {
            throw new AssertionError("Failed to load " + info.getName(), e);
        }
    }

    private static boolean declaresOption(Class<?> clazz) {
        final boolean hasOptionField = Arrays.stream(clazz.getDeclaredFields())
                .anyMatch(field -> field.isAnnotationPresent(Option.class));
        final boolean hasOptionMethod = Arrays.stream(clazz.getDeclaredMethods())
                .anyMatch(method -> method.isAnnotationPresent(Option.class));
        return hasOptionField || hasOptionMethod;
    }

    private static String registrationMessage(
            String registry, Set<Class<?>> missingClasses, Set<Class<?>> unnecessaryClasses) {
        return Stream.of(
                        classList(
                                "Classes declaring @Option members are missing from " + registry + ":",
                                missingClasses),
                        classList("Classes registered in " + registry
                                + " do not declare @Option members:", unnecessaryClasses))
                .filter(message -> !message.isEmpty())
                .collect(Collectors.joining("\n"));
    }

    private static String classList(String heading, Set<Class<?>> classes) {
        if (classes.isEmpty()) {
            return "";
        }
        return classes.stream()
                .map(Class::getName)
                .sorted()
                .collect(Collectors.joining("\n  ", heading + "\n  ", ""));
    }
}
