package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.event.RegReader;

import com.dat3m.dartagnan.program.event.RegWriter;
import com.google.common.base.Preconditions;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;

import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Set;



/*
 * Forward Interval analysis
 * Computes the intervals of integer registers in the program.
 * We assume that the program has been fully processed and contains no loops and functions are inlined.
 * Work list based algorithm based on:
 * Static Program Analysis.
 * Authors: Anders Møller and Michael I. Schwartzbach.
 * Chapter 5.10
 * Page 77
 */
public abstract class IntervalAnalysisWorklist implements IntervalAnalysis {

    // Associate an event with a map of registers to intervals
    protected Map<Event, Map<Register, Interval>> eventStates = new HashMap<>();
    static Logger logger = LoggerFactory.getLogger(IntervalAnalysis.class);
    private static final Set<Expression> unsupportedExpressions = new HashSet<>();


    protected IntervalAnalysisWorklist() { }

    @Override
    public Interval getIntervalAt(Event event, Register r) {
        Type type = r.getType();
        Preconditions.checkArgument(type instanceof IntegerType, "Intervals not supported for type " + type);
        Preconditions.checkArgument(eventStates.containsKey(event), String.format("Event %s is not found", event));
        Map<Register, Interval> registerStates = eventStates.get(event);

        if (!registerStates.containsKey(r)) {
            if (logger.isWarnEnabled()) {
                logger.warn("No interval found at event {} for register {}. Defaulting to top interval", event.toString(), r.getName());
            }
            return Interval.getTop((IntegerType) type);
        }
        return registerStates.get(r);
    }

    // Factory method
    // Visitor can be overidden by subclasses to handle certain events differently.
    protected RegWriterVisitor runVisitor(Event event, Map<Register, Interval> eventState) {
            return new RegWriterVisitor(event, eventState);
    }

    // ============= Worklist Algorithm =============

    // Compute intervals using a fixed point iteration.
    // Local analysis should only require one iteration
    // Global analysis may require multiple
    protected void computeIntervals(Program program) {
        Map<Event, Map<Register, Interval>> prevEventStates;

        do {
            prevEventStates = new HashMap<>(eventStates);
            for (Thread thread : program.getThreads()) {
                if (!(thread.getEntry().getSuccessor() instanceof Init)) {
                    computeIntervals(thread);
                }
            }
        } while (!prevEventStates.equals(eventStates));

        if (!unsupportedExpressions.isEmpty() && logger.isWarnEnabled()) {
            logger.warn("Unsupported expressions found: {}", unsupportedExpressions);
        }
    }

    // Compute Intervals to single thread.
    private void computeIntervals(Function function) {
        function.getEvents().forEach(e -> eventStates.put(e, new HashMap<>()));
        Queue<Event> flowList = new LinkedList<>(function.getEvents());
        flowList.remove();
        List<Register> parameters = function.getParameterRegisters();
        Map<Register, Interval> paramRegisterStates = new HashMap<>();
        for (Register r : parameters) {
            if (r.getType() instanceof IntegerType itype) {
                paramRegisterStates.put(r, Interval.getTop(itype));
            }
        }
        eventStates.put(function.getEntry().getSuccessor(), paramRegisterStates);
        processControlFlow(flowList);
    }

    // Process the control flow of a thread.
    // Calculate new state for successor event based on state of current event.
    private void processControlFlow(Queue<Event> flowList) {
        while (!flowList.isEmpty()) {
            Event current = flowList.remove();
            Map<Register, Interval> currentEventState = eventStates.get(current);
            // Deal with potential register reads that were not encountered previously.
            if (current instanceof RegReader rr) {
                Set<Register.Read> reads = rr.getRegisterReads();
                for (Register.Read read : reads) {
                    Register r = read.register();
                    if (!currentEventState.containsKey(r) && r.getType() instanceof IntegerType itype) {
                        currentEventState.put(r, Interval.getTop(itype));
                    }
                }
            }

            // Event State of the successor node
            // Modified state based on new information from the current node
            Map<Register, Interval> currentEventStateCopy = new HashMap<>(eventStates.get(current));

           // Apply transfer function
            if (current instanceof RegWriter rw && rw.getResultRegister().getType() instanceof IntegerType) {
                RegisterState state = runVisitor(current, currentEventStateCopy).getState();
                if (state != null) {
                    currentEventStateCopy.put(state.reg(), state.interval());
                }
            }

            // Propagate information
            if (current instanceof CondJump cj) {
                Label l = cj.getLabel();
                Map<Register, Interval> labelState = eventStates.getOrDefault(l, new HashMap<>());

                // Unconditional jump
                if (cj.isGoto()) {
                    eventStates.put(l, joinStates(currentEventStateCopy, labelState));
                } else {

                    // Conditional jump can take two paths
                    Event successor = cj.getSuccessor();
                    Map<Register, Interval> successorState = eventStates.getOrDefault(successor, new HashMap<>());
                    eventStates.put(l, joinStates(currentEventStateCopy, labelState));
                    eventStates.put(successor, joinStates(currentEventStateCopy, successorState));
                }
            } else {
                Event successor = current.getSuccessor();
                if (successor != null) {
                    Map<Register, Interval> successorState = eventStates.getOrDefault(successor, new HashMap<>());
                    eventStates.put(successor, joinStates(currentEventStateCopy, successorState));
                }
            }
        }
    }

    private Map<Register, Interval> joinStates(Map<Register, Interval> s1, Map<Register, Interval> s2) {
        Map<Register, Interval> lessIntervals = (s1.size() <= s2.size())
                ? new HashMap<>(s1) : new HashMap<>(s2);
        Map<Register, Interval> moreIntervals = (s1.size() > s2.size())
                ? new HashMap<>(s1) : new HashMap<>(s2);

        for (var pair : lessIntervals.entrySet()) {
            Register key = pair.getKey();
            if (moreIntervals.containsKey(key)) {

                // Join same registers
                lessIntervals.replace(key, pair.getValue().join(moreIntervals.get(key)));
                moreIntervals.remove(key);
            }
        }

        // Add remaining registers
        lessIntervals.putAll(moreIntervals);
        return lessIntervals;
    }
}