package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.IExprUn;
import com.dat3m.dartagnan.expression.IfExpr;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.Comparators;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.ArrayDeque;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Set;

/*
 * Replaces memory accesses that involve addresses that are only used by one thread.
 * Loops are allowed, this analysis ensures termination by storing local copies for each destination of a backwards jump.
 * A distributive framework on the power-set lattice of D:
 * D := (Event times (Register | Allocation | {global}) times (Allocation | {global})).
 * Tracks when a register or address contains an address.
 * Unifies all global addresses into one element represented by {@code null}.
 * TODO Field-sensitivity: Distinguish between data stored in a[0] and a[1]
 * TODO also replaces memcpy memset memcmp alloc malloc.  Currently treated as calls to unknown
 */
public class MemToReg implements FunctionProcessor {

    private static final Logger logger = LogManager.getLogger(MemToReg.class);

    private MemToReg() {
    }

    public static MemToReg fromConfig(Configuration config) throws InvalidConfigurationException {
        return new MemToReg();
    }

    @Override
    public void run(Function function) {
        logger.trace("Processing function \"{}\".", function.getName());
        final var matcher = new Matcher();
        final Comparator<Event> eventComparator = Comparator.comparingInt(Event::getGlobalId);
        final List<Event> events = function.getEvents();
        assert Comparators.isInOrder(events, eventComparator);
        // Initially, all parameters contain published addresses.
        for (final Register parameter : function.getParameterRegisters()) {
            matcher.state.add(new Edge(parameter, null, null));
        }
        // This loop should terminate, since back jumps occur, only if changes were made.
        Label back;
        for (int i = 0; i < events.size(); i = back == null ? i + 1 : Collections.binarySearch(events, back, eventComparator)) {
            back = events.get(i).accept(matcher);
        }
        // Incrementally mark local addresses as global if published.
        final Set<RegWriter> emptySet = new HashSet<>();
        final Set<RegWriter> marked = new HashSet<>(matcher.reachabilityGraph.getOrDefault(null, emptySet));
        final Queue<RegWriter> queue = new ArrayDeque<>(marked);
        while (!queue.isEmpty()) {
            final RegWriter publishedAddress = queue.remove();
            for (final RegWriter contained : matcher.reachabilityGraph.getOrDefault(publishedAddress, emptySet)) {
                if (marked.add(contained)) {
                    queue.add(contained);
                }
            }
        }
        // TODO Replace
        assert false;
    }

    private static Iterable<Expression> getPublishingArguments(FunctionCall call) {
        final String name = call.getCalledFunction().getName();
        if (name.equals("__VERIFIER_assert") || name.startsWith("__VERIFIER_nondet_")) {
            return List.of();
        }
        return call.getArguments();
    }

    // Describes a local containment relationship.
    // A container is either a register, a local memory section returned by an event, or the global memory.
    // A tracked element is either a local memory section
    // Invariant: register == null || from == null
    private record Edge(Register register, RegWriter address, RegWriter value) {}

    // Processes events in program order.
    // Returns a label, if it is program-ordered before the current event and its symbolic state was updated.
    private static final class Matcher implements EventVisitor<Label> {

        // Current symbolic state.
        private final Set<Edge> state = new HashSet<>();
        // Maps labels and jumps to symbolic state information.
        private final Map<Event, Set<Edge>> jumps = new HashMap<>();
        // Join over all memory information.
        private final Map<RegWriter, Set<RegWriter>> reachabilityGraph = new HashMap<>();

        @Override
        public Label visitEvent(Event e) {
            assert !(e instanceof MemoryEvent);//FIXME this is for debugging
            // Publish all values passed as arguments.
            if (e instanceof FunctionCall call) {
                final Set<Register> registers = new HashSet<>();
                for (final Expression argument : getPublishingArguments(call)) {
                    registers.addAll(argument.getRegs());
                }
                publishRegisters(registers);
            }
            // Publish all returned values.
            if (e instanceof Return ret && ret.getValue().isPresent()) {
                final Set<Register> registers = ret.getValue().get().getRegs();
                publishRegisters(registers);
            }
            // Includes function call return values.
            if (e instanceof RegWriter writer) {
                state.add(new Edge(writer.getResultRegister(), null, writer));
            }
            return null;
        }

        @Override
        public Label visitLocal(Local assignment) {
            final Register register = assignment.getResultRegister();
            for (final RegWriter value : collect(assignment.getExpr())) {
                state.add(new Edge(register, null, value));
            }
            return null;
        }

        @Override
        public Label visitLoad(Load load) {
            final Register register = load.getResultRegister();
            final Set<RegWriter> addresses = collect(load.getAddress());
            // Read all local addresses previously stored in any address.  Read a global address if previously stored.
            // Avoid concurrent modification.
            final var values = new HashSet<RegWriter>();
            for (final Edge edge : state) {
                if (edge.register == null && addresses.contains(edge.address)) {
                    values.add(edge.value);
                }
            }
            for (final RegWriter value : values) {
                state.add(new Edge(register, null, value));
            }
            // If reading from published storage, read a global address.
            if (addresses.contains(null)) {
                state.add(new Edge(register, null, null));
            }
            return null;
        }

        @Override
        public Label visitStore(Store store) {
            // Store every value in every address.
            final Set<RegWriter> values = collect(store.getMemValue());
            for (final RegWriter address : collect(store.getAddress())) {
                storeValues(address, values);
            }
            return null;
        }

        @Override
        public Label visitLabel(Label label) {
            final int globalId = label.getGlobalId();
            final boolean looping = label.getJumpSet().stream().anyMatch(jump -> globalId < jump.getGlobalId());
            // If destination of a back jump, keep the state.
            final Set<Edge> s = looping ? jumps.get(label) : jumps.remove(label);
            if (s != null) {
                state.addAll(s);
            }
            return null;
        }

        @Override
        public Label visitCondJump(CondJump jump) {
            if (jump.isDead()) {
                return null;
            }
            final Label label = jump.getLabel();
            final boolean looping = label.getGlobalId() < jump.getGlobalId();
            final boolean isGoto = jump.isGoto();
            // If conditional back jump, send state to next event.
            if (looping && !isGoto) {
                jumps.computeIfAbsent(jump, k -> new HashSet<>()).addAll(state);
            }
            // The state of the label was kept.  When jumping back, only propagate new information.
            if (looping) {
                assert jumps.containsKey(label);
                state.removeAll(jumps.get(label));
            }
            // Jump back only if there is new information.
            if (looping && !state.isEmpty()) {
                return label;
            }
            // No jumping back means continuing with the next event.
            // If not looping, send a copy of the state into the future.  If looping, do nothing.
            jumps.computeIfAbsent(label, k -> new HashSet<>()).addAll(state);
            // If unconditional, discard the state.
            if (isGoto) {
                state.clear();
            }
            // Merge with states sent to next event.
            final Set<Edge> restoredState = jumps.remove(jump);
            if (restoredState != null) {
                assert looping && !isGoto;
                state.addAll(restoredState);
            }
            return null;
        }

        private void publishRegisters(Set<Register> registers) {
            final Set<RegWriter> values = new HashSet<>();
            for (final Edge edge : state) {
                if (registers.contains(edge.register)) {
                    values.add(edge.value);
                }
            }
            storeValues(null, values);
        }

        private void storeValues(RegWriter address, Set<RegWriter> values) {
            for (final RegWriter value : values) {
                state.add(new Edge(null, address, value));
            }
            reachabilityGraph.computeIfAbsent(address, k -> new HashSet<>()).addAll(values);
        }

        // Returned set contains null iff some static address is involved.
        private Set<RegWriter> collect(Expression expression) {
            final var result = new HashSet<RegWriter>();
            // Insert null if a global address could be returned.
            if (expression.accept(new ContainsMemoryObject()) != null) {
                result.add(null);
            }
            //
            final Set<Register> registers = expression.getRegs();
            if (!registers.isEmpty()) {
                for (final Edge entry : state) {
                    if (registers.contains(entry.register)) {
                        result.add(entry.value);
                    }
                }
            }
            return result;
        }
    }

    // Checks if an expression may return a static address directly.  Returns null otherwise.
    private static final class ContainsMemoryObject implements ExpressionVisitor<Object> {

        @Override
        public Object visit(IExprBin iBin) {
            final Object object = iBin.getLHS().accept(this);
            return object != null ? object : iBin.getRHS().accept(this);
        }

        @Override
        public Object visit(IExprUn iUn) {
            return iUn.getInner().accept(this);
        }

        @Override
        public Object visit(IfExpr ifExpr) {
            final Object object = ifExpr.getFalseBranch().accept(this);
            return object != null ? object : ifExpr.getTrueBranch().accept(this);
        }

        @Override
        public Object visit(MemoryObject address) {
            return address;
        }
    }
}
