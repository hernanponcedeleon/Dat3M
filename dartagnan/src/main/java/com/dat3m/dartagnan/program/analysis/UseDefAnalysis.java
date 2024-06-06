package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/*
    This analysis computes the Use-Def graph of a function.
    The Use-Def graph connects a RegReader with possible RegWriters from which it could take its value
    (for each register read by the reader).

    FIXME: The analysis currently cannot capture if a register is possibly uninitialized.
     In particular, if the Def set consists of a single writer,
     then it does not necessarily mean that the writer is the only one (maybe an uninitialized read is also possible).

     NOTE: This analysis is essentially the same as the "Dependency" analysis we already have.
     The main difference is that this analysis works independently of other analyses
     (e.g., it does not depend on ExecutionAnalysis) and can be used on single functions.
 */
public class UseDefAnalysis {

    private Map<RegReader, Map<Register, Set<RegWriter>>> useDefGraph;

    private UseDefAnalysis() { }

    public static UseDefAnalysis forFunction(Function function) {
        final UseDefAnalysis useDefAnalysis = new UseDefAnalysis();
        useDefAnalysis.computeForFunction(function);
        return useDefAnalysis;
    }

    public Map<Register, Set<RegWriter>> getDefs(Event regReader) {
        return useDefGraph.getOrDefault(regReader, Map.of());
    }

    public Set<RegWriter> getDefs(Event regReader, Register register) {
        return getDefs(regReader).getOrDefault(register, Set.of());
    }

    // ======================================================================

    private void computeForFunction(Function function) {
        final Map<Label, Map<Register, Set<RegWriter>>> reachingDefinitionsMap = computeReachingDefinitionsAtLabels(function);
        this.useDefGraph = computeUseDefGraph(function, reachingDefinitionsMap);
    }

    private Map<RegReader, Map<Register, Set<RegWriter>>> computeUseDefGraph(
            Function function, Map<Label, Map<Register, Set<RegWriter>>> reachingDefinitionsMap
    ) {
        final Map<RegReader, Map<Register, Set<RegWriter>>> useDefGraph = new HashMap<>();

        Map<Register, Set<RegWriter>> reachingDefinitions = new HashMap<>();
        for (Event e : function.getEvents()) {
            if (e instanceof RegReader reader) {
                // Project reachable definitions down to those relevant for the RegReader
                final Map<Register, Set<RegWriter>> readableDefinitions = new HashMap<>();
                for (Register.Read read : reader.getRegisterReads()) {
                    readableDefinitions.put(read.register(), reachingDefinitions.get(read.register()));
                }
                useDefGraph.put(reader, readableDefinitions);
            }

            updateReachingDefinitions(e, reachingDefinitions);

            if (e instanceof Label label) {
                // This will cause entries in "reachingDefinitionsMap" to get mutated,
                // but that is fine because we do not need them anymore.
                reachingDefinitions = reachingDefinitionsMap.get(label);
            }
        }

        return useDefGraph;
    }

    // For efficiency reasons, we compute reaching definitions only for labels.
    // TODO: Maybe add a cheap liveness analysis and restrict to only live definitions.
    private Map<Label, Map<Register, Set<RegWriter>>> computeReachingDefinitionsAtLabels(Function function) {
        final Map<Label, Map<Register, Set<RegWriter>>> reachingDefinitionsMap = new HashMap<>();

        Event cur = function.getEntry();
        Map<Register, Set<RegWriter>> reachingDefinitions = new HashMap<>();
        while (cur != null) {
            updateReachingDefinitions(cur, reachingDefinitions);

            if (cur instanceof CondJump jump && !jump.isDead()) {
                final Map<Register, Set<RegWriter>> reachDefAtLabel = reachingDefinitionsMap.computeIfAbsent(jump.getLabel(), k -> new HashMap<>());
                final boolean wasUpdated = joinInto(reachDefAtLabel, reachingDefinitions);
                final boolean isBackJump = jump.getLabel().getGlobalId() < jump.getGlobalId();
                if (wasUpdated && isBackJump) {
                    cur = jump.getLabel();
                    continue;
                }
            }

            if (cur instanceof Label label) {
                final Map<Register, Set<RegWriter>> reachDefAtLabel = reachingDefinitionsMap.computeIfAbsent(label, k -> new HashMap<>());
                if (!IRHelper.isAlwaysBranching(label.getPredecessor())) {
                    joinInto(reachDefAtLabel, reachingDefinitions);
                }
                reachingDefinitions = copy(reachDefAtLabel);
            }

            cur = cur.getSuccessor();
        }

        return reachingDefinitionsMap;
    }

    private void updateReachingDefinitions(Event ev, Map<Register, Set<RegWriter>> reachingDefinitions) {
        if (ev instanceof RegWriter writer) {
            if (writer.cfImpliesExec()) {
                reachingDefinitions.put(writer.getResultRegister(), new HashSet<>(Set.of(writer)));
            } else {
                reachingDefinitions.computeIfAbsent(writer.getResultRegister(), k -> new HashSet<>()).add(writer);
            }
        }
    }

    private boolean joinInto(Map<Register, Set<RegWriter>> base, Map<Register, Set<RegWriter>> toJoin) {
        boolean changed = false;
        for (Map.Entry<Register, Set<RegWriter>> entry : toJoin.entrySet()) {
            if (!base.containsKey(entry.getKey())) {
                changed = true;
            }
            changed |= base.computeIfAbsent(entry.getKey(), k -> new HashSet<>()).addAll(entry.getValue());
        }

        return changed;
    }

    private Map<Register, Set<RegWriter>> copy(Map<Register, Set<RegWriter>> source) {
        final Map<Register, Set<RegWriter>> copy = new HashMap<>(source.size() * 4 / 3);
        source.forEach((reg, writers) -> copy.put(reg, new HashSet<>(writers)));
        return copy;
    }
}
