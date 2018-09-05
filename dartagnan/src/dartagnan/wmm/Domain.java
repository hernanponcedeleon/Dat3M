package dartagnan.wmm;

import static dartagnan.utils.Utils.ssaReg;

import java.util.*;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;
import dartagnan.program.event.*;
import dartagnan.program.utils.EventRepository;

public class Domain {

	public static BoolExpr encode(Program program, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		Set<Event> eventsLoadLocal = program.getEventRepository().getEvents(EventRepository.EVENT_LOAD | EventRepository.EVENT_LOCAL);
		for(Event r1 : eventsLoadLocal) {
			Set<Event> modRegLater = eventsLoadLocal.stream().filter(e -> r1.getReg() == e.getReg() && r1.getEId() < e.getEId()).collect(Collectors.toSet());
			BoolExpr lastModReg = r1.executes(ctx);
			for(Event r2 : modRegLater) {
				lastModReg = ctx.mkAnd(lastModReg, ctx.mkNot(r2.executes(ctx)));
			}
			enc = ctx.mkAnd(enc, ctx.mkImplies(lastModReg, ctx.mkEq(r1.getReg().getLastValueExpr(ctx), ssaReg(r1.getReg(), r1.getSsaRegIndex(), ctx))));
		}
		return enc;
	}
}