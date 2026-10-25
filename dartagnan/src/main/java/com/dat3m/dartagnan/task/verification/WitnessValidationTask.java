package com.dat3m.dartagnan.task.verification;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.SvcompWitnessEncoder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.witness.svcomp.ViolationWitness;
import com.dat3m.dartagnan.witness.svcomp.WitnessResolver;
import com.dat3m.dartagnan.witness.svcomp.WitnessYamlParser;
import com.dat3m.dartagnan.wmm.Wmm;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.ProgressModel.FAIR;
import static com.dat3m.dartagnan.configuration.ProgressModel.uniform;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Validates a violation witness: the witness is confirmed if some execution of the bounded program violates
 * the property of the task and follows the witness. Validation is divided into four steps:
 *
 * 1. Parse: {@link WitnessYamlParser} reads the witness file into a {@link ViolationWitness},
 * independently of the program.
 *
 * 2. Resolve: {@link WitnessResolver} maps each waypoint to its candidates, i.e., the events of the
 * bounded program that may satisfy it.
 *
 * 3. Encode: {@link SvcompWitnessEncoder} turns the candidates into constraints that restrict the
 * encoded executions to those that follow the witness.
 *
 * 4. Solve: {@link AssumeSolver} checks whether the property can be violated under the assumption that
 * these constraints hold. If so, the witness is confirmed. Otherwise, its second check decides whether
 * the bounds are to blame: if a bound event may execute, the result is bounded and the SV-COMP runner
 * validates again with higher bounds; if not, the witness is rejected. The second check does not assume
 * the witness, because waypoints beyond the bounds have no candidates. {@code OutputGenerator} maps
 * these results to the exit codes of the validator.
 */
public final class WitnessValidationTask extends VerificationTask {

    private final ViolationWitness witness;

    public static WitnessValidationTaskBuilder builder(ViolationWitness witness) {
        return new WitnessValidationTaskBuilder(witness);
    }

    WitnessValidationTask(Program program, Wmm memoryModel, Configuration config,
                          Property property, ViolationWitness witness)
            throws InvalidConfigurationException {
        super(program, memoryModel, uniform(FAIR), config, EnumSet.of(property));
        this.witness = checkNotNull(witness);
    }

    public ViolationWitness getWitness() {
        return witness;
    }

    /** The single property whose violation the witness describes. */
    public Property getProperty() {
        return getProperties().iterator().next();
    }

    public static final class WitnessValidationTaskBuilder extends TaskBuilder {

        private final ViolationWitness witness;

        private WitnessValidationTaskBuilder(ViolationWitness witness) {
            this.witness = checkNotNull(witness);
        }

        @Override
        public WitnessValidationTask build(Program program, Wmm memoryModel, EnumSet<Property> properties)
                throws InvalidConfigurationException {
            checkArgument(properties.size() == 1, "Witness validation requires exactly one property");
            return new WitnessValidationTask(
                    program, memoryModel, config.build(), properties.iterator().next(), witness);
        }
    }
}
