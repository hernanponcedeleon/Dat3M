package porthosc.app.errors;

public class ProgramParsingError extends AppError {
    ProgramParsingError(Severity severity, String message) {
        super(severity, message);
    }
}
