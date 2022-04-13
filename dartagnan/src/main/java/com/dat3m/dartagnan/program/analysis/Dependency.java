package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;

import java.util.*;
import java.util.stream.Collectors;

import static com.google.common.base.Verify.verify;
import static java.util.stream.Collectors.toList;
import static java.util.stream.IntStream.range;

/**
 * Computes direct providers for register values, based on when a register is used.
 */
public final class Dependency {

    private final HashMap<Event,Map<Register,List<Event>>> mayMap = new HashMap<>();
    private final HashMap<Event,Map<Register,List<Event>>> mustMap = new HashMap<>();
    private final Map<Register,List<Event>> finalWriters = new HashMap<>();

    /**
     * @param program
     * Instruction lists to be analyzed.
     * @param exec
     * Summarizes branching behavior.
     */
    public Dependency(Program program, ExecutionAnalysis exec) {
        for(Thread t: program.getThreads()) {
            process(t, exec);
        }
    }

    /**
     * Over-approximates the collection of providers for a variable, given a certain state of the program.
     * @param reader
     * Event containing some computation over values of the register space.
     * @return
     * Complete, but unsound, list of direct providers for some register used by {@code dependent}.
     * If the initial register value may be readable, the first element is {@code null}.
     */
    public List<Event> may(Event reader, Register register) {
        return mayMap.getOrDefault(reader, Map.of()).getOrDefault(register, List.of());
    }

    /**
     * Filters the list of dependencies for those that automatically imply the dependency relationship,
     * as soon as the dependency and the dependent are executed.
     * @param reader
     * Event containing some computation over values of the register space.
     * @return
     * Sound, but incomplete, list of direct providers with no overwriting event in between.
     * If the initial register value must be read, returns {@code Arrays.asList(new Event[1])}.
     */
    public List<Event> must(Event reader, Register register) {
        return mustMap.getOrDefault(reader, Map.of()).getOrDefault(register, List.of());
    }

    /**
     * @return
     * Complete set of registers of the analyzed program,
     * mapped to a complete program-ordered list of writers.
     * If the initial register value may be readable,
     * the first element of the list is {@code null}.
     */
    public Map<Register,List<Event>> finalWriters() {
        return finalWriters;
    }

    /**
     * Complete set of possible relationships between register writers and register readers,
     * where a reader may receive the value that the writer produced.
     * @return
     * Grouped by reader, then result register.
     * Writers are program-ordered.
     * If the initial register value may be readable,
     * the first element of a list is {@code null}.
     */
    public Collection<Map.Entry<Event,Map<Register,List<Event>>>> getAll() {
        return mayMap.entrySet();
    }

    private void process(Thread thread, ExecutionAnalysis exec) {
        Map<Event,Set<Writer>> jumps = new HashMap<>();
        Set<Writer> state = new HashSet<>();
        for(Register register : thread.getRegisters()) {
            state.add(new Writer(register,null));
        }
        for(Event event : thread.getEvents()) {
            //merge with incoming jumps
            Set<Writer> j = jumps.remove(event);
            if(j != null) {
                state.addAll(j);
            }
            //collecting dependencies, mixing 'data' and 'addr'
            Set<Register> registers = new HashSet<>();
            if(event instanceof RegReaderData) {
                registers.addAll(((RegReaderData) event).getDataRegs());
            }
            if(event instanceof MemEvent) {
                registers.addAll(((MemEvent) event).getAddress().getRegs());
            }
            if(!registers.isEmpty()) {
                Map<Register,List<Event>> may = new HashMap<>();
                Map<Register,List<Event>> must = new HashMap<>();
                for(Register register : registers) {
                    List<Event> writers = may(state, register);
                    may.put(register, writers);
                    must.put(register, must(writers, exec));
                }
                mayMap.put(event, may);
                mustMap.put(event, must);
            }
            //update state, if changed by event
            if(event instanceof RegWriter) {
                Register register = ((RegWriter) event).getResultRegister();
                if(event.cfImpliesExec()) {
                    state.removeIf(e -> e.register.equals(register));
                }
                state.add(new Writer(register, event));
            }
            //copy state, if branching
            if(event instanceof CondJump) {
                verify(!((CondJump) event).isDead(), "dead jumps after preprocessing");
                jumps.compute(((CondJump) event).getLabel(), (k, v) -> {
                    if(v == null) {
                        return new HashSet<>(state);
                    }
                    v.addAll(state);
                    return v;
                });
                if(((CondJump) event).isGoto()) {
                    state.clear();
                }
            }
        }
        //FIXME there might still be jumps to "END_OF_T"... with cid == -1
        for(Set<Writer> j : jumps.values()) {
            state.addAll(j);
        }
        for(Register register : thread.getRegisters()) {
            finalWriters.put(register, may(state, register));
        }
    }

    private static List<Event> may(Set<Writer> state, Register register) {
        return state.stream()
        .filter(e -> e.register.equals(register))
        .map(e -> e.event)
        .sorted((x, y) -> x == null ? y == null ? 0 : -1 : y == null ? 1 : x.getCId() - y.getCId())
        .collect(Collectors.toCollection(ArrayList::new));
    }

    private static List<Event> must(List<Event> mays, ExecutionAnalysis exec) {
        verify(!mays.isEmpty(), "events should at least read the initial value of a register.");
        if(mays.size() == 1) {
            return mays;
        }
        int begin = mays.get(0) == null ? 1 : 0;
        int end = mays.size();
        return range(begin, end)
        .filter(i -> mays.subList(i + 1, end).stream().allMatch(j -> exec.areMutuallyExclusive(mays.get(i), j)))
        .mapToObj(mays::get)
        .collect(toList());
    }

    private static final class Writer {
        final Register register;
        final Event event;
        Writer(Register r, Event e) {
            register = Objects.requireNonNull(r);
            event = e;
        }
        @Override
        public boolean equals(Object o) {
            return this==o || o instanceof Writer
            && (event == null
                ? ((Writer) o).event == null && register.equals(((Writer) o).register)
                : event.equals(((Writer) o).event));
        }
        @Override
        public int hashCode() {
            return (event == null ? register : event).hashCode();
        }
    }
}
