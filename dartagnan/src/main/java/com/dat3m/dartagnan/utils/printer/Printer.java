package com.dat3m.dartagnan.utils.printer;

import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.expression.ExpressionPrinter;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.program.*;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.stream.Collectors;
import java.util.stream.Stream;

@Options
public class Printer {

    // =========================== Configurables ===========================
    public enum Mode {
        THREADS,
        FUNCTIONS,
        ALL;

        private boolean includesThreads() { return this == THREADS || this == ALL; }
        private boolean includesFunctions() { return this == FUNCTIONS || this == ALL; }
    }

    private Mode mode = Mode.ALL;
    public Printer setMode(Mode mode) {
        this.mode = mode;
        return this;
    }

    @Option(name = OptionNames.PRINTER_SHOW_INIT_THREADS,
            description = "Print init threads (default: false)",
            secure = true)
    private boolean showInitThreads = false;

    @Option(name = OptionNames.PRINTER_SHOW_ANNOTATIONS,
            description = "Print annotation events (default: true)",
            secure = true)
    private boolean showAnnotationEvents = true;

    @Option(name = OptionNames.PRINTER_SHOW_DYNAMIC_ALLOCATIONS,
            description = "Print dynamic allocations (default: true)",
            secure = true)
    private boolean showDynamicAllocations = true;

    @Option(name = OptionNames.PRINTER_SHOW_PROGRAM_CONSTANTS,
            description = "Print non-deterministic program constants (default: false)",
            secure = true)
    private boolean showProgramConstants = true;

    @Option(name = OptionNames.PRINTER_SHOW_SPECIFICATION,
            description = "Print program specification and filter (default: false)",
            secure = true)
    private boolean showSpecification = true;

    // =================================================================================

    private Printer() { }

    private Printer(Configuration configuration) throws InvalidConfigurationException {
        configuration.inject(this);
    }

    public static Printer newInstance() {
        return new Printer();
    }

    public static Printer fromConfig(Configuration config) throws InvalidConfigurationException {
        return new Printer(config);
    }

    // =================================================================================

    public String print(Program program) {
        final StringBuilder result = new StringBuilder();

        // ----- Program header -----
        appendHeader(program, result);
        result.append("\n\n");

        // ----- Program constants -----
        if (showProgramConstants) {
            appendProgramConstants(program, result);
            result.append("\n\n");
        }

        // ----- Memory -----
        appendMemory(program.getMemory(), result);
        result.append("\n\n");

        // ----- Program body -----
        appendMainBody(program, result);

        // ----- Specification -----
        if (showSpecification) {
            appendSpecification(program, result);
        }

        return result.toString();
    }

    private void appendHeader(Program program, StringBuilder result) {
        final String name = program.getName() != null ?  program.getName() : "program";
        result.append(name);
        if (!(program.getEntrypoint() instanceof Entrypoint.Resolved)) {
            result.append(" ").append(program.getEntrypoint());
        }
    }

    // -------------------------------------------------------------------------------------------
    // Program constants

    private void appendProgramConstants(Program program, StringBuilder result) {
        result.append("Non-deterministic constants:");

        for (NonDetValue constant : program.getConstants()) {
            result.append("\n").append(constant);
        }
    }

    // -------------------------------------------------------------------------------------------
    // Memory

    private void appendMemory(Memory memory, StringBuilder result) {
        result.append("Memory:");

        int omitted = 0;
        for (MemoryObject obj : memory.getObjects()) {
            if (showMemoryObject(obj)) {
                result.append("\n");
                appendMemoryObject(obj, result);
            } else {
                omitted++;
            }
        }

        if (omitted > 0) {
            result.append("\n... omitted ").append(omitted).append(" memory objects ...");
        }
    }

    private void appendMemoryObject(MemoryObject obj, StringBuilder result) {
        final String size = obj.hasKnownSize() ? Integer.toString(obj.getKnownSize()) : "unknown";
        final String align = obj.hasKnownAlignment() ? Integer.toString(obj.getKnownAlignment()) : "unknown";
        final String modifier = obj.isStaticallyAllocated() ? "static" : "dynamic";
        final String name = obj.isStaticallyAllocated()
                ? obj.getName()
                : "@E" + obj.getAllocationSite().getGlobalId();

        result.append(modifier).append(" ")
                .append(String.format("[size=%s, align=%s]\t", size, align))
                .append(name).append("\t");

        final int displayLimit = 5;
        var fieldStrings = obj.getInitializedFields().stream().sorted().limit(displayLimit)
                        .map(field -> String.format("%s: %s", field, obj.getInitialValue(field)));
        fieldStrings = obj.getInitializedFields().size() > displayLimit ? Stream.concat(fieldStrings, Stream.of("...")) : fieldStrings;
        result.append(fieldStrings.collect(Collectors.joining(", ", "{ ", " }")));
    }


    private boolean showMemoryObject(MemoryObject obj){
        return showDynamicAllocations || obj.isStaticallyAllocated();
    }

    // -------------------------------------------------------------------------------------------
    // Functions & Threads

    private void appendMainBody(Program program, StringBuilder result) {
        if (mode.includesThreads()) {
            for (Thread thread : program.getThreads()) {
                if (showThread(thread)) {
                    appendFunction(thread, result);
                }
            }

            if (!showInitThreads && !program.getThreads().isEmpty()) {
                result.append("\n... omitted init threads ...\n");
            }
        }

        if (mode.includesFunctions()) {
            for (Function function : program.getFunctions()) {
                if (function instanceof Thread) {
                    continue;
                }
                appendFunction(function, result);
            }
        }
    }

    private void appendFunction(Function func, StringBuilder result) {
        result.append("\n[").append(func.getId()).append("]");
        result.append(func instanceof Thread ? " thread " : " function ");
        result.append(functionSignatureToString(func));
        if (func instanceof Thread t && t.hasScope()) {
           result.append(" ").append(t.getScopeHierarchy());
        }
        if (func.getProgram().getEntrypoint().getEntryFunctions().contains(func)) {
            result.append(" #Entrypoint");
        }
        result.append("\n");
        for (Event e : func.getEvents()) {
            if (showEvent(e)) {
                appendEvent(e, result);
            }
        }
    }

    private boolean showThread(Thread thread){
        return showInitThreads || !IRHelper.isInitThread(thread);
    }

    private void appendEvent(Event event, StringBuilder result){
        final StringBuilder idSb = new StringBuilder()
                .append(event.getGlobalId()).append(":");
        result.append(idSb);
        if(!(event instanceof Label)) {
            result.append("   ");
        }

        final String paddingBase = "      ";
        if (idSb.length() < paddingBase.length()) {
            result.append(paddingBase, idSb.length(), paddingBase.length());
        }
        result.append(event).append("\n");
    }

    private boolean showEvent(Event event) {
        return (showAnnotationEvents || !(event instanceof CodeAnnotation));
    }

    // -------------------------------------------------------------------------------------------
    // Specification

    private static void appendSpecification(Program program, StringBuilder result) {
        final ExpressionPrinter expressionPrinter = new ExpressionPrinter(true);

        if (program.getSpecification() != null) {
            result.append("\nSpecification:\n")
                    .append(program.getSpecificationType()).append(" ")
                    .append(program.getSpecification().accept(expressionPrinter))
                    .append("\n");
        }

        if (!(program.getFilterSpecification() instanceof BoolLiteral c && c.getValue())) {
            result.append("\nFilter specification:\n")
                    .append(program.getFilterSpecification().accept(expressionPrinter));
        }
    }

    // ------------------------------------------------------------------------

    private String functionSignatureToString(Function func) {
        final String prefix = func.getFunctionType().getReturnType() + " " + func.getName() + "(";
        final String suffix = func.getFunctionType().isVarArgs() ? ", ...)": ")";
        return func.getParameterRegisters().stream().map(r -> r.getType() + " " + r.getName())
                .collect(Collectors.joining(", ", prefix, suffix));
    }

}
