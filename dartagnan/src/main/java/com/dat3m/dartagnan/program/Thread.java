package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.If;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.program.utils.ThreadCache;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.Lists;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.*;
import java.util.stream.Collectors;

public class Thread {

	private final String name;
    private final int id;
    private final Event entry;
    private Event exit;

    private final Map<String, Register> registers;
    private ThreadCache cache;

    public Thread(String name, int id, Event entry){
        if(id < 0){
            throw new IllegalArgumentException("Invalid thread ID");
        }
        if(entry == null){
            throw new IllegalArgumentException("Thread entry event must be not null");
        }
        entry.setThread(this);
        this.name = name;
        this.id = id;
        this.entry = entry;
        this.exit = this.entry;
        this.registers = new HashMap<>();
    }

    public Thread(int id, Event entry){
    	this(String.valueOf(id), id, entry);
    }

    public String getName(){
        return name;
    }

    public int getId(){
        return id;
    }

    public ThreadCache getCache(){
        if(cache == null){
            cache = new ThreadCache(entry.getSuccessors());
        }
        return cache;
    }

    public void clearCache(){
        cache = null;
    }

    public Register getRegister(String name){
        return registers.get(name);
    }

    public Register addRegister(String name, int precision){
        if(registers.containsKey(name)){
            throw new RuntimeException("Register " + id + ":" + name + " already exists");
        }
        cache = null;
        Register register = new Register(name, id, precision);
        registers.put(register.getName(), register);
        return register;
    }

    public Event getEntry(){
        return entry;
    }

    public Event getExit(){
        return exit;
    }

    public void append(Event event){
        exit.setSuccessor(event);
        event.setThread(this);
        updateExit(event);
        cache = null;
    }

    private void updateExit(Event event){
        exit = event;
        Event next = exit.getSuccessor();
        while(next != null){
            exit = next;
            exit.setThread(this);
            next = next.getSuccessor();
        }
    }

    @Override
    public int hashCode() {
        return id;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        return id == ((Thread) obj).id;
    }

    public void simplify() {
        entry.simplify(null);
        cache = null;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    public int unroll(int bound, int nextId){
    	while(bound > 0) {
    		entry.unroll(bound, null);
    		bound--;
    	}
        nextId = entry.setUId(nextId);
        updateExit(entry);
        cache = null;
        return nextId;
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    public int compile(Arch target, int nextId) {
        nextId = entry.compile(target, nextId, null);
        updateExit(entry);
        cache = null;
        return nextId;
    }

    // Encoding
    // -----------------------------------------------------------------------------------------------------------------

    public BoolExpr encodeCF(Context ctx){
    	BoolExpr enc = ctx.mkTrue();
    	Stack<If> ifStack = new Stack<If>();
    	BoolExpr guard = ctx.mkTrue();
    	for(Event e : entry.getSuccessors()) {
    		if(!ifStack.isEmpty()) {
        		If lastIf = ifStack.peek();
        		if(e.equals(lastIf.getMainBranchEvents().get(0))) {
        			guard = ctx.mkAnd(lastIf.cf(), lastIf.getGuard().toZ3Bool(lastIf, ctx));
        		}
        		if(e.equals(lastIf.getElseBranchEvents().get(0))) {
        			guard = ctx.mkAnd(lastIf.cf(), ctx.mkNot(lastIf.getGuard().toZ3Bool(lastIf, ctx)));
        		}
        		if(e.equals(lastIf.getSuccessor())) {
        			guard = ctx.mkOr(lastIf.getExitMainBranch().getCfCond(), lastIf.getExitElseBranch().getCfCond());
        			ifStack.pop();
        		}    			
    		}
    		enc = ctx.mkAnd(enc, e.encodeCF(ctx, guard));
    		guard = e.cf();
    		if(e instanceof CondJump) {
    			guard = ctx.mkAnd(guard, ctx.mkNot(((CondJump)e).getGuard().toZ3Bool(e, ctx)));
    		}
    		if(e instanceof If) {
    			ifStack.add((If)e);
    		}
    	}
        return enc;
    }




    // -----------------------------------------------------------------------------------------------------------------
    // -------------------------------- Preprocessing -----------------------------------
    // -----------------------------------------------------------------------------------------------------------------

    public int eliminateDeadCode(int startId) {
        if (entry.is(EType.INIT)) {
            return startId;
        }

        Set<Event> reachableEvents = new HashSet<>();
        computeReachableEvents(getEntry(), reachableEvents);

        Event pred = null;
        Event cur = getEntry();
        int id = startId;
        while (cur != null) {
            if (!reachableEvents.contains(cur) && cur != getExit()) {
                cur.delete(pred);
                cur = pred;
            } else {
                //System.out.println(cur.toString() + " (" + id + " <- " + cur.getOId() + ")");
                cur.setOId(id++);
            }
            pred = cur;
            cur = cur.getSuccessor();
        }

        clearCache();
        return id;
    }

    private void computeReachableEvents(Event e, Set<Event> reachable) {
        if (reachable.contains(e))
            return;

        while (e != null && reachable.add(e)) {
            if (e instanceof CondJump) {
                CondJump j = (CondJump) e;
                if (j.isGoto()) {
                    e = j.getLabel();
                    continue;
                }
                else {
                    computeReachableEvents(j.getLabel(), reachable);
                }
            }
            e = e.getSuccessor();
        }
    }



    public void reorderBranches() {
        List<MoveableBranch> moveables = new ArrayList<>();
        Map<Event, MoveableBranch> map = new HashMap<>();

        // =========== Compute all moveable branches ===========
        MoveableBranch cur = new MoveableBranch();
        moveables.add(cur);
        Event e = entry;

        while (e != null) {
            cur.events.add(e);
            map.put(e, cur);

            if (e.equals(exit)) {
                break;
            } else if (e instanceof CondJump && ((CondJump)e).isGoto()) {
                moveables.add(cur = new MoveableBranch());
            }

            e = e.getSuccessor();
        }
        // =====================================================================

        // =================== Build Successor Graph on Branches ===============
        MoveableBranch finalBranch = map.get(exit);
        for (MoveableBranch br : moveables) {
            for (Event ev : br.events.stream().filter(x -> x instanceof CondJump).collect(Collectors.toList())) {
                CondJump jump = (CondJump) ev;
                br.successors.add(map.get(jump.getLabel()));
                br.successors.add(finalBranch);
            }
        }
        DependencyGraph<MoveableBranch> cfGraph = DependencyGraph.fromSingleton(moveables.get(0), x -> x.successors);

        // ======================= Traverse the graph and reorder the branches ===================
        Event pred = null;
        int id = getEntry().getOId();
        //int branch = 0;
        List<Set<DependencyGraph<MoveableBranch>.Node>> sccs = Lists.reverse(cfGraph.getSCCs());
        for (Set<DependencyGraph<MoveableBranch>.Node> scc : sccs) {
            /*if (scc.size() > 1) {
                System.out.println("============== SCC START =============");
            }*/
            List<MoveableBranch> branches = scc.stream().map(DependencyGraph.Node::getContent)
                    .sorted(Comparator.comparingInt(x -> x.events.get(0).getOId())).collect(Collectors.toList());
            for (MoveableBranch br : branches) {
                //System.out.println("----- Branch " + branch++ + " ------");
                for (Event ev : br.events) {
                    if (pred != null) {
                        pred.setSuccessor(ev);
                    }
                    ev.setOId(id++);
                    pred = ev;

                    //System.out.println(ev);
                }
            }
            /*if (scc.size() > 1) {
                System.out.println("============== SCC END =============");
            }*/
        }
    }

    private static class MoveableBranch {
        List<Event> events = new ArrayList<>();
        Set<MoveableBranch> successors = new HashSet<>();
    }






}
