package com.dat3m.dartagnan.others.utils.rules;

import org.junit.rules.TestWatcher;
import org.junit.runner.Description;

import java.util.Map;
import java.util.function.Function;
import java.util.function.Supplier;

/*
    This Provider can be used to provide information based on the executed test method
    as opposed to the current test instance.
    This has limited use cases at it can mostly only respond based on the NAME of the executed test.
 */
public class MethodSpecificProvider<T> extends TestWatcher implements Supplier<T> {

    private final Function<Description, T> mapping;
    protected T value;

    @Override
    public T get() {
        return value;
    }

    private MethodSpecificProvider(Function<Description, T> mapping) {
        this.mapping = mapping;
    }

    public static <V> MethodSpecificProvider<V> fromDescription(Function<Description, V> mapping) {
        return new MethodSpecificProvider<>(mapping);
    }

    public static <V> MethodSpecificProvider<V> fromMethodName(Function<String, V> mapping) {
        return fromDescription(desc -> mapping.apply(
                desc.getMethodName().substring(0, desc.getMethodName().indexOf("["))
        ));
    }

    public static <V> MethodSpecificProvider<V> fromMethodName(Map<String, V> mapping) {
        return fromMethodName(mapping::get);
    }




    @Override
    protected void starting(Description description) {
        value = mapping.apply(description);
    }
}
