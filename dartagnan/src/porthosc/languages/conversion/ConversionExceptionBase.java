package porthosc.languages.conversion;

public abstract class ConversionExceptionBase extends RuntimeException {

    public ConversionExceptionBase() {
    }

    public ConversionExceptionBase(String message) {
        super(message);
    }
}
