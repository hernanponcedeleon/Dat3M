package com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations;

import com.dat3m.dartagnan.exception.ParsingException;

import java.util.HashMap;
import java.util.Map;

public class SpecId implements Decoration {

    private final Map<String, String> mapping = new HashMap<>();

    @Override
    public void addDecoration(String id, String... params) {
        if (params.length != 1) {
            throw new ParsingException("Illegal decoration '%s' for '%s'",
                    getClass().getSimpleName(), id);
        }
        if (mapping.containsKey(id)) {
            throw new ParsingException("Duplicated decoration '%s' for '%s'",
                    getClass().getSimpleName(), id);
        }
        mapping.put(id, params[0]);
    }

    public String getValue(String id) {
        return mapping.get(id);
    }
}
