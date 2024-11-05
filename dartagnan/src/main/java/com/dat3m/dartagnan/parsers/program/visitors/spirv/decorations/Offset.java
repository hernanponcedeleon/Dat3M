package com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations;

import com.dat3m.dartagnan.exception.ParsingException;

import java.util.HashMap;
import java.util.Map;

public class Offset implements Decoration {

    private final Map<String, Map<Integer, Integer>> mapping = new HashMap<>();

    @Override
    public void addDecoration(String id, String... params) {
        if (params.length != 2) {
            throw new ParsingException("Illegal decoration '%s' for '%s'",
                    getClass().getSimpleName(), id);
        }
        int index = Integer.parseInt(params[0]);
        int offset = Integer.parseInt(params[1]);
        Map<Integer, Integer> typeOffsets = mapping.computeIfAbsent(id, x -> new HashMap<>());
        if (typeOffsets.containsKey(index)) {
            throw new ParsingException("Duplicated '%s' decoration for '%s' index '%s'",
                    getClass().getSimpleName(), id, index);
        }
        typeOffsets.put(index, offset);
    }

    public Map<Integer, Integer> getValue(String id) {
        return mapping.get(id);
    }
}
