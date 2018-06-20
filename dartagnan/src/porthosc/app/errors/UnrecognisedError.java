package porthosc.app.errors;

public class UnrecognisedError extends AppError {

    public UnrecognisedError(Severity severity, Exception e) {
        super(severity, e);
    }

    @Override
    public String toString() {
        return "Unrecognised Error: " + super.toString();
    }
}
