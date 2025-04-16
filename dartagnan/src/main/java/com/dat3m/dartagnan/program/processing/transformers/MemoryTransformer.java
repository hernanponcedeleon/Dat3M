package com.dat3m.dartagnan.program.processing.transformers;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.*;
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
    private static final List<String> namePrefixesVulkan = List.of("T", "S", "W", "Q", "D");
    private static final List<String> namePrefixesOpenCL = List.of("T", "S", "W", "D", "A");

    private final Program program;
    private final Function function;
    private final BuiltIn builtIn;
    private final List<? extends Map<MemoryObject, MemoryObject>> scopeMapping;
    private final Map<MemoryObject, ScopedPointerVariable> pointerMapping;
    private final List<IntUnaryOperator> scopeIdProvider;
    private final List<IntUnaryOperator> namePrefixIdxProvider;
    private Map<Register, Register> registerMapping;
    private Map<NonDetValue, NonDetValue> nonDetMapping;
    private int tid;

    public MemoryTransformer(ThreadGrid grid, Function function, BuiltIn builtIn, Set<ScopedPointerVariable> variables) {
        this.program = function.getProgram();
        this.function = function;
        this.builtIn = builtIn;
        this.scopeMapping = grid.getArch() == Arch.VULKAN ?
                Stream.generate(() -> new HashMap<MemoryObject, MemoryObject>()).limit(namePrefixesVulkan.size()).toList() :
                Stream.generate(() -> new HashMap<MemoryObject, MemoryObject>()).limit(namePrefixesOpenCL.size()).toList();
        this.pointerMapping = variables.stream().collect(Collectors.toMap((ScopedPointerVariable::getAddress), (v -> v)));
        this.scopeIdProvider = getScopeIdProvider(grid);
        this.namePrefixIdxProvider = getNamePrefixIdxProvider(grid);
    }

    private List<IntUnaryOperator> getScopeIdProvider(ThreadGrid grid) {
        if (grid.getArch() == Arch.VULKAN) {
            return List.of(
                    tid1 -> grid.getId(Tag.Vulkan.INVOCATION, tid1),
                    tid2 -> grid.getId(Tag.Vulkan.SUB_GROUP, tid2),
                    tid3 -> grid.getId(Tag.Vulkan.WORK_GROUP, tid3),
                    tid4 -> grid.getId(Tag.Vulkan.QUEUE_FAMILY, tid4),
                    tid5 -> grid.getId(Tag.Vulkan.DEVICE, tid5));
        }
        if (grid.getArch() == Arch.OPENCL) {
            return List.of(
                    tid1 -> grid.getId(Tag.OpenCL.WORK_ITEM, tid1),
                    tid2 -> grid.getId(Tag.OpenCL.SUB_GROUP, tid2),
                    tid3 -> grid.getId(Tag.OpenCL.WORK_GROUP, tid3),
                    tid4 -> grid.getId(Tag.OpenCL.DEVICE, tid4),
                    tid5 -> grid.getId(Tag.OpenCL.ALL, tid5));
        }
        throw new UnsupportedOperationException("Thread grid not supported for architecture: " + grid.getArch());
    }

    private List<IntUnaryOperator> getNamePrefixIdxProvider(ThreadGrid grid) {
        if (grid.getArch() == Arch.VULKAN) {
            return List.of(
                    i -> i,
                    i -> i / grid.getSize(Tag.Vulkan.SUB_GROUP),
                    i -> i / grid.getSize(Tag.Vulkan.WORK_GROUP),
                    i -> i / grid.getSize(Tag.Vulkan.QUEUE_FAMILY),
                    i -> i / grid.getSize(Tag.Vulkan.DEVICE));
        }
        if (grid.getArch() == Arch.OPENCL) {
            return List.of(
                    i -> i,
                    i -> i / grid.getSize(Tag.OpenCL.SUB_GROUP),
                    i -> i / grid.getSize(Tag.OpenCL.WORK_GROUP),
                    i -> i / grid.getSize(Tag.OpenCL.DEVICE),
                    i -> i / grid.getSize(Tag.OpenCL.ALL));
        }
        throw new UnsupportedOperationException("Thread grid not supported for architecture: " + grid.getArch());
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
        nonDetMapping = new HashMap<>();
    }

    public List<MemoryObject> getThreadLocalMemoryObjects() {
        List<MemoryObject> threadLocalMemoryObjects = new ArrayList<>();
        for (MemoryObject memoryObject : pointerMapping.keySet()) {
            if (memoryObject.isThreadLocal()) {
                threadLocalMemoryObjects.add(memoryObject);
            }
        }
        return threadLocalMemoryObjects;
    }

    @Override
    public Expression visitRegister(Register register) {
        return registerMapping.get(register);
    }

    @Override
    public Expression visitNonDetValue(NonDetValue nonDetValue) {
        return nonDetMapping.computeIfAbsent(nonDetValue, x -> (NonDetValue) program.newConstant(x.getType()));
    }

    @Override
    public Expression visitMemoryObject(MemoryObject memObj) {
        String storageClass = pointerMapping.get(memObj).getScopeId();
        return switch (storageClass) {
            // Device/All-level memory (keep the same instance)
            case Tag.Spirv.SC_UNIFORM_CONSTANT,
                 Tag.Spirv.SC_UNIFORM,
                 Tag.Spirv.SC_GENERIC,
                 Tag.Spirv.SC_OUTPUT,
                 Tag.Spirv.SC_PUSH_CONSTANT,
                 Tag.Spirv.SC_STORAGE_BUFFER,
                 Tag.Spirv.SC_PHYS_STORAGE_BUFFER,
                 Tag.Spirv.SC_CROSS_WORKGROUP -> memObj;
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
        Map<MemoryObject, MemoryObject> mapping = scopeMapping.get(scopeDepth);
        if (!mapping.containsKey(memObj)) {
            MemoryObject copy = memObj instanceof VirtualMemoryObject
                    ? program.getMemory().allocateVirtual(memObj.getKnownSize(), true, null)
                    : program.getMemory().allocate(memObj.getKnownSize());
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
        List<String> namePrefixes = program.getArch() == Arch.OPENCL ? namePrefixesOpenCL : namePrefixesVulkan;
        return String.format("%s@%s%s", base, namePrefixes.get(idx), namePrefixIdxProvider.get(idx).applyAsInt(tid));
    }
}
