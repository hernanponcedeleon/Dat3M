package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.If;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.List;

//TODO(TH/HP): Can we restrict to visible events?
// What is even the use, if none of the edges are visible?
public class RelCtrlDirect extends StaticRelation {

    public RelCtrlDirect(){
        term = "ctrlDirect";
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();

            //NOTE: If's (under Linux) have different notion of ctrl dependency than conditional jumps!
            // In particular, transforming If's to CondJump's is invalid under Linux
            for(Thread thread : task.getProgram().getThreads()){
                for(Event e1 : thread.getCache().getEvents(FilterBasic.get(EType.CMP))){
                    for(Event e2 : ((If) e1).getMainBranchEvents()){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                    for(Event e2 : ((If) e1).getElseBranchEvents()){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }

                //Relates jumps with all later events
                List<Event> condJumps = thread.getCache().getEvents(FilterBasic.get(EType.JUMP));
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
