package com.dat3m.dartagnan.parsers.program.visitors.spirv.utils;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import com.dat3m.dartagnan.program.memory.VirtualMemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static java.util.stream.Collectors.toMap;

public class MemoryTransformer extends ExprTransformer {

    private static final List<String> namePrefixes = List.of("T", "S", "W", "Q");

    private final List<Integer> grid;
    private final Function function;
    private final BuiltIn builtIn;
    private final List<Integer> threadId;
    private Map<Register, Register> registerMapping;
    private final List<? extends Map<MemoryObject, MemoryObject>> memoryScopeMapping;
    private final Map<MemoryObject, ScopedPointerVariable> memoryPointersMapping;

    public MemoryTransformer(List<Integer> grid, Function function, BuiltIn builtIn, Set<ScopedPointerVariable> variables) {
        this.grid = grid;
        this.function = function;
        this.builtIn = builtIn;
        this.threadId = new ArrayList<>(Stream.generate(() -> 0).limit(grid.size()).toList());
        this.memoryScopeMapping = Stream.generate(() -> new HashMap<MemoryObject, MemoryObject>()).limit(grid.size()).toList();
        this.memoryPointersMapping = variables.stream().collect(Collectors.toMap((ScopedPointerVariable::getAddress), (v -> v)));
    }

    public Register getRegisterMapping(Register register) {
        return registerMapping.get(register);
    }

    public void setThread(Thread thread) {
        List<Integer> newThreadId = getThreadHierarchicalId(thread);
        for (int i = 0; i < newThreadId.size(); i++) {
            if (!threadId.get(i).equals(newThreadId.get(i))) {
                for (int j = 0; j <= i; j++) {
                    memoryScopeMapping.get(j).clear();
                }
            }
            threadId.set(i, newThreadId.get(i));
        }
        builtIn.setHierarchy(newThreadId);
        registerMapping = function.getRegisters().stream().collect(
                toMap(r -> r, r -> thread.getOrNewRegister(r.getName(), r.getType())));
    }

    @Override
    public Expression visitRegister(Register register) {
        return registerMapping.get(register);
    }

    @Override
    public Expression visitMemoryObject(MemoryObject memObj) {
        String storageClass = memoryPointersMapping.get(memObj).getScopeId();
        return switch (storageClass) {
            case Tag.Spirv.SC_UNIFORM_CONSTANT,
                    Tag.Spirv.SC_UNIFORM,
                    Tag.Spirv.SC_OUTPUT,
                    Tag.Spirv.SC_PUSH_CONSTANT,
                    Tag.Spirv.SC_STORAGE_BUFFER,
                    Tag.Spirv.SC_PHYS_STORAGE_BUFFER -> memObj;
            case Tag.Spirv.SC_PRIVATE,
                    Tag.Spirv.SC_FUNCTION,
                    Tag.Spirv.SC_INPUT -> applyMapping(memObj, 0);
            case Tag.Spirv.SC_WORKGROUP -> applyMapping(memObj, 2);
            default -> throw new UnsupportedOperationException(
                    "Unsupported storage class " + storageClass);
        };
    }

    private Expression applyMapping(MemoryObject memObj, int scopeLevel) {
        Program program = function.getProgram();
        Map<MemoryObject, MemoryObject> mapping = memoryScopeMapping.get(scopeLevel);
        if (!mapping.containsKey(memObj)) {
            MemoryObject copy = memObj instanceof VirtualMemoryObject
                    ? program.getMemory().allocateVirtual(memObj.size(), true, null)
                    : program.getMemory().allocate(memObj.size());

            copy.setName(makeVariableName(scopeLevel, memObj.getName()));
            for (int offset : memObj.getInitializedFields()) {
                Expression value = memObj.getInitialValue(offset);
                if (value instanceof NonDetValue) {
                    value = program.newConstant(value.getType());
                }
                copy.setInitialValue(offset, value);
            }
            builtIn.decorate(memObj.getName(), copy, memoryPointersMapping.get(memObj).getInnerType());
            mapping.put(memObj, copy);
        }
        return mapping.getOrDefault(memObj, memObj);
    }

    private List<Integer> getThreadHierarchicalId(Thread thread) {
        int sgId = thread.getScopeHierarchy().getScopeId(Tag.Vulkan.SUB_GROUP);
        int wgId = thread.getScopeHierarchy().getScopeId(Tag.Vulkan.WORK_GROUP);
        int qfId = thread.getScopeHierarchy().getScopeId(Tag.Vulkan.QUEUE_FAMILY);
        int thId = thread.getId() % grid.get(0);
        return List.of(thId, sgId, wgId, qfId);
    }

    private String makeVariableName(int idx, String base) {
        return String.format("%s@%s%s", base, namePrefixes.get(idx), builtIn.getGlobalIdAtIndex(idx));
    }
}
