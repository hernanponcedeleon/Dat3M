package com.dat3m.dartagnan.utils.printer;

import com.dat3m.dartagnan.program.Entrypoint;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Printer {

    public enum Mode {
        THREADS,
        FUNCTIONS,
        ALL
    }

    private StringBuilder result;
    private StringBuilder padding;

    private boolean showAuxiliaryEvents = true;
    private boolean showInitThreads = false;
    private Mode mode = Mode.ALL;

    private final String paddingBase = "      ";

    public String print(Program program) {
        result = new StringBuilder();
        padding = new StringBuilder(paddingBase);

        String name = program.getName();
        if(name == null){
            name = "program";
        }
        result.append(name);
        if (!(program.getEntrypoint() instanceof Entrypoint.Resolved)) {
            result.append(" ").append(program.getEntrypoint());
        }
        result.append("\n");

        for (MemoryObject obj : program.getMemory().getObjects()) {
            if (obj.isStaticallyAllocated()) {
                appendMemoryObject(obj);
            }
        }

        result.append("\n");

        if (mode == Mode.THREADS || mode == Mode.ALL) {
            for (Thread thread : program.getThreads()) {
                if (shouldPrintThread(thread)) {
                    appendFunction(thread);
                }
            }

            if (!showInitThreads && !program.getThreads().isEmpty()) {
                result.append("\nSkipping init threads...");
                result.append("\n...");
                result.append("\n...");
                result.append("\n...");
                result.append("\n");
            }
        }

        if (mode == Mode.FUNCTIONS || mode == Mode.ALL) {
            for (Function function : program.getFunctions()) {
                if (function instanceof Thread) {
                    continue;
                }
                appendFunction(function);
            }
        }

        return result.toString();
    }

    private void appendMemoryObject(MemoryObject obj) {
        result.append("\nstatic ").append(obj.getName())
                .append(String.format(" [size=%s, align=%s] ", obj.getKnownSize(), obj.getKnownAlignment()));

        final int displayLimit = 10;
        var fieldStrings = obj.getInitializedFields().stream().sorted().limit(displayLimit)
                        .map(field -> String.format("%s: %s", field, obj.getInitialValue(field)));
        fieldStrings = obj.getInitializedFields().size() > displayLimit ? Stream.concat(fieldStrings, Stream.of("...")) : fieldStrings;
        result.append(fieldStrings.collect(Collectors.joining(", ", "{ ", " }")));
    }

    public Printer setShowAuxiliaryEvents(boolean flag) {
        this.showAuxiliaryEvents = flag;
        return this;
    }

    public Printer setShowInitThreads(boolean flag) {
        this.showInitThreads = flag;
        return this;
    }

    public Printer setMode(Mode mode) {
        this.mode = mode;
        return this;
    }

    private boolean shouldPrintThread(Thread thread){
        if(showInitThreads){
            return true;
        }
        Event firstEvent = thread.getEntry().getSuccessor();
        // Thread always have at least two events, Skip and end Label
        return firstEvent.getSuccessor() != null && !(firstEvent instanceof Init);
    }

    private void appendFunction(Function func) {
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
            appendEvent(e);
        }
    }

    public String functionSignatureToString(Function func) {
        final String prefix = func.getFunctionType().getReturnType() + " " + func.getName() + "(";
        final String suffix = func.getFunctionType().isVarArgs() ? ", ...)": ")";
        return func.getParameterRegisters().stream().map(r -> r.getType() + " " + r.getName())
                .collect(Collectors.joining(", ", prefix, suffix));
    }

    private void appendEvent(Event event){
        if(showAuxiliaryEvents || !isAuxiliary(event)){
            StringBuilder idSb = new StringBuilder();
            idSb.append(event.getGlobalId()).append(":");
            result.append(idSb);
            if(!(event instanceof Label)) {
                result.append("   ");
            }
            if (idSb.length() < padding.length()) {
                result.append(padding, idSb.length(), padding.length());
            }
            result.append(event).append("\n");
        }
    }

    private boolean isAuxiliary(Event event){
        return event instanceof Skip;
    }
}
