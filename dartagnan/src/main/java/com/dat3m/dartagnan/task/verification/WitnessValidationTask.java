package com.dat3m.dartagnan.task.verification;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.witness.svcomp.ViolationWitness;
import com.dat3m.dartagnan.wmm.Wmm;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.ProgressModel.FAIR;
import static com.dat3m.dartagnan.configuration.ProgressModel.uniform;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

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
