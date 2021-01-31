package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.If;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.List;

public class RelCtrlDirect extends StaticRelation {

    public RelCtrlDirect(){
        term = "ctrlDirect";
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();

            //TODO: Is If and CondJump different from a semantic point of view?
            // Compiling If's to CondJumps changes the Control-Dependency.
            // Relates Ifs with main and else branch, but not with events thereafter
            // This is apparently a discrepancy between linux (which uses If's instead of CondJumps)
            // and other architectures.
            for(Thread thread : program.getThreads()){
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
        }
        return maxTupleSet;
    }
}
