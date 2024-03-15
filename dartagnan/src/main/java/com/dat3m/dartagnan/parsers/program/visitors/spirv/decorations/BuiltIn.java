package com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BuiltIn implements Decoration {

    private static final ExpressionFactory FACTORY = ExpressionFactory.getInstance();
    private static final IntegerType TYPE_ARCH = TypeFactory.getInstance().getArchType();

    private final Map<String, List<String>> mapping = new HashMap<>();

    private int x = -1;
    private int y = -1;
    private int z = -1;

    public BuiltIn setHierarchy(int x, int y, int z) {
        this.x = x;
        this.y = y;
        this.z = z;
        return this;
    }

    @Override
    public void addDecoration(String id, String... params) {
        if (params.length != 1) {
            throw new ParsingException("Illegal decoration '%s' for '%s'",
                    getClass().getSimpleName(), id);
        }
        List<String> values = mapping.computeIfAbsent(id, k -> new ArrayList<>());
        if (values.contains(params[0])) {
            throw new ParsingException("Duplicated decoration '%s' '%s' for '%s'",
                    getClass().getSimpleName(), params[0], id);
        }
        values.add(params[0]);
    }

    public void decorate(String id, MemoryObject memObj, Type type) {
        if (x < 0 || y < 0 || z < 0) {
            throw new ParsingException("Illegal BuiltIn hierarchy ('%d', '%d', '%d')", x, y, z);
        }
        for (String decoration : mapping.getOrDefault(id, List.of())) {
            switch (decoration) {
                case "LocalInvocationId", "GlobalInvocationId" -> {
                    int size = TypeFactory.getInstance().getMemorySizeInBytes(type) / 3;
                    // TODO: Use array element type instead of arch type
                    memObj.setInitialValue(0, FACTORY.makeValue(x, TYPE_ARCH));
                    memObj.setInitialValue(size, FACTORY.makeValue(y, TYPE_ARCH));
                    memObj.setInitialValue(size * 2, FACTORY.makeValue(z, TYPE_ARCH));
                }
                default -> throw new ParsingException("Unsupported decoration '%s'", decoration);
            }
        }
    }
}
