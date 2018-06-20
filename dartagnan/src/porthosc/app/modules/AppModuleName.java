package porthosc.app.modules;

public enum AppModuleName {
    Porthos,   // Portability analysis
    Dartagnan, // Reachability analysis
    Aramis,    // Memory model generation
    ;

    public static AppModuleName parse(String value) {
        switch (value.toLowerCase()) {
            case "porthos":
                return AppModuleName.Porthos;
            case "dartagnan":
                return AppModuleName.Dartagnan;
            case "aramis":
                return AppModuleName.Aramis;
            default:
                return null;
        }
    }
}
