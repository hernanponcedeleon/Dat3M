package com.dat3m.dartagnan.utils.options;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.witness.WitnessType;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.OptionNames.*;

@Options
public abstract class BaseOptions {

    @Option(
            name = PROPERTY,
            description = "A combination of properties to check for: program_spec, termination, cat_spec (defaults to all).",
            toUppercase = true)
    private EnumSet<Property> property = Property.getDefault();

    public EnumSet<Property> getProperty() {
        return property;
    }

    @Option(
            name = PROGRESSMODEL,
            description = """
                        The progress model to assume: fair (default), hsa, obe, unfair.
                        To specify progress models per scope, use [<scope>=<progressModel>,...].
                        Defaults to "fair" for unspecified scopes unless "default=<progressModel>" is specified.
                        """,
            toUppercase = true)
    private ProgressModel.Hierarchy progressModel = ProgressModel.defaultHierarchy();

    public ProgressModel.Hierarchy getProgressModel() {
        return this.progressModel;
    }

    @Option(
            name = VALIDATE,
            description = "Performs violation witness validation. Argument is the path to the witness file.")
    private String witnessPath;

    public boolean runValidator() {
        return witnessPath != null;
    }

    public String getWitnessPath() {
        return witnessPath;
    }

    @Option(
            name = METHOD,
            description = "Solver method to be used.",
            toUppercase = true)
    private Method method = Method.getDefault();

    public Method getMethod() {
        return method;
    }


    @Option(
            name = WITNESS,
            description = "Type of the violation graph to generate in the output directory.")
    private WitnessType witnessType = WitnessType.getDefault();

    public WitnessType getWitnessType() {
        return witnessType;
    }

    @Option(
            name = CAT_INCLUDE,
            description = "The directory used to resolve cat include statements. Defaults to $DAT3M_HOME/cat."
    )
    private String catIncludePath = GlobalSettings.getCatDirectory();

    public String getCatIncludePath() {
        return catIncludePath;
    }

    @Option(
            name = ENTRY,
            description = "Name of the entry point function."
    )
    private String entry_function = "";

    public String getEntryFunction() {
        return entry_function;
    }

    public boolean overrideEntryFunction() {
        return !entry_function.isEmpty();
    }

}