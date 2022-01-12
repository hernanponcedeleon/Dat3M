package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.encoding.Encoder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.verification.Context;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.*;

public abstract class Event implements Encoder, Comparable<Event> {

	public static final int PRINT_PAD_EXTRA = 50;

	protected int oId = -1;		// ID after parsing (original)
	protected int uId = -1;		// ID after unrolling
	protected int cId = -1;		// ID after compilation
	protected int fId = -1;		// ID within a function

	protected int cLine = -1;	// line in the original C program

	protected Thread thread; // The thread this event belongs to

	protected final Set<String> filter;

	protected transient Event successor;

	protected transient BooleanFormula cfVar;

	protected Set<Event> listeners = new HashSet<>();

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
        this.filter = other.filter;
        this.thread = other.thread;
		this.listeners = other.listeners;
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
	public void setCLine(int line) {
		this.cLine = line;
	}

	public Event getSuccessor(){
		return successor;
	}

	public void setSuccessor(Event event){
		successor = event;
		if (successor != null) {
			successor.setThread(this.thread);
		}
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

	public boolean is(String param){
		return param != null && (filter.contains(param));
	}

	public void addFilters(String... params){
		filter.addAll(Arrays.asList(params));
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

    public void addListener(Event e) {
    	listeners.add(e);
    }

    public Set<Event> getListeners() {
		return listeners;
	}

    public void notify(Event e) {
    	throw new UnsupportedOperationException("notify is not allowed for " + getClass().getSimpleName());
    }



	// Unrolling
    // -----------------------------------------------------------------------------------------------------------------

	public Event getCopy(){
		throw new UnsupportedOperationException("Copying is not allowed for " + getClass().getSimpleName());
	}

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

	public List<Event> compile(Arch target) {
		return Collections.singletonList(this);
	}

	public void delete(Event pred) {
		if (pred != null) {
			pred.successor = this.successor;
		}
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

	public BooleanFormula exec(){
		return cf();
	}

	public BooleanFormula cf(){ return cfVar; }
	public void setCfVar(BooleanFormula cfVar) { this.cfVar = cfVar; }

	// This method needs to get overwritten for conditional events.
	public boolean cfImpliesExec() {
		return true;
	}

	public BooleanFormula encodeExec(SolverContext ctx){
		return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
	}

	// =============== Utility methods ==================

	public boolean wasExecuted(Model model) {
		Boolean expr = model.evaluate(exec());
		return expr != null && expr;
	}

	public boolean wasInControlFlow(Model model) {
		Boolean expr = model.evaluate(cf());
		return expr != null && expr;
	}


}