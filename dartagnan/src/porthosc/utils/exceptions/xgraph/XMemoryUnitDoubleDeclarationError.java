package porthosc.utils.exceptions.xgraph;


public class XMemoryUnitDoubleDeclarationError extends XInterpretationError {

    public XMemoryUnitDoubleDeclarationError(String memoryUnitName, boolean isLocal) {
        super("Duplicating declaration of " + (isLocal ? "local" : "shared") + " memoryevents unit: " + memoryUnitName);
    }
}
