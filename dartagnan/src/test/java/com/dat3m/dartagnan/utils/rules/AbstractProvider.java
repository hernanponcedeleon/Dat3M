package com.dat3m.dartagnan.utils.rules;

import org.junit.rules.ExternalResource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/*
    A provider generates a value before a test and stores it for multiple reuses.
    After the test, it will clean up the value if it is an AutoClosable.
 */
public abstract class AbstractProvider<T> extends ExternalResource implements Provider<T> {

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
        if (value instanceof AutoCloseable closeable) {
            try {
                closeable.close();
            } catch (Exception e) {
                LoggerFactory.getLogger(Logger.ROOT_LOGGER_NAME).error(e.getMessage());
            }
        }
        value = null;
    }

}
