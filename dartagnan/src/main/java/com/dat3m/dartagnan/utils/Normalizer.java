package com.dat3m.dartagnan.utils;

import java.util.HashMap;

public class Normalizer {

    private final HashMap<Object, Object> map = new HashMap<>();

    @SuppressWarnings("unchecked")
    public <T> T normalize(T obj) {
        return (T)map.computeIfAbsent(obj, k -> k);
    }
}
