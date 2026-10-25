package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.metadata.SourceLocation;
import com.dat3m.dartagnan.program.event.Event;

import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.witness.svcomp.Witness.Location;

/**
 * Relates the events of a program to the source locations of a witness.
 * Witness extraction and validation share these definitions, so that they agree on what a waypoint denotes.
 */
public final class SourceMatching {

    private SourceMatching() { }

    /** Events are matched by source line and file name, ignoring directories. */
    public static boolean matches(Location location, Event event) {
        return switch (event.getMetadata(SourceLocation.class)) {
            case SourceLocation.Generic(var path, int line) ->
                    line == location.line() && path.getFileName().equals(location.fileName().getFileName());
            case null, default -> false;
        };
    }

    /**
     * One C source line may compile into several events, all carrying {@code SourceLocation.Generic(X.c, N)}.
     * After loop unrolling or function inlining, every copy repeats that group.
     * Returns the events at {@code location} that come before {@code event} in that one occurrence of
     * the line, in program order. It does not include {@code event} itself.
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
