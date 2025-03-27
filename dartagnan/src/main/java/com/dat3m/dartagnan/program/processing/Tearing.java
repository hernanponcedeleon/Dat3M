package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.annotations.TransactionMarker;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.dat3m.dartagnan.program.memory.FinalMemoryValue;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.Ordering;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.*;

import static com.google.common.base.Preconditions.checkArgument;

public final class Tearing {

    private static final Logger logger = LogManager.getLogger(Tearing.class);

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final boolean bigEndian;
    private final Map<MemoryCoreEvent, List<Event>> map = new HashMap<>();

    private Tearing(boolean e) {
        bigEndian = e;
    }

    public static boolean run(Program program, AliasAnalysis alias) {
        final boolean isBigEndian = program.getMemory().isBigEndian();
        logger.info("Running Tearing assuming {}", isBigEndian ? "big-endian" : "little-endian");
        return new Tearing(isBigEndian).replaceAll(program, alias);
    }

    private boolean replaceAll(Program program, AliasAnalysis alias) {
        // Generate transaction events for mixed-size accesses
        final int numTearedInits = tearInits(program, alias);
        //NOTE RMWStores need to access the associated load's replacements
        final List<MemoryCoreEvent> events = program.getThreadEvents(MemoryCoreEvent.class);
        for (MemoryCoreEvent event : events) {
            final Load load = event instanceof Load l ? l : null;
            final List<Integer> msa = load == null ? List.of() : alias.mayMixedSizeAccesses(event);
            if (!msa.isEmpty()) {
                map.put(load, createTransaction(load, msa));
            }
        }
        for (MemoryCoreEvent event : events) {
            final Store store = event instanceof Store s && !(event instanceof Init) ? s : null;
            final List<Integer> msa = store == null ? List.of() : alias.mayMixedSizeAccesses(event);
            if (!msa.isEmpty()) {
                map.put(store, createTransaction(store, msa));
            }
        }
        // Replace instructions by transactions of events
        //NOTE Some loads are used by stores, and cannot be replaced before them
        for (Map.Entry<MemoryCoreEvent, List<Event>> entry : map.entrySet()) {
            if (entry.getKey() instanceof Store store && !entry.getValue().equals(List.of(store))) {
                Event firstStore = entry.getValue().stream().filter(Store.class::isInstance).findFirst().orElseThrow();
                store.getUsers().forEach(u -> u.updateReferences(Map.of(store, firstStore)));
                store.replaceBy(entry.getValue());
            }
        }
        for (Map.Entry<MemoryCoreEvent, List<Event>> entry : map.entrySet()) {
            if (entry.getKey() instanceof Load load && !entry.getValue().equals(List.of(load))) {
                load.replaceBy(entry.getValue());
            }
        }

        final int numTearedNonInit = map.size();
        logger.info("Teared {} init and {} non-init events.", numTearedInits, numTearedNonInit);
        if (logger.isDebugEnabled()) {
            final List<SourceLocation> sortedLocs = map.keySet().stream()
                    .map(e -> e.getMetadata(SourceLocation.class))
                    .filter(Objects::nonNull)
                    .distinct()
                    .sorted(Ordering.usingToString())
                    .toList();
            StringBuilder info = new StringBuilder();
            info.append("\n").append("======== Tearing source information ========");
            sortedLocs.forEach(loc -> info.append("\n\t").append(loc));
            info.append("\n").append("============================================");
            logger.debug(info);
        }

        return (numTearedInits + numTearedNonInit) > 0;
    }

    private int tearInits(Program program, AliasAnalysis alias) {
        int numTearings = 0;
        for (Init init : program.getThreadEvents(Init.class)) {
            final List<Integer> offsets = alias.mayMixedSizeAccesses(init);
            if (offsets.isEmpty()) {
                continue;
            }
            final int bytes = checkBytes(init, offsets);
            final MemoryObject base = init.getBase();
            final int initOffset = init.getOffset();
            final Expression value = init.getValue();
            // Tear initial values
            final int frontBegin = bigEndian ? bytes - offsets.get(0) : 0;
            final int frontEnd = bigEndian ? bytes : offsets.get(0);
            final Expression frontValue = expressions.makeIntExtract(value, 8 * frontBegin, 8 * frontEnd - 1);
            base.setInitialValue(initOffset, frontValue);
            for (int i = 0; i < offsets.size(); i++) {
                final int offset = offsets.get(i);
                final int next = i + 1 < offsets.size() ? offsets.get(i + 1) : bytes;
                final int begin = bigEndian ? bytes - next : offset;
                final int end = bigEndian ? bytes - offset : next;
                final Expression tearedValue = expressions.makeIntExtract(value, 8 * begin, 8 * end - 1);
                base.setInitialValue(initOffset + offset, tearedValue);
            }
            // Tear init event
            init.setMemValue(frontValue);
            for (int begin : offsets) {
                program.addInit(base, initOffset + begin);
            }
            numTearings++;
        }
        tearExpressions(program);
        return numTearings;
    }

    private void tearExpressions(Program program) {
        //TODO currently, FinalMemoryValue only occurs in the program's final state expressions.
        final Expression specification = program.getSpecification();
        final Expression filter = program.getFilterSpecification();
        if (specification == null && filter == null) {
            return;
        }
        final var substitution = new FinalValueTearSubstitution();
        for (Init init : program.getThreadEvents(Init.class)) {
            substitution.typesByObject.computeIfAbsent(init.getBase(), k -> new HashMap<>())
                    .put(init.getOffset(), init.getAccessType());
        }
        final Expression updatedSpecification = specification == null ? null : specification.accept(substitution);
        final Expression updatedFilter = filter == null ? null : filter.accept(substitution);
        program.setSpecification(program.getSpecificationType(), updatedSpecification);
        program.setFilterSpecification(updatedFilter);
    }

    private List<Event> createTransaction(Load load, List<Integer> offsets) {
        final int bytes = checkBytes(load, offsets);
        final List<Event> replacement = new ArrayList<>();
        final IntegerType addressType = checkIntegerType(load.getAddress().getType(),
                "Non-integer address in '%s'", load);
        checkIntegerType(load.getAccessType(), "Non-integer mixed-size access in '%s'", load);
        final Function function = load.getFunction();
        final Register addressRegister = toRegister(load.getAddress(), function, replacement);
        final List<Register> smallerRegisters = new ArrayList<>();
        for (int i = -1; i < offsets.size(); i++) {
            int start = i < 0 ? 0 : offsets.get(i);
            int end = i + 1 < offsets.size() ? offsets.get(i + 1) : bytes;
            assert start < end;
            smallerRegisters.add(function.newRegister(types.getIntegerType(8 * (end - start))));
        }
        assert bytes == smallerRegisters.stream().mapToInt(t -> types.getMemorySizeInBytes(t.getType())).sum();
        final TransactionMarker begin = EventFactory.newTransactionBegin(load);
        replacement.add(begin);
        for (int i = -1; i < offsets.size(); i++) {
            final int start = i < 0 ? 0 : offsets.get(i);
            final Expression offset = expressions.makeValue(start, addressType);
            final Expression address = expressions.makeAdd(addressRegister, offset);
            final Load byteLoad = load.getCopy();
            byteLoad.setResultRegister(smallerRegisters.get(i + 1));
            byteLoad.setAddress(address);
            replacement.add(byteLoad);
        }
        replacement.add(EventFactory.newTransactionEnd(load, begin));
        final Expression combination = expressions.makeIntConcat(smallerRegisters);
        replacement.add(EventFactory.newLocal(load.getResultRegister(), combination));
        return replacement;
    }

    private List<Event> createTransaction(Store store, List<Integer> offsets) {
        final int bytes = checkBytes(store, offsets);
        final List<Event> replacement = new ArrayList<>();
        final IntegerType addressType = checkIntegerType(store.getAddress().getType(),
                "Non-integer address in '%s'", store);
        checkIntegerType(store.getAccessType(), "Non-integer mixed-size access in '%s'", store);
        final Function function = store.getFunction();
        final Register addressRegister = toRegister(store.getAddress(), function, replacement);
        final Register valueRegister = toRegister(store.getMemValue(), function, replacement);
        final List<Load> loads = store instanceof RMWStore st ? map.get(st.getLoadEvent()).stream()
                .filter(Load.class::isInstance).map(Load.class::cast).toList() : null;
        final TransactionMarker beginTransaction = EventFactory.newTransactionBegin(store);
        replacement.add(beginTransaction);
        for (int i = -1; i < offsets.size(); i++) {
            final int offset = i < 0 ? 0 : offsets.get(i);
            final int next = i + 1 < offsets.size() ? offsets.get(i + 1) : bytes;
            final int begin = bigEndian ? bytes - next : offset;
            final int end = bigEndian ? bytes - offset : next;
            final Expression address = expressions.makeAdd(addressRegister, expressions.makeValue(offset, addressType));
            final Expression value = expressions.makeIntExtract(valueRegister, 8 * begin, 8 * end - 1);
            final Store byteStore = store.getCopy();
            byteStore.setAddress(address);
            byteStore.setMemValue(value);
            if (loads != null && byteStore instanceof RMWStore st) {
                st.updateReferences(Map.of(st.getLoadEvent(), loads.get(i + 1)));
            }
            replacement.add(byteStore);
        }
        replacement.add(EventFactory.newTransactionEnd(store, beginTransaction));
        return replacement;
    }

    private IntegerType checkIntegerType(Type type, String message, Event event) {
        final IntegerType integerType = type instanceof IntegerType t ? t : null;
        if (integerType != null) {
            return integerType;
        }
        throw new UnsupportedOperationException(String.format(message, event));
    }

    private Register toRegister(Expression expression, Function function, List<Event> replacement) {
        if (expression instanceof Register r) {
            return r;
        }
        final Register r = function.newRegister(expression.getType());
        replacement.add(EventFactory.newLocal(r, expression));
        return r;
    }

    private int checkBytes(MemoryCoreEvent event, List<Integer> offsets) {
        final int bytes = types.getMemorySizeInBytes(event.getAccessType());
        checkArgument(offsets.stream().allMatch(i -> 0 < i && i < bytes), "offset out of range");
        checkArgument(isStrictlySorted(offsets), "unsorted offset list");
        return bytes;
    }

    private static <T extends Comparable<T>> boolean isStrictlySorted(List<T> list) {
        for (int i = 0; i < list.size() - 1; i++) {
            if (list.get(i).compareTo(list.get(i + 1)) >= 0) {
                return false;
            }
        }
        return true;
    }

    private static final class FinalValueTearSubstitution extends ExprTransformer {

        // Teared types, Grouped by object and reverse-ordered by offset.
        private final Map<MemoryObject, Map<Integer, Type>> typesByObject = new HashMap<>();

        @Override
        public Expression visitFinalMemoryValue(FinalMemoryValue value) {
            final Map<Integer, Type> typesByOffset = typesByObject.get(value.getMemoryObject());
            if (typesByOffset == null) {
                // Object unaffected from MSAs; nothing to do
                return value;
            }
            final int begin = value.getOffset();
            final int end = begin + types.getMemorySizeInBytes(value.getType());
            final List<Expression> result = new ArrayList<>();
            for (int offset = begin; offset < end;) {
                final Type t = typesByOffset.get(offset);
                result.add(new FinalMemoryValue(value.getName(), t, value.getMemoryObject(), offset));
                offset += types.getMemorySizeInBytes(t);
            }
            final Expression combined = result.size() == 1 ? result.get(0) : expressions.makeIntConcat(result);
            return expressions.makeCast(combined, value.getType());
        }
    }
}
