package porthosc.utils.exceptions;

public class ArgumentNullException extends IllegalArgumentException {

    public ArgumentNullException() {
        this("?"); // TODO: more informative message
    }

    public ArgumentNullException(String argumentName) {
        super("Argument " + argumentName + " must have non-null value.");
    }
}
