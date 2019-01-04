package dartagnan.parsers.utils;

import com.google.common.collect.ImmutableSet;
import dartagnan.asserts.AbstractAssert;
import dartagnan.expression.IConst;
import dartagnan.parsers.utils.branch.Cmp;
import dartagnan.parsers.utils.branch.CondJump;
import dartagnan.parsers.utils.branch.Label;
import dartagnan.program.Program;
import dartagnan.program.Register;
import dartagnan.program.Thread;
import dartagnan.program.event.If;
import dartagnan.program.event.Init;
import dartagnan.program.event.Local;
import dartagnan.program.event.Skip;
import dartagnan.program.memory.Address;
import dartagnan.program.memory.Location;
import dartagnan.program.memory.Memory;

import java.util.*;

public class ProgramBuilder {

    private Map<String, Map<String, Register>> registers = new HashMap<>();
    private Map<String, Location> locations = new HashMap<>();
    private Map<String, Address> pointers = new HashMap<>();

    private Map<String, Map<String, Label>> labels = new HashMap<>();
    private Map<String, LinkedList<Thread>> threads = new HashMap<>();
    private Map<Address, IConst> iValueMap = new HashMap<>();
    private Memory memory = new Memory();

    private AbstractAssert ass;
    private AbstractAssert assFilter;

    public Program build(){
        Program program = new Program(memory, ImmutableSet.copyOf(locations.values()));
        for(LinkedList<Thread> thread : threads.values()){
            thread = buildBranches(thread);
            program.add(Thread.fromList(true, thread));
        }
        for (Map.Entry<Address, IConst> entry : iValueMap.entrySet()) {
            program.add(new Init(entry.getKey(), entry.getValue()));
        }
        program.setAss(ass);
        program.setAssFilter(assFilter);
        new AliasAnalysis().calculateLocationSets(program, memory);
        return program;
    }

    public void initThread(String thread){
        registers.putIfAbsent(thread, new HashMap<>());
        threads.putIfAbsent(thread, new LinkedList<>());
    }

    public Thread addChild(String thread, Thread child){
        if(!threads.containsKey(thread)){
            throw new RuntimeException("Thread " + thread + " is not initialised");
        }
        threads.get(thread).add(child);
        return child;
    }

    public Thread removeChild(String thread){
        if(!threads.containsKey(thread)){
            throw new RuntimeException("Thread " + thread + " is not initialised");
        }
        return Thread.fromList(true, threads.remove(thread));
    }

    public Thread getLastThreadEvent(String thread){
        if(threads.containsKey(thread)){
            return threads.get(thread).getLast();
        }
        return null;
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
        Location location = getOrCreateLocation(leftName);
        iValueMap.put(location.getAddress(), getOrCreateLocation(rightName).getAddress());
    }

    public void initLocEqLocVal(String leftName, String rightName){
        Location left = getOrCreateLocation(leftName);
        Location right = getOrCreateLocation(rightName);
        iValueMap.put(left.getAddress(), iValueMap.get(right.getAddress()));
    }

    public void initLocEqConst(String locName, IConst iValue){
        Location location = getOrCreateLocation(locName);
        iValueMap.put(location.getAddress(), iValue);
    }

    public void initRegEqLocPtr(String regThread, String regName, String locName){
        Location loc = getOrCreateLocation(locName);
        Register reg = getOrCreateRegister(regThread, regName);
        addChild(regThread, new Local(reg, loc.getAddress()));
    }

    public void initRegEqLocVal(String regThread, String regName, String locName){
        Location loc = getOrCreateLocation(locName);
        Register reg = getOrCreateRegister(regThread, regName);
        addChild(regThread, new Local(reg, iValueMap.get(loc.getAddress())));
    }

    public void initRegEqConst(String regThread, String regName, IConst iValue){
        addChild(regThread, new Local(getOrCreateRegister(regThread, regName), iValue));
    }

    public void addDeclarationArray(String name, List<IConst> values){
        int size = values.size();
        List<Address> addresses = memory.malloc(name, size);
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

    public Location getLocation(String name){
        return locations.get(name);
    }

    public Location getOrCreateLocation(String name){
        if(!locations.containsKey(name)){
            Location location = memory.getOrCreateLocation(name);
            locations.put(name, location);
            iValueMap.put(location.getAddress(), new IConst(Location.DEFAULT_INIT_VALUE));
        }
        return locations.get(name);
    }

    public Location getOrErrorLocation(String name){
        if(locations.containsKey(name)){
            return locations.get(name);
        }
        throw new ParsingException("Location " + name + " has not been initialised");
    }

    public Register getRegister(String thread, String name){
        if(registers.containsKey(thread)){
            return registers.get(thread).get(name);
        }
        return null;
    }

    public Register getOrCreateRegister(String thread, String name){
        if(!registers.containsKey(thread)){
            initThread(thread);
        }
        Map<String, Register> threadRegisters = registers.get(thread);
        if(name == null || !(threadRegisters.keySet().contains(name))) {
            threadRegisters.put(name, new Register(name));
        }
        return threadRegisters.get(name);
    }

    public Register getOrErrorRegister(String thread, String name){
        if(registers.containsKey(thread)){
            Register register = registers.get(thread).get(name);
            if(register != null){
                return register;
            }
        }
        throw new RuntimeException("Register " + thread + ":" + name + " is not initialised");
    }

    public Label getLabel(String thread, String name){
        if(labels.containsKey(thread)){
            return labels.get(thread).get(name);
        }
        return null;
    }

    public Label getOrCreateLabel(String thread, String name){
        labels.putIfAbsent(thread, new HashMap<>());
        Map<String, Label> threadLabels = labels.get(thread);
        threadLabels.putIfAbsent(name, new Label(name));
        return threadLabels.get(name);
    }

    public Label getOrErrorLabel(String thread, String name){
        if(labels.containsKey(thread)){
            Label label = labels.get(thread).get(name);
            if(label != null){
                return label;
            }
        }
        throw new RuntimeException("Label " + thread + ":" + name + " is not initialised");
    }

    public IConst getInitValue(Address address){
        return iValueMap.getOrDefault(address, new IConst(Location.DEFAULT_INIT_VALUE));
    }


    // ----------------------------------------------------------------------------------------------------------------
    // A basic conversion from jump instructions to if structure

    private LinkedList<Thread> buildBranches(LinkedList<Thread> events){
        Stack<LinkedList<Thread>> bStack = new Stack<>();
        LinkedList<Thread> thread = new LinkedList<>();

        Cmp lastCmp = null;
        for(Thread event : events){
            if(event instanceof Cmp){
                lastCmp = (Cmp)event;

            } else if(event instanceof CondJump){
                if(lastCmp == null){
                    throw new RuntimeException("Unrecognised instruction sequence");
                }
                ((CondJump)event).setCmp(lastCmp);
                bStack.push(thread);
                thread = new LinkedList<>();
                thread.add(event);

            } else if(event instanceof Label){
                Thread t;
                do{
                    CondJump jump = (CondJump)thread.pollFirst();
                    if(jump == null || jump.getLabel() != event){
                        throw new RuntimeException("Unrecognised instruction sequence");
                    }
                    If ifEvent = jump.toIf(new Skip(), Thread.fromList(true, thread));
                    thread = bStack.pop();
                    thread.add(ifEvent);
                    t = thread.peekFirst();
                } while (t instanceof CondJump && ((CondJump)t).getLabel() == event);


            } else {
                thread.add(event);
            }
        }

        return thread;
    }

    public Address getPointer(String name){
        return pointers.get(name);
    }
}
