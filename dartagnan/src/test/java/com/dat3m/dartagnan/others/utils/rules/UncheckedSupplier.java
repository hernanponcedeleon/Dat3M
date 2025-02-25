package com.dat3m.dartagnan.others.utils.rules;

import java.util.function.Supplier;

/*
    This is a functional interface for convenience.
    It is used to create Suppliers using lambdas that throw checked exceptions.
    It does so by wrapping the checked exception into an unchecked RuntimeException.
 */
@FunctionalInterface
public interface UncheckedSupplier<T> extends Supplier<T> {

    T getChecked() throws Throwable;

    @Override
    default T get() {
        try {
            return getChecked();
        } catch (Throwable throwable) {
            throw new RuntimeException(throwable);
        }
    }

    static <T> Supplier<T> create(UncheckedSupplier<T> supplier) {
        return supplier;
    }
}
