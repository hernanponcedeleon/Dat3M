package com.dat3m.dartagnan.program.svcomp.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import static com.dat3m.dartagnan.program.utils.EType.RMW;
import static com.dat3m.dartagnan.program.utils.EType.SVCOMPATOMIC;

// NOTE: The SVCOMP rules state that BeginAtomic and EndAtomic belong to the same
// control-flow block, that is, there shall be no code that can leave the atomic block prematurely.
// In particular, this means: No gotos to the outside and  no assertions/aborts (e.g. assume_abort_if_not) inside the block!
public class EndAtomic extends Event {

	private static final Logger logger = LogManager.getLogger(EndAtomic.class);

	protected BeginAtomic begin;
	protected BeginAtomic begin4Copy;
	protected transient List<Event> enclosedEvents;

	public EndAtomic(BeginAtomic begin) {
        this.begin = begin;
    	this.begin.addListener(this);
        addFilters(RMW, SVCOMPATOMIC);
    }

    protected EndAtomic(EndAtomic other){
		super(other);
		this.begin = other.begin4Copy;
		Event notifier = begin != null ? begin : other.begin;
		notifier.addListener(this);
	}

    public BeginAtomic getBegin(){
    	return begin;
    }
    
    public List<Event> getBlock(){
		Preconditions.checkState(cId >= 0, "The program needs to get compiled first.");
    	return enclosedEvents;
    }

	@Override
	public void initialise(VerificationTask task, SolverContext ctx) {
		super.initialise(task, ctx);
		//===== Temporary fix to rematch atomic blocks correctly =====
		BranchEquivalence eq = task.getBranchEquivalence();
		this.begin = (BeginAtomic) this.thread.getEvents()
				.stream().filter( x -> x instanceof BeginAtomic && eq.isReachableFrom(x, this))
				.reduce((a, b) -> b).orElseThrow();
		// =======================================================

		findEnclosedEvents(eq);

	}

	private void findEnclosedEvents(BranchEquivalence eq) {
    	enclosedEvents = new ArrayList<>();
		BranchEquivalence.Class startClass = eq.getEquivalenceClass(begin);
		BranchEquivalence.Class endClass = eq.getEquivalenceClass(this);
		if (!startClass.getReachableClasses().contains(endClass)) {
			logger.warn("BeginAtomic {} can't reach EndAtomic {}" + this.getCId(),begin.getCId(), this.getCId());
		}

		//TODO: The following check would be nice to have to make sure that the SVCOMP rules are satisfied.
		// However, due to the way we parse conditional jumps, we end up inserting a lot of assume-like events
		// that are impossible to violate yet they *would* cause a jump outside the atomic block!
		/*if (!startClass.getImpliedClasses().contains(endClass)) {
			logger.warn("Control-flow between BeginAtomic {} and EndAtomic {} may be interrupted", begin.getCId(), this.getCId());
		}*/

		for (BranchEquivalence.Class c : startClass.getReachableClasses()) {
			for (Event e : c) {
				if (begin.getCId() <= e.getCId() && e.getCId() <= this.getCId()) {
					if (!eq.isImplied(e, begin)) {
						logger.warn("{} is inside atomic block but can be reached from the outside", e);
					}
					enclosedEvents.add(e);
					e.addFilters(RMW);
				}
			}
		}
		enclosedEvents.sort(Comparator.naturalOrder());
		enclosedEvents = ImmutableList.copyOf(enclosedEvents);
	}

	@Override
    public String toString() {
    	return "end_atomic()";
    }
    
    @Override
    public void notify(Event begin) {
    	//TODO(HP): create an interface for easy maintenance of the listeners logic
    	if(this.begin == null) {
    		this.begin = (BeginAtomic)begin;
    	} else if (oId > begin.getOId()) {
    		this.begin4Copy = (BeginAtomic)begin;
    	}
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
	public EndAtomic getCopy(){
		return new EndAtomic(this);
	}
}