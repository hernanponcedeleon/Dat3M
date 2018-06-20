package porthosc.languages.syntax.xgraph.visitors;

public class XVisitorIllegalStateException extends RuntimeException {

    XVisitorIllegalStateException() {
    }

    XVisitorIllegalStateException(String message) {
        super(message);
    }

    XVisitorIllegalStateException(String message, Throwable cause) {
        super(message, cause);
    }

    XVisitorIllegalStateException(Throwable cause) {
        super(cause);
    }
}
