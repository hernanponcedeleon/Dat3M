package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.collections.IndexedDomain;
import com.google.common.base.Verify;

import java.util.EnumMap;
import java.util.List;

import static com.dat3m.dartagnan.program.event.Tag.VISIBLE;

public final class EventDomainRepository {

    private final EnumMap<DomainBound, IndexedDomain<Event>> domains;

    private EventDomainRepository(Program program) {
        domains = new EnumMap<>(DomainBound.class);
        initialise(program);
        validate();
    }

    public static EventDomainRepository forProgram(Program program) {
        return new EventDomainRepository(program);
    }

    public IndexedDomain<Event> getDomain(DomainBound bound) {
        return domains.get(bound);
    }

    public enum DomainBound { VISIBLE, ALL }

    private void initialise(Program program) {
        final List<Event> list = program.getThreadEvents();
        list.sort(this::compare);
        domains.put(DomainBound.VISIBLE, new IndexedDomain<>(list.stream().filter(e -> e.hasTag(VISIBLE)).toList()));
        domains.put(DomainBound.ALL, new IndexedDomain<>(list));
    }

    private void validate() {
        for (IndexedDomain<Event> domain1 : domains.values()) {
            for (IndexedDomain<Event> domain2 : domains.values()) {
                Verify.verify(domain1.isCompatibleWith(domain2), "Incompatible domains.");
            }
        }
    }

    // Sorts all events by VISIBLE Tag existence, then by globalId.
    private int compare(Event e1, Event e2) {
        final boolean visible = e1.hasTag(VISIBLE);
        if (visible != e2.hasTag(VISIBLE)) {
            return visible ? -1 : 1;
        }
        return e1.getGlobalId() - e2.getGlobalId();
    }
}