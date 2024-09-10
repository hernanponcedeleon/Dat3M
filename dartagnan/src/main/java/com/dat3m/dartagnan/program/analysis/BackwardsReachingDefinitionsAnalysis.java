package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.verification.Context;
import com.google.common.base.Preconditions;
import com.google.common.collect.Iterables;
import org.sosy_lab.common.configuration.Configuration;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * Collects all direct usage relationships between {@link RegWriter} and {@link RegReader}.
 * <p>
 * In contrast to a usual Reaching-Definitions-Analysis, this implementation analyzes the program from back to front,
 * assigning each program point the set of readers, who may still require a register initialization.
 * This means that it does not collect definitions for unused registers.
 * Especially, it does not collect last writers for all registers.
 * <p>
 * This analysis is control-flow-sensitive;
 * that is, {@link Label} splits the information among the jumps to it and {@link CondJump} merges the information.
 * <p>
 * This analysis supports loops;
 * that is, backward jumps cause re-evaluation of the loop body until convergence.
 * This results in a squared worst-case time complexity in terms of events being processed.
 */
public class BackwardsReachingDefinitionsAnalysis implements ReachingDefinitionsAnalysis {

    private final Map<RegReader, ReaderInfo> readerMap = new HashMap<>();
    private final Map<RegWriter, Readers> writerMap = new HashMap<>();
    private final RegWriter INITIAL_WRITER = null;
    private final RegReader FINAL_READER = null;

    @Override
    public Writers getWriters(RegReader reader) {
        Preconditions.checkNotNull(reader, "reader is null");
        final ReaderInfo result = readerMap.get(reader);
        Preconditions.checkArgument(result != null, "reader %s has not been analyzed.", reader);
        return result;
    }

    @Override
    public Writers getFinalWriters() {
        final ReaderInfo result = readerMap.get(FINAL_READER);
        Preconditions.checkState(result != null, "final state has not been analyzed.");
        return result;
    }

    /**
     * Lists all potential users of the result of an event.
     * @param writer Event of interest to fetch information about.
     * @throws IllegalArgumentException If {@code writer} was not inside the program when it was analyzed.
     */
    public Readers getReaders(RegWriter writer) {
        Preconditions.checkNotNull(writer, "writer is null");
        final Readers result = writerMap.get(writer);
        Preconditions.checkArgument(result != null, "writer %s has not been analyzed.", writer);
        return result;
    }

    /**
     * Lists all potential users of uninitialized registers.
     */
    public Readers getInitialReaders() {
        final Readers result = writerMap.get(INITIAL_WRITER);
        Preconditions.checkState(result != null, "initial state has not been analyzed.");
        return result;
    }

    /**
     * Analyzes an entire function definition.
     * @param function Defined function to be analyzed.  Its parameters are marked as initialized.
     */
    public static BackwardsReachingDefinitionsAnalysis forFunction(Function function) {
        final var analysis = new BackwardsReachingDefinitionsAnalysis();
        final Set<Register> finalRegisters = new HashSet<>();
        analysis.initialize(function, finalRegisters);
        analysis.run(function, finalRegisters);
        analysis.postProcess();
        return analysis;
    }

    /**
     * Analyzes the entire program (after thread creation).
     * <p>
     * Optionally queries {@link ExecutionAnalysis} for pairs of writers appearing together in an execution.
     * @param program Contains a set of threads to be analyzed.  Additionally-defined functions are ignored.
     * @param analysisContext Collection of previous analyses to be used as dependencies.
     * @param config User-defined settings for this analysis.
     */
    public static BackwardsReachingDefinitionsAnalysis fromConfig(Program program, Context analysisContext, Configuration config) {
        final ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
        final var analysis = new BackwardsReachingDefinitionsAnalysis();
        final Set<Register> finalRegisters = finalRegisters(program);
        for (Function function : program.isUnrolled() ? program.getThreads() :
                Iterables.concat(program.getThreads(), program.getFunctions())) {
            analysis.initialize(function, finalRegisters);
            analysis.run(function, finalRegisters);
        }
        analysis.postProcess();
        if (exec != null && program.isUnrolled()) {
            analysis.analyzeMust(exec);
        }
        return analysis;
    }

    private static Set<Register> finalRegisters(Program program) {
        final Set<Register> finalRegisters = new HashSet<>();
        if (program.getSpecification() != null) {
            finalRegisters.addAll(program.getSpecification().getRegs());
        }
        if (program.getFilterSpecification() != null) {
            finalRegisters.addAll(program.getFilterSpecification().getRegs());
        }
        return finalRegisters;
    }

    /**
     * Local information for either a {@link RegReader} or the final state of the program.
     */
    private static final class ReaderInfo implements Writers {

        private final Set<Register> used;
        private final List<RegWriter> mayWriters = new ArrayList<>();
        private final List<RegWriter> mustWriters = new ArrayList<>();
        private final Set<Register> uninitialized = new HashSet<>();

        private ReaderInfo(Set<Register> u) {
            used = Set.copyOf(u);
        }

        @Override
        public Set<Register> getUsedRegisters() {
            return used;
        }

        @Override
        public RegisterWriters ofRegister(Register register) {
            return new RegisterWritersView(this, register);
        }
    }

    private static final class RegisterWritersView implements RegisterWriters {

        private final ReaderInfo info;
        private final Register register;

        private RegisterWritersView(ReaderInfo info, Register register) {
            this.info = info;
            this.register = register;
        }

        @Override
        public List<RegWriter> getMayWriters() {
            return info.mayWriters.stream().filter(w -> w.getResultRegister().equals(register)).toList();
        }

        @Override
        public List<RegWriter> getMustWriters() {
            return info.mustWriters.stream().filter(w -> w.getResultRegister().equals(register)).toList();
        }

        @Override
        public boolean mustBeInitialized() {
            return !info.uninitialized.contains(register);
        }
    }

    /**
     * Local information for either a {@link RegWriter} or the initial state of the program.
     */
    public static final class Readers {

        private final Set<RegReader> readers = new HashSet<>();
        private boolean mayBeFinal;

        private Readers() {}

        /**
         * Lists readers s.t. there may be an execution where an instance of that reader uses the result of an instance of the associated writer.
         * @return Unordered set of Readers.
         */
        public Collection<RegReader> getReaders() {
            return Collections.unmodifiableCollection(readers);
        }

        /**
         * @return {@code true} if there may be an execution, where an instance of the associated writer defines the last value of its register.
         */
        public boolean mayBeFinal() {
            return mayBeFinal;
        }
    }

    private BackwardsReachingDefinitionsAnalysis() {}

    private void initialize(Function function, Set<Register> finalRegisters) {
        for (RegWriter writer : function.getEvents(RegWriter.class)) {
            writerMap.put(writer, new Readers());
        }
        writerMap.put(INITIAL_WRITER, new Readers());
        for (RegReader reader : function.getEvents(RegReader.class)) {
            final Set<Register> usedRegisters = new HashSet<>();
            for (Register.Read read : reader.getRegisterReads()) {
                usedRegisters.add(read.register());
            }
            readerMap.put(reader, new ReaderInfo(usedRegisters));
        }
        readerMap.put(FINAL_READER, new ReaderInfo(finalRegisters));
    }

    private void run(Function function, Set<Register> finalRegisters) {
        //For each register used after this state, all future users.
        final State currentState = new State();
        for (Register finalRegister : finalRegisters) {
            final var info = new StateInfo();
            info.mayReaders.add(FINAL_READER);
            currentState.put(finalRegister, info);
        }
        final Map<CondJump, State> trueStates = new HashMap<>();
        final Map<CondJump, State> falseStates = new HashMap<>();
        final List<Event> events = function.getEvents();
        for (int i = events.size() - 1; i >= 0; i--) {
            final CondJump loop = runLocal(events.get(i), currentState, trueStates, falseStates);
            if (loop != null) {
                merge(currentState, falseStates.getOrDefault(loop, new State()));
                update(currentState, loop);
                i = events.indexOf(loop);
            }
        }
        // set the uninitialized flags
        final Readers uninitialized = writerMap.get(INITIAL_WRITER);
        for (Map.Entry<Register, StateInfo> entry : currentState.entrySet()) {
            uninitialized.readers.addAll(entry.getValue().mayReaders);
            for (RegReader reader : entry.getValue().mayReaders) {
                readerMap.get(reader).uninitialized.add(entry.getKey());
            }
        }
    }

    private void postProcess() {
        // build the reverse association
        for (Map.Entry<RegWriter, Readers> entry : writerMap.entrySet()) {
            if (Objects.equals(entry.getKey(), INITIAL_WRITER)) {
                continue;
            }
            for (RegReader reader : entry.getValue().readers) {
                List<RegWriter> mayWriters = readerMap.get(reader).mayWriters;
                assert !mayWriters.contains(entry.getKey());
                mayWriters.add(entry.getKey());
            }
        }
        final Comparator<RegWriter> byGlobalId = Comparator.comparingInt(RegWriter::getGlobalId);
        for (Map.Entry<RegReader, ReaderInfo> entry : readerMap.entrySet()) {
            entry.getValue().mayWriters.sort(byGlobalId);
        }
        // set the final flag
        for (Readers writer : writerMap.values()) {
            writer.mayBeFinal = writer.readers.remove(FINAL_READER);
        }
    }

    private static final class State extends HashMap<Register, StateInfo> {}

    private static final class StateInfo {
        private Set<RegReader> mayReaders = new HashSet<>();
        private boolean copyOnWrite;
    }

    private CondJump runLocal(Event event, State currentState, Map<CondJump, State> trueStates, Map<CondJump, State> falseStates) {
        if (event instanceof Label label) {
            CondJump latest = null;
            // Update all jumps.
            for (CondJump jump : label.getJumpSet()) {
                if (jump.isDead()) {
                    continue;
                }
                final boolean change = merge(trueStates.computeIfAbsent(jump, k -> new State()), currentState);
                if (change && (latest == null || latest.getGlobalId() < jump.getGlobalId())) {
                    latest = jump;
                }
            }
            // If exists, repeat from most distant back jump.
            // Occurs linear-many times due to guaranteed progress.
            if (latest != null && label.getGlobalId() < latest.getGlobalId()) {
                return latest;
            }
        }
        if (event instanceof CondJump jump && !jump.isDead()) {
            if (jump.isGoto()) {
                currentState.clear();
            } else {
                merge(falseStates.computeIfAbsent(jump, k -> new State()), currentState);
            }
            merge(currentState, trueStates.getOrDefault(jump, new State()));
        }
        if (event instanceof RegWriter writer) {
            final Register register = writer.getResultRegister();
            final StateInfo state = writer.cfImpliesExec() ? currentState.remove(register) : currentState.get(register);
            if (state != null) {
                writerMap.get(writer).readers.addAll(state.mayReaders);
            }
        }
        if (event instanceof RegReader reader) {
            update(currentState, reader);
        }
        return null;
    }

    private static void update(State states, RegReader reader) {
        for (Register register : reader.getRegisterReads().stream().map(Register.Read::register).distinct().toList()) {
            final StateInfo state = states.computeIfAbsent(register, k -> new StateInfo());
            state.mayReaders = state.copyOnWrite ? new HashSet<>(state.mayReaders) : state.mayReaders;
            state.copyOnWrite = false;
            state.mayReaders.add(reader);
        }
    }

    private static boolean merge(State target, State source) {
        boolean change = false;
        for (Map.Entry<Register, StateInfo> entry : source.entrySet()) {
            change |= merge(target.computeIfAbsent(entry.getKey(), k -> new StateInfo()), entry.getValue());
        }
        return change;
    }

    private static boolean merge(StateInfo target, StateInfo source) {
        if (target.mayReaders.containsAll(source.mayReaders)) {
            return false;
        }
        assert !source.mayReaders.isEmpty();
        if (target.mayReaders.isEmpty()) {
            target.mayReaders = source.mayReaders;
            target.copyOnWrite = source.copyOnWrite = true;
            return true;
        }
        target.mayReaders = target.copyOnWrite ? new HashSet<>(target.mayReaders) : target.mayReaders;
        target.copyOnWrite = false;
        target.mayReaders.addAll(source.mayReaders);
        return true;
    }

    private void analyzeMust(ExecutionAnalysis exec) {
        // Require that function is unrolled.
        for (ReaderInfo reader : readerMap.values()) {
            for (int i = 0; i < reader.mayWriters.size(); i++) {
                final RegWriter writer = reader.mayWriters.get(i);
                if (!mayBeOverwritten(writer, reader.mayWriters.subList(i+1, reader.mayWriters.size()), exec)) {
                    reader.mustWriters.add(writer);
                }
            }
        }
    }

    private static boolean mayBeOverwritten(RegWriter earlyWriter, List<RegWriter> lateWriters, ExecutionAnalysis exec) {
        final Register resultRegister = earlyWriter.getResultRegister();
        for (RegWriter lateWriter : lateWriters) {
            if (lateWriter.getResultRegister().equals(resultRegister) &&
                    !exec.areMutuallyExclusive(earlyWriter, lateWriter)) {
                return true;
            }
        }
        return false;
    }
}
