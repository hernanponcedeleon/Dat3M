package com.dat3m.dartagnan.configuration;

import com.google.common.reflect.ClassPath;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.io.IOException;
import java.lang.reflect.*;
import java.util.regex.Pattern;
import java.util.stream.Stream;

/**
 * Collects all {@link Option}s of a program.
 * <p>
 * Mimics {@link org.sosy_lab.common.configuration.OptionCollector OptionCollector} with reduced functionality.
 */
public final class OptionInfo {

    private static final Pattern PROJECT_CLASSES = Pattern.compile("^com\\.dat3m\\..*$");

    /**
     * Traverses all options from all classes and outputs them.
     * Each find is printed to {@link System#out}.
     */
    public static void collectOptions() {

        ClassPath classPath;
        try {
            classPath = ClassPath.from(OptionInfo.class.getClassLoader());
        }
        catch(IOException e) {
            return;
        }

        classPath.getAllClasses().stream()
                .flatMap(OptionInfo::collectOptions)
                .forEach(OptionInfo::print);
    }

    /**
     * This method collects every {@link Option} of a class.
     *
     * @param i class where to take the Option from
     */
    private static Stream<OptionInfo> collectOptions(ClassPath.ClassInfo i) {
        Class<?> c;
        try {
            c = i.load();
        }
        catch(NoClassDefFoundError e) {
            return Stream.empty();
        }

        Options o = c.getAnnotation(Options.class);
        if(o == null) {
            return Stream.empty();
        }

        if(!PROJECT_CLASSES.matcher(c.getCanonicalName()).matches()) {
            return Stream.empty();
        }

        ClassInfo p = new ClassInfo(o);
        return Stream.concat(
                Stream.of(c.getDeclaredFields()).flatMap(p::of),
                Stream.of(c.getDeclaredMethods()).flatMap(p::of));
    }

    private static class ClassInfo {

        final String prefix;

        ClassInfo(Options o) {
            prefix = o.prefix().isEmpty() ? "" : o.prefix() + ".";
        }

        Stream<OptionInfo> of(Field f) {
            Option o = f.getAnnotation(Option.class);
            if(o == null) {
                return Stream.empty();
            }
            return Stream.of(new OptionInfo(this,o,f,f.getType()));
        }

        Stream<OptionInfo> of(Method m) {
            Option o = m.getAnnotation(Option.class);
            if(o == null) {
                return Stream.empty();
            }
            return Stream.of(new OptionInfo(this,o,m,m.getParameterTypes()[0]));
        }
    }

    private final ClassInfo parent;
    private final Option option;
    private final Member member;
    private final Class<?> domain;

    private OptionInfo(ClassInfo i, Option o, Member m, Class<?> d) {
        parent = i;
        option = o;
        member = m;
        domain = d;
    }

    private void print() {
        System.out.printf("\n\t%s%s : %s\n%s\n",
            parent.prefix,
            option.name().isEmpty() ? member.getName() : option.name(),
            domain.getSimpleName(),
            option.description());
    }
}