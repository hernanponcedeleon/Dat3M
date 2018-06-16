package dartagnan.wmm;

import static dartagnan.wmm.EncodingsCAT.satUnion;
import static dartagnan.wmm.Encodings.satAcyclic;
import static dartagnan.wmm.Encodings.satCycleDef;
import static dartagnan.wmm.Encodings.satCycle;

import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;

public class SC {
	
	public static BoolExpr encode(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
	    BoolExpr enc = satUnion("co", "fr", events, ctx);
	    enc = ctx.mkAnd(enc, satUnion("com", "(co+fr)", "rf", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("ghb-sc", "po", "com", events, ctx));
		return enc;
	}
	
	public static BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return satAcyclic("ghb-sc", events, ctx);
	}
	
	public static BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return ctx.mkAnd(satCycleDef("ghb-sc", events, ctx), satCycle("ghb-sc", events, ctx));
	}
}