package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.witness.svcomp.SvcompViolationWitness;
import com.dat3m.dartagnan.wmm.Wmm;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.ProgressModel.FAIR;
import static com.dat3m.dartagnan.configuration.ProgressModel.uniform;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

public final class WitnessValidationTask extends VerificationTask {

    private final SvcompViolationWitness witness;

    public static WitnessValidationTaskBuilder builder(SvcompViolationWitness witness) {
        return new WitnessValidationTaskBuilder(witness);
    }

    WitnessValidationTask(Program program, Wmm memoryModel, Configuration config,
                          Property property, SvcompViolationWitness witness)
            throws InvalidConfigurationException {
        super(program, memoryModel, uniform(FAIR), config, EnumSet.of(property));
        this.witness = checkNotNull(witness);
    }

    public SvcompViolationWitness getWitness() {
        return witness;
    }

    /** The single property whose violation the witness describes. */
    public Property getProperty() {
        return getProperties().iterator().next();
    }

    public static final class WitnessValidationTaskBuilder extends TaskBuilder {

        private final SvcompViolationWitness witness;

        private WitnessValidationTaskBuilder(SvcompViolationWitness witness) {
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
