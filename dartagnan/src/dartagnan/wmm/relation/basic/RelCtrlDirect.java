package dartagnan.wmm.relation.basic;

import dartagnan.program.event.Event;
import dartagnan.program.event.If;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

public class RelCtrlDirect extends BasicRelation {

    public RelCtrlDirect(){
        term = "ctrlDirect";
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Event e1 : program.getEventRepository().getEvents(EventRepository.EVENT_IF)){
                for(Event e2 : ((If) e1).getT1().getEvents()){
                    maxTupleSet.add(new Tuple(e1, e2));
                }
                for(Event e2 : ((If) e1).getT2().getEvents()){
                    maxTupleSet.add(new Tuple(e1, e2));
                }
            }
        }
        return maxTupleSet;
    }
}
