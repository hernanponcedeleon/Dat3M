package com.dat3m.dartagnan.parsers.program.utils;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.*;
import com.google.common.collect.ImmutableSet;
import com.dat3m.dartagnan.asserts.AbstractAssert;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.Memory;

import java.util.*;

public class ProgramBuilder {

    private Map<Integer, Thread> threads = new HashMap<>();

    private Map<String, Location> locations = new HashMap<>();
    private Map<String, Address> pointers = new HashMap<>();

    private Map<Address, IConst> iValueMap = new HashMap<>();
    private Memory memory = new Memory();

    private Map<String, Label> labels = new HashMap<>();

    private AbstractAssert ass;
    private AbstractAssert assFilter;

    private int lastOrigId = 0;

    public Program build(){
        Program program = new Program(memory, ImmutableSet.copyOf(locations.values()));
        buildInitThreads();
        for(Thread thread : threads.values()){
            validateLabels(thread);
            program.add(thread);
        }
        program.setAss(ass);
        program.setAssFilter(assFilter);
        return program;
    }

    public void initThread(String name, int id){
        if(!threads.containsKey(id)){
            Skip threadEntry = new Skip();
            threadEntry.setOId(lastOrigId++);
            threads.putIfAbsent(id, new Thread(name, id, threadEntry));
        }
    }

    public void initThread(int id){
        initThread(null, id);
    }

    public Event addChild(int thread, Event child){
        if(!threads.containsKey(thread)){
            throw new RuntimeException("Thread " + thread + " is not initialised");
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

    public void initLocEqLocPtr(String leftName, String rightName, int precision){
        Location location = getOrCreateLocation(leftName, precision);
        iValueMap.put(location.getAddress(), getOrCreateLocation(rightName, precision).getAddress());
    }

    public void initLocEqLocVal(String leftName, String rightName, int precision){
        Location left = getOrCreateLocation(leftName, precision);
        Location right = getOrCreateLocation(rightName, precision);
        iValueMap.put(left.getAddress(), iValueMap.get(right.getAddress()));
    }

    public void initLocEqConst(String locName, IConst iValue){
        Location location = getOrCreateLocation(locName, iValue.getPrecision());
        iValueMap.put(location.getAddress(), iValue);
    }

    public void initRegEqLocPtr(int regThread, String regName, String locName, int precision){
        Location loc = getOrCreateLocation(locName, precision);
        Register reg = getOrCreateRegister(regThread, regName, precision);
        addChild(regThread, new Local(reg, loc.getAddress()));
    }

    public void initRegEqLocVal(int regThread, String regName, String locName, int precision){
        Location loc = getOrCreateLocation(locName, precision);
        Register reg = getOrCreateRegister(regThread, regName, precision);
        addChild(regThread, new Local(reg, iValueMap.get(loc.getAddress())));
    }

    public void initRegEqConst(int regThread, String regName, IConst iValue){
        addChild(regThread, new Local(getOrCreateRegister(regThread, regName, iValue.getPrecision()), iValue));
    }

    public void addDeclarationArray(String name, List<IConst> values, int precision){
        int size = values.size();
        List<Address> addresses = memory.malloc(name, size, precision);
        for(int i = 0; i < size; i++){
            String varName = name + "[" + i + "]";
            Address address = addresses.get(i);
            locations.put(varName, new Location(varName, address));
            iValueMap.put(address, values.get(i));
        }
        pointers.put(name, addresses.get(0));
    }

    public void addDeclarationArray(String name, List<IConst> values){
    	addDeclarationArray(name, values, -1);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Utility

    public Event getLastEvent(int thread){
        return threads.get(thread).getExit();
    }

    public Location getLocation(String name){
        return locations.get(name);
    }

    public Location getOrCreateLocation(String name, int precision){
        if(!locations.containsKey(name)){
            Location location = memory.getOrCreateLocation(name, precision);
            locations.put(name, location);
            iValueMap.put(location.getAddress(), new IConst(Location.DEFAULT_INIT_VALUE, location.getAddress().getPrecision()));
        }
        return locations.get(name);
    }

    public Location getOrErrorLocation(String name){
        if(locations.containsKey(name)){
            return locations.get(name);
        }
        throw new ParsingException("Location " + name + " has not been initialised");
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
        throw new ParsingException("Register " + thread + ":" + name + " is not initialised");
    }

    public boolean hasLabel(String name) {
    	return labels.containsKey(name);
    }
    
    public Label getOrCreateLabel(String name){
        labels.putIfAbsent(name, new Label(name));
        return labels.get(name);
    }

    public IConst getInitValue(Address address){
        return iValueMap.getOrDefault(address, new IConst(Location.DEFAULT_INIT_VALUE, address.getPrecision()));
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
        for (Map.Entry<Address, IConst> entry : iValueMap.entrySet()) {
            Event e = new Init(entry.getKey(), entry.getValue());
            Thread thread = new Thread(nextThreadId, e);
            threads.put(nextThreadId, thread);
            nextThreadId++;
        }
    }

    private void validateLabels(Thread thread) throws ParsingException {
        Map<String, Label> threadLabels = new HashMap<>();
        Set<String> referencedLabels = new HashSet<>();
        Event e = thread.getEntry();
        while(e != null){
            if(e instanceof CondJump){
                referencedLabels.add(((CondJump) e).getLabel().getName());
            } else if(e instanceof Label){
                Label label = labels.remove(((Label) e).getName());
                if(label == null){
                    throw new ParsingException("Duplicated label " + ((Label) e).getName());
                }
                threadLabels.put(label.getName(), label);
            }
            e = e.getSuccessor();
        }

        for(String labelName : referencedLabels){
            if(!threadLabels.containsKey(labelName)){
                throw new ParsingException("Illegal jump to label " + labelName);
            }
        }
    }
}
