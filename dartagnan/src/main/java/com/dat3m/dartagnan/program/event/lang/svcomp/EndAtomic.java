package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.verification.Context;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.program.event.Tag.RMW;
import static com.dat3m.dartagnan.program.event.Tag.SVCOMP.SVCOMPATOMIC;

public class EndAtomic extends Event {

	private static final Logger logger = LogManager.getLogger(EndAtomic.class);

	protected BeginAtomic begin;
	protected transient List<Event> enclosedEvents;

	public EndAtomic(BeginAtomic begin) {
        this.begin = begin;
        addFilters(RMW, SVCOMPATOMIC);
    }

    protected EndAtomic(EndAtomic other){
		super(other);
		this.begin = other.begin;
	}

    public BeginAtomic getBegin(){
    	return begin;
    }
    
    public List<Event> getBlock(){
    	Preconditions.checkState(cId >= 0, "The program needs to get compiled first");
    	return enclosedEvents;
    }

	@Override
	public void runLocalAnalysis(Program program, Context context) {
		//===== Temporary fix to rematch atomic blocks correctly =====
		BranchEquivalence eq = context.requires(BranchEquivalence.class);
		List<Event> begins = this.thread.getEvents()
				.stream().filter( x -> x instanceof BeginAtomic && eq.isReachableFrom(x, this))
				.collect(Collectors.toList());
		this.begin = (BeginAtomic) begins.get(begins.size() - 1);
		// =======================================================

		findEnclosedEvents(eq);
	}

	private void findEnclosedEvents(BranchEquivalence eq) {
    	enclosedEvents = new ArrayList<>();
		BranchEquivalence.Class startClass = eq.getEquivalenceClass(begin);
		BranchEquivalence.Class endClass = eq.getEquivalenceClass(this);
		if (!startClass.getReachableClasses().contains(endClass)) {
			logger.warn("BeginAtomic" + begin.getGlobalId() + "can't reach EndAtomic " + this.getGlobalId());
		}

		for (BranchEquivalence.Class c : startClass.getReachableClasses()) {
			for (Event e : c) {
				if (begin.getGlobalId() <= e.getGlobalId() && e.getGlobalId() <= this.getGlobalId()) {
					if (!eq.isImplied(e, begin)) {
						logger.warn(e + " is inside atomic block but can be reached from the outside");
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

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
	public EndAtomic getCopy(){
		return new EndAtomic(this);
	}

	@Override
	public void updateReferences(Map<Event, Event> updateMapping) {
		this.begin = (BeginAtomic) updateMapping.getOrDefault(this.begin, this.begin);
	}

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitEndAtomic(this);
	}
}