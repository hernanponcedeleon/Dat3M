package com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.Decoration;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.SpecId;

import java.util.EnumMap;

import static com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType.SPEC_ID;

public class HelperDecorations {

    private final EnumMap<DecorationType, Decoration> mapping = new EnumMap<>(DecorationType.class);

    public HelperDecorations() {
        mapping.put(SPEC_ID, new SpecId());
    }

    public Decoration getDecoration(DecorationType type) {
        if (mapping.containsKey(type)) {
            return mapping.get(type);
        }
        throw new ParsingException("Unsupported decoration type '%s'", type);
    }

    public void addDecorationIfAbsent(DecorationType type, Decoration decoration) {
        mapping.putIfAbsent(type, decoration);
    }
}
