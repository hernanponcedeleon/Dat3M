package com.dat3m.dartagnan.parsers.program.utils;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.*;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.program.event.metadata.OriginalId;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.memory.VirtualMemoryObject;
import com.dat3m.dartagnan.program.processing.IdReassignment;
import com.google.common.base.Preconditions;
import com.google.common.base.Verify;
import com.google.common.collect.Iterables;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.dat3m.dartagnan.program.event.Tag.NOOPT;
import static com.google.common.base.Preconditions.checkState;

public class ProgramBuilder {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private static final FunctionType DEFAULT_THREAD_TYPE =
            types.getFunctionType(types.getVoidType(), List.of());

    private final Map<Integer, Function> id2FunctionsMap = new HashMap<>();
    private final Map<Integer, Map<String, Label>> fid2LabelsMap = new HashMap<>();
    private final Map<String, MemoryObject> locations = new HashMap<>();

    private final Program program;

    // ----------------------------------------------------------------------------------------------------------------
    // Construction
    private ProgramBuilder(SourceLanguage format) {
        this.program = new Program(new Memory(), format);
    }

    public static ProgramBuilder forArch(SourceLanguage format, Arch arch) {
        final ProgramBuilder programBuilder = forLanguage(format);
        programBuilder.program.setArch(arch);
        return programBuilder;
    }

    public static ProgramBuilder forLanguage(SourceLanguage format) {
        return new ProgramBuilder(format);
    }

    public Program build() {
        for (Thread thread : program.getThreads()) {
            final Label endOfThread = getEndOfThreadLabel(thread.getId());
            // The terminator should not get inserted somewhere beforehand.
            Verify.verify(endOfThread.getFunction() == null);
            // Every event in litmus tests is non-optimisable
            if (program.getFormat() == LITMUS) {
                endOfThread.addTags(NOOPT);
            }
            thread.append(endOfThread);
        }
        processAfterParsing(program);
        return program;
    }

    public static void processAfterParsing(Program program) {
        program.getFunctions().forEach(Function::validate);
        program.getThreads().forEach(Function::validate);
        IdReassignment.newInstance().run(program);
        for (Function func : Iterables.concat(program.getThreads(), program.getFunctions())) {
            if (func.hasBody()) {
                func.getEvents().forEach(e -> e.setMetadata(new OriginalId(e.getGlobalId())));
            }
        }
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Misc

    public TypeFactory getTypeFactory() {
        return types;
    }

    public ExpressionFactory getExpressionFactory() {
        return expressions;
    }

    public void setAssert(Program.SpecificationType type, Expression ass) {
        program.setSpecification(type, ass);
    }

    public void setAssertFilter(Expression ass) {
        program.setFilterSpecification(ass);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Threads and Functions

    // This method creates a "default" thread that has no parameters, no return value, and runs unconditionally.
    // It is only useful for creating threads of Litmus code.
    public Thread newThread(String name, int tid) {
        if(id2FunctionsMap.containsKey(tid)) {
            throw new MalformedProgramException("Function or thread with id " + tid + " already exists.");
        }
        final Thread thread = new Thread(name, DEFAULT_THREAD_TYPE, List.of(), tid, EventFactory.newThreadStart(null));
        id2FunctionsMap.put(tid, thread);
        program.addThread(thread);
        return thread;
    }

    public Function newFunction(String name, int fid, FunctionType type, List<String> parameterNames) {
        if(id2FunctionsMap.containsKey(fid)) {
            throw new MalformedProgramException("Function or thread with id " + fid + " already exists.");
        }
        final Function func = new Function(name, type, parameterNames, fid, null);
        id2FunctionsMap.put(fid, func);
        program.addFunction(func);
        return func;
    }

    public Thread newThread(int tid) {
        final String threadName = (program.getFormat() == LITMUS ? "P" : "__thread_") + tid;
        return newThread(threadName, tid);
    }

    public Thread getOrNewThread(int tid) {
        if (!id2FunctionsMap.containsKey(tid)) {
            return newThread(tid);
        }
        return (Thread) id2FunctionsMap.get(tid);
    }

    public boolean functionExists(int fid) {
        return id2FunctionsMap.containsKey(fid);
    }

    public Function getFunctionOrError(int fid) {
        final Function function = id2FunctionsMap.get(fid);
        if (function != null) {
            return function;
        }
        throw new MalformedProgramException("Function or Thread with id " + fid + " does not exist");
    }

    public Event addChild(int fid, Event child) {
        // Every event in litmus tests is non-optimisable
        if (program.getFormat().equals(Program.SourceLanguage.LITMUS)) {
            child.addTags(NOOPT);
        }
        getFunctionOrError(fid).append(child);
        return child;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Memory & Constants

    public MemoryObject getMemoryObject(String name) {
        return locations.get(name);
    }

    public MemoryObject getOrNewMemoryObject(String name, int size) {
        MemoryObject mem = locations.get(name);
        if (mem == null) {
            mem = program.getMemory().allocate(size);
            mem.setName(name);
            if (program.getFormat() == LITMUS) {
                // Litmus code always initializes memory
                final Expression zero = expressions.makeZero(types.getByteType());
                for (int offset = 0; offset < size; offset++) {
                    mem.setInitialValue(offset, zero);
                }
            }
            locations.put(name, mem);
        }
        return mem;
    }

    public MemoryObject getOrNewMemoryObject(String name) {
        return getOrNewMemoryObject(name, 1);
    }

    public MemoryObject newMemoryObject(String name, int size) {
        checkState(!locations.containsKey(name),
                "Illegal allocation. Memory object %s is already defined", name);
        return getOrNewMemoryObject(name, size);
    }

    public Expression newConstant(Type type) {
        return program.newConstant(type);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Declarators
    public void initLocEqLocPtr(String leftName, String rightName) {
        initLocEqConst(leftName, getOrNewMemoryObject(rightName));
    }

    public void initLocEqLocVal(String leftName, String rightName){
        initLocEqConst(leftName,getInitialValue(rightName));
    }

    public void initLocEqConst(String locName, Expression iValue){
        getOrNewMemoryObject(locName).setInitialValue(0,iValue);
    }

    public void initRegEqLocPtr(int regThread, String regName, String locName, Type type) {
        MemoryObject object = getOrNewMemoryObject(locName);
        Register reg = getOrNewRegister(regThread, regName, type);
        addChild(regThread, EventFactory.newLocal(reg, object));
    }

    public void initRegEqLocVal(int regThread, String regName, String locName, Type type) {
        Register reg = getOrNewRegister(regThread, regName, type);
        addChild(regThread, EventFactory.newLocal(reg,getInitialValue(locName)));
    }

    public void initRegEqConst(int regThread, String regName, Expression value){
        Preconditions.checkArgument(value.getRegs().isEmpty());
        addChild(regThread, EventFactory.newLocal(getOrNewRegister(regThread, regName, value.getType()), value));
    }

    private Expression getInitialValue(String name) {
        return getOrNewMemoryObject(name).getInitialValue(0);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Utility

    public Register getRegister(int fid, String name){
        return getFunctionOrError(fid).getRegister(name);
    }

    public Register getOrNewRegister(int fid, String name) {
        return getOrNewRegister(fid, name, types.getArchType());
    }

    public Register getOrNewRegister(int fid, String name, Type type) {
        Function func = getFunctionOrError(fid);
        Register register = name == null ? func.newRegister(type) : func.getRegister(name);
        return register != null ? register : func.newRegister(name, type);
    }

    public Register getOrErrorRegister(int fid, String name) {
        final Register register = getFunctionOrError(fid).getRegister(name);
        if (register != null) {
            return register;
        }
        throw new IllegalStateException("Register " + fid + ":" + name + " is not initialised");
    }

    public Label getOrCreateLabel(int funcId, String name){
        return fid2LabelsMap
                .computeIfAbsent(funcId, k -> new HashMap<>())
                .computeIfAbsent(name, EventFactory::newLabel);
    }

    public Label getEndOfThreadLabel(int tid) {
        return getOrCreateLabel(tid, "END_OF_T" + tid);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // PTX

    public void newScopedThread(Arch arch, String name, int id, int ...scopeIds) {
        if(id2FunctionsMap.containsKey(id)) {
            throw new MalformedProgramException("Function or thread with id " + id + " already exists.");
        }
        // Litmus threads run unconditionally (have no creator) and have no parameters/return types.
        ThreadStart threadEntry = EventFactory.newThreadStart(null);
        Thread scopedThread = switch (arch) {
            case PTX -> new Thread(name, DEFAULT_THREAD_TYPE, List.of(), id, threadEntry,
                    ScopeHierarchy.ScopeHierarchyForPTX(scopeIds[0], scopeIds[1]), new HashSet<>());
            case VULKAN -> new Thread(name, DEFAULT_THREAD_TYPE, List.of(), id, threadEntry,
                    ScopeHierarchy.ScopeHierarchyForVulkan(scopeIds[0], scopeIds[1], scopeIds[2]), new HashSet<>());
            default -> throw new UnsupportedOperationException("Unsupported architecture: " + arch);
        };
        id2FunctionsMap.put(id, scopedThread);
        program.addThread(scopedThread);
    }

    public void newScopedThread(Arch arch, int id, int ...ids) {
        newScopedThread(arch, String.valueOf(id), id, ids);
    }

    public void initVirLocEqCon(String leftName, IntLiteral iValue){
        MemoryObject object = locations.computeIfAbsent(
                leftName, k->program.getMemory().allocateVirtual(1, true, null));
        object.setName(leftName);
        object.setInitialValue(0, iValue);
    }

    public void initVirLocEqLoc(String leftName, String rightName){
        VirtualMemoryObject rightLocation = (VirtualMemoryObject) getMemoryObject(rightName);
        if (rightLocation == null) {
            throw new MalformedProgramException("Alias to non-exist location: " + rightName);
        }
        MemoryObject object = locations.computeIfAbsent(leftName,
                k->program.getMemory().allocateVirtual(1, true, null));
        object.setName(leftName);
        object.setInitialValue(0,rightLocation.getInitialValue(0));
    }

    public void initVirLocEqLocAliasGen(String leftName, String rightName){
        VirtualMemoryObject rightLocation = (VirtualMemoryObject) getMemoryObject(rightName);
        if (rightLocation == null) {
            throw new MalformedProgramException("Alias to non-exist location: " + rightName);
        }
        MemoryObject object = locations.computeIfAbsent(leftName,
                k->program.getMemory().allocateVirtual(1, true, rightLocation));
        object.setName(leftName);
        object.setInitialValue(0,rightLocation.getInitialValue(0));
    }

    public void initVirLocEqLocAliasProxy(String leftName, String rightName){
        VirtualMemoryObject rightLocation = (VirtualMemoryObject) getMemoryObject(rightName);
        if (rightLocation == null) {
            throw new MalformedProgramException("Alias to non-exist location: " + rightName);
        }
        MemoryObject object = locations.computeIfAbsent(
                leftName, k->program.getMemory().allocateVirtual(1, false, rightLocation));
        object.setName(leftName);
        object.setInitialValue(0,rightLocation.getInitialValue(0));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Vulkan
    public void addSwwPairThreads(int threadId0, int threadId1) {
        Thread thread0 = (Thread) getFunctionOrError(threadId0);
        Thread thread1 = (Thread) getFunctionOrError(threadId1);
        if (thread0.hasSyncSet()) {
            thread0.getSyncSet().add(thread1);
        }
    }
}
