package porthosc;

import porthosc.app.AppBase;
import porthosc.app.modules.AppModule;
import porthosc.app.modules.dartagnan.DartagnanModule;
import porthosc.app.modules.dartagnan.DartagnanOptions;


public class DartagnanApp extends AppBase {

    public static void main(String[] args) {
        System.out.println("Hello from Dartagnan");
        DartagnanOptions options = parseOptions(args, new DartagnanOptions());
        if (options == null) {
            System.exit(1);
        }

        AppModule module = new DartagnanModule(options);
        start(module);
    }
}
