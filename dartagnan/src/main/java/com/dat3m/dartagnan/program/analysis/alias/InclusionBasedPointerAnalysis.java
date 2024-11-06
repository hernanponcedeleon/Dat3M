package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.threading.ThreadArgument;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.witness.graphviz.Graphviz;
import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.*;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Verify.verify;

/**
 * Offset- and alignment-enhanced inclusion-based pointer analysis based on Andersen's.
 * This implementation is insensitive to control-flow, but field-sensitive.
 */
/*
    The analysis constructs a directed inclusion graph over expressions of the program.
    The nodes abstractly represent the values an expression (at a program location) could take over all executions.
    There is a node (also called variable in the code) for each memory object (addr), two for each Local (result and rhs), Load (result and addr), and Store (addr and value).
    These nodes are not just per expression but also per program location to achieve an SSA-like form (*).

    Edges between two nodes A and B describe one of three relationships:
    (1) An edge "A -f_includes-> B" means that "f(A) \subseteq B" holds (where A/B are understood as sets of values).
    Rather than arbitrary functions "f", we use multi-linear expressions "f(A) = A + k1*x1 + k2*x2 + ... kn*xn + o" where ki and o are constants.
    For simplicity, we write "k*x + o" where k=(k1,...,kn) and x=(x1,...,xn) are understood as vectors, and drop the _includes suffix (i.e. write A -f-> B).
    The (sub)expression "k*x + o" describes the set of values {k*x + o | x \in Z^n} that can be obtained by varying x freely (**).
    (2) An edge "A -stores-> B" means that there exists a store that stores at address-expression A the value-expression B.
    (3) An edge "A -loads-> R" means that there exists a load that loads from address-expression A and puts its result into R (R is the node of a register).

    Initially, the graph has the following edges
    - For every "store(A, V)" event, it has a "A -stores-> V" edge
    - For every "R = load(A)" event, it has a "A -loads-> R" edge.
    - For every assignment "R := B + k*x + o", we have a "B -(k*x+o)-> R" edge
    For too complex assignments that do not match the structure, say "R := h(B1, B2, .., Bn)" where h is complex, we introduce edges "Bi -1x+0-> R".

    On this initial graph, two rules are applied until saturation
    (1) Transitivity: A -f_includes-> B AND B -g_includes-> C IMPLIES A -fg_includes-> C (notice that we need to compose the labels as well).
    (2) Communication: if A -loads-> R and B -stores-> V and A and B can overlap (i.e. the corresponding Load/Store events can alias), then V -0x+0-> R (all values in V are included in R)

    It can happen that these rules generate an edge A -f-> B although another edge A -g-> B already exists.
    In this case, the edges get merged by a join operation.
    To guarantee termination, the saturation of cyclic inclusion relationships get accelerated:
    E.g. if A includes B (B -0x+0-> A) and B includes A+2 (A -0x+2-> B)
    then A includes A+2x, B includes A+2x+2 and both include B+2x.

    (*) We also generate special phi nodes that can improve precision on code that is not in SSA form.
    (**) In the implementation we make an unsound assumption that x is non-negative.
    This disallows negative (dynamic) indexing into arrays/pointers but gives additional precision in other cases.
    Note that "o" can be negative which is sufficient to support "containerof" functionality.
*/
public class InclusionBasedPointerAnalysis <M> implements AliasAnalysis {

    private static final Logger logger = LogManager.getLogger(InclusionBasedPointerAnalysis.class);

    // This analysis depends on another, that maps used registers to a list of possible direct writers.
    private final ReachingDefinitionsAnalysis dependency;

    // For providing helpful error messages, this analysis prints call-stack and loop information for events.
    private final Supplier<SyntacticContextAnalysis> synContext;

    private final ModifierType<M> mod;

    // When a variable gains an includes-edge, it is added to this queue for later processing.
    // For lazy cycle detection, it is grouped by the absolute value of IncludeEdge.modifier.offset.
    private final TreeMap<Integer, LinkedHashMap<Variable<M>, List<IncludeEdge<M>>>> queue = new TreeMap<>();

    // Maps memory events to variables representing their pointer set.
    private final Map<MemoryCoreEvent, DerivedVariable<M>> addressVariables = new HashMap<>();

    // Maps memory objects to variables representing their base address.
    // These Variables should always have empty includes-sets.
    private final Map<MemoryObject, Variable<M>> objectVariables = new HashMap<>();

    // Maps a set of same-register writers to a variable representing their combined result sets (~phi node).
    // Non-trivial modifiers may only appear for singleton Locals.
    private final Map<List<RegWriter>, DerivedVariable<M>> registerVariables = new HashMap<>();
    // Second variant where the uninitialized value is also considered.
    private final Map<List<RegWriter>, DerivedVariable<M>> registerVariablesInit = new HashMap<>();

    // Maps function parameters to the points-to set.
    private final Map<Register, Variable<M>> parameterVariables = new HashMap<>();

    // Maps functions to the returning points-to set.
    private final Map<Function, Variable<M>> returnVariables = new HashMap<>();

    // If enabled, the algorithm describes its internal graph to be written into a file.
    private Graphviz graphviz;

    // ================================ Debugging ================================

    // Count created variables.
    private int totalVariables = 0;
    // Count variable substitutions.
    private int totalReplacements = 0;
    // Count times a piece of new information was added to the graph.
    private int addIntoGraphSucceesses, addIntoGraphFails, addIntoCyclesSuccesses, addIntoCyclesFails;
    // Count cycle checks, which can result in fast or slow rejects, or accepts.
    private int cyclesFastCulled;
    private int cyclesSlowCulled;
    private int cyclesDetected;

    // ================================ Construction ================================

    public static InclusionBasedPointerAnalysis<?> fromConfig(Program program, Context analysisContext, AliasAnalysis.Config config) {
        final ReachingDefinitionsAnalysis def = analysisContext.requires(ReachingDefinitionsAnalysis.class);
        final var analysis = switch (config.method) {
            case FIELD_INSENSITIVE -> new InclusionBasedPointerAnalysis<>(program, new ModifierType.FieldInsensitive(), def);
            case FIELD_SENSITIVE -> new InclusionBasedPointerAnalysis<>(program, new ModifierType.FieldSensitive1(), def);
            case FULL -> new InclusionBasedPointerAnalysis<>(program, new ModifierType.FieldSensitiveN(), def);
        };
        analysis.run(program, config);
        logger.debug("variable count: {}",
                analysis.totalVariables);
        logger.debug("replacement count: {}",
                analysis.totalReplacements);
        logger.debug("addInto graph: {} successes vs {} fails",
                analysis.addIntoGraphSucceesses,
                analysis.addIntoGraphFails);
        logger.debug("addInto for cycle detection: {} successes vs {} fails",
                analysis.addIntoCyclesSuccesses,
                analysis.addIntoCyclesFails);
        logger.debug("cycles: {} detected vs {} fast-culled vs {} slow-culled",
                analysis.cyclesDetected,
                analysis.cyclesFastCulled,
                analysis.cyclesSlowCulled);
        return analysis;
    }

    private InclusionBasedPointerAnalysis(Program p, ModifierType<M> m, ReachingDefinitionsAnalysis d) {
        dependency = d;
        synContext = Suppliers.memoize(() -> SyntacticContextAnalysis.newInstance(p));
        mod = m;
    }

    // ================================ API ================================

    @Override
    public boolean mayAlias(MemoryCoreEvent x, MemoryCoreEvent y) {
        final DerivedVariable<M> vx = addressVariables.get(x);
        final DerivedVariable<M> vy = addressVariables.get(y);
        if (vx == null || vy == null) {
            return true;
        }
        if (vx.base == vy.base && mod.isConstant(vx.modifier) && mod.isConstant(vy.modifier)) {
            return vx.modifier.equals(vy.modifier);
        }
        final List<IncludeEdge<M>> ox = new ArrayList<>(vx.base.includes);
        ox.add(new IncludeEdge<>(vx.base, mod.trivial()));
        final List<IncludeEdge<M>> oy = new ArrayList<>(vy.base.includes);
        oy.add(new IncludeEdge<>(vy.base, mod.trivial()));
        for (final IncludeEdge<M> ax : ox) {
            for (final IncludeEdge<M> ay : oy) {
                if (ax.source == ay.source && overlaps(compose(ax.modifier, vx.modifier), compose(ay.modifier, vy.modifier))) {
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public boolean mustAlias(MemoryCoreEvent x, MemoryCoreEvent y) {
        final DerivedVariable<M> vx = addressVariables.get(x);
        final DerivedVariable<M> vy = addressVariables.get(y);
        return vx != null && vy != null && vx.base == vy.base && isConstant(vx.modifier) &&
                vx.modifier.equals(vy.modifier);
    }

    @Override
    public Graphviz getGraphVisualization() {
        return graphviz;
    }

    // ================================ Processing ================================

    private void run(Program program, AliasAnalysis.Config configuration) {
        checkArgument(program.isCompiled(), "The program must be compiled first.");
        // Pre-processing:
        // Each memory object gets a variable representing its base address value.
        for (final MemoryObject object : program.getMemory().getObjects()) {
            totalVariables++;
            objectVariables.put(object, new Variable<>(object, object.toString()));
        }
        for (final Function function : program.getFunctions()) {
            for (final Register register : function.getRegisters()) {
                final Variable<M> parameter = newVariable("parameter " + function.getName() + " " + register.getName());
                parameterVariables.put(register, parameter);
            }
            returnVariables.put(function, newVariable("ret of " + function.getName()));
        }
        // Each expression gets a "res" variable representing its result value set.
        // Each register writer gets an "out" variable ("ld" for loads) representing its return value set.
        // If needed, a register gets a "phi" variable representing its phi-node's value set.
        // Variables may fulfill multiple roles, e.g. the "out" of a Local is the "res" of its expression, etc.
        for (final RegWriter writer : getEvents(program, RegWriter.class)) {
            processWriter(writer);
        }
        for (final RegReader reader : getEvents(program, RegReader.class)) {
            processReader(reader);
        }
        for (final MemoryCoreEvent memoryEvent : getEvents(program, MemoryCoreEvent.class)) {
            processMemoryEvent(memoryEvent);
        }
        // Fixed-point computation:
        while (!queue.isEmpty()) {
            final Map.Entry<Integer, LinkedHashMap<Variable<M>, List<IncludeEdge<M>>>> q = queue.pollFirstEntry();
            logger.trace("dequeue level={}", q.getKey());
            for (final Map.Entry<Variable<M>, List<IncludeEdge<M>>> e : q.getValue().entrySet()) {
                algorithm(e.getKey(), e.getValue());
            }
        }
        if (configuration.graphvizInternal) {
            generateGraph();
        }
        for (final Map.Entry<MemoryCoreEvent, DerivedVariable<M>> entry : addressVariables.entrySet()) {
            postProcess(entry);
        }
        objectVariables.clear();
        registerVariables.clear();
    }

    private <T extends Event> Iterable<T> getEvents(Program program, Class<T> cls) {
        if (program.isUnrolled()) {
            return program.getThreadEvents(cls);
        }
        final List<T> events = new ArrayList<>();
        for (final Function function : program.getThreads()) {
            events.addAll(function.getEvents(cls));
        }
        for (final Function function : program.getFunctions()) {
            events.addAll(function.getEvents(cls));
        }
        return events;
    }

    // Declares the "out" variable of 'event' and inserts initial 'includes' and 'loads' edges.
    // Also declares "res" and "phi" variables, if needed.
    private void processWriter(RegWriter event) {
        logger.trace("{}", event);
        final Expression expr = event instanceof Local local ? local.getExpr() :
                        event instanceof ThreadArgument arg ? arg.getCreator().getArguments().get(arg.getIndex()) :
                        event instanceof Alloc alloc ? alloc.getAllocatedObject() : null;
        final DerivedVariable<M> value;
        if (expr != null) {
            final RegReader reader = event instanceof ThreadArgument arg ? arg.getCreator() : (RegReader) event;
            value = getResultVariable(expr, reader);
            if (value == null) {
                return;
            }
        } else if (event instanceof Load load) {
            final DerivedVariable<M> address = getResultVariable(load.getAddress(), load);
            if (address == null) {
                logger.warn("null pointer address for {}", synContext.get().getContextInfo(event));
                return;
            }
            addressVariables.put(load, address);
            final Variable<M> result = newVariable("ld" + load.getGlobalId() + "(" + load.getResultRegister().getName() + ")");
            address.base.loads.add(new LoadEdge<>(result, address.modifier));
            result.seeAlso.add(address.base);
            value = derive(result);
        } else if (event instanceof ValueFunctionCall call) {
            value = derive(returnVariables.get(call.getCalledFunction()));
        } else {
            return;
        }
        final DerivedVariable<M> old = registerVariables.put(List.of(event), value);
        if (old != null) {
            // this might happen if events are iterated out of order
            assert isTrivial(old.modifier);
            replace(old.base, value);
        }
    }

    private void processReader(RegReader event) {
        if (event instanceof FunctionCall call) {
            final List<Register> parameterRegisters = call.getCalledFunction().getParameterRegisters();
            for (int i = 0; i < call.getArguments().size(); i++) {
                final DerivedVariable<M> argument = getResultVariable(call.getArguments().get(i), call);
                if (argument == null) {
                    continue;
                }
                final Variable<M> parameter = parameterVariables.get(parameterRegisters.get(i));
                addInclude(parameter, includeEdge(argument));
            }
        }
        if (event instanceof Return ret && ret.getValue().isPresent()) {
            final DerivedVariable<M> result = getResultVariable(ret.getValue().get(), ret);
            if (result != null) {
                addInclude(returnVariables.get(ret.getFunction()), includeEdge(result));
            }
        }
    }

    // Declares the "res" variables of the address of 'event', if needed, and inserts 'stores' relationships.
    // Also propagates communications to loads, if both directly access the same variable.
    private void processMemoryEvent(MemoryCoreEvent event) {
        logger.trace("{}", event);
        if (event instanceof Load) {
            // event was already processed in processWriter(RegWriter)
            return;
        }
        final DerivedVariable<M> address = getResultVariable(event.getAddress(), event);
        if (address == null) {
            logger.warn("null pointer address for {}", synContext.get().getContextInfo(event));
            return;
        }
        addressVariables.put(event, address);
        if (event instanceof Store store) {
            final DerivedVariable<M> value = getResultVariable(store.getMemValue(), store);
            if (value != null) {
                final var edge = new StoreEdge<>(value, address.modifier);
                address.base.stores.add(edge);
                value.base.seeAlso.add(address.base);
                final List<LoadEdge<M>> loads = new ArrayList<>(address.base.loads);
                for (final Variable<M> includer : address.base.seeAlso) {
                    if (includer.loads.isEmpty()) {
                        continue;
                    }
                    for (final IncludeEdge<M> includeEdge : includer.includes) {
                        if (includeEdge.source == address.base) {
                            for (final LoadEdge<M> load : includer.loads) {
                                loads.add(compose(load, includeEdge.modifier));
                            }
                        }
                    }
                }
                processCommunication(List.of(edge), loads);
            }
        }
    }

    // Propagates the pointer sets and tests for new communications.
    private void algorithm(Variable<M> variable, List<IncludeEdge<M>> edges) {
        logger.trace("{} includes {}", variable, edges);
        verify(variable.object == null, "Trying to add include edge to object %s.", variable);
        // Propagate pointer sets.
        final List<IncludeEdge<M>> pointers = edges.stream().filter(e -> e.source.object != null).toList();
        if (!pointers.isEmpty()) {
            for (final Variable<M> user : List.copyOf(variable.seeAlso)) {
                for (final IncludeEdge<M> edgeAfter : user.includes.stream().filter(e -> e.source == variable).toList()) {
                    for (final IncludeEdge<M> edge : pointers) {
                        addInclude(user, compose(edge, edgeAfter.modifier));
                    }
                    // In a cycle, variable gets an accelerating self-loop.
                    for (final IncludeEdge<M> cycleEdge : detectCycles(user, edgeAfter)) {
                        if (cycleEdge.source == user) {
                            final M composed = compose(cycleEdge.modifier, edgeAfter.modifier);
                            final M accelerated = mod.accelerate(composed);
                            addInclude(user, new IncludeEdge<>(user, accelerated));
                        }
                    }
                }
            }
        }
        for (final IncludeEdge<M> edgeAfter : edges) {
            if (edgeAfter.source.object != null) {
                continue;
            }
            for (final IncludeEdge<M> edge : List.copyOf(edgeAfter.source.includes)) {
                if (edge.source.object != null) {
                    addInclude(variable, compose(edge, edgeAfter.modifier));
                }
            }
        }
        // memory communication
        // X <stores- A <- variable -> B -loads> Y   ==>   X -> Y (if overlapping modifiers)
        // Note that variable -> variable can be implied here
        final boolean hasLoads = !variable.loads.isEmpty();
        final boolean hasStores = !variable.stores.isEmpty();
        if (hasLoads || hasStores) {
            for (final IncludeEdge<M> edge : edges) {
                if (edge.source.object == null) {
                    continue;
                }
                final List<LoadEdge<M>> loads = new ArrayList<>(edge.source.loads);
                final List<StoreEdge<M>> stores = new ArrayList<>(edge.source.stores);
                for (final Variable<M> out : edge.source.seeAlso) {
                    for (final IncludeEdge<M> edge1 : out.includes) {
                        if (hasStores && edge1.source == edge.source) {
                            for (final LoadEdge<M> load : out.loads) {
                                loads.add(compose(load, edge1.modifier));
                            }
                        }
                        if (hasLoads && edge1.source == edge.source) {
                            for (final StoreEdge<M> store : out.stores) {
                                stores.add(compose(store, edge1.modifier));
                            }
                        }
                    }
                }
                final boolean isTrivial = isTrivial(edge.modifier);
                final List<LoadEdge<M>> variableLoads = isTrivial ? variable.loads : new ArrayList<>(variable.loads.size());
                final List<StoreEdge<M>> variableStores = isTrivial ? variable.stores : new ArrayList<>(variable.stores.size());
                if (!isTrivial) {
                    for (final LoadEdge<M> load : variable.loads) {
                        variableLoads.add(new LoadEdge<>(load.result, compose(load.addressModifier, edge.modifier)));
                    }
                    for (final StoreEdge<M> store : variable.stores) {
                        variableStores.add(new StoreEdge<>(store.value, compose(store.addressModifier, edge.modifier)));
                    }
                }
                processCommunication(variableStores, loads);
                processCommunication(stores, variableLoads);
            }
        }
    }

    // Removes information from the internal graph, which are no longer needed after the algorithm has finished.
    // This simplifies alias queries and releases memory resources.
    private void postProcess(Map.Entry<MemoryCoreEvent, DerivedVariable<M>> entry) {
        logger.trace("{}", entry);
        final DerivedVariable<M> address = entry.getValue();
        if (address == null) {
            // should have already warned about this event
            return;
        }
        // Remove all obsolete inclusion relationships between register states.
        address.base.includes.removeIf(i -> i.source.object == null);
        address.base.loads.clear();
        address.base.stores.clear();
        address.base.seeAlso.clear();
        // In a well-structured program, all address expressions refer to at least one memory object.
        if (logger.isWarnEnabled() && address.base.object == null &&
                address.base.includes.stream().allMatch(i -> i.source.object == null)) {
            logger.warn("empty pointer set for {}", synContext.get().getContextInfo(entry.getKey()));
        }
        if (address.base.includes.size() != 1) {
            return;
        }
        final IncludeEdge<M> includeEdge = address.base.includes.get(0);
        final M modifier = compose(includeEdge.modifier, address.modifier);
        assert includeEdge.source.object != null;
        // If the only included address refers to the last element, treat it as a direct static offset instead.
        if (!includeEdge.source.object.hasKnownSize() || !(modifier instanceof ModifierType.ModifierN m)) {
            return;
        }
        final int remainingSize = includeEdge.source.object.getKnownSize() - m.offset();
        for (final Integer a : m.alignment()) {
            if (a < remainingSize) {
                return;
            }
        }
        entry.setValue(new DerivedVariable<>(includeEdge.source, mod.constant(m.offset())));
    }

    // ================================ Internals ================================

    private static final class Variable<Modifier> {
        // Any value contained in the referred variables is also contained (+ modifier).
        // Visualized as ingoing edges.
        private final List<IncludeEdge<Modifier>> includes = new ArrayList<>();
        // There is some load event using this (+ address modifier) as pointer set and the referred variable as result set.
        // Visualized as outgoing edges.
        private final List<LoadEdge<Modifier>> loads = new ArrayList<>();
        // There is some store event using this (+ address modifier) as pointer set and the derived variable as value set.
        // Visualized as outgoing edges.
        private final List<StoreEdge<Modifier>> stores = new ArrayList<>();
        // All variables that have a direct (includes/loads/stores) link to this.
        private final Set<Variable<Modifier>> seeAlso = new LinkedHashSet<>();
        // If nonnull, this variable represents that object's base address.
        private final MemoryObject object;
        // For visualization.
        private final String name;
        private Variable(MemoryObject o, String n) {
            object = o;
            name = n;
        }
        @Override public String toString() { return name; }
    }

    private record IncludeEdge<Modifier>(Variable<Modifier> source, Modifier modifier) {}

    private record LoadEdge<Modifier>(Variable<Modifier> result, Modifier addressModifier) {}

    private record StoreEdge<Modifier>(DerivedVariable<Modifier> value, Modifier addressModifier) {}

    private record DerivedVariable<Modifier>(Variable<Modifier> base, Modifier modifier) {}

    private boolean isConstant(M modifier) {
        return mod.isConstant(modifier);
    }

    private boolean isTrivial(M modifier) {
        return mod.isTrivial(modifier);
    }

    private DerivedVariable<M> derive(Variable<M> base) {
        return new DerivedVariable<>(base, mod.trivial());
    }

    private IncludeEdge<M> includeEdge(DerivedVariable<M> variable) {
        return new IncludeEdge<>(variable.base, variable.modifier);
    }

    private Variable<M> newVariable(String name) {
        totalVariables++;
        return new Variable<>(null, name);
    }

    // Inserts a single inclusion relationship into the graph.
    // Any cycle closed by this edge will eventually be detected and resolved.
    private void addInclude(Variable<M> variable, IncludeEdge<M> includeEdge) {
        // accelerate for self-loops.
        // this is necessary besides lazy cycle detection, because it handles cycles of length 1.
        // LCD uses the edge that triggered the detection, which is not always the self-loop.
        final IncludeEdge<M> edge = tryAccelerate(variable, includeEdge);
        if (!addInto(variable.includes, edge, true)) {
            return;
        }
        edge.source.seeAlso.add(variable);
        final int level = Math.abs(mod.offset(edge.modifier));
        // enqueue the new edge
        final List<IncludeEdge<M>> edges = queue.computeIfAbsent(level, k -> new LinkedHashMap<>())
                .computeIfAbsent(variable, k -> new ArrayList<>());
        if (edges.isEmpty()) {
            logger.trace("enqueue level={} variable={}", level, variable);
        }
        edges.add(edge);
    }

    private IncludeEdge<M> tryAccelerate(Variable<M> variable, IncludeEdge<M> edge) {
        if (edge.source != variable) {
            return edge;
        }
        return new IncludeEdge<>(edge.source, mod.accelerate(edge.modifier));
    }

    // Tries to detect cycles when a new edge is to be added.
    // Called when a pointer propagates from variable to successor, due to an inclusion edge.
    private List<IncludeEdge<M>> detectCycles(Variable<M> variable, IncludeEdge<M> edge) {
        // Fast check for cycles of length 1.
        if (edge.source == variable) {
            return List.of(edge);
        }
        // Fast check with lazy cycle detection:
        // Eventually, any cycle will have a 'new' edge, where the pointer sets are equal.
        // Therefore, we wait for this, instead of trying to immediately detect the cycle.
        if (!equalsPointerSet(variable, edge.source)) {
            cyclesFastCulled++;
            return List.of();
        }
        // Slow check
        final Set<Variable<M>> includerSet = getIncluderSet(variable);
        if (!includerSet.contains(edge.source)) {
            cyclesSlowCulled++;
            return List.of();
        }
        cyclesDetected++;
        final List<IncludeEdge<M>> result = getAllCyclicPaths(edge, includerSet);
        assert result.stream().anyMatch(e -> e.source == variable);
        return result;
    }

    private boolean equalsPointerSet(Variable<M> left, Variable<M> right) {
        // TODO hashing: each variable gets a hash code for its pointer set.
        return includesPointerSet(left, right) && includesPointerSet(right, left);
    }

    private boolean includesPointerSet(Variable<M> variable1, Variable<M> variable2) {
        for (final IncludeEdge<M> i : variable1.includes) {
            if (i.source.object != null && !variable2.includes.contains(i)) {
                return false;
            }
        }
        return true;
    }

    private Set<Variable<M>> getIncluderSet(Variable<M> variable) {
        final Set<Variable<M>> result = new HashSet<>(List.of(variable));
        List<Variable<M>> worklist = new ArrayList<>(List.of(variable));
        while (!worklist.isEmpty()) {
            final List<Variable<M>> next = new ArrayList<>();
            for (final Variable<M> current : worklist) {
                for (final Variable<M> v : current.seeAlso) {
                    // Culling
                    if (result.contains(v)) {
                        continue;
                    }
                    // Try to find some include edge, as 'seeAlso' also indicates store and load edges.
                    for (final IncludeEdge<M> i : v.includes) {
                        if (i.source == current && result.add(v)) {
                            next.add(v);
                            break;
                        }
                    }
                }
            }
            worklist = next;
        }
        return result;
    }

    private List<IncludeEdge<M>> getAllCyclicPaths(IncludeEdge<M> edge, Set<Variable<M>> includerSet) {
        final Map<Variable<M>, List<IncludeEdge<M>>> edges = new HashMap<>();
        // Use 'set' for performance.
        final Set<IncludeEdge<M>> set = new HashSet<>();
        List<IncludeEdge<M>> worklist = new ArrayList<>(List.of(new IncludeEdge<>(edge.source, mod.trivial())));
        // Since cycles are detected lazily, we need a bound for cycle lengths.
        for (int length = 0; length < includerSet.size(); length++) {
            if (worklist.isEmpty()) {
                break;
            }
            final List<IncludeEdge<M>> next = new ArrayList<>();
            for (final IncludeEdge<M> current : worklist) {
                for (final IncludeEdge<M> i : current.source.includes) {
                    if (edge.source != i.source && includerSet.contains(i.source)) {
                        final IncludeEdge<M> joinedEdge = compose(i, current.modifier);
                        if (set.add(joinedEdge) &&
                                addInto(edges.computeIfAbsent(i.source, k -> new ArrayList<>()), joinedEdge, false)) {
                            next.add(joinedEdge);
                        }
                    }
                }
            }
            worklist = next;
        }
        final List<IncludeEdge<M>> result = new ArrayList<>();
        edges.values().forEach(result::addAll);
        return result;
    }

    private boolean addInto(List<IncludeEdge<M>> list, IncludeEdge<M> element, boolean isGraphModification) {
        //NOTE The Stream API is too costly here
        for (final IncludeEdge<M> o : list) {
            if (element.source.equals(o.source) && includes(o.modifier, element.modifier)) {
                if (isGraphModification) {
                    addIntoGraphFails++;
                } else {
                    addIntoCyclesFails++;
                }
                return false;
            }
        }
        if (isGraphModification) {
            addIntoGraphSucceesses++;
        } else {
            addIntoCyclesSuccesses++;
        }
        list.removeIf(o -> element.source.equals(o.source) && includes(element.modifier, o.modifier));
        list.add(element);
        return true;
    }

    // Called when a placeholder variable for a register writer is to be replaced by the proper variable.
    // A variable cannot be removed, if some event maps to it and there are multiple replacements.
    // In this case, the mapping stays but all outgoing edges are removed from that variable.
    private void replace(Variable<M> old, DerivedVariable<M> replacement) {
        assert old != replacement.base;
        assert !objectVariables.containsValue(old);
        totalReplacements++;
        logger.trace("{} -> {}", old, replacement);
        // likely / most frequent case
        addressVariables.replaceAll((k, v) -> v.base != old ? v : compose(replacement, v.modifier));
        registerVariables.replaceAll((k, v) -> v.base != old ? v : compose(replacement, v.modifier));
        for (final Variable<M> out : old.seeAlso) {
            out.includes.replaceAll(e -> e.source != old ? e : includeEdge(compose(replacement, e.modifier)));
            assert out.loads.stream().noneMatch(e -> e.result == old);
            out.stores.replaceAll(e -> e.value.base != old ? e :
                    new StoreEdge<>(compose(replacement, e.value.modifier), e.addressModifier));
        }
        replacement.base.seeAlso.addAll(old.seeAlso);
        for (final IncludeEdge<M> edge : old.includes) {
            edge.source.seeAlso.remove(old);
            edge.source.seeAlso.add(replacement.base);
        }
        // Redirect load and store relationships.
        // This could enable more communications, but replacement.
        for (final LoadEdge<M> load : old.loads) {
            replacement.base.loads.add(compose(load, replacement.modifier));
            load.result.seeAlso.add(replacement.base);
        }
        for (final StoreEdge<M> store : old.stores) {
            replacement.base.stores.add(compose(store, replacement.modifier));
            store.value.base.seeAlso.add(replacement.base);
        }
        old.seeAlso.clear();
        old.includes.clear();
        old.loads.clear();
        old.stores.clear();
    }

    // Find "may read from" relationships and deduce new 'includes' edges for the internal graph.
    private void processCommunication(List<StoreEdge<M>> stores, List<LoadEdge<M>> loads) {
        logger.trace("{} vs {}", stores, loads);
        if (loads.isEmpty()) {
            return;
        }
        for (final StoreEdge<M> store : stores) {
            for (final LoadEdge<M> load : loads) {
                if (overlaps(store.addressModifier, load.addressModifier)) {
                    addInclude(load.result, includeEdge(store.value));
                }
            }
        }
    }

    // Checks if leftAlignment contains all linear combinations of offset + rightAlignment.
    // Is allowed to have false negatives, as such only lead to more memory usage of the analysis.
    private boolean includes(M left, M right) {
        return mod.includes(left, right);
    }

    // Checks if there may be some common value in both sets.
    // Allowed to have false positives.
    private boolean overlaps(M l, M r) {
        return mod.overlaps(l, r);
    }

    private M compose(M left, M right) {
        return mod.compose(left, right);
    }

    // Applies another offset to an existing labeled edge.
    private DerivedVariable<M> compose(DerivedVariable<M> other, M modifier) {
        return isTrivial(modifier) ? other : new DerivedVariable<>(other.base, compose(other.modifier, modifier));
    }

    private IncludeEdge<M> compose(IncludeEdge<M> other, M modifier) {
        return isTrivial(modifier) ? other : new IncludeEdge<>(other.source, compose(other.modifier, modifier));
    }

    private LoadEdge<M> compose(LoadEdge<M> other, M modifier) {
        return isTrivial(modifier) ? other : new LoadEdge<>(other.result, compose(other.addressModifier, modifier));
    }

    private StoreEdge<M> compose(StoreEdge<M> other, M modifier) {
        return isTrivial(modifier) ? other : new StoreEdge<>(other.value, compose(other.addressModifier, modifier));
    }

    // Interprets an expression.
    // The result refers to an existing variable,
    // if the expression has a static base, or if the expression has a dynamic base with exactly one writer.
    // Otherwise, it refers to a new variable with proper incoming edges.
    private DerivedVariable<M> getResultVariable(Expression expression, RegReader reader) {
        final var collector = new Collector();
        expression.accept(collector);
        // Extract constant offset.
        int offset = 0;
        final Iterator<Map.Entry<Expression, Integer>> i = collector.operands.entrySet().iterator();
        while (i.hasNext()) {
            final Map.Entry<Expression, Integer> entry = i.next();
            if (entry.getKey() instanceof IntLiteral k) {
                offset += k.getValueAsInt() * entry.getValue();
                i.remove();
            }
        }
        // Try matching static GEP expressions
        final List<MemoryObject> bases = collector.operands.entrySet().stream()
                .filter(e -> e.getValue() == 1 && e.getKey() instanceof MemoryObject)
                .map(e -> (MemoryObject) e.getKey())
                .toList();
        final var operands = new ArrayList<DerivedVariable<M>>();
        if (bases.size() == 1) {
            final M modifier = mod.fromExpression(offset, collector.operands, bases.get(0));
            operands.add(new DerivedVariable<>(objectVariables.get(bases.get(0)), modifier));
            collector.operands.remove(bases.get(0));
        }
        // Handle other candidate bases.
        //TODO try to exclude registers that never contain addresses
        for (Map.Entry<Expression, Integer> entry : collector.operands.entrySet()) {
            if (entry.getKey() instanceof Register register) {
                final M modifier = mod.fromExpression(offset, collector.operands, entry.getKey());
                operands.add(compose(getPhiNodeVariable(register, reader), modifier));
            } else {
                for (Register register : entry.getKey().getRegs()) {
                    operands.add(compose(getPhiNodeVariable(register, reader), mod.top()));
                }
                final var objects = new ObjectCollector();
                entry.getKey().accept(objects);
                for (MemoryObject object : objects.collection) {
                    operands.add(new DerivedVariable<>(objectVariables.get(object), mod.top()));
                }
            }
        }
        if (operands.isEmpty()) {
            return null;
        }
        if (operands.size() == 1) {
            return operands.get(0);
        }
        final Variable<M> variable = newVariable("res" + reader.getGlobalId() + "(" + expression + ")");
        for (DerivedVariable<M> o : operands) {
            addInclude(variable, includeEdge(o));
        }
        return derive(variable);
    }

    // Fetches the node for address values that can be read from a register at a specific program point.
    // Constructs a new node, if there are multiple writers.
    private DerivedVariable<M> getPhiNodeVariable(Register register, RegReader reader) {
        // We assume here that uninitialized values carry no meaningful address to any memory object.
        final ReachingDefinitionsAnalysis.RegisterWriters state = dependency.getWriters(reader).ofRegister(register);
        final List<RegWriter> writers = state.getMayWriters();
        final boolean initialized = state.mustBeInitialized();
        final Variable<M> parameter = initialized ? null : parameterVariables.get(register);
        if (parameter != null && writers.isEmpty()) {
            return derive(parameter);
        }
        final Map<List<RegWriter>, DerivedVariable<M>> map = initialized ? registerVariables : registerVariablesInit;
        final DerivedVariable<M> find = map.get(writers);
        if (find != null) {
            return find;
        }
        final Variable<M> result = newVariable("phi" + reader.getGlobalId() + "(" + register.getName() + ")");
        if (parameter != null) {
            addInclude(result, new IncludeEdge<>(parameter, mod.trivial()));
        }
        // If writers is a singleton here, its "phi" node will be replaced later.  Otherwise, the "out" nodes.
        for (final RegWriter writer : writers.size() == 1 ? List.<RegWriter>of() : writers) {
            // The variables created here will be replaced later, if the events are out of order.
            final DerivedVariable<M> writerVariable = map.computeIfAbsent(List.of(writer),
                    k -> derive(newVariable("out" + writer.getGlobalId())));
            addInclude(result, includeEdge(writerVariable));
        }
        return map.compute(writers, (k, v) -> derive(result));
    }

    private static final class Collector implements ExpressionVisitor<Void> {

        private final Map<Expression, Integer> operands = new HashMap<>();
        private int factor = 1;

        @Override
        public Void visitExpression(Expression x) {
            operands.put(x, factor);
            return null;
        }

        @Override
        public Void visitIntBinaryExpression(IntBinaryExpr x) {
            switch (x.getKind()) {
                case MUL -> {
                    final var leftLiteral = x.getLeft() instanceof IntLiteral l ? l : null;
                    final var rightLiteral = x.getRight() instanceof IntLiteral l ? l : null;
                    if ((leftLiteral == null) == (rightLiteral == null)) {
                        return visitExpression(x);
                    }
                    final int oldFactor = factor;
                    try {
                        final IntLiteral literal = leftLiteral != null ? leftLiteral : rightLiteral;
                        factor = Math.multiplyExact(factor, literal.getValueAsInt());
                    } catch (ArithmeticException e) {
                        return visitExpression(x);
                    }
                    (leftLiteral != null ? x.getRight() : x.getLeft()).accept(this);
                    factor = oldFactor;
                }
                case ADD -> {
                    x.getLeft().accept(this);
                    x.getRight().accept(this);
                }
                case SUB -> {
                    x.getLeft().accept(this);
                    factor = -factor;
                    x.getRight().accept(this);
                    factor = -factor;
                }
                default -> visitExpression(x);
            }
            return null;
        }

        @Override
        public Void visitIntUnaryExpression(IntUnaryExpr x) {
            if (x.getKind() != IntUnaryOp.MINUS) {
                return visitExpression(x);
            }
            factor = -factor;
            x.getOperand().accept(this);
            factor = -factor;
            return null;
        }

        @Override
        public Void visitIntSizeCastExpression(IntSizeCast x) {
            // We assume type casts do not affect the value of pointers.
            if (!x.isExtension() || x.preservesSign()) {
                return visitExpression(x);
            }
            x.getOperand().accept(this);
            return null;
        }
    }

    private static final class ObjectCollector implements ExpressionInspector {
        private final List<MemoryObject> collection = new ArrayList<>();
        @Override
        public MemoryObject visitMemoryObject(MemoryObject x) {
            collection.add(x);
            return x;
        }
    }

    // Projects the internal representation of this analysis:
    // Nodes are variables, grey edges are inclusions.
    // Blue edges connect address variables to register variables.
    // Red edges connect address variables to stored value variables.
    // Green-labeled nodes represent memory objects.
    // Red-labeled nodes are address variables that do not include any memory objects (probably a bug).
    private void generateGraph() {
        final Set<Variable<M>> seen = new HashSet<>(objectVariables.values());
        for (Set<Variable<M>> news = seen; !news.isEmpty();) {
            final var next = new HashSet<Variable<M>>();
            for (final Variable<M> v : news) {
                next.addAll(v.seeAlso);
                v.includes.forEach(o -> next.add(o.source));
                v.loads.forEach(o -> next.add(o.result));
                v.stores.forEach(o -> next.add(o.value.base));
            }
            next.removeAll(seen);
            seen.addAll(next);
            news = next;
        }
        final Map<String, Set<String>> map = new HashMap<>();
        final Map<String, Set<String>> loads = new HashMap<>();
        final Map<String, Set<String>> stores = new HashMap<>();
        for (Variable<M> v : seen) {
            if (v == null) {
                continue;
            }
            for (final IncludeEdge<M> i : v.includes) {
                verify(i.source.seeAlso.contains(v));
                map.computeIfAbsent("\"" + i.source.name + "\"", k -> new HashSet<>()).add("\"" + v.name + "\"");
            }
            for (final LoadEdge<M> i : v.loads) {
                verify(i.result.seeAlso.contains(v));
                loads.computeIfAbsent("\"" + v.name + "\"", k -> new HashSet<>()).add("\"" + i.result.name + "\"");
            }
            for (final StoreEdge<M> i : v.stores) {
                verify(i.value.base.seeAlso.contains(v));
                stores.computeIfAbsent("\"" + v.name + "\"", k -> new HashSet<>()).add("\"" + i.value.base.name + "\"");
            }
        }
        final Set<String> problematic = new HashSet<>();
        for (final DerivedVariable<M> a : addressVariables.values()) {
            if (!objectVariables.containsValue(a.base) &&
                    a.base.includes.stream().noneMatch(i -> objectVariables.containsValue(i.source))) {
                problematic.add("\"" + a.base.name + "\"");
            }
        }
        graphviz = new Graphviz();
        graphviz.beginDigraph("internal alias");
        for (final Variable<M> v : objectVariables.values()) {
            graphviz.addNode("\"" + v.name + "\"", "fontcolor=mediumseagreen");
        }
        for (final String v : problematic) {
            graphviz.addNode(v, "fontcolor=red");
        }
        graphviz.beginSubgraph("inclusion");
        graphviz.setEdgeAttributes("color=grey");
        graphviz.addEdges(map);
        graphviz.end();
        graphviz.beginSubgraph("loads");
        graphviz.setEdgeAttributes("color=mediumslateblue");
        graphviz.addEdges(loads);
        graphviz.end();
        graphviz.beginSubgraph("stores");
        graphviz.setEdgeAttributes("color=orangered3");
        graphviz.addEdges(stores);
        graphviz.end();
        graphviz.end();
    }
}
