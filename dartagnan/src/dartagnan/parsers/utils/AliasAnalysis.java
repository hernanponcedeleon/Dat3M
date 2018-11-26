package dartagnan.parsers.utils;

import com.google.common.collect.ImmutableSet;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Program;
import dartagnan.program.Register;
import dartagnan.program.event.Event;
import dartagnan.program.event.Local;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.memory.Address;
import dartagnan.program.memory.Location;
import dartagnan.program.memory.Memory;
import dartagnan.program.utils.EventRepository;

import java.util.*;

public class AliasAnalysis {

    public void calculateLocationSets(Program program, Memory memory){
        Map<Register, List<Event>> regWrites = new HashMap<>();
        for(Event e : program.getEventRepository().getEvents(EventRepository.ALL)){
            if(e instanceof RegWriter){
                Register register = ((RegWriter)e).getModifiedReg();
                regWrites.putIfAbsent(register, new ArrayList<>());
                regWrites.get(register).add(e);
            }
        }
        for(Event e : program.getEventRepository().getEvents(EventRepository.ALL)){
            if(e instanceof RegReaderAddress){
                Register register = ((RegReaderAddress) e).getAddressReg();
                if(!regWrites.containsKey(register)){
                    throw new RuntimeException("Address register " + register + " has not been initialised");
                }
                List<Event> events = regWrites.get(register);
                if(events.size() == 1){
                    Event regWrite = events.get(0);
                    if(regWrite instanceof Local){
                        ExprInterface expr = ((Local)regWrite).getExpr();
                        if(expr instanceof Address){
                            Set<Location> locations = ImmutableSet.of(memory.getLocationForAddress((Address) expr));
                            ((RegReaderAddress) e).setMaxLocationSet(locations);
                            continue;
                        }
                    }
                }
                ((RegReaderAddress) e).setMaxLocationSet(memory.getLocations());
            }
        }
    }
}
