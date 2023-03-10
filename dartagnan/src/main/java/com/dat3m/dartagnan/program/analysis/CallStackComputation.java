package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.annotations.FunCall;
import com.dat3m.dartagnan.program.event.core.annotations.FunRet;

import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Stack;

public class CallStackComputation {

    private Map<Event, Stack<FunCall>> callStackMapping = new HashMap<>();

    private CallStackComputation() {
    }

    public static CallStackComputation fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    public static CallStackComputation newInstance() {
        return new CallStackComputation();
    }

    public Map<Event, Stack<FunCall>> getCallStackMapping() {
        return callStackMapping;
    }

    public void run(Program program) {

        for (Thread thread : program.getThreads()) {
            Stack<FunCall> callStack = new Stack<>();
            Event current = thread.getEntry();
            while (current != null) {
                if (current instanceof FunCall) {
                    FunCall call = (FunCall) current;
                    callStack.push(call);
                }
                if (current instanceof FunRet) {
                    callStack.pop();
                }
                if ((current instanceof MemEvent || current.is(Tag.ASSERTION) || current.is(Tag.SPINLOOP))
                        && !callStack.isEmpty()) {
                    Stack<FunCall> newStack = new Stack<>();
                    newStack.addAll(callStack);
                    callStackMapping.put(current, newStack);
                }
                current = current.getSuccessor();
            }
        }
    }

    public String getStackAsString(Event e, String callsSeparator) {
        StringBuilder strB = new StringBuilder();
        Iterator<FunCall> it = callStackMapping.get(e).iterator();
        while (it.hasNext()) {
            FunCall next = it.next();
            strB.append(String.format("%s (%s#%s)", next.getFunctionName(), next.getSourceCodeFileName(), next.getCLine()));
            if (it.hasNext()) {
                strB.append(" -> " + callsSeparator);
            }
        }
        return strB.toString();
    }
}