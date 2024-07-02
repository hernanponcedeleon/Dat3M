package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.annotations.FunCallMarker;
import com.dat3m.dartagnan.program.event.core.annotations.FunReturnMarker;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Iterables;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.HashMap;
import java.util.Map;
import java.util.Stack;
import java.util.function.Predicate;
import java.util.stream.Stream;

/*
    This analysis computes the "syntactic context" surrounding each event in the program.
    The syntactic context of an event includes the executing thread, the call stack, and the iteration numbers
    of surrounding loops.
 */
public class SyntacticContextAnalysis {

    private static final Logger logger = LogManager.getLogger(SyntacticContextAnalysis.class);

    // ============================================================================
    // ============================== Helper classes ==============================
    // ============================================================================

    // ---------------------------------- Contexts --------------------------------
    /*
        Contexts represent information surrounding an event like the executing thread, the call stack
        and the iteration numbers of loops.
     */
    public interface Context {
    }

    public record ThreadContext(Thread thread) implements Context {
        @Override
        public String toString() {
            return String.format("T%d:%s", thread.getId(), thread.getName());
        }
    }

    public record LoopContext(Event loopMarker, int iterationNumber) implements Context {
        @Override
        public String toString() {
            return String.format("Iter#%d %s", iterationNumber, getSourceLocationString(loopMarker));
        }
    }

    public record CallContext(FunCallMarker funCallMarker) implements Context {
        @Override
        public String toString() {
            return String.format("%s %s", funCallMarker.getFunctionName(), getSourceLocationString(funCallMarker));
        }
    }

    // ---------------------------------- Info --------------------------------

    /*
        This is the information object we attach to all events.
     */
    public static class Info {
        private final Event event;
        private final ImmutableList<Context> contextStack;

        private Info(Event event, ImmutableList<Context> contextStack) {
            this.event = event;
            this.contextStack = contextStack;
        }

        public Event getEvent() {
            return this.event;
        }

        public ImmutableList<Context> getContextStack() {
            return this.contextStack;
        }

        public boolean hasContext() {
            return !contextStack.isEmpty();
        }

        public <T extends Context> ImmutableList<T> getContextOfType(Class<T> contextClass) {
            final Stream<T> filteredContext = contextStack.stream()
                    .filter(contextClass::isInstance).map(contextClass::cast);
            return ImmutableList.copyOf(filteredContext::iterator);
        }

        public String getContextString(boolean skipThreadContext) {
            final Predicate<Context> filter = skipThreadContext ? (ctx -> !(ctx instanceof ThreadContext)) : (ctx -> true);
            return makeContextString(contextStack.stream().filter(filter)::iterator, " -> ");
        }

        @Override
        public String toString() {
            return String.format("%s %s%nContext: %s", event, getSourceLocationString(event),
                    getContextString(false));
        }
    }

    // ============================================================================

    private final Map<Event, Info> infoMap = new HashMap<>();

    public Info getContextInfo(Event ev) {
        Info retVal = infoMap.get(ev);
        if (retVal == null) {
            retVal = new Info(ev, ImmutableList.of());
        }
        return retVal;
    }

    private SyntacticContextAnalysis() {
    }

    public static SyntacticContextAnalysis newInstance(Program program) {
        final SyntacticContextAnalysis analysis = new SyntacticContextAnalysis();
        analysis.run(program);
        return analysis;
    }

    public static SyntacticContextAnalysis getEmptyInstance() {
        return new SyntacticContextAnalysis();
    }

    public String getSourceLocationWithContext(Event e, boolean addGlobalId) {
        final StringBuilder builder = new StringBuilder();
        final String ctx = makeContextString(this.getContextInfo(e).getContextStack(), " -> ");
        if (addGlobalId) {
            builder.append("E").append(e.getGlobalId()).append(": \t");
        }
        builder
                .append(ctx.isEmpty() ? ctx : ctx + " -> ")
                .append(getSourceLocationString(e));

        return builder.toString();
    }

    // ============================================================================
    // ============================== Analysis logic ==============================
    // ============================================================================

    private void run(Program program) {
        final LoopAnalysis loopAnalysis = LoopAnalysis.newInstance(program);
        program.getThreads().forEach(thread -> this.run(thread, loopAnalysis));
    }

    private void run(Thread thread, LoopAnalysis loops) {
        final Map<Event, LoopAnalysis.LoopIterationInfo> loopMarkerTypesMap = getLoopMarkerTypesMap(thread, loops);

        Stack<Context> curContextStack = new Stack<>();
        curContextStack.push(new ThreadContext(thread));
        for (Event ev : thread.getEvents()) {

            final ImmutableList<Context> copyOfCurContextStack = ImmutableList.copyOf(curContextStack);
            infoMap.put(ev, new Info(ev, copyOfCurContextStack));
            // TODO: The above could be made more efficient by sharing unchanged context

            if (ev instanceof FunCallMarker fc) {
                curContextStack.push(new CallContext(fc));
            } else if (ev instanceof FunReturnMarker retMarker) {
                CallContext topCallCtx;
                do {
                    // FIXME: DCE can sometimes delete the end marker of functions if those never return
                    //  (e.g., "reach_error() { abort(0); }").
                    //  Here we try to also pop those calls that have missing markers.
                    if(curContextStack.peek() instanceof CallContext) {
                        topCallCtx = (CallContext) curContextStack.pop();
                    } else {
                        logger.warn("Found a FunCallMarker without a matching FunReturnMarker. Giving up the analysis");
                        break;
                    }
                } while (!topCallCtx.funCallMarker.getFunctionName().equals(retMarker.getFunctionName()));
            }

            final LoopAnalysis.LoopIterationInfo iteration = loopMarkerTypesMap.get(ev);
            if (iteration != null) {
                final boolean start = ev == iteration.getIterationStart();
                final boolean end = ev == iteration.getIterationEnd();
                assert start || end;
                if (start) {
                    curContextStack.push(new LoopContext(ev, iteration.getIterationNumber()));
                }
                if (end) {
                    if (curContextStack.peek() instanceof LoopContext c &&
                            c.loopMarker == iteration.getIterationStart() &&
                            c.iterationNumber == iteration.getIterationNumber()) {
                        curContextStack.pop();
                    } else {
                        logger.warn("Found a IterationStart without a matching IterationEnd. Giving up the analysis");
                        break;
                    }
                }
            }
        }
    }

    private Map<Event, LoopAnalysis.LoopIterationInfo> getLoopMarkerTypesMap(Thread thread, LoopAnalysis loopAnalysis) {
        final Map<Event, LoopAnalysis.LoopIterationInfo> loopMarkerTypesMap = new HashMap<>();
        for (LoopAnalysis.LoopInfo loop : loopAnalysis.getLoopsOfFunction(thread)) {
            for (LoopAnalysis.LoopIterationInfo iteration : loop.iterations()) {
                loopMarkerTypesMap.put(iteration.getIterationStart(), iteration);
                loopMarkerTypesMap.put(iteration.getIterationEnd(), iteration);
            }
        }
        return loopMarkerTypesMap;
    }


    // ============================================================================
    // ============================== Utility methods =============================
    // ============================================================================

    public static String getSourceLocationString(Event ev) {
        SourceLocation loc = ev.getMetadata(SourceLocation.class);
        return loc != null ? String.format("@%s#%s", loc.getSourceCodeFileName(), loc.lineNumber()) : "@unknown";
    }

    public static <T extends Context> String makeContextString(Iterable<T> contextStack, String separator) {
        return String.join(separator, Iterables.transform(contextStack, Context::toString));
    }
}
