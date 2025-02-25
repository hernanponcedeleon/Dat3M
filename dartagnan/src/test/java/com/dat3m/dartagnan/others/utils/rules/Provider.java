package com.dat3m.dartagnan.others.utils.rules;

import org.junit.rules.TestRule;
import org.junit.runner.Description;
import org.junit.runners.model.Statement;

import java.util.function.Supplier;

/*
    A Provider is a TestRule that provides values for tests.
    While not strictly necessary, Providers are implemented to generate
    their value only once per test and then return cached values.
 */
public interface Provider<T> extends Supplier<T>, TestRule {

    @Override
    default Statement apply(Statement statement, Description description) {
        return statement;
    }


    static <V> Provider<V> fromSupplier(Supplier<V> supplier) {
        return new AbstractProvider<>() {
            @Override
            protected V provide() {
                return supplier.get();
            }
        };
    }

    static <V> Provider<V> fromSupplier(UncheckedSupplier<V> supplier) {
        return fromSupplier((Supplier<V>) supplier);
    }

}
