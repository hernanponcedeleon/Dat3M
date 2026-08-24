package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import org.antlr.v4.runtime.CharStream;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public abstract class ParserAsm {
    protected static final TypeFactory types = TypeFactory.getInstance();
    protected static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    protected static final IntegerType i64 = types.getIntegerType(64);
    protected static final IntegerType i32 = types.getIntegerType(32);
    protected static final IntegerType i16 = types.getIntegerType(16);
    protected static final IntegerType i8 = types.getIntegerType(8);
    protected final Function function;
    protected final List<Event> events = new ArrayList<>();
    private final Map<String, Label> labels = new HashMap<>();

    protected ParserAsm(Function f) { function = f; }

    public abstract List<Event> parse(CharStream charStream);

    public abstract Register formatLlvmRegister(int index, char constraintCode);

    public abstract String formatArgument(int index, char constraintCode, String modifier);

    public String formatComment() {
        return ";";
    }

    public String formatPrivateLabelPrefix() {
        return "L";
    }

    public static ParserAsm forTarget(Arch target, Function entry) {
        return switch (target) {
            case ARM8 -> new ParserAsmArm(entry);
            case POWER -> new ParserAsmPPC(entry);
            case RISCV -> new ParserAsmRISCV(entry);
            case TSO -> new ParserAsmX86(entry, false, false);
            default -> throw new UnsupportedOperationException("No assembler for target %s".formatted(target));
        };
    }

    protected final Label declareLabel(String name) {
        return labels.computeIfAbsent(name, EventFactory::newLabel);
    }

    protected final Label declareLabel(String name, boolean forward) {
        final Label old = labels.get(name);
        check(forward || old != null, "Missing label '%s'", name);
        if (!forward || old != null && !events.contains(old)) {
            return old;
        }
        final Label label = EventFactory.newLabel(name);
        labels.put(name, label);
        return label;
    }

    protected final void appendLabel(String name) {
        final Label found = labels.get(name);
        if (found != null && !events.contains(found)) {
            events.add(found);
            return;
        }
        final Label label = EventFactory.newLabel(name);
        labels.put(name, label);
        events.add(label);
    }

    protected final void validate() {
        final List<String> undefinedLabels = new ArrayList<>();
        for (Map.Entry<String, Label> entry : labels.entrySet()) {
            if (!events.contains(entry.getValue())) {
                undefinedLabels.add(entry.getKey());
            }
        }
        check(undefinedLabels.isEmpty(), "undefined labels: %s", undefinedLabels);
    }

    protected final void check(boolean condition, String format, Object... arguments) {
        if (!condition) {
            //TODO provide line number (must be adjusted for litmus tests)
            parsingException(format, arguments);
        }
    }

    protected static <T> T parsingException(String format, Object... arguments) {
        throw new ParsingException(format, arguments);
    }
}
