package dartagnan.wmm.arch;

import static dartagnan.wmm.EncodingsCAT.satUnion;
import static dartagnan.wmm.Encodings.satAcyclic;
import static dartagnan.wmm.Encodings.satCycleDef;
import static dartagnan.wmm.Encodings.satCycle;

import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;
import dartagnan.program.event.Event;
import dartagnan.program.event.MemEvent;
import dartagnan.wmm.WmmInterface;

public class SC implements WmmInterface {
	
	public BoolExpr encode(Program program, Context ctx, boolean approx, boolean idl) throws Z3Exception {
		if(program.hasRMWEvents()){
			throw new RuntimeException("RMW is not implemented for SC");
		}

		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
	    BoolExpr enc = satUnion("co", "fr", events, ctx);
	    enc = ctx.mkAnd(enc, satUnion("com", "(co+fr)", "rf", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("ghb-sc", "po", "com", events, ctx));
		return enc;
	}
	
	public BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return satAcyclic("ghb-sc", events, ctx);
	}
	
	public BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return ctx.mkAnd(satCycleDef("ghb-sc", events, ctx), satCycle("ghb-sc", events, ctx));
	}
}