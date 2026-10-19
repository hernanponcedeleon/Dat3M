package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.Wmm;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;


// A task to enumerate all final states (final-state enumeration).
public final class EnumerationTask extends Task {

    EnumerationTask(Program program, Wmm memoryModel, ProgressModel.Hierarchy progressModel,
                    Configuration config) throws InvalidConfigurationException {
        super(program, memoryModel, progressModel, config);
    }
}
