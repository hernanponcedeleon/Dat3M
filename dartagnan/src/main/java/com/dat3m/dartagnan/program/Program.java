package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import com.google.common.base.Preconditions;

import java.util.*;
import java.util.stream.Collectors;

public class Program {

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
    private Arch arch;
    private int unrollingBound = 0;
    private boolean isCompiled;
    private final SourceLanguage format;

    private int nextConstantId = 0;

    public Program(Memory memory, SourceLanguage format) {
        this("", memory, format);
    }

    public Program(String name, Memory memory, SourceLanguage format) {
        this.name = name;
        this.memory = memory;
        this.threads = new ArrayList<>();
        this.functions = new ArrayList<>();
        this.format = format;
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
        this.filterSpec = spec;
    }

    public void addThread(Thread t) {
        threads.add(t);
        t.setProgram(this);
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
            return expressions.makeArray(arrayType.getElementType(), entries, true);
        }
        if (type instanceof AggregateType aggregateType) {
            final List<Expression> elements = new ArrayList<>(aggregateType.getDirectFields().size());
            for (Type fieldType : aggregateType.getDirectFields()) {
                elements.add(newConstant(fieldType));
            }
            return expressions.makeConstruct(elements);
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