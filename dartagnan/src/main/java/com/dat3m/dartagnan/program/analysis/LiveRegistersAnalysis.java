package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.google.common.collect.ImmutableSet;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/*
    Computes the registers that are (potentially) live at every program point.
    A register is live, if it is used (i.e., read from) before getting overwritten.
    A register may be declared live even if it is not used, however, a non-live (dead) register is always guaranteed
    to be overwritten.

    This is a backwards analysis: the control-flow is traversed from exit to beginning.
 */
public class LiveRegistersAnalysis {

    private final Map<Event, Set<Register>> liveRegistersMap = new HashMap<>();

    public static LiveRegistersAnalysis forFunction(Function f) {
        final LiveRegistersAnalysis analysis = new LiveRegistersAnalysis();
        analysis.computeForFunction(f);
        return analysis;
    }

    public Set<Register> getLiveRegistersAt(Event ev) {
        return liveRegistersMap.getOrDefault(ev, Set.of());
    }

    // ======================================================================

    private void computeForFunction(Function f) {
        computeLiveRegisters(f, computeLiveRegistersAtJumps(f));
    }

    private void computeLiveRegisters(Function f, Map<CondJump, Set<Register>> liveRegsAtJump) {

        Set<Register> liveRegs = new HashSet<>();
        // The copy is an optimizations: multiple events may have the same set of live registers,
        // so we try to reuse that set to save memory.
        Set<Register> liveRegsCopy = ImmutableSet.copyOf(liveRegs);
        Event cur = f.getExit();
        while (cur != null) {
            boolean updated;
            if (cur instanceof CondJump jump) {
                liveRegs = liveRegsAtJump.get(jump);
                updated = true;
            } else {
                updated = updateLiveRegs(cur, liveRegs);
            }

            if (updated) {
                liveRegsCopy = ImmutableSet.copyOf(liveRegs);
            }
            liveRegistersMap.put(cur, liveRegsCopy);

            cur = cur.getPredecessor();
        }
    }

    private static Map<CondJump, Set<Register>> computeLiveRegistersAtJumps(Function f) {
        Map<CondJump, Set<Register>> liveRegsAtJumpMap = new HashMap<>();
        Set<Register> liveRegs = new HashSet<>();
        Event cur = f.getExit();
        while (cur != null) {

            updateLiveRegs(cur, liveRegs);

            if (cur instanceof CondJump jump) {
                final Set<Register> liveRegsAtJump = liveRegsAtJumpMap.computeIfAbsent(jump, key -> new HashSet<>());
                if (!IRHelper.isAlwaysBranching(jump)) {
                    liveRegsAtJump.addAll(liveRegs);
                }
                liveRegs = new HashSet<>(liveRegsAtJump);
            }

            if (cur instanceof Label label) {
                // Propagate live sets to all incoming jumps. If an incoming jump is a backjump,
                // we have a loop and may need to re-traverse the loop with the propagated values.
                CondJump latestUpdatedBackjump = null;
                for (CondJump jump : label.getJumpSet()) {
                    if (jump.isDead()) {
                        continue;
                    }

                    final Set<Register> liveRegsAtJump = liveRegsAtJumpMap.computeIfAbsent(jump, key -> new HashSet<>());
                    if (liveRegsAtJump.addAll(liveRegs) && jump.getGlobalId() > label.getGlobalId()) {
                        if (latestUpdatedBackjump == null || jump.getGlobalId() > latestUpdatedBackjump.getGlobalId()) {
                            latestUpdatedBackjump = jump;
                        }
                    }
                }

                if (latestUpdatedBackjump != null) {
                    cur = latestUpdatedBackjump;
                    continue;
                }
            }

            cur = cur.getPredecessor();
        }

        return liveRegsAtJumpMap;
    }

    // Returns true if the live registers may have updated (may return true even if no actual update happened).
    private static boolean updateLiveRegs(Event ev, Set<Register> liveRegs) {
        boolean changed = false;
        if ((ev instanceof AbortIf || ev instanceof Return) && IRHelper.isAlwaysBranching(ev)) {
            liveRegs.clear();
            changed = true;
        }

        if (ev instanceof RegWriter writer && writer.cfImpliesExec()) {
            changed |= liveRegs.remove(writer.getResultRegister());
        }

        if (ev instanceof RegReader reader) {
            changed |= reader.getRegisterReads().stream()
                    .map(read -> liveRegs.add(read.register()))
                    .reduce(false, (res, b) -> res || b);
        }

        return changed;

    }
}
