package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.Wmm;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.EnumSet;

import static com.google.common.base.Preconditions.checkNotNull;

// A property verification task
public final class VerificationTask extends Task {

    private final EnumSet<Property> properties;

    VerificationTask(Program program, Wmm memoryModel, ProgressModel.Hierarchy progressModel,
                     Configuration config, EnumSet<Property> properties) throws InvalidConfigurationException {
        super(program, memoryModel, progressModel, config);
        this.properties = checkNotNull(properties);
    }

    public EnumSet<Property> getProperties() {
        return properties;
    }
}
