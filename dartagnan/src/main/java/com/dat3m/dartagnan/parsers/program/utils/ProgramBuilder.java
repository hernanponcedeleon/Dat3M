package com.dat3m.dartagnan.parsers.program.utils;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
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
    private final List<INonDet> constants = new ArrayList<>();
    private final Map<String,MemoryObject> locations = new HashMap<>();

    private final Memory memory = new Memory();

    private final Map<String, Label> labels = new HashMap<>();

    private AbstractAssert ass;
    private AbstractAssert assFilter;

    private final SourceLanguage format;

    public ProgramBuilder(SourceLanguage format) {
    	this.format = format;
    }
    
    public Program build(){
        Program program = new Program(memory, format);
        List<Thread> threads = functions.values().stream()
                .filter(Thread.class::isInstance).map(Thread.class::cast)
                .toList();
        for(Thread thread : threads){
            addChild(thread.getId(), getOrCreateLabel("END_OF_T" + thread.getId()));
            validateLabels(thread);
            program.addThread(thread);
            thread.setProgram(program);
        }

        List<Function> funcs = functions.values().stream()
                .filter(f -> !(f instanceof Thread))
                .toList();
        for (Function f : funcs) {
            f.setProgram(program);
            program.addFunction(f);
        }
        constants.forEach(program::addConstant);
        program.setSpecification(ass);
        program.setFilterSpecification(assFilter);
        EventIdReassignment.newInstance().run(program);
        program.getEvents().forEach(e -> e.setMetadata(new OriginalId(e.getGlobalId())));
        return program;
    }

    public void initThread(String name, int id){
        if(!functions.containsKey(id)){
            Skip threadEntry = EventFactory.newSkip();
            functions.putIfAbsent(id, new Thread(name, id, threadEntry));
        }
    }

    public Function initFunction(String name, int id, FunctionType type, List<String> parameterNames) {
        if(!functions.containsKey(id)){
            Skip entry = EventFactory.newSkip();
            functions.putIfAbsent(id, new Function(name, type, parameterNames, id, entry));
            return functions.get(id);
        }
        return null;
    }


    public void initThread(int id){
        initThread(String.valueOf(id), id);
    }

    public Event addChild(int thread, Event child) {
        //TODO: Generalize to functions
        if(!functions.containsKey(thread)){
            throw new MalformedProgramException("Thread " + thread + " is not initialised");
        }
        if (child.getThread() != null) {
            //FIXME: This is a bad error message, but our tests require this for now.
            final String error = String.format(
                    "Trying to reinsert event %s from thread %s into thread %s",
                    child, child.getThread().getId(), thread);
            throw new MalformedProgramException(error);
        }
        functions.get(thread).append(child);
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

    public void initRegEqLocPtr(int regThread, String regName, String locName, IntegerType type) {
        MemoryObject object = getOrNewObject(locName);
        Register reg = getOrNewRegister(regThread, regName, type);
        addChild(regThread, EventFactory.newLocal(reg, object));
    }

    public void initRegEqLocVal(int regThread, String regName, String locName, IntegerType type) {
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

    public Register getRegister(int thread, String name){
        if(functions.containsKey(thread)){
            return functions.get(thread).getRegister(name);
        }
        return null;
    }

    public Register getOrNewRegister(int threadId, String name) {
        return getOrNewRegister(threadId, name, types.getArchType());
    }

    public Register getOrNewRegister(int threadId, String name, IntegerType type) {
        initThread(threadId);
        Function func = functions.get(threadId);
        if(name == null) {
            return func.newRegister(type);
        }
        Register register = func.getRegister(name);
        if(register == null){
            return func.newRegister(name, type);
        }
        return register;
    }

    public Register getOrErrorRegister(int thread, String name){
        if(functions.containsKey(thread)){
            Register register = functions.get(thread).getRegister(name);
            if(register != null){
                return register;
            }
        }
        throw new IllegalStateException("Register " + thread + ":" + name + " is not initialised");
    }

    public boolean hasLabel(String name) {
    	return labels.containsKey(name);
    }
    
    public Label getOrCreateLabel(String name){
        labels.putIfAbsent(name, EventFactory.newLabel(name));
        return labels.get(name);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Private utility

    private void validateLabels(Thread thread) throws MalformedProgramException {
        Map<String, Label> threadLabels = new HashMap<>();
        Set<String> referencedLabels = new HashSet<>();
        Event e = thread.getEntry();
        while(e != null){
            if(e instanceof CondJump jump){
                referencedLabels.add(jump.getLabel().getName());
            } else if(e instanceof Label lb){
                Label label = labels.remove(lb.getName());
                if(label == null){
                    throw new MalformedProgramException("Duplicated label " + lb.getName());
                }
                threadLabels.put(label.getName(), label);
            }
            e = e.getSuccessor();
        }

        for(String labelName : referencedLabels){
            if(!threadLabels.containsKey(labelName)){
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
