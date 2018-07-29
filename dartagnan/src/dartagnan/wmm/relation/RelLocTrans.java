package dartagnan.wmm.relation;

import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;

import java.util.Collection;

/**
 *
 * @author Florian Furbach
 */
public class RelLocTrans extends RelTrans {

    public RelLocTrans(Relation r1) {
        super(r1);
    }

    public RelLocTrans(Relation r1, String name) {
        super(r1, name);
    }

    @Override
    protected Collection<Event> getProgramEvents(Program program){
        return program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_LOCAL);
    }
}
