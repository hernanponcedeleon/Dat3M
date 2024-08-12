package com.dat3m.dartagnan.parsers.program.visitors.spirv.builders;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.Decoration;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.SpecId;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.utils.ThreadGrid;

import java.util.EnumMap;

import static com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType.BUILT_IN;
import static com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType.SPEC_ID;

public class DecorationsBuilder {

    private final EnumMap<DecorationType, Decoration> mapping = new EnumMap<>(DecorationType.class);

    public DecorationsBuilder(ThreadGrid grid) {
        mapping.put(BUILT_IN, new BuiltIn(grid));
        mapping.put(SPEC_ID, new SpecId());
    }

    public Decoration getDecoration(DecorationType type) {
        if (mapping.containsKey(type)) {
            return mapping.get(type);
        }
        throw new ParsingException("Unsupported decoration type '%s'", type);
    }
}
