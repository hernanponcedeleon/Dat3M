package com.dat3m.dartagnan.configuration;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.reflect.ClassPath;
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

public final class OptionRegistrationTestUtils {

    private OptionRegistrationTestUtils() {
    }

    public static Set<Class<?>> findOptionClasses(Class<?> mainClass, String packagePrefix)
            throws IOException {
        final ClassLoader classLoader = mainClass.getClassLoader();
        final URL mainCodeSource = mainClass.getProtectionDomain().getCodeSource().getLocation();

        final Set<Class<?>> optionClasses = ClassPath.from(classLoader).getAllClasses().stream()
                .filter(info -> info.getName().startsWith(packagePrefix))
                .map(OptionRegistrationTestUtils::load)
                // Test classes can share the package prefix, but are irrelevant for production registration.
                .filter(clazz -> Objects.equals(
                        clazz.getProtectionDomain().getCodeSource().getLocation(), mainCodeSource))
                .filter(OptionRegistrationTestUtils::declaresOption)
                .sorted(Comparator.comparing(Class::getName))
                .collect(Collectors.toCollection(LinkedHashSet::new));
        assertFalse("No classes declaring @Option members were found", optionClasses.isEmpty());
        return optionClasses;
    }

    public static void assertAllOptionClassesRegisteredForReflection(
            Set<Class<?>> optionClasses, Class<?> resourceClass, String reflectionConfig)
            throws IOException {
        final ClassLoader classLoader = resourceClass.getClassLoader();
        try (InputStream stream = classLoader.getResourceAsStream(reflectionConfig)) {
            assertNotNull("Cannot find " + reflectionConfig, stream);
            final JsonNode config = new ObjectMapper().readTree(stream);
            assertTrue(reflectionConfig + " must contain a JSON array", config.isArray());
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

    public static String registrationMessage(
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
