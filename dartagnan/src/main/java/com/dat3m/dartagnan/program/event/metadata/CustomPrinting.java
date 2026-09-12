package com.dat3m.dartagnan.program.event.metadata;


import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.metadata.Metadata;

import java.util.Optional;

@FunctionalInterface
public interface CustomPrinting extends Metadata {

    Optional<String> stringify(Event e);
}
