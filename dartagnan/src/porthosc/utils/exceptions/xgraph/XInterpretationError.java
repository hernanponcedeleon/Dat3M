package porthosc.utils.exceptions.xgraph;

public class XInterpretationError extends RuntimeException {

    public XInterpretationError() {
    }

    // TODO: pass the process id here
    public XInterpretationError(String message) {
        super(message);
    }

    public XInterpretationError(String message, Throwable cause) {
        super(message, cause);
    }

    public XInterpretationError(Throwable cause) {
        super(cause);
    }
}
