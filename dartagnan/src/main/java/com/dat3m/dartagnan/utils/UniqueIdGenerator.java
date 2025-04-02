package com.dat3m.dartagnan.utils;

import java.util.HashMap;
import java.util.Map;

public class UniqueIdGenerator {
    private final Map<String, Integer> name2freeId;

    private UniqueIdGenerator(Map<String, Integer> name2freeId) {
        this.name2freeId = name2freeId;
    }

    public static UniqueIdGenerator fresh() {
        return new UniqueIdGenerator(new HashMap<>());
    }

    public static UniqueIdGenerator copy(UniqueIdGenerator other) {
        return new UniqueIdGenerator(new HashMap<>(other.name2freeId));
    }

    public String getUniqueName(String name) {
        final int counter = name2freeId.compute(name, (k, v) -> (v == null ? 0 : v) + 1);
        return name + "#" + counter;
    }

    public void max(UniqueIdGenerator other) {
        other.name2freeId.forEach((k, v) -> name2freeId.merge(k, v, Math::max));
    }

}
