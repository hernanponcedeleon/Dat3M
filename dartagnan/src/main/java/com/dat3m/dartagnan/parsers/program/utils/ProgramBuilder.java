package com.dat3m.dartagnan.parsers.program.utils;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.ScopedThread.PTXThread;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.program.event.metadata.OriginalId;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.memory.VirtualMemoryObject;
import com.dat3m.dartagnan.program.processing.EventIdReassignment;
import com.dat3m.dartagnan.program.specification.AbstractAssert;

import java.util.*;

import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.google.common.base.Preconditions.checkArgument;

public class ProgramBuilder {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private static final FunctionType DEFAULT_THREAD_TYPE =
            types.getFunctionType(types.getVoidType(), List.of());

    private final Map<Integer, Function> id2FunctionsMap = new HashMap<>();
    private final Map<Integer, Map<String, Label>> fid2LabelsMap = new HashMap<>();
    private final Map<String, MemoryObject> locations = new HashMap<>();

    private final Program program;

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

    public TypeFactory getTypeFactory() {
        return types;
    }

    public ExpressionFactory getExpressionFactory() {
        return expressions;
    }
    
    public Program build() {
        for (Thread thread : program.getThreads()) {
            addChild(thread.getId(), getOrCreateLabel(thread.getId(), "END_OF_T" + thread.getId()));
        }
        id2FunctionsMap.values().forEach(this::validateLabels);

        EventIdReassignment.newInstance().run(program);
        program.getEvents().forEach(e -> e.setMetadata(new OriginalId(e.getGlobalId())));
        return program;
    }

    public void initThread(String name, int tid) {
        if(id2FunctionsMap.containsKey(tid)) {
            throw new MalformedProgramException("Function or thread with id " + tid + " already exists.");
        }
        final Thread thread = new Thread(name, DEFAULT_THREAD_TYPE, List.of(), tid, EventFactory.newSkip());
        id2FunctionsMap.put(tid, thread);
        program.addThread(thread);
    }

    public Function initFunction(String name, int fid, FunctionType type, List<String> parameterNames) {
        if(id2FunctionsMap.containsKey(fid)) {
            throw new MalformedProgramException("Function or thread with id " + fid + " already exists.");
        }
        final Function func = new Function(name, type, parameterNames, fid, null);
        id2FunctionsMap.put(fid, func);
        program.addFunction(func);
        return func;
    }

    public void initThread(int tid) {
        initThread(String.valueOf(tid), tid);
    }

    public Thread getOrNewThread(int tid) {
        if (!id2FunctionsMap.containsKey(tid)) {
            initThread(tid);
        }
        return (Thread)id2FunctionsMap.get(tid);
    }

    public Event addChild(int fid, Event child) {
        final Function func = id2FunctionsMap.get(fid);
        if(func == null){
            throw new MalformedProgramException("Function " + fid + " is not initialised");
        }
        func.append(child);
        // Every event in litmus tests is non-optimisable
        if(program.getFormat().equals(LITMUS)) {
            child.addTags(Tag.NOOPT);
        }
        return child;
    }

    public void setAssert(AbstractAssert ass) {
        program.setSpecification(ass);
    }

    public void setAssertFilter(AbstractAssert ass) {
        program.setFilterSpecification(ass);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Declarators
    public void initLocEqLocPtr(String leftName, String rightName){
        initLocEqConst(leftName, getOrNewObject(rightName));
    }

    public void initLocEqLocVal(String leftName, String rightName){
        initLocEqConst(leftName,getInitialValue(rightName));
    }

    public void initLocEqConst(String locName, IConst iValue){
        getOrNewObject(locName).setInitialValue(0,iValue);
    }

    public void initRegEqLocPtr(int regThread, String regName, String locName, Type type) {
        MemoryObject object = getOrNewObject(locName);
        Register reg = getOrNewRegister(regThread, regName, type);
        addChild(regThread, EventFactory.newLocal(reg, object));
    }

    public void initRegEqLocVal(int regThread, String regName, String locName, Type type) {
        Register reg = getOrNewRegister(regThread, regName, type);
        addChild(regThread,EventFactory.newLocal(reg,getInitialValue(locName)));
    }

    public void initRegEqConst(int regThread, String regName, IConst iValue){
        addChild(regThread, EventFactory.newLocal(getOrNewRegister(regThread, regName, iValue.getType()), iValue));
    }

    private IConst getInitialValue(String name) {
        return getOrNewObject(name).getInitialValue(0);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Utility

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

    public INonDet newConstant(IntegerType type, boolean signed) {
        var constant = new INonDet(program.getConstants().size(), type, signed);
        program.addConstant(constant);
        return constant;
    }

    public MemoryObject getObject(String name) {
        return locations.get(name);
    }

    public MemoryObject getOrNewObject(String name) {
        MemoryObject object = locations.computeIfAbsent(name, k -> program.getMemory().allocate(1, true));
        object.setCVar(name);
        return object;
    }

    public MemoryObject newObject(String name, int size) {
        checkArgument(!locations.containsKey(name), "Illegal malloc. Array " + name + " is already defined");
        MemoryObject result = program.getMemory().allocate(size, true);
        locations.put(name, result);
        return result;
    }

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

    // ----------------------------------------------------------------------------------------------------------------
    // Private utility

    private void validateLabels(Function function) throws MalformedProgramException {
        Map<String, Label> funcLabels = new HashMap<>();
        Set<String> referencedLabels = new HashSet<>();
        Event e = function.getEntry();
        Map<String, Label> labels = fid2LabelsMap.get(function.getId());
        if (labels == null) {
            return;
        }
        while(e != null){
            if(e instanceof CondJump jump){
                referencedLabels.add(jump.getLabel().getName());
            } else if(e instanceof Label lb){
                Label label = labels.remove(lb.getName());
                if(label == null){
                    throw new MalformedProgramException("Duplicated label " + lb.getName());
                }
                funcLabels.put(label.getName(), label);
            }
            e = e.getSuccessor();
        }

        for(String labelName : referencedLabels){
            if(!funcLabels.containsKey(labelName)){
                throw new MalformedProgramException("Illegal jump to label " + labelName);
            }
        }
    }

    // ----------------------------------------------------------------------------------------------------------------
    // PTX

    public void initScopedThread(String name, int id, int ctaID, int gpuID) {
        if(id2FunctionsMap.containsKey(id)) {
            throw new MalformedProgramException("Function or thread with id " + id + " already exists.");
        }
        Skip threadEntry = EventFactory.newSkip();
        PTXThread ptxThread = new PTXThread(name, DEFAULT_THREAD_TYPE, List.of(), id, threadEntry, gpuID, ctaID);
        id2FunctionsMap.put(id, ptxThread);
        program.addThread(ptxThread);
    }

    public void initScopedThread(int id, int ctaID, int gpuID) {
        initScopedThread(String.valueOf(id), id, ctaID, gpuID);
    }

    public void initVirLocEqCon(String leftName, IConst iValue){
        MemoryObject object = locations.computeIfAbsent(
                leftName, k->program.getMemory().allocateVirtual(1, true, true, null));
        object.setCVar(leftName);
        object.setInitialValue(0, iValue);
    }

    public void initVirLocEqLoc(String leftName, String rightName){
        VirtualMemoryObject rightLocation = (VirtualMemoryObject) getObject(rightName);
        if (rightLocation == null) {
            throw new MalformedProgramException("Alias to non-exist location: " + rightName);
        }
        MemoryObject object = locations.computeIfAbsent(leftName,
                k->program.getMemory().allocateVirtual(1, true, true, null));
        object.setCVar(leftName);
        object.setInitialValue(0,rightLocation.getInitialValue(0));
    }

    public void initVirLocEqLocAliasGen(String leftName, String rightName){
        VirtualMemoryObject rightLocation = (VirtualMemoryObject) getObject(rightName);
        if (rightLocation == null) {
            throw new MalformedProgramException("Alias to non-exist location: " + rightName);
        }
        MemoryObject object = locations.computeIfAbsent(leftName,
                k->program.getMemory().allocateVirtual(1, true, true, rightLocation));
        object.setCVar(leftName);
        object.setInitialValue(0,rightLocation.getInitialValue(0));
    }

    public void initVirLocEqLocAliasProxy(String leftName, String rightName){
        VirtualMemoryObject rightLocation = (VirtualMemoryObject) getObject(rightName);
        if (rightLocation == null) {
            throw new MalformedProgramException("Alias to non-exist location: " + rightName);
        }
        MemoryObject object = locations.computeIfAbsent(
                leftName, k->program.getMemory().allocateVirtual(1, true, false, rightLocation));
        object.setCVar(leftName);
        object.setInitialValue(0,rightLocation.getInitialValue(0));
    }
}
