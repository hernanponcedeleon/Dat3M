package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.verification.Context;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.*;
import java.util.stream.Collectors;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;
import static com.google.common.base.Verify.verify;
import static java.util.stream.Collectors.toList;
import static java.util.stream.IntStream.range;

/**
 * Computes direct providers for register values, based on when a register is used.
 * Instances of this class store the results of the analysis,
 * which was performed on the instance's creation.
 */
public final class Dependency {

    private static final Logger logger = LogManager.getLogger(Dependency.class);

    private final HashMap<Event, Map<Register, State>> map = new HashMap<>();
    private final Map<Register, State> finalWriters = new HashMap<>();

    private Dependency() {
    }

    /**
     * Performs a dependency analysis on a program.
     *
     * @param program         Instruction lists to be analyzed.
     * @param analysisContext Collection of other analyses previously performed on {@code program}.
     *                        Should include {@link ExecutionAnalysis}.
     * @param config          Mapping from keywords to values,
     *                        further specifying the behavior of this analysis.
     *                        See this class's list of options for details.
     * @throws InvalidConfigurationException Some option was provided with an unsupported type.
     */
    public static Dependency fromConfig(Program program, Context analysisContext, Configuration config) throws InvalidConfigurationException {
        logger.info("Analyze dependencies");
        ExecutionAnalysis exec = analysisContext.requires(ExecutionAnalysis.class);
        Dependency result = new Dependency();
        for (Thread t : program.getThreads()) {
            result.process(t, exec);
        }
        return result;
    }

    /**
     * Queries the collection of providers for a variable, given a certain state of the program.
     *
     * @param reader   Event containing some computation over values of the register space.
     * @param register Thread-local program variable used by {@code reader}.
     * @return Local result of this analysis.
     */
    public State of(Event reader, Register register) {
        return map.getOrDefault(reader, Map.of()).getOrDefault(register, new State(false, List.of(), List.of()));
    }

    /**
     * @return Complete set of registers of the analyzed program,
     * mapped to program-ordered list of writers.
     */
    public Map<Register, State> finalWriters() {
        return finalWriters;
    }

    /**
     * Complete set of possible relationships between register writers and register readers,
     * where a reader may receive the value that the writer produced.
     *
     * @return Grouped by reader, then result register.
     * Writers are program-ordered.
     */
    public Collection<Map.Entry<Event, Map<Register, State>>> getAll() {
        return map.entrySet();
    }

    private void process(Thread thread, ExecutionAnalysis exec) {
        Map<Event, Set<Writer>> jumps = new HashMap<>();
        Set<Writer> state = new HashSet<>();
        for (Register register : thread.getRegisters()) {
            state.add(new Writer(register, null));
        }
        for (Event event : thread.getEvents()) {
            //merge with incoming jumps
            Set<Writer> j = jumps.remove(event);
            if (j != null) {
                state.addAll(j);
            }
            //collecting all register dependencies
            Set<Register> registers = new HashSet<>();
            if (event instanceof RegReader regReader) {
                regReader.getRegisterReads().forEach( read -> registers.add(read.register()));
            }

            if (!registers.isEmpty()) {
                Map<Register, State> result = new HashMap<>();
                for (Register register : registers) {
                    State writers;
                    if (register.getFunction() != event.getThread()) {
                        writers = finalWriters.get(register);
                        checkArgument(writers != null,
                                "Helper thread %s should be listed after their creator thread %s.",
                                thread,
                                register.getFunction());
                        if (writers.may.size() != 1) {
                            logger.warn("Writers {} for inter-thread register {} read by event {} of thread {}",
                                    writers.may,
                                    register,
                                    event,
                                    thread.getId());
                        }
                    } else {
                        writers = process(event, state, register, exec);
                        if (!writers.initialized) {
                            logger.warn("Uninitialized register {} read by event {} of thread {}",
                                    register,
                                    event,
                                    thread.getId());
                        }
                    }
                    result.put(register, writers);
                }
                map.put(event, result);
            }
            //update state, if changed by event
            if (event instanceof RegWriter rw) {
                Register register = rw.getResultRegister();
                if (event.cfImpliesExec()) {
                    state.removeIf(e -> e.register.equals(register));
                }
                state.add(new Writer(register, event));
            }
            //copy state, if branching
            if (event instanceof CondJump jump) {
                jumps.computeIfAbsent(jump.getLabel(), k -> new HashSet<>()).addAll(state);
                if (jump.isGoto()) {
                    state.clear();
                }
            }
        }
        if (!jumps.isEmpty()) {
            logger.warn("Thread {} contains jumps to removed labels {}",
                    thread.getId(),
                    jumps.keySet());
            for (Set<Writer> j : jumps.values()) {
                state.addAll(j);
            }
        }
        for (Register register : thread.getRegisters()) {
            finalWriters.put(register, process(null, state, register, exec));
        }
    }

    private static State process(Event reader, Set<Writer> state, Register register, ExecutionAnalysis exec) {
        List<Event> candidates = state.stream()
                .filter(e -> e.register.equals(register))
                .map(e -> e.event)
                .filter(e -> reader == null || !exec.areMutuallyExclusive(reader, e))
                .collect(toList());
        //NOTE if candidates is empty, the reader is unreachable
        List<Event> mays = candidates.stream()
                .filter(Objects::nonNull)
                .sorted(Comparator.comparingInt(Event::getGlobalId))
                .collect(Collectors.toCollection(ArrayList::new));
        int end = mays.size();
        List<Event> musts = range(0, end)
                .filter(i -> mays.subList(i + 1, end).stream().allMatch(j -> exec.areMutuallyExclusive(mays.get(i), j)))
                .mapToObj(mays::get)
                .collect(toList());
        return new State(!candidates.contains(null), mays, musts);
    }

    private static final class Writer {
        final Register register;
        final Event event;

        Writer(Register r, Event e) {
            register = checkNotNull(r);
            event = e;
        }

        @Override
        public boolean equals(Object o) {
            return this == o || o instanceof Writer writer
                    && (event == null
                    ? writer.event == null && register.equals(writer.register)
                    : event.equals(writer.event));
        }

        @Override
        public int hashCode() {
            return (event == null ? register : event).hashCode();
        }
    }

    /**
     * Indirectly associated with an instance of {@link Register}, as well as an optional event of the respective thread.
     * When no such event exists, the instance describes the final register values.
     */
    public static final class State {

        /**
         * The analysis was able to determine that in all executions, there is a provider for the register.
         */
        public final boolean initialized;

        /**
         * Complete, but unsound, program-ordered list of direct providers for the register:
         * If there is a program execution where an event of the program was the latest writer, that event is contained in this list.
         */
        public final List<Event> may;

        /**
         * Sound, but incomplete, program-ordered list of direct providers with no overwriting event in between:
         * Each event in this list will be the latest writer in any execution that contains that event.
         */
        public final List<Event> must;

        private State(boolean initialized, List<Event> may, List<Event> must) {
            verify(new HashSet<>(may).containsAll(must), "Each must-writer must also be a may-writer.");
            verify(may.isEmpty() || must.contains(may.get(may.size() - 1)), "The last may-writer must also be a must-writer.");
            this.initialized = initialized;
            this.may = may;
            this.must = must;
        }
    }
}
