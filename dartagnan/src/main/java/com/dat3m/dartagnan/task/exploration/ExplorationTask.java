package com.dat3m.dartagnan.task.exploration;

import com.dat3m.dartagnan.task.Task;

import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.Wmm;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.EnumSet;

import static com.google.common.base.Preconditions.checkNotNull;

/*
    A task that enumerates all consistent executions of a (non-unrolled) program
    using stateless model checking (TruSt, POPL'22) and checks the given properties on them.
 */
public final class ExplorationTask extends Task {

    private final EnumSet<Property> properties;

    public ExplorationTask(Program program, Wmm memoryModel, ProgressModel.Hierarchy progressModel,
                    Configuration config, EnumSet<Property> properties) throws InvalidConfigurationException {
        super(program, memoryModel, progressModel, config);
        this.properties = checkNotNull(properties);
    }

    public EnumSet<Property> getProperties() {
        return properties;
    }
}
