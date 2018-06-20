package porthosc.app;

import com.beust.jcommander.ParameterException;
import porthosc.app.errors.AppError;
import porthosc.app.modules.AppModule;
import porthosc.app.modules.AppVerdict;
import porthosc.app.modules.IAppVerdictStringifier;
import porthosc.app.modules.JsonVerdictStringifier;
import porthosc.app.options.AppOptions;


public abstract class AppBase {

    protected static <T extends AppOptions> T parseOptions(String[] args, T options) {
        try {
            options.parse(args);
            if (options.help) {
                System.out.println(options.getUsageString());
                System.exit(0);
            }
            return options;
        } catch (ParameterException e) {
            // TODO: log
            System.out.println(e.getMessage() + "\n");
            System.out.println(options.getUsageString());
        }
        return null;
    }

    protected static void start(AppModule module) {
        IAppVerdictStringifier stringifier = new JsonVerdictStringifier();
        AppVerdict verdict = module.run();
        if (verdict.hasErrors()) {
            for (AppError error : verdict.getErrors()) {
                // todo: log error:
                System.out.println(error.getMessage());
                // todo: log info:
                System.out.println(error.getAdditionalMessage());
                System.out.println("");
            }
            System.exit(1);
        }
        System.out.println(stringifier.stringify(verdict));
    }
}
