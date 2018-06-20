package porthosc.languages.conversion.toxgraph.hooks;

import porthosc.languages.conversion.toxgraph.interpretation.XProgramInterpreter;
import porthosc.languages.syntax.xgraph.memories.*;
import porthosc.utils.exceptions.NotImplementedException;
import porthosc.utils.exceptions.xgraph.XMethodInvocationError;

import static porthosc.utils.StringUtils.wrap;


class XKernelInvocationHook
        extends XInvocationHookBase
        implements XInvocationHook {

    XKernelInvocationHook(XProgramInterpreter program) {
        super(program);
    }

    @Override
    public XInvocationHookAction tryInterceptInvocation(String methodName) {
        switch (methodName) {
            case "WRITE_ONCE": {
                return new XInvocationHookAction((receiver, arguments) -> {
                    if (arguments.length != 2) {
                        return null;
                    }

                    XMemoryUnit destinationUnit = arguments[0];
                    if (!(destinationUnit instanceof XSharedLvalueMemoryUnit)) {
                        throw new XMethodInvocationError(methodName, "1st argument: expected to be a shared l-value variable, received: " + wrap(destinationUnit));
                    }
                    XSharedLvalueMemoryUnit destination = (XSharedLvalueMemoryUnit) destinationUnit;

                    XMemoryUnit sourceUnit = arguments[1];
                    if (!(sourceUnit instanceof XLocalMemoryUnit)) {
                        throw new XMethodInvocationError(methodName, "1st argument: expected to be a local memory unit, received: " + wrap(sourceUnit));
                    }
                    XLocalMemoryUnit source = (XLocalMemoryUnit) sourceUnit;

                    return program.emitMemoryEvent(destination, source);
                });
            }
            case "READ_ONCE":  {
                return new XInvocationHookAction((receiver, arguments) -> {
                    if (arguments.length != 1) {
                        return null;
                    }
                    XMemoryUnit sourceUnit = arguments[0];

                    if (!(sourceUnit instanceof XSharedMemoryUnit)) {
                        throw new XMethodInvocationError(methodName, "1st argument: expected to be a shared memory unit, received: " + wrap(sourceUnit));
                    }
                    XSharedMemoryUnit source = (XSharedMemoryUnit) sourceUnit;

                    XRegister tempReg = program.getMemoryManager().declareTempRegister(source.getType());
                    program.emitMemoryEvent(tempReg, source);

                    return tempReg;
                });
            }
            case "rcu_read_lock":
                throw new NotImplementedException();
            case "rcu_read_unlock":
                throw new NotImplementedException();
            case "synchronize_rcu":
                throw new NotImplementedException();
            default:
                return null;
        }
    }
}
