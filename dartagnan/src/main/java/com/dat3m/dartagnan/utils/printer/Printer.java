package com.dat3m.dartagnan.utils.printer;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Skip;

import java.util.stream.Collectors;

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
        result.append(name).append("\n");

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
        result.append(functionSignatureToString(func)).append("\n");
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
            result.append(padding, idSb.length(), padding.length());
            result.append(event).append("\n");
        }
    }

    private boolean isAuxiliary(Event event){
        return event instanceof Skip;
    }
}
