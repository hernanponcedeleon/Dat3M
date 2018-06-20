package porthosc.utils.exceptions.xgraph;


public class XUndeclaredMemoryUnitError extends XInterpretationError {

    public XUndeclaredMemoryUnitError(String memoryUnitName) {
        super("Attempt to access an unregistered memory unit: " + memoryUnitName);
    }
}
