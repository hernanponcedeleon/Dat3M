package com.dat3m.dartagnan.programNew.utils;

import com.google.common.collect.ForwardingMap;

import java.util.HashMap;
import java.util.Map;

public class SymbolTable<T> extends ForwardingMap<String, T> {

    private final Map<String, T> backingMap = new HashMap<>();

    @Override
    protected Map<String, T> delegate() {
        return backingMap;
    }
}
