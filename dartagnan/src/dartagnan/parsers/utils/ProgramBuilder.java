package dartagnan.parsers.utils;

import dartagnan.asserts.AbstractAssert;
import dartagnan.expression.AConst;
import dartagnan.parsers.utils.branch.Cmp;
import dartagnan.parsers.utils.branch.CondJump;
import dartagnan.parsers.utils.branch.Label;
import dartagnan.program.Location;
import dartagnan.program.Program;
import dartagnan.program.Register;
import dartagnan.program.Thread;
import dartagnan.program.event.If;
import dartagnan.program.event.Local;
import dartagnan.program.event.Skip;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Stack;

public class ProgramBuilder {

    public static final int DEFAULT_INIT_VALUE = 0;

    private Map<String, Location> locations = new HashMap<>();
    private Map<String, Map<String, Register>> registers = new HashMap<>();
    private Map<String, Map<String, Location>> mapRegLoc = new HashMap<>();
    private Map<String, Map<String, Label>> labels = new HashMap<>();
    private Map<String, LinkedList<Thread>> threads = new HashMap<>();

    private Program program = new Program();

    public Program build(){
        for(LinkedList<Thread> thread : threads.values()){
            thread = buildBranches(thread);
            program.add(Thread.fromList(true, thread));
        }
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

    public void setAssert(AbstractAssert ass){
        program.setAss(ass);
    }

    public void setAssertFilter(AbstractAssert ass){
        program.setAssFilter(ass);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Declarators

    public void addDeclarationLocLoc(String leftName, String rightName){
        getOrCreateLocation(leftName).setIValue(getOrCreateLocation(rightName).getIValue());
    }

    public void addDeclarationLocImm(String locName, int imm){
        getOrCreateLocation(locName).setIValue(imm);
    }

    public void addDeclarationRegLoc(String regThread, String regName, String locName){
        addRegLocPair(regThread, getOrCreateRegister(regThread, regName).getName(), getOrCreateLocation(locName));
    }

    public void addDeclarationRegImm(String regThread, String regName, int imm){
        addChild(regThread, new Local(getOrCreateRegister(regThread, regName), new AConst(imm)));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Utility

    public Location getLocation(String name){
        return locations.get(name);
    }

    public Location getOrCreateLocation(String name){
        if(!locations.containsKey(name)){
            Location location = new Location(name);
            location.setIValue(DEFAULT_INIT_VALUE);
            locations.put(name, location);
        }
        return locations.get(name);
    }

    public Location getOrErrorLocation(String name){
        if(!locations.containsKey(name)){
            throw new RuntimeException("Location " + name + " is not initialised");
        }
        return locations.get(name);
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
            threadRegisters.put(name, new Register(name).setPrintMainThreadId(thread));
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

    public void addRegLocPair(String thread, String regName, Location location){
        mapRegLoc.putIfAbsent(thread, new HashMap<>());
        mapRegLoc.get(thread).put(regName, location);
    }

    public Location getLocForReg(String threadName, String registerName){
        if(!mapRegLoc.containsKey(threadName)){
            throw new RuntimeException("Unrecognised thread " + threadName);
        }
        Map<String, Location> registerLocationMap = mapRegLoc.get(threadName);
        if(!registerLocationMap.containsKey(registerName)){
            throw new RuntimeException("Register " + registerName + " must be initialized to a location");
        }
        return registerLocationMap.get(registerName);
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
}
