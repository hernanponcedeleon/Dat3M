package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.IfAsJump;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterMinus;
import com.dat3m.dartagnan.program.filter.FilterUnion;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.List;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CTRLDIRECT;

//TODO: We can restrict the codomain to visible events as the only usage of this Relation is in
// ctrl := idd^+;ctrlDirect & (R*V)
public class RelCtrlDirect extends StaticRelation {

    public RelCtrlDirect(){
        term = CTRLDIRECT;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitControl(this);
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();

            // NOTE: If's (under Linux) have different notion of ctrl dependency than conditional jumps!
            for(Thread thread : task.getProgram().getThreads()){
                for(Event e1 : thread.getCache().getEvents(FilterBasic.get(Tag.CMP))){
                    for(Event e2 : ((IfAsJump) e1).getBranchesEvents()){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
                
                // Relates jumps (except those implementing Ifs and their internal jump to end) with all later events
                List<Event> condJumps = thread.getCache().getEvents(FilterMinus.get(
                		FilterBasic.get(Tag.JUMP),
                		FilterUnion.get(FilterBasic.get(Tag.CMP), FilterBasic.get(Tag.IFI))));
                if(!condJumps.isEmpty()){
                    for(Event e2 : thread.getCache().getEvents(FilterBasic.get(Tag.ANY))){
                        for(Event e1 : condJumps){
                            if(e1.getCId() < e2.getCId()){
                                maxTupleSet.add(new Tuple(e1, e2));
                            }
                        }
                    }
                }
            }
            removeMutuallyExclusiveTuples(maxTupleSet);
        }
        return maxTupleSet;
    }
}
