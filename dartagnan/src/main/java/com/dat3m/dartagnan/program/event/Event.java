package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.utils.recursion.RecursiveAction;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.program.Thread;

import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;

import java.util.*;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

public abstract class Event implements Comparable<Event> {

	public static final int PRINT_PAD_EXTRA = 50;

	protected int oId = -1;		// ID after parsing (original)
	protected int uId = -1;		// ID after unrolling
	protected int cId = -1;		// ID after compilation
	
	protected int cLine = -1;	// line in the original C program

	protected Thread thread; // The thread this event belongs to

	protected final Set<String> filter;

	protected transient Event successor;

    protected transient BooleanFormula cfEnc;
    protected transient BooleanFormula cfCond;
	protected transient BooleanFormula cfVar;

	protected VerificationTask task;

	protected Set<Event> listeners = new HashSet<>();

	private String repr;

	protected Event(int cLine) {
		filter = new HashSet<>();
		this.cLine = cLine;
	}

	protected Event(){
		filter = new HashSet<>();
	}

	protected Event(Event other){
		this.oId = other.oId;
        this.uId = other.uId;
        this.cId = other.cId;
        this.cLine = other.cLine;
        this.filter = other.filter;
        this.thread = other.thread;
		this.listeners = other.listeners;
    }

	public int getOId() {
		return oId;
	}

	public void setOId(int id) {
		this.oId = id;
	}

	public int getUId(){
		return uId;
	}

	public int getCId() {
		return cId;
	}

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
		if (thread != null && !thread.equals(this.thread)) {
			this.thread = thread;
			if (successor != null) {
				//TODO: Get rid of this recursion completely
				successor.setThread(thread);
			}
		}
	}

	public final List<Event> getSuccessors(){
		List<Event> events = new ArrayList<>();
		getSuccessorsRecursive(events, 0).execute();
		return events;
	}

	protected RecursiveAction getSuccessorsRecursive(List<Event> list, int depth) {
		list.add(this);
		if (successor != null) {
			if (depth < GlobalSettings.MAX_RECURSION_DEPTH) {
				return successor.getSuccessorsRecursive(list, depth + 1);
			} else {
				return RecursiveAction.call(() -> successor.getSuccessorsRecursive(list, 0));
			}
		}
		return RecursiveAction.done();
	}

	public String label(){
		return repr() + " " + getClass().getSimpleName();
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
    
    public final void simplify(Event predecessor) {
		simplifyRecursive(predecessor, 0).execute();
    }

    protected RecursiveAction simplifyRecursive(Event predecessor, int depth) {
		if (successor != null) {
			if (depth < GlobalSettings.MAX_RECURSION_DEPTH) {
				return successor.simplifyRecursive(this, depth + 1);
			} else {
				return RecursiveAction.call(() -> successor.simplifyRecursive(this, 0));
			}
		}
		return RecursiveAction.done();
	}

	// Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    public final int setUId(int nextId) {
		return setUIdRecursive(nextId, 0).execute();
    }

	protected RecursiveFunction<Integer> setUIdRecursive(int nextId, int depth) {
		uId = nextId;
		if (successor != null) {
			if (depth < GlobalSettings.MAX_RECURSION_DEPTH) {
				return successor.setUIdRecursive(nextId + 1, depth + 1);
			} else {
				return RecursiveFunction.call(() -> successor.setUIdRecursive(nextId + 1, 0));
			}
		}
		return RecursiveFunction.done(nextId + 1);
	}



	// --------------------------------

    public final void unroll(int bound, Event predecessor) {
		unrollRecursive(bound, predecessor, 0).execute();
    }

    protected RecursiveAction unrollRecursive(int bound, Event predecessor, int depth) {
		Event copy = this;
		if(predecessor != null) {
			// This check must be done inside this if
			// Needed for the current implementation of copy in If events
			if(bound != 1) {
				copy = getCopy();
			}
			predecessor.setSuccessor(copy);
		}
		if(successor != null) {
			if (depth < GlobalSettings.MAX_RECURSION_DEPTH) {
				return successor.unrollRecursive(bound, copy, depth + 1);
			} else {
				Event finalCopy = copy;
				return RecursiveAction.call(() -> successor.unrollRecursive(bound, finalCopy, 0));
			}
		}
		return RecursiveAction.done();
	}

	public Event getCopy(){
		throw new UnsupportedOperationException("Copying is not allowed for " + getClass().getSimpleName());
	}

	static Event copyPath(Event from, Event until, Event appendTo){
		while(from != null && !from.equals(until)){
			Event copy = from.getCopy();
			appendTo.setSuccessor(copy);
			appendTo = copy;
			from = from.successor;
		}
		return appendTo;
	}


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    public final int compile(Arch target, int nextId, Event predecessor) {
		return compileRecursive(target, nextId, predecessor, 0).execute();
    }

	protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
		cId = nextId++;
		if(successor != null){
			if (depth < GlobalSettings.MAX_RECURSION_DEPTH) {
				return successor.compileRecursive(target, nextId, this, depth + 1);
			} else {
				int finalNextId = nextId;
				return RecursiveFunction.call(() -> successor.compileRecursive(target, finalNextId, this, 0));
			}
		}
		return RecursiveFunction.done(nextId);
	}

	protected RecursiveFunction<Integer> compileSequenceRecursive(Arch target, int nextId, Event predecessor, LinkedList<Event> sequence, int depth){
		for(Event e : sequence){
			e.oId = oId;
			e.uId = uId;
			e.cId = nextId++;
			predecessor.setSuccessor(e);
			predecessor = e;
		}
		if(successor != null){
			predecessor.successor = successor;
			if (depth < GlobalSettings.MAX_RECURSION_DEPTH) {
				return successor.compileRecursive(target, nextId, predecessor, depth + 1);
			} else {
				Event finalPredecessor = predecessor;
				int finalNextId = nextId;
				return RecursiveFunction.call(() -> successor.compileRecursive(target, finalNextId, finalPredecessor, 0));
			}
		}
		return RecursiveFunction.done(nextId);
	}

	public void delete(Event pred) {
		if (pred != null) {
			pred.successor = this.successor;
		}
	}


	// Encoding
	// -----------------------------------------------------------------------------------------------------------------

	public void initialise(VerificationTask task, SolverContext ctx){
		if(cId < 0){
			throw new RuntimeException("Event ID is not set in " + this);
		}
		this.task = task;
		FormulaManager fmgr = ctx.getFormulaManager();
		if (GlobalSettings.MERGE_CF_VARS) {
			cfVar = fmgr.makeVariable(BooleanType, "cf(" + task.getBranchEquivalence().getRepresentative(this).repr() + ")");
		} else {
			
			cfVar = fmgr.makeVariable(BooleanType, "cf(" + repr() + ")");
		}
		//listeners.removeIf(x -> x.getCId() < 0);
	}

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

	public BooleanFormula cf(){
		return cfVar;
	}

	public BooleanFormula getCfCond(){
		return cfCond;
	}

	public void addCfCond(SolverContext ctx, BooleanFormula cond){
		cfCond = (cfCond == null) ? cond : ctx.getFormulaManager().getBooleanFormulaManager().or(cfCond, cond);
	}

	public BooleanFormula encodeCF(SolverContext ctx, BooleanFormula cond) {
		if(cfEnc == null){
			BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
			cfCond = (cfCond == null) ? cond : bmgr.or(cfCond, cond);
			cfEnc = bmgr.equivalence(cfVar, cfCond);
			cfEnc = bmgr.and(cfEnc, encodeExec(ctx));
		}
		return cfEnc;
	}

	protected BooleanFormula encodeExec(SolverContext ctx){
		return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
	}


	// =============== Utility methods ==================

	public boolean wasExecuted(Model model) {
		return model.evaluate(exec()).booleanValue();
	}

	public boolean wasInControlFlow(Model model) {
		return model.evaluate(cf()).booleanValue();
	}

	public boolean cfImpliesExec() {
		return cf() == exec();
	}

}