package porthosc.utils.exceptions;

public class NotSupportedException extends IllegalStateException {

    public NotSupportedException(String notSupportedTarget) {
        super("Not supported: " + notSupportedTarget);
    }
}
