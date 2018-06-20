package porthosc.memorymodels.wmm;


public class MemoryModel {

    public enum Kind {
        SC,
        TSO,
        PSO,
        RMO,
        Alpha,
        Power,
        ARM,
        ;

        public static Kind parse(String value) {
            switch (value.toLowerCase()) {
                case "sc":
                    return Kind.SC;
                case "tso":
                    return Kind.TSO;
                case "pso":
                    return Kind.PSO;
                case "rmo":
                    return Kind.RMO;
                case "alpha":
                    return Kind.Alpha;
                case "power":
                    return Kind.Power;
                case "arm":
                    return Kind.ARM;
                default:
                    return null;
            }
        }

        public boolean is(Kind other) {
            return this == other;
        }

    }
}
