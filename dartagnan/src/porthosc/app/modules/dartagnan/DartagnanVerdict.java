package porthosc.app.modules.dartagnan;

import porthosc.app.modules.AppVerdict;
import porthosc.app.options.AppOptions;


public class DartagnanVerdict extends AppVerdict {
    public enum Status {
        Reachable,
        NonReachable,
    }

    public Status result;

    public DartagnanVerdict(AppOptions options) {
        super(options);
    }
}
