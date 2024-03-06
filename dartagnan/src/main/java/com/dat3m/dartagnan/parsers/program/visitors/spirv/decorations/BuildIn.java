package com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations;

import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.Map;
import java.util.function.BiConsumer;

public class BuildIn {

    private static final ExpressionFactory FACTORY = ExpressionFactory.getInstance();
    private static final IntegerType TYPE_ARCH = TypeFactory.getInstance().getArchType();
    private static final int SIZE_ARCH = TypeFactory.getInstance().getMemorySizeInBytes(TYPE_ARCH);

    private static final Map<String, BiConsumer<BuildIn, MemoryObject>> decorations = Map.ofEntries(
            Map.entry("LocalInvocationId",  (b, m) -> {
                m.setInitialValue(0, FACTORY.makeValue(b.x, TYPE_ARCH));
                m.setInitialValue(SIZE_ARCH, FACTORY.makeValue(b.y, TYPE_ARCH));
                m.setInitialValue(SIZE_ARCH * 2, FACTORY.makeValue(b.z, TYPE_ARCH));
            }),
            Map.entry("GlobalInvocationId",  (b, m) -> {
                m.setInitialValue(0, FACTORY.makeValue(b.x, TYPE_ARCH));
                m.setInitialValue(SIZE_ARCH, FACTORY.makeValue(b.y, TYPE_ARCH));
                m.setInitialValue(SIZE_ARCH * 2, FACTORY.makeValue(b.z, TYPE_ARCH));
            })
    );

    private final int x;
    private final int y;
    private final int z;

    // TODO: Pass other data if needed
    public BuildIn(int x, int y, int z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public MemoryObject decorate(MemoryObject memObj, String decoration) {
        if (decorations.containsKey(decoration)) {
            decorations.get(decoration).accept(this, memObj);
            return memObj;
        }
        throw new UnsupportedOperationException("Unsupported decoration " + decoration);
    }

    // TODO: Implement other buildIns, testing
}
