package com.dat3m.dartagnan.utils.rules;

import org.apache.logging.log4j.LogManager;
import org.junit.rules.ExternalResource;

import java.util.function.Supplier;

public abstract class Provider<T> extends ExternalResource implements Supplier<T> {

    protected T value;

    @Override
    public T get() {
        return value;
    }

    protected abstract T provide() throws Throwable;

    @Override
    protected void before() throws Throwable {
        value = provide();
    }

    @Override
    protected void after() {
        if (value instanceof AutoCloseable) {
            try {
                ((AutoCloseable) value).close();
            } catch (Exception e) {
                LogManager.getRootLogger().error(e.getMessage());
            }
        }
        value = null;
    }
}
