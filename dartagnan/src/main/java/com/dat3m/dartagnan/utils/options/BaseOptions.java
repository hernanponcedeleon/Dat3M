package com.dat3m.dartagnan.utils.options;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.witness.WitnessType;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

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
            name = SOLVER,
            description = "Uses the specified SMT solver as a backend.",
            toUppercase = true)
    private Solvers solver = Solvers.Z3;

    public Solvers getSolver() {
        return solver;
    }

    @Option(
            name = TIMEOUT,
            description = "Timeout (in secs) before interrupting the SMT solver.")
    private int timeout = 0;

    public boolean hasTimeout() {
        return timeout > 0;
    }

    public int getTimeout() {
        return timeout;
    }

    @Option(
            name = PHANTOM_REFERENCES,
            description = "Decrease references on Z3 formula objects once they are no longer referenced.")
    private boolean phantomReferences = true;

    public boolean usePhantomReferences() {
        return phantomReferences;
    }

    @Option(
            name = WITNESS,
            description = "Type of the violation graph to generate in the output directory.")
    private WitnessType witnessType = WitnessType.getDefault();

    public WitnessType getWitnessType() {
        return witnessType;
    }

    @Option(
            name = SMTLIB2,
            description = "Dump encoding to an SMTLIB2 file.")
    private boolean smtlib = false;

    public boolean getDumpSmtLib() {
        return smtlib;
    }

    @Option(
            name = CAT_INCLUDE,
            description = "The directory used to resolve cat include statements. Defaults to $DAT3M_HOME/cat."
    )
    private String catIncludePath = GlobalSettings.getCatDirectory();

    public String getCatIncludePath() {
        return catIncludePath;
    }

}