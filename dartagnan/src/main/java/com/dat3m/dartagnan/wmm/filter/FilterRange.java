package com.dat3m.dartagnan.wmm.filter;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.HashSet;
import java.util.Set;

// TODO: Mode the whole thing to relation
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

    @Override
    public int hashCode() {
        return relation.getName().hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        FilterRange fObj = (FilterRange) obj;
        return fObj.relation.getName().equals(relation.getName());
    }
}
