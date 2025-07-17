package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.TypeOffset;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import com.google.common.base.Preconditions;

import java.util.*;
import java.util.stream.Collectors;

public class Program {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final FunctionType auxiliaryThreadType = types.getFunctionType(types.getVoidType(), List.of());

    public enum SourceLanguage { LITMUS, LLVM, SPV }

    public enum SpecificationType { EXISTS, FORALL, NOT_EXISTS, ASSERT }

    private String name;
    private SpecificationType specificationType = SpecificationType.ASSERT;
    private Expression spec;
    private Expression filterSpec; // Acts like "assume" statements, filtering out executions
    private final List<Thread> threads;
    private final List<Function> functions;
    private final List<NonDetValue> constants = new ArrayList<>();
    private final Memory memory;
    private Entrypoint entrypoint;
    private Arch arch;
    private int unrollingBound = 0;
    private boolean isCompiled;
    private final SourceLanguage format;

    private int nextThreadId = 0;
    private int nextConstantId = 0;

    // ------------------------

    public Program(Memory memory, SourceLanguage format) {
        this("", memory, format);
    }

    public Program(String name, Memory memory, SourceLanguage format) {
        this.name = name;
        this.memory = memory;
        this.threads = new ArrayList<>();
        this.functions = new ArrayList<>();
        this.format = format;

        this.filterSpec = ExpressionFactory.getInstance().makeTrue();
    }

    public SourceLanguage getFormat() {
        return format;
    }

    public boolean isCompiled() {
        return isCompiled;
    }

    public boolean isUnrolled() {
        return unrollingBound > 0;
    }

    public int getUnrollingBound() {
        return unrollingBound;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setArch(Arch arch) {
        this.arch = arch;
    }

    public Arch getArch() {
        return arch;
    }

    public Memory getMemory() {
        return this.memory;
    }

    public void setEntrypoint(Entrypoint entrypoint) {
        this.entrypoint = entrypoint;
    }

    public Entrypoint getEntrypoint() {
        return entrypoint;
    }

    public SpecificationType getSpecificationType() {
        return specificationType;
    }

    public boolean hasReachabilitySpecification() {
        return SpecificationType.EXISTS.equals(specificationType);
    }

    public Expression getSpecification() {
        return spec;
    }

    public void setSpecification(SpecificationType type, Expression spec) {
        this.specificationType = type;
        this.spec = spec;
    }

    public Expression getFilterSpecification() {
        return filterSpec;
    }

    public void setFilterSpecification(Expression spec) {
        Preconditions.checkArgument(spec.getType() instanceof BooleanType);
        this.filterSpec = spec;
    }

    public void addThread(Thread t) {
        threads.add(t);
        t.setProgram(this);
        nextThreadId = Math.max(nextThreadId, t.getId()) + 1;
    }

    public void addFunction(Function func) {
        Preconditions.checkArgument(!(func instanceof Thread), "Use addThread to add threads to the program");
        functions.add(func);
        func.setProgram(this);
    }

    public boolean removeFunction(Function func) {
        return functions.remove(func);
    }

    public List<Thread> getThreads() {
        return threads;
    }

    public List<Function> getFunctions() { return functions; }

    // Looks up a declared function by name.
    public Optional<Function> getFunctionByName(String name) {
        return functions.stream().filter(f -> f.getName().equals(name)).findFirst();
    }

    public Expression newConstant(Type type) {
        final ExpressionFactory expressions = ExpressionFactory.getInstance();

        if (type instanceof ArrayType arrayType) {
            final List<Expression> entries = new ArrayList<>(arrayType.getNumElements());
            for (int i = 0; i < arrayType.getNumElements(); i++) {
                entries.add(newConstant(arrayType.getElementType()));
            }
            return expressions.makeArray(arrayType, entries);
        }
        if (type instanceof AggregateType aggregateType) {
            final List<Expression> elements = new ArrayList<>(aggregateType.getFields().size());
            for (TypeOffset typeOffset : aggregateType.getFields()) {
                elements.add(newConstant(typeOffset.type()));
            }
            return expressions.makeConstruct(type, elements);
        }
        var expression = new NonDetValue(type, nextConstantId++);
        constants.add(expression);
        return expression;
    }

    public Collection<NonDetValue> getConstants() {
        return Collections.unmodifiableCollection(constants);
    }

    public List<Event> getThreadEvents() {
        Preconditions.checkState(!threads.isEmpty(), "The program has no threads yet.");
        List<Event> events = new ArrayList<>();
        for (Function func : threads) {
            events.addAll(func.getEvents());
        }
        return events;
    }

    public <T extends Event> List<T> getThreadEvents(Class<T> cls) {
        return getThreadEvents().stream().filter(cls::isInstance).map(cls::cast).collect(Collectors.toList());
    }

    public List<Event> getThreadEventsWithAllTags(String... tags) {
        final List<String> tagList = Arrays.asList(tags);
        return getThreadEvents().stream().filter(e -> e.getTags().containsAll(tagList)).collect(Collectors.toList());
    }

    public void addInit(MemoryObject object, int offset) {
        final boolean isC11 = arch == Arch.C11 || arch == Arch.OPENCL;
        final List<String> paramNames = List.of();
        // NOTE: We use different names to avoid symmetry detection treating all inits as symmetric.
        final String threadName = "Init_" + nextThreadId;
        final Thread thread = new Thread(threadName, auxiliaryThreadType, paramNames, nextThreadId,
                EventFactory.newThreadStart(null));
        final Event init = EventFactory.newInit(object, offset);
        thread.append(init);
        if (isC11) {
            init.addTags(Tag.C11.NONATOMIC);
        }
        thread.append(EventFactory.newLabel("END_OF_T" + thread.getId()));
        addThread(thread);
    }

    public void addTerminationThread() {
        final List<String> paramNames = List.of();
        final Thread thread = new Thread("Termination", auxiliaryThreadType, paramNames, nextThreadId,
                EventFactory.newThreadStart(null));
        thread.append(EventFactory.newTerminationEvent());
        thread.append(EventFactory.newLabel("END_OF_T" + thread.getId()));
        addThread(thread);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    public boolean markAsUnrolled(int bound) {
        if (unrollingBound > 0) {
            return false;
        }
        unrollingBound = bound;
        return true;
    }

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    public boolean markAsCompiled() {
        if (isCompiled) {
            return false;
        }
        isCompiled = true;
        return true;
    }
}