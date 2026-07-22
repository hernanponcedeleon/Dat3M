package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.configuration.Property;

import java.util.EnumSet;

public sealed interface TaskGoal {

    record Verify(EnumSet<Property> properties) implements TaskGoal { }

}
