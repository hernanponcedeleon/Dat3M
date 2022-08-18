package com.dat3m.dartagnan.configuration;

import com.google.common.reflect.ClassPath;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.Member;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.lang.reflect.WildcardType;
import java.util.Arrays;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.google.common.base.Verify.verify;

/**
 * Collects all {@link Option}s of a program.
 * <p>
 * Mimics {@link org.sosy_lab.common.configuration.OptionCollector OptionCollector} with reduced functionality.
 */
public final class OptionInfo implements Comparable<OptionInfo> {

    private static final Pattern PROJECT_CLASSES = Pattern.compile("^com\\.dat3m\\..*$");

    /**
     * Traverses all options from all classes and outputs them.
     * Each find is printed to {@link System#out}.
     */
    public static void collectOptions() {

        stream()
                .sorted()
                .forEach(System.out::print);
    }

    public static Stream<OptionInfo> stream() {
        return classes().flatMap(OptionInfo::collectOptions);
    }

    private static Stream<Class<?>> classes() {
        ClassPath classPath;
        try {
            classPath = ClassPath.from(OptionInfo.class.getClassLoader());
        } catch(IOException e) {
            return Stream.empty();
        }

        return classPath.getAllClasses().stream().flatMap(OptionInfo::load);
    }

    private static Stream<Class<?>> load(ClassPath.ClassInfo i) {
        try {
            return Stream.of(i.load());
        } catch(LinkageError e) {
            return Stream.empty();
        }
    }

    /**
     * This method collects every {@link Option} of a class.
     *
     * @param c class where to take the Option from
     */
    private static Stream<OptionInfo> collectOptions(Class<?> c) {

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
            return Stream.of(new OptionInfo(this,o,f,f.getGenericType()));
        }

        Stream<OptionInfo> of(Method m) {
            Option o = m.getAnnotation(Option.class);
            if(o == null) {
                return Stream.empty();
            }
            return Stream.of(new OptionInfo(this,o,m,m.getGenericParameterTypes()[0]));
        }
    }

    private final ClassInfo parent;
    private final Option option;
    private final Member member;
    private final Type type;
    private final Class<?> domain;

    private OptionInfo(ClassInfo i, Option o, Member m, Type t) {
        parent = i;
        option = o;
        member = m;
        type = t;
        Type raw = t instanceof ParameterizedType ? ((ParameterizedType)t).getRawType() : t;
        verify(raw instanceof Class);
        domain = (Class<?>)raw;
    }

    public String getName() {
        return option.name();
    }

    public Class<?> getDomain() {
        return domain;
    }

    public Stream<String> getAvailableValues() {
        if(domain.isEnum()) {
            return Stream.of(domain.getEnumConstants()).map(Object::toString);
        }
        if(domain.equals(Class.class)) {
            verify(type instanceof ParameterizedType);
            Type[] argument = ((ParameterizedType)type).getActualTypeArguments();
            verify(argument.length == 1);
            verify(argument[0] instanceof WildcardType);
            WildcardType variable = (WildcardType)argument[0];
            verify(variable.getLowerBounds().length == 0);
            Type[] bound = variable.getUpperBounds();
            verify(bound.length == 1);
            verify(bound[0] instanceof Class);
            Class<?> base = (Class<?>)bound[0];
            return classes().filter(base::isAssignableFrom).filter(c->!Modifier.isAbstract(c.getModifiers())).map(Class::getName);
        }
        return Stream.empty();
    }

    @Override
    public String toString() {
    	return String.format("\n[-] %s%s : %s\n\t%s\n",
            parent.prefix,
            option.name().isEmpty() ? member.getName() : option.name(),
            domain.isEnum() ? 
            		"[" + String.join(", ", Arrays.stream(domain.getEnumConstants())
            				.map(o -> o instanceof OptionInterface ? 
            						((OptionInterface)o).asStringOption() : 
            						o.toString().toLowerCase())
            				.collect(Collectors.toList())) + 
            		"]" : 
        			domain.getSimpleName(),
            option.description());
    }

	@Override
	public int compareTo(OptionInfo o) {
		return toString().compareTo(o.toString());
	}
}