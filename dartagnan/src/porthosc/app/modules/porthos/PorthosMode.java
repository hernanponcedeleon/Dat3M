package porthosc.app.modules.porthos;

public enum PorthosMode {
    StateInclusion,
    ExecutionInslusion,
    ;

    public static PorthosMode parse(String value) {
        switch (value.toLowerCase()) {
            case "s":
            case "state":
            case "stateinclusion":
                return PorthosMode.StateInclusion;

            case "e":
            case "execution":
            case "executioninclusion":
                return PorthosMode.ExecutionInslusion;

            default:
                return null;
        }
    }
}
