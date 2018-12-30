package porthos;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;
import dartagnan.program.Program;
import dartagnan.program.Register;
import dartagnan.program.event.Event;
import dartagnan.program.event.Load;
import dartagnan.program.event.Store;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.memory.Location;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.Utils;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.*;
import java.util.stream.Collectors;

class Encodings {

	static BoolExpr encodeCommonExecutions(Program p1, Program p2, Context ctx) {
		List<Event> p1Events = sortedByHlId(p1);
        List<Event> p2Events = sortedByHlId(p2);

        Iterator it1 = p1Events.iterator();
        Iterator it2 = p2Events.iterator();

        Set<Tuple> rTuples = new TupleSet();
        Set<Tuple> wTuples = new TupleSet();

        BoolExpr enc = ctx.mkTrue();

        while(it1.hasNext() && it2.hasNext()) {
            Event e1 = (Event) it1.next();
            Event e2 = (Event) it2.next();

            if(e1.getHLId() != e2.getHLId()){
                throw new RuntimeException("Invalid HLId");
            }
            enc = ctx.mkAnd(enc, ctx.mkEq(e1.executes(ctx), e2.executes(ctx)));

            if(e1 instanceof Load && e2 instanceof Load){
                rTuples.add(new Tuple(e1, e2));

            } else if(e1 instanceof Store && e2 instanceof Store){
                wTuples.add(new Tuple(e1, e2));
            }
        }

        for(Tuple rTuple : rTuples){
            Event r1 = rTuple.getFirst();
            Event r2 = rTuple.getSecond();
            for(Tuple wTuple : wTuples){
                enc = ctx.mkAnd(enc, ctx.mkEq(
                        Utils.edge("rf", wTuple.getFirst(), r1, ctx),
                        Utils.edge("rf", wTuple.getSecond(), r2, ctx)
                ));
            }
        }

        for(Tuple wTupleFrom : wTuples){
            Event w1From = wTupleFrom.getFirst();
            Event w2From = wTupleFrom.getSecond();
            for(Tuple wTupleTo : wTuples){
                if(w1From.getEId() != wTupleTo.getFirst().getEId()){
                    enc = ctx.mkAnd(enc, ctx.mkEq(
                            Utils.edge("co", w1From, wTupleTo.getFirst(), ctx),
                            Utils.edge("co", w2From, wTupleTo.getSecond(), ctx)
                    ));
                }
            }
        }
		return enc;
	}
	
	static BoolExpr encodeReachedState(Program p, Model model, Context ctx) {
		BoolExpr reachedState = ctx.mkTrue();
		for(Location loc : p.getLocations()) {
			reachedState = ctx.mkAnd(reachedState, ctx.mkEq(loc.getLastValueExpr(ctx), model.getConstInterp(loc.getLastValueExpr(ctx))));
		}
		Set<RegWriter> executedEvents = p.getEventRepository().getEvents(EventRepository.ALL).stream()
                .filter(e -> model.getConstInterp(e.executes(ctx)).isTrue())
				.filter(e -> e instanceof RegWriter)
                .map(e -> (RegWriter)e)
                .collect(Collectors.toSet());
		Set<Register> regs = new HashSet<>();
		for(RegWriter e : executedEvents){
			regs.add(e.getModifiedReg());
		}
		for(Register reg : regs) {
			reachedState = ctx.mkAnd(reachedState, ctx.mkEq(reg.getLastValueExpr(ctx), model.getConstInterp(reg.getLastValueExpr(ctx))));
		}
		return reachedState;
	}

	private static List<Event> sortedByHlId(Program program){
        return program.getEventRepository()
                .getEvents(EventRepository.MEMORY | EventRepository.LOCAL)
                .stream()
                .sorted(Comparator.comparing(Event::getHLId))
                .collect(Collectors.toList());
    }
}