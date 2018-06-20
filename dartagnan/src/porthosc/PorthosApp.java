package porthosc;

import porthosc.app.AppBase;
import porthosc.app.modules.AppModule;
import porthosc.app.modules.porthos.PorthosModule;
import porthosc.app.modules.porthos.PorthosOptions;


public class PorthosApp extends AppBase {

    public static void main(String[] args) {
        PorthosOptions options = parseOptions(args, new PorthosOptions());
        if (options == null) {
            System.exit(1);
        }

        AppModule module = new PorthosModule(options);
        start(module);
    }
}
