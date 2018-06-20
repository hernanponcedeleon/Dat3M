package porthosc.app.options;


import com.beust.jcommander.JCommander;
import com.beust.jcommander.Parameter;
import com.beust.jcommander.Parameters;
import com.beust.jcommander.converters.IntegerConverter;
import porthosc.app.AppBase;
import porthosc.app.options.converters.LogLevelConverter;
import porthosc.app.options.validators.LogLevelValidator;
import porthosc.utils.logging.LogLevel;


@Parameters(separators = " =")
public abstract class AppOptions {

    @Parameter(names = {"-b", "--bound"},
            converter = IntegerConverter.class)
    public int unrollingBound = 20;

    @Parameter(names = {"-log", "--log"},
            converter = LogLevelConverter.class,
            validateValueWith = LogLevelValidator.class)
    public transient LogLevel logLevel;

    @Parameter(names = {"-h", "-?", "--help"},
            descriptionKey = "Print help message",
            help = true)
    public transient boolean help;

    //@YFunctionParameter(names = {"-m", "--module"},
    //        required = true,
    //        arity = 1,
    //        description = "module name",
    //        converter = AppModuleConverter.class,
    //        validateValueWith = AppModuleValidator.class)
    //public AppModuleName moduleName;

    public void parse(String[] args) {
        JCommander.newBuilder().addObject(this).build().parse(args);
    }

    public String getUsageString() {
        JCommander jCommander = new JCommander(this);
        jCommander.setProgramName(AppBase.class.getName());
        StringBuilder builder = new StringBuilder();
        jCommander.usage(builder);
        return builder.toString();
    }
}
