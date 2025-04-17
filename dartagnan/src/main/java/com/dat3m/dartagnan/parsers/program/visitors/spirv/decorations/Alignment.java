package com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations;

import com.dat3m.dartagnan.exception.ParsingException;

import java.util.HashMap;
import java.util.Map;

public class Alignment implements Decoration {

    private final Map<String, Integer> mapping = new HashMap<>();

    @Override
    public void addDecoration(String id, String... params) {
        if (params.length != 1) {
            throw new ParsingException("Illegal decoration '%s' for '%s'",
                    getClass().getSimpleName(), id);
        }
        int alignment = Integer.parseInt(params[0]);
        mapping.put(id, alignment);
    }

    public Integer getValue(String id) {
        return mapping.get(id);
    }
}
