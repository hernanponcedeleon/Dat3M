package com.dat3m.dartagnan.parsers.program.visitors.spirv.transformers;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.LeafExpression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.memory.VirtualMemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn.GRID_SIZE;

public class MemoryTransformer extends ExprTransformer {

    private static final List<String> NAME_PREFIX = List.of("T", "S", "W", "Q");

    private final Program program;
    private final BuiltIn builtIn;
    private final Map<String, Type> typeMap;
    private final Map<String, String> storageClassMap;
    private final List<Integer> threadId;
    private final List<? extends Map<Expression, Expression>> mappings;

    public MemoryTransformer(Program program, BuiltIn builtIn, Map<String, Type> typeMap,
                             Map<String, String> storageClassMap) {
        this.program = program;
        this.builtIn = builtIn;
        this.typeMap = typeMap;
        this.storageClassMap = storageClassMap;
        this.threadId = new ArrayList<>(Stream.generate(() -> 0)
                .limit(GRID_SIZE).toList());
        this.mappings = Stream.generate(() -> new HashMap<Expression, Expression>())
                .limit(GRID_SIZE).toList();
    }

    public void setHierarchy(List<Integer> threadId) {
        if (threadId.stream().anyMatch(e -> e < 0) || threadId.size() != GRID_SIZE) {
            throw new ParsingException("Illegal hierarchical thread id %s",
                    String.join(", ", threadId.stream().map(Object::toString).toList()));
        }
        for (int i = 0; i < threadId.size(); i++) {
            if (!this.threadId.get(i).equals(threadId.get(i))) {
                for (int j = 0; j <= i; j++) {
                    mappings.get(j).clear();
                }
            }
            this.threadId.set(i, threadId.get(i));
        }
        builtIn.setHierarchy(threadId);
    }

    @Override
    public Expression visitLeafExpression(LeafExpression expr) {
        if (expr instanceof MemoryObject memObj) {
            String storageClass = storageClassMap.get(memObj.getName());
            return switch (storageClass) {
                case Tag.Spirv.SC_UNIFORM_CONSTANT,
                        Tag.Spirv.SC_UNIFORM,
                        Tag.Spirv.SC_OUTPUT,
                        Tag.Spirv.SC_PUSH_CONSTANT,
                        Tag.Spirv.SC_STORAGE_BUFFER,
                        Tag.Spirv.SC_PHYS_STORAGE_BUFFER -> expr;
                case Tag.Spirv.SC_PRIVATE,
                        Tag.Spirv.SC_FUNCTION,
                        Tag.Spirv.SC_INPUT -> applyMapping(memObj, 0);
                case Tag.Spirv.SC_WORKGROUP -> applyMapping(memObj, 2);
                default -> throw new UnsupportedOperationException(
                        "Unsupported storage class " + storageClass);
            };
        }
        return expr;
    }

    private Expression applyMapping(MemoryObject memObj, int idx) {
        Map<Expression, Expression> mapping = mappings.get(idx);
        if (!mapping.containsKey(memObj)) {
            MemoryObject copy;
            if (memObj instanceof VirtualMemoryObject) {
                // TODO: alias
                copy = program.getMemory().allocateVirtual(memObj.size(), true, null);
            } else {
                copy = program.getMemory().allocate(memObj.size());
            }
            copy.setName(makeVariableName(idx, memObj.getName()));
            for (Integer i : memObj.getInitializedFields()) {
                Expression initValue = memObj.getInitialValue(i);
                if (initValue instanceof NonDetValue) {
                    initValue = program.newConstant(initValue.getType());
                }
                copy.setInitialValue(i, initValue);
            }
            builtIn.decorate(memObj.getName(), copy, typeMap.get(memObj.getName()));
            mapping.put(memObj, copy);
        }
        return mapping.getOrDefault(memObj, memObj);
    }

    private String makeVariableName(int idx, String base) {
        return String.format("%s@%s%s", base, NAME_PREFIX.get(idx), builtIn.getGlobalIdAtIndex(idx));
    }
}
