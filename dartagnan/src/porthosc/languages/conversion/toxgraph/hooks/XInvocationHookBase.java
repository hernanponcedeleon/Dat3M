package porthosc.languages.conversion.toxgraph.hooks;

import porthosc.languages.conversion.toxgraph.interpretation.XProgramInterpreter;


public abstract class XInvocationHookBase implements XInvocationHook {
    protected final XProgramInterpreter program;

    public XInvocationHookBase(XProgramInterpreter program) {
        this.program = program;
    }
}
