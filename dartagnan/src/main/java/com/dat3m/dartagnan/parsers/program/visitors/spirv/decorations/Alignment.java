package com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;

import java.util.HashMap;
import java.util.Map;

public class Alignment implements Decoration {

    private static final TypeFactory types = TypeFactory.getInstance();
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

    public void validateAlignment(String id, Type type) {
        Integer value = mapping.get(id);
        if (value != null) {
            if (type instanceof ScopedPointerType pType) {
                type = pType.getPointedType();
            }
            if (type instanceof ArrayType aType) {
                type = aType.getElementType();
            }
            if (types.getMemorySizeInBytes(type) % value != 0) {
                throw new ParsingException("Unsupported alignment for element '%s'", id);
            }
        }
    }
}
