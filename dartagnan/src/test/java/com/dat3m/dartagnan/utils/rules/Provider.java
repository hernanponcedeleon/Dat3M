package com.dat3m.dartagnan.utils.rules;

import org.junit.rules.TestRule;
import org.junit.runner.Description;
import org.junit.runners.model.Statement;

import java.util.function.Supplier;

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

}
