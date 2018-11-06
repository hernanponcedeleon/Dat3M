package dartagnan.parsers.utils.aarch64;

import dartagnan.parsers.utils.ParsingException;
import dartagnan.program.Thread;
import dartagnan.program.event.aarch64.rmw.StoreExclusive;
import dartagnan.program.event.rmw.RMWLoad;

import java.util.LinkedList;

public class ProgramBuilder extends dartagnan.parsers.utils.ProgramBuilder {

    public Thread addChild(String thread, Thread child){
        if(!threads.containsKey(thread)){
            throw new ParsingException("Thread " + thread + " is not initialised");
        }
        LinkedList<Thread> events = threads.get(thread);
        if(child instanceof StoreExclusive){
            Thread readExclusive = events.getLast();
            if(!(readExclusive instanceof RMWLoad)){
                throw new ParsingException("Exclusive store without a corresponding exclusive load: " + child);
            }
            ((StoreExclusive) child).setLoadEvent((RMWLoad) readExclusive);
        }
        events.add(child);
        return child;
    }
}
