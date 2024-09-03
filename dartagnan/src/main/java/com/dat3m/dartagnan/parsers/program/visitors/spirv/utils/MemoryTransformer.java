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
import java.util.function.IntUnaryOperator;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static java.util.stream.Collectors.toMap;

public class MemoryTransformer extends ExprTransformer {

    // Thread / Subgroup / Workgroup / QueueFamily / Device
    private static final List<String> namePrefixes = List.of("T", "S", "W", "Q", "D");

    private final Function function;
    private final BuiltIn builtIn;
    private final List<? extends Map<MemoryObject, MemoryObject>> scopeMapping;
    private final Map<MemoryObject, ScopedPointerVariable> pointerMapping;
    private final List<IntUnaryOperator> scopeIdProvider;
    private final List<IntUnaryOperator> namePrefixIdxProvider;
    private Map<Register, Register> registerMapping;
    private int tid;

    public MemoryTransformer(ThreadGrid grid, Function function, BuiltIn builtIn, Set<ScopedPointerVariable> variables) {
        this.function = function;
        this.builtIn = builtIn;
        this.scopeMapping = Stream.generate(() -> new HashMap<MemoryObject, MemoryObject>()).limit(namePrefixes.size()).toList();
        this.pointerMapping = variables.stream().collect(Collectors.toMap((ScopedPointerVariable::getAddress), (v -> v)));
        this.scopeIdProvider = List.of(grid::thId, grid::sgId, grid::wgId, grid::qfId, grid::dvId);
        this.namePrefixIdxProvider = List.of(
                i -> i,
                i -> i / grid.sgSize(),
                i -> i / grid.wgSize(),
                i -> i / grid.qfSize(),
                i -> i / grid.dvSize());
    }

    public Register getRegisterMapping(Register register) {
        return registerMapping.get(register);
    }

    public void setThread(Thread thread) {
        int newTid = thread.getId();
        int depth = getScopeIdx(newTid, scopeIdProvider);
        for (int i = 0; i <= depth; i++) {
            scopeMapping.get(i).clear();
        }
        tid = newTid;
        builtIn.setThreadId(tid);
        registerMapping = function.getRegisters().stream().collect(
                toMap(r -> r, r -> thread.getOrNewRegister(r.getName(), r.getType())));
    }

    @Override
    public Expression visitRegister(Register register) {
        return registerMapping.get(register);
    }

    @Override
    public Expression visitMemoryObject(MemoryObject memObj) {
        String storageClass = pointerMapping.get(memObj).getScopeId();
        return switch (storageClass) {
            // Device-level memory (keep the same instance)
            case Tag.Spirv.SC_UNIFORM_CONSTANT,
                    Tag.Spirv.SC_UNIFORM,
                    Tag.Spirv.SC_OUTPUT,
                    Tag.Spirv.SC_PUSH_CONSTANT,
                    Tag.Spirv.SC_STORAGE_BUFFER,
                    Tag.Spirv.SC_PHYS_STORAGE_BUFFER -> memObj;
            // Private memory (copy for each new thread)
            case Tag.Spirv.SC_PRIVATE,
                    Tag.Spirv.SC_FUNCTION,
                    Tag.Spirv.SC_INPUT -> applyMapping(memObj, 0);
            // Workgroup-level memory (copy for each new workgroup)
            case Tag.Spirv.SC_WORKGROUP -> applyMapping(memObj, 2);
            default -> throw new UnsupportedOperationException(
                    "Unsupported storage class " + storageClass);
        };
    }

    private Expression applyMapping(MemoryObject memObj, int scopeDepth) {
        Program program = function.getProgram();
        Map<MemoryObject, MemoryObject> mapping = scopeMapping.get(scopeDepth);
        if (!mapping.containsKey(memObj)) {
            MemoryObject copy = memObj instanceof VirtualMemoryObject
                    ? program.getMemory().allocateVirtual(memObj.size(), true, null)
                    : program.getMemory().allocate(memObj.size());
            copy.setName(makeVariableName(scopeDepth, memObj.getName()));
            for (int offset : memObj.getInitializedFields()) {
                Expression value = memObj.getInitialValue(offset);
                if (value instanceof NonDetValue) {
                    value = program.newConstant(value.getType());
                }
                copy.setInitialValue(offset, value);
            }
            builtIn.decorate(memObj.getName(), copy, pointerMapping.get(memObj).getInnerType());
            mapping.put(memObj, copy);
        }
        return mapping.getOrDefault(memObj, memObj);
    }

    private int getScopeIdx(int newTid, List<IntUnaryOperator> f) {
        for (int i = f.size() - 1; i >= 0; i--) {
            if (f.get(i).applyAsInt(newTid) != f.get(i).applyAsInt(tid)) {
                return i;
            }
        }
        return -1;
    }

    private String makeVariableName(int idx, String base) {
        return String.format("%s@%s%s", base, namePrefixes.get(idx),
                namePrefixIdxProvider.get(idx).applyAsInt(tid));
    }
}
