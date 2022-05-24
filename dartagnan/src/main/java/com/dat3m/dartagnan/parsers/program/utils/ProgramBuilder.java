package com.dat3m.dartagnan.parsers.program.utils;

import com.dat3m.dartagnan.asserts.AbstractAssert;
import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.google.common.base.Preconditions.checkArgument;

public class ProgramBuilder {

    private final Map<Integer, Thread> threads = new HashMap<>();

    private final Map<String,MemoryObject> locations = new HashMap<>();

    private final Memory memory = new Memory();

    private final Map<String, Label> labels = new HashMap<>();

    private AbstractAssert ass;
    private AbstractAssert assFilter;

    private int lastOrigId = 0;
    
    private SourceLanguage format;

    public ProgramBuilder(SourceLanguage format) {
    	this.format = format;
    }
    
    public Program build(){
        Program program = new Program(memory, format);
        buildInitThreads();
        for(Thread thread : threads.values()){
        	addChild(thread.getId(), getOrCreateLabel("END_OF_T" + thread.getId()));
            validateLabels(thread);
            program.add(thread);
            thread.setProgram(program);
        }
        program.setAss(ass);
        program.setAssFilter(assFilter);
        return program;
    }

    public void initThread(String name, int id){
        if(!threads.containsKey(id)){
            Skip threadEntry = EventFactory.newSkip();
            threadEntry.setOId(lastOrigId++);
            threads.putIfAbsent(id, new Thread(name, id, threadEntry));
        }
    }

    public void initThread(int id){
        initThread(String.valueOf(id), id);
    }

    public Event addChild(int thread, Event child){
        if(!threads.containsKey(thread)){
            throw new MalformedProgramException("Thread " + thread + " is not initialised");
        }
        child.setOId(lastOrigId++);
        threads.get(thread).append(child);
        // Every event in litmus tests is no-optimisable
        if(format.equals(LITMUS)) {
            child.addFilters(Tag.NOOPT);
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

    public void initRegEqLocPtr(int regThread, String regName, String locName, int precision){
        MemoryObject object = getOrNewObject(locName);
        Register reg = getOrCreateRegister(regThread, regName, precision);
        addChild(regThread, EventFactory.newLocal(reg, object));
    }

    public void initRegEqLocVal(int regThread, String regName, String locName, int precision){
        Register reg = getOrCreateRegister(regThread, regName, precision);
        addChild(regThread,EventFactory.newLocal(reg,getInitialValue(locName)));
    }

    public void initRegEqConst(int regThread, String regName, IConst iValue){
        addChild(regThread, EventFactory.newLocal(getOrCreateRegister(regThread, regName, iValue.getPrecision()), iValue));
    }

    private IConst getInitialValue(String name) {
        return getOrNewObject(name).getInitialValue(0);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Utility

    public Event getLastEvent(int thread){
        return threads.get(thread).getExit();
    }

    public MemoryObject getObject(String name) {
        return locations.get(name);
    }

    public MemoryObject getOrNewObject(String name) {
        MemoryObject object = locations.computeIfAbsent(name,k->memory.allocate(1));
        object.setCVar(name);
		return object;
    }

    public MemoryObject newObject(String name, int size) {
        checkArgument(!locations.containsKey(name), "Illegal malloc. Array " + name + " is already defined");
        MemoryObject result = memory.allocate(size);
        locations.put(name,result);
        return result;
    }

    public Register getRegister(int thread, String name){
        if(threads.containsKey(thread)){
            return threads.get(thread).getRegister(name);
        }
        return null;
    }

    public Register getOrCreateRegister(int threadId, String name, int precision){
        initThread(threadId);
        Thread thread = threads.get(threadId);
        if(name == null) {
            return thread.newRegister(precision);
        }
        Register register = thread.getRegister(name);
        if(register == null){
            return thread.newRegister(name, precision);
        }
        return register;
    }

    public Register getOrErrorRegister(int thread, String name){
        if(threads.containsKey(thread)){
            Register register = threads.get(thread).getRegister(name);
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

    private int nextThreadId(){
        int maxId = -1;
        for(int key : threads.keySet()){
            maxId = Integer.max(maxId, key);
        }
        return maxId + 1;
    }

    private void buildInitThreads(){
        int nextThreadId = nextThreadId();
        for(MemoryObject a : memory.getObjects()) {
            for(int i = 0; i < a.size(); i++) {
                Event e = EventFactory.newInit(a,i);
                Thread thread = new Thread(nextThreadId,e);
                threads.put(nextThreadId,thread);
                nextThreadId++;
            }
        }
    }

    private void validateLabels(Thread thread) throws MalformedProgramException {
        Map<String, Label> threadLabels = new HashMap<>();
        Set<String> referencedLabels = new HashSet<>();
        Event e = thread.getEntry();
        while(e != null){
            if(e instanceof CondJump){
                referencedLabels.add(((CondJump) e).getLabel().getName());
            } else if(e instanceof Label){
                Label label = labels.remove(((Label) e).getName());
                if(label == null){
                    throw new MalformedProgramException("Duplicated label " + ((Label) e).getName());
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
}
