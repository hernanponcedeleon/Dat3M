package dartagnan.wmm.filter;

import dartagnan.program.event.Event;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.Tuple;

import java.util.HashSet;
import java.util.Set;

public class FilterRange extends FilterAbstract {

    private Relation relation;
    private Set<Event> range;

    public FilterRange(Relation relation){
        if(!relation.getIsStatic()){
            throw new UnsupportedOperationException("Range is available for static relations only");
        }
        this.relation = relation;
    }

    @Override
    public boolean filter(Event e){
        if(range == null){
            range = new HashSet<>();
            for(Tuple t : relation.getMaxTupleSet()){
                range.add(t.getSecond());
            }
        }
        return range.contains(e);
    }

    @Override
    public void initialise(){
        range = null;
    }
}
