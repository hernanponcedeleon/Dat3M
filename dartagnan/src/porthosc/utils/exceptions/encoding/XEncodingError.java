package porthosc.utils.exceptions.encoding;

public class XEncodingError extends RuntimeException {

    public XEncodingError() {
    }

    public XEncodingError(String message) {
        super(message);
    }

    public XEncodingError(String message, Throwable cause) {
        super(message, cause);
    }

    public XEncodingError(Throwable cause) {
        super(cause);
    }
}
