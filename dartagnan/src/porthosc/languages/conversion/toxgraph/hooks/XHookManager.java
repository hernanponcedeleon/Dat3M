package porthosc.languages.conversion.toxgraph.hooks;

import com.google.common.collect.ImmutableSet;
import porthosc.languages.conversion.toxgraph.interpretation.XProgramInterpreter;

import java.util.HashSet;


public class XHookManager implements XInvocationHook {

    private final ImmutableSet<XInvocationHook> registeredHooks;

    // TODO: accept the settings structure as argument for DISABLING unnecessary type processors (without doing this, may be unwanted errors)
    public XHookManager(XProgramInterpreter program) {
        this.registeredHooks = ImmutableSet.copyOf(
                new HashSet<XInvocationHook>() {{
                    add(new XLegacyInvocationHook(program));
                    add(new XKernelInvocationHook(program));
                }});
    }

    @Override
    public XInvocationHookAction tryInterceptInvocation(String methodName) {
        for (XInvocationHook hook : registeredHooks) {
            XInvocationHookAction result = hook.tryInterceptInvocation(methodName);
            if (result != null) {
                return result;
            }
        }
        return null;
    }
}
