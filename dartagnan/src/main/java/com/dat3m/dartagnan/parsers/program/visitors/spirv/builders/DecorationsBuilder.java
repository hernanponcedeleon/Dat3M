package com.dat3m.dartagnan.parsers.program.visitors.spirv.builders;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.Decoration;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.Offset;
import com.dat3m.dartagnan.program.ThreadGrid;

import java.util.EnumMap;

import static com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType.BUILT_IN;
import static com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType.OFFSET;

public class DecorationsBuilder {

    private final EnumMap<DecorationType, Decoration> mapping = new EnumMap<>(DecorationType.class);

    public DecorationsBuilder() {
        mapping.put(BUILT_IN, new BuiltIn());
        mapping.put(OFFSET, new Offset());
    }

    public void setThreadGrid(ThreadGrid grid) {
        if (mapping.containsKey(BUILT_IN)) {
            ((BuiltIn) mapping.get(BUILT_IN)).setThreadGrid(grid);
        }
    }

    public Decoration getDecoration(DecorationType type) {
        if (mapping.containsKey(type)) {
            return mapping.get(type);
        }
        throw new ParsingException("Unsupported decoration type '%s'", type);
    }
}
