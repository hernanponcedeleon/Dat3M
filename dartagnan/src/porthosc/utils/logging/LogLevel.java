package porthosc.utils.logging;


public enum LogLevel {
    Debug,
    Info,
    Warn,
    Fatal,
    ;

    public static LogLevel parse(String value) {
        switch (value.toLowerCase()) {
            case "debug":
                return LogLevel.Debug;
            case "info":
                return LogLevel.Info;
            case "warn":
                return LogLevel.Warn;
            case "fatal":
                return LogLevel.Fatal;
            default:
                return null;
        }
    }

    public boolean is(LogLevel other) {
        return this == other;
    }
}
