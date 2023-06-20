package com.dat3m.dartagnan.parsers.program.utils;

import com.dat3m.dartagnan.exception.MalformedProgramException;
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

    private final Map<Integer, Function> functions = new HashMap<>();
    private final Map<Integer, Map<String, Label>> function2LabelsMap = new HashMap<>();

    private final Memory memory = new Memory();
    private final Map<String, MemoryObject> locations = new HashMap<>();
    private final List<INonDet> constants = new ArrayList<>();

    private AbstractAssert ass;
    private AbstractAssert assFilter;

    private final SourceLanguage format;

    public ProgramBuilder(SourceLanguage format) {
        this.format = format;
    }
    
    public Program build() {
        Program program = new Program(memory, format);
        for (Function func : functions.values()) {
            if (func instanceof Thread thread) {
                addChild(thread.getId(), getOrCreateLabel(thread.getId(), "END_OF_T" + thread.getId()));
                program.addThread(thread);
            } else {
                program.addFunction(func);
            }
            validateLabels(func);
        }

        constants.forEach(program::addConstant);
        program.setSpecification(ass);
        program.setFilterSpecification(assFilter);
        EventIdReassignment.newInstance().run(program);
        program.getEvents().forEach(e -> e.setMetadata(new OriginalId(e.getGlobalId())));
        return program;
    }

    public void initThread(String name, int tid) {
        if(!functions.containsKey(tid)){
            Skip threadEntry = EventFactory.newSkip();
            functions.putIfAbsent(tid, new Thread(name, tid, threadEntry));
        }
    }

    public Function initFunction(String name, int fid, FunctionType type, List<String> parameterNames) {
        if(!functions.containsKey(fid)){
            functions.putIfAbsent(fid, new Function(name, type, parameterNames, fid, null));
            return functions.get(fid);
        }
        return null;
    }

    public void initThread(int tid){
        initThread(String.valueOf(tid), tid);
    }

    public Event addChild(int fid, Event child) {
        if(!functions.containsKey(fid)){
            throw new MalformedProgramException("Function " + fid + " is not initialised");
        }
        if (child.getThread() != null) {
            //FIXME: This is a bad error message, but our tests require this for now.
            final String error = String.format(
                    "Trying to reinsert event %s from thread %s into thread %s",
                    child, child.getThread().getId(), fid);
            throw new MalformedProgramException(error);
        }
        functions.get(fid).append(child);
        // Every event in litmus tests is non-optimisable
        if(format.equals(LITMUS)) {
            child.addTags(Tag.NOOPT);
        }
        return child;
    }

    public void setAssert(AbstractAssert ass){
        this.ass = ass;
    }

    public void setAssertFilter(AbstractAssert ass){
        this.assFilter = ass;
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

    public INonDet newConstant(IntegerType type, boolean signed) {
        var constant = new INonDet(constants.size(), type, signed);
        constants.add(constant);
        return constant;
    }

    public MemoryObject getObject(String name) {
        return locations.get(name);
    }

    public MemoryObject getOrNewObject(String name) {
        MemoryObject object = locations.computeIfAbsent(name, k -> memory.allocate(1, true));
        object.setCVar(name);
        return object;
    }

    public MemoryObject newObject(String name, int size) {
        checkArgument(!locations.containsKey(name), "Illegal malloc. Array " + name + " is already defined");
        MemoryObject result = memory.allocate(size, true);
        locations.put(name,result);
        return result;
    }

    public Register getRegister(int fid, String name){
        if(functions.containsKey(fid)){
            return functions.get(fid).getRegister(name);
        }
        return null;
    }

    public Register getOrNewRegister(int fid, String name) {
        return getOrNewRegister(fid, name, types.getArchType());
    }

    public Register getOrNewRegister(int fid, String name, Type type) {
        initThread(fid); // FIXME: Scary code!
        Function func = functions.get(fid);
        return name == null ? func.newRegister(type) : func.getOrNewRegister(name, type);
    }

    public Register getOrErrorRegister(int fid, String name){
        if(functions.containsKey(fid)){
            Register register = functions.get(fid).getRegister(name);
            if(register != null){
                return register;
            }
        }
        throw new IllegalStateException("Register " + fid + ":" + name + " is not initialised");
    }

    public Label getOrCreateLabel(int funcId, String name){
        return function2LabelsMap
                .computeIfAbsent(funcId, k -> new HashMap<>())
                .computeIfAbsent(name, EventFactory::newLabel);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Private utility

    private void validateLabels(Function function) throws MalformedProgramException {
        Map<String, Label> funcLabels = new HashMap<>();
        Set<String> referencedLabels = new HashSet<>();
        Event e = function.getEntry();
        Map<String, Label> labels = function2LabelsMap.get(function.getId());
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
        if(!functions.containsKey(id)){
            Skip threadEntry = EventFactory.newSkip();
            functions.putIfAbsent(id, new PTXThread(name, id, threadEntry, gpuID, ctaID));
        }
    }

    public void initScopedThread(int id, int ctaID, int gpuID) {
        initScopedThread(String.valueOf(id), id, ctaID, gpuID);
    }

    public void initVirLocEqCon(String leftName, IConst iValue){
        MemoryObject object = locations.computeIfAbsent(
                leftName, k->memory.allocateVirtual(1, true, true, null));
        object.setCVar(leftName);
        object.setInitialValue(0, iValue);
    }

    public void initVirLocEqLoc(String leftName, String rightName){
        VirtualMemoryObject rightLocation = (VirtualMemoryObject) getObject(rightName);
        if (rightLocation == null) {
            throw new MalformedProgramException("Alias to non-exist location: " + rightName);
        }
        MemoryObject object = locations.computeIfAbsent(leftName,
                k->memory.allocateVirtual(1, true, true, null));
        object.setCVar(leftName);
        object.setInitialValue(0,rightLocation.getInitialValue(0));
    }

    public void initVirLocEqLocAliasGen(String leftName, String rightName){
        VirtualMemoryObject rightLocation = (VirtualMemoryObject) getObject(rightName);
        if (rightLocation == null) {
            throw new MalformedProgramException("Alias to non-exist location: " + rightName);
        }
        MemoryObject object = locations.computeIfAbsent(leftName,
                k->memory.allocateVirtual(1, true, true, rightLocation));
        object.setCVar(leftName);
        object.setInitialValue(0,rightLocation.getInitialValue(0));
    }

    public void initVirLocEqLocAliasProxy(String leftName, String rightName){
        VirtualMemoryObject rightLocation = (VirtualMemoryObject) getObject(rightName);
        if (rightLocation == null) {
            throw new MalformedProgramException("Alias to non-exist location: " + rightName);
        }
        MemoryObject object = locations.computeIfAbsent(
                leftName, k->memory.allocateVirtual(1, true, false, rightLocation));
        object.setCVar(leftName);
        object.setInitialValue(0,rightLocation.getInitialValue(0));
    }
}
