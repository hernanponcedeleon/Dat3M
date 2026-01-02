package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.event.RegReader;

import com.dat3m.dartagnan.program.event.core.threading.ThreadArgument;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.dat3m.dartagnan.expression.integers.IntSizeCast;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.*;

import java.util.*;

/*
 * Forward Interval analysis
 * Computes the intervals of registers in the program.
 * We assume that the program has been fully processed and contains no loops and functions are inlined.
 * Work list based algorithm based on:
 * Static Program Analysis.
 * Authors: Anders Møller and Michael I. Schwartzbach.
 * Chapter 5.10
 * Page 77
 * An interval is of the form [lb,ub] where a variable can take any possible value between (including) lb and ub.
 */
public abstract class IntervalAnalysisWorklist implements IntervalAnalysis {

    // Associate an event with a map of registers to intervals
    protected Map<Event,Map<Register,Interval>> eventStates = new HashMap<>();
    private final Program program;
    static Logger logger = LogManager.getLogger(IntervalAnalysis.class);
    private static final Set<Object> unsupportedExpressions = new HashSet<>();


    protected IntervalAnalysisWorklist(Program program) {
        this.program = program;
    }


    @Override
    public Interval getIntervalAt(Event event, Register r) throws RuntimeException {
        if (r.getType() instanceof IntegerType itype){
            if (eventStates.containsKey(event)){
                Map<Register,Interval> registerStates = eventStates.get(event);
                if(registerStates.containsKey(r)) {
                    return registerStates.get(r);
                } else {
                    if(logger.isWarnEnabled()) {
                        logger.warn("No interval found at event {} for register {}. Defaulting to top interval", event.toString(),r.getName());
                    }
                    return Interval.getTop(itype);
                }
            } else throw new EventNotFoundException(event);
        } else throw new InvalidRegisterTypeException(r.getType());
    }


    // Helper class to carry information about a register and its computed interval.

    static protected class RegisterState {
        public Register reg;
        public Interval interval;

        public RegisterState(Register reg, Interval interval) {
            this.reg = reg;
            this.interval = interval;
        }

        @Override
        public String toString() {
            return "RegisterState{" +
            "reg=" + reg +
            ", interval=" + interval +
            '}';
        }
    }



    // Analyse an event to calculate an interval for a register (i.e. the transfer function).
    // TODO: Maybe use the event visitor
    RegisterState analyseEvent(Event e, Map<Register,Interval> eventState) {
        if (e instanceof RegWriter rw) {
            if ((rw.getResultRegister().getType() instanceof IntegerType)) {
                if (rw instanceof Local lc) {
                    return analyseLocal(lc,eventState);
                } else if (rw instanceof Load ld) {
                    return analyseLoad(ld,eventState);
                } else if (rw instanceof ThreadArgument ta) {
                    return analyseThreadArgument(ta,eventState);
                } else {
                    return analyseOther(rw);
                }
            }
        }
        return null;
    }

    // Transfer functions to be implemented by subclasses
    protected abstract RegisterState analyseLoad(Load l, Map<Register,Interval> eventState);

    protected RegisterState analyseLocal(Local l, Map<Register,Interval> eventState) {
        Register result = l.getResultRegister();
        Expression expr = l.getExpr();
        return new RegisterState(result, new AbstractExpressionEvaluator((IntegerType) result.getType(),expr,eventState).getResultInterval());
    }

    protected RegisterState analyseThreadArgument(ThreadArgument ta, Map<Register,Interval> eventState) {
        Expression arg = ta.getCreator().getArguments().get(ta.getIndex());
        Register result = ta.getResultRegister();
        return new RegisterState(result, new AbstractExpressionEvaluator((IntegerType) result.getType(), arg, eventState).getResultInterval());
    }

    protected RegisterState analyseOther(RegWriter other) {
        Register reg = other.getResultRegister();
        return new RegisterState(reg, Interval.getTop((IntegerType) reg.getType()));
    }

    // ============= Worklist Algorithm =============

    // Compute intervals using a fixed point iteration.
    // Local analysis should only require one iteration
    // Global analysis may require multiple
    // TODO: Maybe this is too naive?
    protected void computeIntervals(Program program) {
        Map<Event,Map<Register,Interval>> prevEventStates;
        do {
            prevEventStates = new HashMap<>(eventStates);
            for(Thread thread : program.getThreads()) {
                if(!(thread.getEntry().getSuccessor() instanceof Init)) {
                    computeIntervals(thread);
                }
            }

        } while (!prevEventStates.equals(eventStates));

        if (!unsupportedExpressions.isEmpty() && logger.isWarnEnabled()) {
            logger.warn("Unsupported expressions found: {}",unsupportedExpressions);
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
        while(!flowList.isEmpty()) {
            Event current = flowList.remove();
            Map<Register,Interval> currentEventState = eventStates.get(current);
            // Deal with potential register reads that were not encountered previously.
            if (current instanceof RegReader rr) {
                Set<Register.Read> reads = rr.getRegisterReads();
                for(Register.Read read : reads) {
                    Register r = read.register();
                    if(!currentEventState.containsKey(r) && r.getType() instanceof IntegerType itype) {
                        currentEventState.put(r, Interval.getTop(itype));
                    }

                }
            }
            // Event State of the successor node
            // Modified state based on new information from the current node.
            Map<Register,Interval> currentEventStateCopy = new HashMap<>(eventStates.get(current));
           // Apply transfer function
            RegisterState state = analyseEvent(current, currentEventStateCopy);
            if (state != null) {
                currentEventStateCopy.put(state.reg,state.interval);
            }

            // Propagate information
            if (current instanceof CondJump cj) {
                Label l = cj.getLabel();
                Map<Register,Interval> labelState = eventStates.getOrDefault(l,new HashMap<>());
                // Unconditional jump
                if(cj.isGoto()) {
                    eventStates.put(l, joinStates(currentEventStateCopy,labelState));
                } else {
                    // Conditional jump can take two paths
                    Event successor = cj.getSuccessor();
                    Map<Register,Interval> successorState = eventStates.getOrDefault(successor,new HashMap<>());
                    eventStates.put(l, joinStates(currentEventStateCopy,labelState));
                    eventStates.put(successor, joinStates(currentEventStateCopy,successorState));
                }
            } else {
                Event successor = current.getSuccessor();
                if(successor != null) {
                    Map<Register,Interval> successorState = eventStates.getOrDefault(successor,new HashMap<>());
                    eventStates.put(successor, joinStates(currentEventStateCopy,successorState));
                }
            }

        }

    }



    protected static final class AbstractExpressionEvaluator implements ExpressionVisitor<Interval> {
        private final Map<Register,Interval> eventState;
        private final Interval resultInterval;
        private final IntegerType type;
        public Interval getResultInterval() {
            return resultInterval;
        }
        AbstractExpressionEvaluator(IntegerType type, Expression expr, Map<Register,Interval> eventState) {
            this.eventState = eventState;
            this.type = type;
            resultInterval = expr.accept(this);
        }

        @Override
        public Interval visitExpression(Expression expr) {
            return Interval.getTop(type);
        }

        @Override
        public Interval visitIntLiteral(IntLiteral lit) {
            return Interval.makeSingleton(lit.getValue(),type);
        }

        @Override
        public Interval visitRegister(Register regExpr) {
            return eventState.getOrDefault(regExpr, Interval.getTop(type));
        }

        @Override
        public Interval visitIntSizeCastExpression(IntSizeCast cast) {
            Interval operandInterval = cast.getOperand().accept(this);
            IntegerType targetType = cast.getTargetType();
            if(!cast.preservesSign() && cast.isExtension()) {
                return Interval.getTop(targetType);
            } else {
                // Interval constructor to return top with eventual overflow regarding truncation.
                return new Interval(operandInterval.getLowerbound(),operandInterval.getUpperbound(),targetType);
            }
        }

        @Override
        public Interval visitIntBinaryExpression(IntBinaryExpr binExpr) {
            IntBinaryOp op = binExpr.getKind();
            Interval intervalLeft = binExpr.getLeft().accept(this);
            Interval intervalRight = binExpr.getRight().accept(this);
            return intervalLeft.applyOperator(op,intervalRight,type);
        }

        @Override
        public Interval visitITEExpression(ITEExpr ite) {
            Interval trueInterval = ite.getTrueCase().accept(this);
            Interval falseInterval = ite.getFalseCase().accept(this);
            return trueInterval.join(falseInterval);
        }
    }



    private Map<Register, Interval> joinStates(Map<Register, Interval> s1, Map<Register, Interval> s2) {
        Map<Register,Interval> lessIntervals = (s1.size() <= s2.size()) ?
        new HashMap<>(s1) :
        new HashMap<>(s2);
        Map<Register,Interval> moreIntervals = (s1.size() > s2.size()) ?
        new HashMap<>(s1) :
        new HashMap<>(s2);
        for(var pair : lessIntervals.entrySet()) {
            Register key = pair.getKey();
            if(moreIntervals.containsKey(key)) {
                // Join same registers
                lessIntervals.replace(key,pair.getValue().join(moreIntervals.get(key)));
                moreIntervals.remove(key);
            }
        }
        // Add remaining registers
        lessIntervals.putAll(moreIntervals);
        return lessIntervals;
    }


    // For debugging
    @SuppressWarnings("unused")
    private void logIntervals() {
        for(Thread t : program.getThreads()) {
            String header = String.format("Intervals of thread: %s\n", t.getName());
            System.out.println(header);
            System.out.println("===================================\n");
            for (Event e : t.getEvents()) {
                Map<Register,Interval> eventState = eventStates.get(e);
                String eventFormat = String.format("%d %s=%s\n",e.getGlobalId(),e,eventState);
                System.out.println(eventFormat);
            }
            System.out.println("===================================\n");
        }
    }

}
