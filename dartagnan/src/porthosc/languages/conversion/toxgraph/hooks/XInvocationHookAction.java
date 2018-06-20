package porthosc.languages.conversion.toxgraph.hooks;

import porthosc.languages.syntax.xgraph.XEntity;
import porthosc.languages.syntax.xgraph.memories.XMemoryUnit;

import java.util.function.BiFunction;


public class XInvocationHookAction {

    // TODO: remove receiver and from signature
    private final BiFunction<XMemoryUnit, XMemoryUnit[], ? extends XEntity> action;

    XInvocationHookAction(BiFunction<XMemoryUnit, XMemoryUnit[], ? extends XEntity> action) {
        this.action = action;
    }

    public XEntity execute(XMemoryUnit receiver, XMemoryUnit... arguments) {
        return action.apply(receiver, arguments);
    }
}
