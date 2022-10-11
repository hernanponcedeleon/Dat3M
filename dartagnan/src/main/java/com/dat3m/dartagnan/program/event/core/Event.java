package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.Encoder;
import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.verification.Context;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.*;

public abstract class Event implements Encoder, Comparable<Event> {

	public static final int PRINT_PAD_EXTRA = 50;

	protected int oId = -1;		// ID after parsing (original)
	protected int uId = -1;		// ID after unrolling
	protected int cId = -1;		// ID after compilation
	protected int fId = -1;		// ID within a function

	protected int cLine = -1;				// line in the original C program
	protected String sourceCodeFile = "";	// filename of the original C program

	protected Thread thread; // The thread this event belongs to

	protected final Set<String> filter;

	protected transient Event successor;
	protected transient Event predecessor;

	private transient String repr;

	protected Event(){
		filter = new HashSet<>();
	}

	protected Event(Event other){
		this.oId = other.oId;
        this.uId = other.uId;
        this.cId = other.cId;
        this.fId = other.fId;
        this.cLine = other.cLine;
        this.sourceCodeFile = other.sourceCodeFile;
        this.filter = other.filter; // TODO: Dangerous code! A Copy-on-Write Set should be used (e.g. PersistentSet/Map)
        this.thread = other.thread;
    }

	public int getOId() { return oId; }
	public void setOId(int id) { this.oId = id; }

	public int getUId(){ return uId; }
	public void setUId(int id) { this.uId = id; }

	public int getCId() { return cId; }
	public void setCId(int id) { this.cId = id; }

	// TODO: This should be called "LId" (localId) and be set once after all processing is done.
	public int getFId() { return fId; }
	public void setFId(int id) { this.fId = id; }

	public int getCLine() {
		return cLine;
	}
	public Event setCLine(int line) {
		this.cLine = line;
		return this;
	}

	public String getSourceCodeFile() {
		return sourceCodeFile;
	}

	public Event setSourceCodeFile(String name) {
		this.sourceCodeFile = name;
		return this;
	}

	public Event getSuccessor(){
		return successor;
	}
	public Event getPredecessor() { return predecessor; }

	public void setSuccessor(Event event) {
		if (successor != null) {
			successor.predecessor = null;
		}
		if (event != null) {
			if (event.predecessor != null){
				event.predecessor.successor = null;
			}
			event.predecessor = this;
			event.setThread(this.thread);
		}
		successor = event;
	}

	public void setPredecessor(Event event) {
		if (predecessor != null) {
			predecessor.successor = null;
		}
		if (event != null) {
			if (event.successor != null){
				event.successor.predecessor = null;
			}
			event.successor = this;
			event.setThread(this.thread);
		}
		predecessor = event;
	}

	public Thread getThread() {
		return thread;
	}

	public void setThread(Thread thread) {
		Preconditions.checkNotNull(thread);
		this.thread = thread;
	}

	public final List<Event> getSuccessors(){
		List<Event> events = new ArrayList<>();
		Event cur = this;
		while (cur != null) {
			events.add( cur);
			cur = cur.getSuccessor();
		}

		return events;
	}

	public final List<Event> getPredecessors(){
		List<Event> events = new ArrayList<>();
		Event cur = this;
		while (cur != null) {
			events.add( cur);
			cur = cur.getPredecessor();
		}

		return events;
	}

	public boolean is(String param){
		return param != null && (filter.contains(param));
	}

	public void addFilters(Collection<? extends String> filters) { filter.addAll(filters); }
	public void addFilters(String... params){
		addFilters(Arrays.asList(params));
	}
	public void removeFilters(Collection<? extends String> filters) { filter.removeAll(filters); }
	public void removeFilters(String... params){
		removeFilters(Arrays.asList(params));
	}

	// The return value should not get modified directly.
	public Set<String> getFilters() {
		return filter;
	}

	public boolean hasFilter(String f) {
		return filter.contains(f);
	}
	
	@Override
	public int compareTo(Event e){
		int result = Integer.compare(cId, e.cId);
		if(result == 0){
			result = Integer.compare(uId, e.uId);
			if(result == 0){
				result = Integer.compare(oId, e.oId);
			}
		}
		return result;
	}

	public void delete() {
		if (getPredecessor() != null) {
			getPredecessor().setSuccessor(this.getSuccessor());
		} else if (getSuccessor() != null) {
			this.getSuccessor().setPredecessor(null);
		}
	}

	// Unrolling
    // -----------------------------------------------------------------------------------------------------------------

	public Event getCopy(){
		throw new UnsupportedOperationException("Copying is not allowed for " + getClass().getSimpleName());
	}

	public void updateReferences(Map<Event, Event> updateMapping) { }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitEvent(this);
	}

	// Encoding
	// -----------------------------------------------------------------------------------------------------------------

	public void initializeEncoding(SolverContext ctx) { }

	public void runLocalAnalysis(Program program, Context context) { }
	
	public String repr() {
		if (cId == -1) {
			// We have not yet compiled
			return "E" + oId;
		}
		if (repr == null) {
			// We cache the result, because this saves string concatenations
			// for every(!) single edge encoded in the program
			repr = "E" + cId;
		}
		return repr;
	}

	// This method needs to get overwritten for conditional events.
	public boolean cfImpliesExec() {
		return true;
	}

	public BooleanFormula encodeExec(EncodingContext ctx) {
		return ctx.getBooleanFormulaManager().makeTrue();
	}
}