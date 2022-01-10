package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.exception.UnsatisfiedRequirementException;
import com.google.common.collect.ClassToInstanceMap;
import com.google.common.collect.MutableClassToInstanceMap;

public class Context {
    private final ClassToInstanceMap<Object> metaDataMap;

    private Context() {
        metaDataMap = MutableClassToInstanceMap.create();
    }

    public static Context create() {
        return new Context();
    }

    // =============================================

    public <T> boolean has(Class<T> c) {
        return metaDataMap.containsKey(c);
    }

    public <T> T get(Class<T> c) {
        return metaDataMap.getInstance(c);
    }

    public <T> boolean invalidate(Class<T> c) {
        return metaDataMap.remove(c) == null;
    }

    public <T> boolean register(Class<T> c, T instance) {
        if (has(c)) {
            return false;
        }
        metaDataMap.putInstance(c, instance);
        return true;
    }

    public <T> T requires(Class<T> c) {
        T instance = get(c);
        if (instance == null) {
            throw new UnsatisfiedRequirementException("Requires " + c.getSimpleName());
        }
        return instance;
    }
}
