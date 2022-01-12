package com.dat3m.dartagnan.parsers.program.utils;

import com.dat3m.dartagnan.asserts.AbstractAssert;
import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.Memory;

import java.math.BigInteger;
import java.util.*;

import static com.google.common.base.Preconditions.checkArgument;

public class ProgramBuilder {

	public static final BigInteger DEFAULT_INIT_VALUE = BigInteger.ZERO;

    private final Map<Integer, Thread> threads = new HashMap<>();

    private final Map<String, Location> locations = new HashMap<>();
    private final Map<String, Address> pointers = new HashMap<>();

    private final Map<Address,IConst> iValueMap = new HashMap<>();
    private final Memory memory = new Memory();

    private final Map<String, Label> labels = new HashMap<>();

    private AbstractAssert ass;
    private AbstractAssert assFilter;

    private int lastOrigId = 0;

    public Program build(){
        Program program = new Program(memory);
        buildInitThreads();
        for(Thread thread : threads.values()){
            validateLabels(thread);
            // The boogie visitor creates the label by itself because it need it for EventFactory.Pthread.newStart
            // thus we check if the label exists to avoid having it twice
            if(!hasLabel("END_OF_T" + thread.getId())) {
            	addChild(thread.getId(), getOrCreateLabel("END_OF_T" + thread.getId()));
            }
            program.add(thread);
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
        Address location = getOrCreateLocation(leftName);
        iValueMap.put(location, getOrCreateLocation(rightName));
    }

    public void initLocEqLocVal(String leftName, String rightName){
        Address left = getOrCreateLocation(leftName);
        Address right = getOrCreateLocation(rightName);
        iValueMap.put(left, iValueMap.get(right));
    }

    public void initLocEqConst(String locName, IConst iValue){
        Address location = getOrCreateLocation(locName);
        iValueMap.put(location, iValue);
    }

    public void initRegEqLocPtr(int regThread, String regName, String locName, int precision){
        Address loc = getOrCreateLocation(locName);
        Register reg = getOrCreateRegister(regThread, regName, precision);
        addChild(regThread, EventFactory.newLocal(reg, loc));
    }

    public void initRegEqLocVal(int regThread, String regName, String locName, int precision){
        Address loc = getOrCreateLocation(locName);
        Register reg = getOrCreateRegister(regThread, regName, precision);
        addChild(regThread, EventFactory.newLocal(reg, iValueMap.get(loc)));
    }

    public void initRegEqConst(int regThread, String regName, IConst iValue){
        addChild(regThread, EventFactory.newLocal(getOrCreateRegister(regThread, regName, iValue.getPrecision()), iValue));
    }

    public void addDeclarationArray(String name, List<IConst> values){
        checkArgument(!pointers.containsKey(name), "Illegal malloc. Array " + name + " is already defined");
        int size = values.size();
        List<Address> addresses = memory.malloc(size);
        for(int i = 0; i < size; i++){
            String varName = name + "[" + i + "]";
            Address address = addresses.get(i);
            locations.put(varName, new Location(varName, address));
            iValueMap.put(address, values.get(i));
        }
        pointers.put(name, addresses.get(0));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Utility

    public Event getLastEvent(int thread){
        return threads.get(thread).getExit();
    }

    public Address getLocation(String name){
        Location l = locations.get(name);
        return l==null ? null : l.getAddress();
    }

    public Address getOrCreateLocation(String name){
        if(!locations.containsKey(name)){
            Address address = memory.newLocation();
            locations.put(name, new Location(name,address));
            iValueMap.put(address, new IConst(DEFAULT_INIT_VALUE, address.getPrecision()));
        }
        return locations.get(name).getAddress();
    }

    public Location getOrErrorLocation(String name){
        if(locations.containsKey(name)){
            return locations.get(name);
        }
        throw new IllegalStateException("Location " + name + " has not been initialised");
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
        Register register = thread.getRegister(name);
        if(register == null){
            return thread.addRegister(name, precision);
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

    public IConst getInitValue(Address address){
        return iValueMap.getOrDefault(address, new IConst(DEFAULT_INIT_VALUE, address.getPrecision()));
    }

    public Address getPointer(String name){
        return pointers.get(name);
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
        for (Map.Entry<Address,IConst> entry : iValueMap.entrySet()) {
            Event e = EventFactory.newInit(entry.getKey(),0,entry.getValue());
            Thread thread = new Thread(nextThreadId, e);
            threads.put(nextThreadId, thread);
            nextThreadId++;
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
