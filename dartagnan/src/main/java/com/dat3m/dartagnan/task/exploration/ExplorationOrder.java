package com.dat3m.dartagnan.task.exploration;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;
import java.util.*;

/*
    The order along which events are explored (and along which backward revisits preserve prefixes).

    PO:            The original TruSt algorithm: (po U rf) must be acyclic in all consistent executions.
    DEPENDENCIES:  po is replaced by the relation
                       E := data | addr | branch;po | addr;po | po-loc | rmw | (po;[S]) | ([S];po)
                   where "branch" relates reads to the conditional jumps their values influence
                   (a superset of ctrl: it also covers jumps whose ctrl-dependency is scoped, e.g. IfAsJump),
                   where S is the set of "strong" events (fences, thread management, and accesses with
                   ordering annotations, e.g., acquire/release/SC or exclusive accesses).
                   This allows exploring executions with (po U rf)-cycles (e.g. load buffering),
                   as long as the memory model forbids (E U rf)-cycles and is prefix-closed and maximally
                   extensible w.r.t. E.
 */
public enum ExplorationOrder {
    PO, DEPENDENCIES;

    // Tags that do not impose any ordering on an access (per architecture).
    private static final Set<String> COMMON_RELAXED = ImmutableSet.of(
            Tag.VISIBLE, Tag.MEMORY, Tag.READ, Tag.WRITE, Tag.RMW, Tag.NOOPT, Tag.NO_INSTRUCTION, Tag.NO_CARRY_DEPS);

    private static final Set<String> INSTRUCTION_FENCES = ImmutableSet.of("ISB", "isync");

    static Set<String> relaxedTags(Arch arch) {
        final ImmutableSet.Builder<String> builder = ImmutableSet.<String>builder().addAll(COMMON_RELAXED);
        if (arch == null) {
            return builder.build();
        }
        switch (arch) {
            case C11, OPENCL, IMM -> builder.add(Tag.C11.ATOMIC, Tag.C11.NONATOMIC, Tag.C11.NON_ATOMIC_LOCATION,
                    Tag.C11.MO_RELAXED, Tag.C11.NORETURN);
            case LKMM -> builder.add(Tag.Linux.MO_ONCE, Tag.Linux.NORETURN);
            case ARM8 -> builder.add(Tag.ARMv8.NO_RET);
            default -> { }
        }
        return builder.build();
    }

    /*
        Incrementally computes the direct E-predecessors of the events of a single thread,
        which are visited in program order.
     */
    static final class Tracker {
        private final ExplorationOrder order;
        private final Set<String> relaxedTags;

        Node lastNode;
        Node lastStrong;
        // Nodes since the last strong node (a strong node depends on all of them).
        Set<Node> sinceStrong = new LinkedHashSet<>();
        Map<BigInteger, Node> lastByAddress = new HashMap<>();
        // Sources of address dependencies of po-earlier events (for addr;po).
        Set<Node> addrPoSources = new HashSet<>();

        Tracker(ExplorationOrder order, Set<String> relaxedTags) {
            this.order = order;
            this.relaxedTags = relaxedTags;
        }

        Tracker copy() {
            final Tracker c = new Tracker(order, relaxedTags);
            c.lastNode = lastNode;
            c.lastStrong = lastStrong;
            c.sinceStrong = new LinkedHashSet<>(sinceStrong);
            c.lastByAddress = new HashMap<>(lastByAddress);
            c.addrPoSources = new HashSet<>(addrPoSources);
            return c;
        }

        boolean isStrong(Node.Kind kind, Event e) {
            if (kind == Node.Kind.OTHER && e.hasTag(Tag.FENCE) && INSTRUCTION_FENCES.stream().anyMatch(e::hasTag)) {
                // Instruction fences (ISB, isync) only order in combination with ctrl/addr dependencies,
                // which are part of the exploration order anyway.
                return false;
            }
            if (kind != Node.Kind.READ && kind != Node.Kind.WRITE) {
                return true; // Fences, thread management, failed exclusives, other visible events.
            }
            if (e.hasTag(Tag.EXCL)) {
                return true;
            }
            for (String tag : e.getTags()) {
                if (!relaxedTags.contains(tag) && !(tag.startsWith("__") && !tag.equals(Tag.EXCL))) {
                    return true;
                }
            }
            return false;
        }

        // Computes the E-predecessors of a node that is about to be created.
        Set<Node> predecessors(Node.Kind kind, Event e, BigInteger address,
                               Set<Node> dataDeps, Set<Node> addrDeps, Set<Node> branchSources, Node pairedLoad) {
            if (order == PO) {
                return lastNode == null ? Set.of() : Set.of(lastNode);
            }
            final Set<Node> preds = new HashSet<>();
            preds.addAll(dataDeps);
            preds.addAll(addrDeps);
            preds.addAll(branchSources);
            preds.addAll(addrPoSources);
            if (pairedLoad != null) {
                preds.add(pairedLoad);
            }
            if (lastStrong != null) {
                preds.add(lastStrong);
            }
            if (address != null) {
                final Node sameLoc = lastByAddress.get(address);
                if (sameLoc != null) {
                    preds.add(sameLoc);
                }
            }
            if (isStrong(kind, e)) {
                preds.addAll(sinceStrong);
            }
            return preds;
        }

        // Updates the tracker after a node was executed (in program order).
        void update(Node n) {
            lastNode = n;
            if (order == PO) {
                return;
            }
            if (isStrong(n.kind, n.event)) {
                lastStrong = n;
                sinceStrong = new LinkedHashSet<>();
            } else {
                sinceStrong.add(n);
            }
            if (n.address != null) {
                lastByAddress.put(n.address, n);
            }
            addrPoSources.addAll(n.addrDeps);
        }
    }
}
