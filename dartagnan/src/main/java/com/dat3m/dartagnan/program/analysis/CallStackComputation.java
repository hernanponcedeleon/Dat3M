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

public class CallStackComputation  {
	
	private Map<Event, String> callStackMapping = new HashMap<>(); 

    private CallStackComputation () { }

    public static CallStackComputation  fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    public static CallStackComputation  newInstance() {
        return new CallStackComputation ();
    }

	public Map<Event, String> getCallStackMapping() {
		return callStackMapping;
	}

    public void run(Program program, String callsSeparator) {

        for(Thread thread : program.getThreads()) {
			Stack<String> callStack = new Stack<>();
			Event current = thread.getEntry();
			while (current != null) {
 				if(current instanceof FunCall) {
					FunCall call = (FunCall)current;
					callStack.push(call.getFunctionName());
				}
				if(current instanceof FunRet) {
					callStack.pop();
				}
                String stack = stackToString(callStack, callsSeparator);
				if(current instanceof MemEvent && !stack.isEmpty()) {
					callStackMapping.put(current, stack);
				}
				if(current.is(Tag.ASSERTION) && !stack.isEmpty()) {
					callStackMapping.put(current, stack);
				}
				if(current.is(Tag.SPINLOOP) && !stack.isEmpty()) {
					callStackMapping.put(current, stack);
				}
				current = current.getSuccessor();
			}       
		}
    }

	private String stackToString(Stack<String> s, String callsSeparator) {
		StringBuilder strB = new StringBuilder();
		Iterator<String> it = s.iterator();
		while(it.hasNext()) {
			String next = it.next();
			strB.append(next);
			if(it.hasNext()) {
				strB.append(" -> " + callsSeparator);
			}
		}
		return strB.toString();
	}
}