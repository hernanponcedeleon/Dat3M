package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.annotations.FunCallMarker;
import com.dat3m.dartagnan.program.event.core.annotations.FunReturnMarker;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Iterables;

import java.util.HashMap;
import java.util.List;
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

    // ============================================================================
    // ============================== Helper classes ==============================
    // ============================================================================

    // ---------------------------------- Contexts --------------------------------
    /*
        Contexts represent information surrounding an event like the executing thread, the call stack
        and the iteration numbers of loops.
     */
    public interface Context { }

    public static class ThreadContext implements Context {
        private final Thread thread;

        private ThreadContext(Thread thread) { this.thread = thread; }

        public Thread getThread() { return this.thread; }

        @Override
        public String toString() {
            return String.format("T%d:%s", thread.getId(), thread.getName());
        }
    }

    public static class LoopContext implements Context {
        private final Event loopMarker;
        private final int iterationNumber;

        private LoopContext(Event loopMarker, int loopIteration) {
            this.loopMarker = loopMarker;
            this.iterationNumber = loopIteration;
        }

        public Event getLoopMarker() { return this.loopMarker; }
        public int getIterationNumber() { return this.iterationNumber; }

        @Override
        public String toString() {
            return String.format("Iter#%d %s", iterationNumber, getSourceLocationString(loopMarker));
        }
    }

    public static class CallContext implements Context {
        private final FunCallMarker funCallMarker;

        private CallContext(FunCallMarker funCallMarker) { this.funCallMarker = funCallMarker; }

        public FunCallMarker getFunctionCall() { return this.funCallMarker; }

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

        public Event getEvent() { return this.event; }
        public ImmutableList<Context> getContextStack() { return this.contextStack; }
        public boolean hasContext() { return !contextStack.isEmpty(); }

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

    // We use this enum to track loop nesting
    private enum LoopMarkerTypes { START, INC, END }

    // ============================================================================

    private final Map<Event, Info> infoMap = new HashMap<>();

    public Info getContextInfo(Event ev) {
        Info retVal = infoMap.get(ev);
        if (retVal == null) {
            retVal = new Info(ev, ImmutableList.of());
        }
        return retVal;
    }

    private SyntacticContextAnalysis() {}

    public static SyntacticContextAnalysis newInstance(Program program) {
        final SyntacticContextAnalysis analysis = new SyntacticContextAnalysis();
        analysis.run(program);
        return analysis;
    }

    public static SyntacticContextAnalysis getEmptyInstance() {
        return new SyntacticContextAnalysis();
    }

    // ============================================================================
    // ============================== Analysis logic ==============================
    // ============================================================================

    private void run(Program program) {
        final LoopAnalysis loopAnalysis = LoopAnalysis.newInstance(program);
        program.getThreads().forEach(thread -> this.run(thread, loopAnalysis));
    }

    private void run(Thread thread, LoopAnalysis loops) {
        final Map<Event, LoopMarkerTypes> loopMarkerTypesMap = getLoopMarkerTypesMap(thread, loops);

        Stack<Context> curContextStack = new Stack<>();
        curContextStack.push(new ThreadContext(thread));
        for (Event ev : thread.getEvents()) {

            final ImmutableList<Context> copyOfCurContextStack = ImmutableList.copyOf(curContextStack);
            infoMap.put(ev, new Info(ev, copyOfCurContextStack));
            // TODO: The above could be made more efficient by sharing unchanged context

            if (ev instanceof FunCallMarker fc) {
                curContextStack.push(new CallContext(fc));
            } else if (ev instanceof FunReturnMarker) {
                assert curContextStack.peek() instanceof CallContext;
                curContextStack.pop();
            }

            if (loopMarkerTypesMap.containsKey(ev)) {
                switch (loopMarkerTypesMap.get(ev)) {
                    case START:
                        curContextStack.push(new LoopContext(ev,1));
                        break;
                    case INC:
                        assert curContextStack.peek() instanceof LoopContext;
                        int iterNum = ((LoopContext)curContextStack.pop()).iterationNumber;
                        curContextStack.push(new LoopContext(ev, iterNum + 1));
                        break;
                    case END:
                        assert curContextStack.peek() instanceof LoopContext;
                        curContextStack.pop();
                        break;
                }
            }
        }
    }

    private Map<Event, LoopMarkerTypes> getLoopMarkerTypesMap(Thread thread, LoopAnalysis loopAnalysis) {
        final Map<Event, LoopMarkerTypes> loopMarkerTypesMap = new HashMap<>();
        for (LoopAnalysis.LoopInfo loop : loopAnalysis.getLoopsOfFunction(thread)) {
            final List<LoopAnalysis.LoopIterationInfo> iterations = loop.iterations();

            loopMarkerTypesMap.put(iterations.get(0).getIterationStart(), LoopMarkerTypes.START);
            iterations.subList(1, iterations.size())
                    .forEach(iter -> loopMarkerTypesMap.put(iter.getIterationStart(), LoopMarkerTypes.INC));
            loopMarkerTypesMap.put(iterations.get(iterations.size() - 1).getIterationEnd(), LoopMarkerTypes.END);
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
