package com.dat3m.dartagnan.parsers.program.visitors.spirv.builders;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.*;
import com.dat3m.dartagnan.program.ThreadGrid;

import java.util.EnumMap;

import static com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType.*;

public class DecorationsBuilder {

    private final EnumMap<DecorationType, Decoration> mapping = new EnumMap<>(DecorationType.class);

    public DecorationsBuilder(ThreadGrid grid) {
        mapping.put(ARRAY_STRIDE, new ArrayStride());
        mapping.put(BUILT_IN, new BuiltIn(grid));
        mapping.put(OFFSET, new Offset());
    }

    public Decoration getDecoration(DecorationType type) {
        if (mapping.containsKey(type)) {
            return mapping.get(type);
        }
        throw new ParsingException("Unsupported decoration type '%s'", type);
    }
}
