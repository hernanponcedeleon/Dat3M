package porthosc.app.errors;

import porthosc.utils.StringUtils;
import porthosc.utils.exceptions.ExceptionUtils;


public abstract class AppError {
    public enum  Severity {
        Critical,
        NonCritical,
    }

    private final Severity severity;
    private final String message;
    private final String additionalInfo;

    AppError(Severity severity, String message, String additionalInfo) {
        this.severity = severity;
        this.message = getClass().getName() + ": " + StringUtils.nonNull(message);
        this.additionalInfo = StringUtils.nonNull(additionalInfo);
    }

    AppError(Severity severity, Exception e) {
        this.severity = severity;
        this.message = StringUtils.nonNull(e.getMessage());
        this.additionalInfo = ExceptionUtils.getStackTrace(e);
    }

    AppError(Severity severity, String message) {
        this(severity, message, "");
    }

    public Severity getSeverity() {
        return severity;
    }

    public String getMessage() {
        return message;
    }

    public String getAdditionalMessage() {
        return additionalInfo;
    }

    @Override
    public String toString() {
        return "AppError: " + getSeverity() + ": " + getMessage() + "\n" + getAdditionalMessage();
    }
}
