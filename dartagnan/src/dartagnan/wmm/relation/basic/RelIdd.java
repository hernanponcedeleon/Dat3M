package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Location;
import dartagnan.program.Program;
import dartagnan.program.Register;
import dartagnan.program.Thread;
import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.Relation;

import java.util.Collection;
import java.util.Set;
import java.util.stream.Collectors;

import static dartagnan.utils.Utils.edge;

public class RelIdd extends Relation {

    public RelIdd(){
        term = "idd";
    }

    @Override
    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

        for(Event e1 : program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY)){
            for(Event e2 : program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY)){
                if(!e1.getMainThreadId().equals(e2.getMainThreadId()) || e1.getEId() >= e2.getEId()){
                    enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd^+", e1, e2, ctx)));
                    enc = ctx.mkAnd(enc, ctx.mkNot(edge("data", e1, e2, ctx)));
                }
            }
        }

        for(Thread t : program.getThreads()){
            // Idd is impossible by type
            for(Event e1 : t.getEventRepository().getEvents(EventRepository.EVENT_FENCE | EventRepository.EVENT_RCU | EventRepository.EVENT_SKIP | EventRepository.EVENT_IF)){
                for(Event e2 : t.getEventRepository().getEvents(EventRepository.EVENT_ALL)){
                    enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", e1, e2, ctx)));
                }
            }
            for(Event e1 : t.getEventRepository().getEvents(EventRepository.EVENT_LOAD | EventRepository.EVENT_LOCAL)){
                for(Event e2 : t.getEventRepository().getEvents(EventRepository.EVENT_LOAD)){
                    enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", e1, e2, ctx)));
                }
            }
            for(Event e1 : t.getEventRepository().getEvents(EventRepository.EVENT_STORE)){
                for(Event e2 : t.getEventRepository().getEvents(EventRepository.EVENT_STORE | EventRepository.EVENT_LOCAL | EventRepository.EVENT_IF)){
                    enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", e1, e2, ctx)));
                }
            }

            // Idd via register
            // TODO: Load can be also a regReader (for address dependency)
            Collection<Event> events = t.getEventRepository().getEvents(EventRepository.EVENT_STORE | EventRepository.EVENT_LOAD | EventRepository.EVENT_LOCAL);
            Set<Register> registers = events.stream().filter(e -> e.getReg() != null).map(e -> e.getReg()).collect(Collectors.toSet());
            Set<Event> eventsLoadLocal = t.getEventRepository().getEvents(EventRepository.EVENT_LOCAL | EventRepository.EVENT_LOAD);
            Set<Event> eventsStoreLocalIf = t.getEventRepository().getEvents(EventRepository.EVENT_STORE | EventRepository.EVENT_LOCAL | EventRepository.EVENT_IF);

            for(Event regReader : eventsStoreLocalIf){
                Set<Register> readerRegisters = regReader.getExpr().getRegs();
                for(Event regWriter : eventsLoadLocal){
                    if(!readerRegisters.contains(regWriter.getReg())){
                        enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", regWriter, regReader, ctx)));
                    }
                }
            }

            for(Register r : registers){
                Set<Event> regWriters = eventsLoadLocal.stream().filter(e -> e.getReg().equals(r)).collect(Collectors.toSet());
                Set<Event> regReaders = eventsStoreLocalIf.stream().filter(e -> e.getExpr().getRegs().contains(r)).collect(Collectors.toSet());

                for(Event e1 : regWriters){
                    for(Event e2 : regReaders){
                        if(e1.getEId() >= e2.getEId()){
                            enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", e1, e2, ctx)));
                        } else {
                            BoolExpr clause = ctx.mkAnd(e1.executes(ctx), e2.executes(ctx));
                            for(Event e3 : regWriters){
                                if(e3.getEId() > e1.getEId() && e3.getEId() < e2.getEId()){
                                    clause = ctx.mkAnd(clause, ctx.mkNot(e3.executes(ctx)));
                                }
                            }
                            enc = ctx.mkAnd(enc, ctx.mkEq(clause, edge("idd", e1, e2, ctx)));
                        }
                    }
                }
            }

            // Idd via location
            Collection<Event> eventsLocation = t.getEventRepository().getEvents(EventRepository.EVENT_STORE | EventRepository.EVENT_LOAD);
            Set<Location> locations = eventsLocation.stream().map(e -> e.getLoc()).collect(Collectors.toSet());
            Set<Event> eventsStore = t.getEventRepository().getEvents(EventRepository.EVENT_STORE);
            Set<Event> eventsLoad = t.getEventRepository().getEvents(EventRepository.EVENT_LOAD);

            for(Event locReader : eventsLoad){
                Location location = locReader.getLoc();
                for(Event locWriter : eventsStore){
                    if(!locWriter.getLoc().equals(location)){
                        enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", locWriter, locReader, ctx)));
                    }
                }
            }

            for(Location l : locations){
                Set<Event> locWriters = eventsStore.stream().filter(e -> e.getLoc().equals(l)).collect(Collectors.toSet());
                Set<Event> locReaders = eventsLoad.stream().filter(e -> e.getLoc().equals(l)).collect(Collectors.toSet());

                for(Event e1 : locWriters){
                    for(Event e2 : locReaders){
                        if(e1.getEId() >= e2.getEId()){
                            enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", e1, e2, ctx)));
                        } else {
                            BoolExpr clause = ctx.mkAnd(e1.executes(ctx), e2.executes(ctx));
                            for(Event e3 : locWriters){
                                if(e3.getEId() > e1.getEId() && e3.getEId() < e2.getEId()){
                                    clause = ctx.mkAnd(clause, ctx.mkNot(e3.executes(ctx)));
                                }
                            }
                            enc = ctx.mkAnd(enc, ctx.mkEq(clause, edge("idd", e1, e2, ctx)));
                        }
                    }
                }
            }
        }
        return enc;
    }

    @Override
    protected BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
        return encodeBasic(program, ctx);
    }
}
