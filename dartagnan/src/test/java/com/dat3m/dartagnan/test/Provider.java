package com.dat3m.dartagnan.test;

import org.junit.rules.ExternalResource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.function.Supplier;

/*
    A Provider is a TestRule that provides values for tests.
    While not strictly necessary, Providers are implemented to generate
    their value only once per test and then return cached values.
 */
public final class Provider<T> extends ExternalResource implements Supplier<T> {

    private final Supplier<T> supplier;
    private volatile T value;

    private Provider(Supplier<T> supplier) { this.supplier = supplier; }

    @Override
    public T get() { return value; }

    @Override
    protected void before() throws Throwable { value = supplier.get(); }

    @Override
    protected void after() {
        if (value instanceof AutoCloseable closeable) {
            try {
                closeable.close();
            } catch (Exception e) {
                LoggerFactory.getLogger(Logger.ROOT_LOGGER_NAME).error(e.getMessage());
            }
        }
        value = null;
    }

    public static <V> Provider<V> fromSupplier(Supplier<V> supplier) {
        return new Provider<>(supplier);
    }
}
