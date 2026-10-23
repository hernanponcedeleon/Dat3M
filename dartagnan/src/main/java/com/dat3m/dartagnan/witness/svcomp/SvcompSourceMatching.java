package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.metadata.SourceLocation;
import com.dat3m.dartagnan.program.event.Event;

import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.witness.svcomp.SvcompWitness.Location;

/**
 * Relates the events of a program to the source locations of witnesses.
 * Witness extraction and validation share these definitions, so that they agree on what a waypoint denotes.
 */
public final class SvcompSourceMatching {

    private SvcompSourceMatching() { }

    /** Events are matched by source line and file name, ignoring directories. */
    public static boolean matches(Location location, Event event) {
        return event.getMetadata(SourceLocation.class) instanceof SourceLocation.Generic generic
                && generic.lineNumber() == location.line()
                && generic.sourcePath().getFileName().equals(location.fileName().getFileName());
    }

    /**
     * The events before {@code event} in its statement instance at {@code location}, in program order.
     * A statement instance is a maximal run of consecutive events in program order at the same location,
     * e.g., one loop iteration of the statement.
     */
    public static List<Event> earlierInStatementInstance(Location location, Event event) {
        final List<Event> earlier = new ArrayList<>();
        for (Event previous = event.getPredecessor(); previous != null && matches(location, previous);
                previous = previous.getPredecessor()) {
            earlier.addFirst(previous);
        }
        return earlier;
    }
}
