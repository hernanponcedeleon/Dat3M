package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.IfAsJump;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterMinus;
import com.dat3m.dartagnan.wmm.filter.FilterUnion;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CTRLDIRECT;

import java.util.List;

//TODO(TH/HP): Can we restrict to visible events?
// What is even the use, if none of the edges are visible?
public class RelCtrlDirect extends StaticRelation {

    public RelCtrlDirect(){
        term = CTRLDIRECT;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();

            // NOTE: If's (under Linux) have different notion of ctrl dependency than conditional jumps!
            for(Thread thread : task.getProgram().getThreads()){
                for(Event e1 : thread.getCache().getEvents(FilterBasic.get(EType.CMP))){
                    for(Event e2 : ((IfAsJump) e1).getBranchesEvents()){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
                
                // Relates jumps (except those implementing Ifs and their internal jump to end) with all later events
                List<Event> condJumps = thread.getCache().getEvents(FilterMinus.get(
                		FilterBasic.get(EType.JUMP), 
                		FilterUnion.get(FilterBasic.get(EType.CMP), FilterBasic.get(EType.IFI))));
                if(!condJumps.isEmpty()){
                    for(Event e2 : thread.getCache().getEvents(FilterBasic.get(EType.ANY))){
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
