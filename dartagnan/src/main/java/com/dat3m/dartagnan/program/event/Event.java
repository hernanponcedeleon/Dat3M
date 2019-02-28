package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.*;

public abstract class Event implements Comparable<Event> {

	public static final int PRINT_PAD_EXTRA = 50;

	protected int oId = -1;		// ID after parsing (original)
	protected int uId = -1;		// ID after unrolling
	protected int cId = -1;		// ID after compilation

	protected final Set<String> filter;

	protected transient Event successor;
	private transient Event copy;

    protected transient BoolExpr cfEnc;
    protected transient BoolExpr cfCond;

	protected Event(){
		filter = new HashSet<>();
	}

	protected Event(Event other){
		this.oId = other.oId;
        this.uId = other.uId;
        this.cId = other.cId;
        this.filter = other.filter;
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

	public Event getSuccessor(){
		return successor;
	}

	public void setSuccessor(Event event){
		successor = event;
	}

	public LinkedList<Event> getSuccessors(){
		LinkedList<Event> result = successor != null
				? successor.getSuccessors()
				: new LinkedList<>();
		result.addFirst(this);
		return result;
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


	// Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    public int unroll(int bound, int nextId, Event predecessor) {
		uId = nextId++;
		if(successor != null){
			nextId = successor.unroll(bound, nextId, this);
		}
	    return nextId;
    }

    public void resetCopy(){
		copy = null;
		if(successor != null){
			successor.resetCopy();
		}
    }

    public Event getCopy(){
        if(copy == null){
            copy = mkCopy();
        }
        return copy;
    }

    protected abstract Event mkCopy();


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    public int compile(Arch target, int nextId, Event predecessor) {
		cId = nextId++;
		if(successor != null){
			return successor.compile(target, nextId, this);
		}
        return nextId;
    }

    protected int compileSequence(Arch target, int nextId, Event predecessor, LinkedList<Event> sequence){
        for(Event e : sequence){
        	e.oId = oId;
			e.uId = uId;
            e.cId = nextId++;
            predecessor.setSuccessor(e);
            predecessor = e;
        }
        if(successor != null){
            predecessor.successor = successor;
            return successor.compile(target, nextId, predecessor);
        }
        return nextId;
    }


	// Encoding
	// -----------------------------------------------------------------------------------------------------------------

	public void initialise(Context ctx){}

	public String repr() {
		if(cId > -1){
			return "E" + cId;
		}
		throw new RuntimeException("Event ID is not set in " + this);
	}

	public BoolExpr executes(Context ctx) {
		if(cId > -1){
			return ctx.mkBoolConst("ex(" + repr() + ")");
		}
		throw new RuntimeException("Event ID is not set in " + this);
	}

	public String cfVar(){
		if(cId > -1){
			return "CF_" + cId;
		}
		throw new RuntimeException("Event ID is not set in " + this);
	}

	public void addCfCond(Context ctx, BoolExpr cond){
		cfCond = (cfCond == null) ? cond : ctx.mkOr(cfCond, cond);
	}

	public BoolExpr encodeCF(Context ctx, BoolExpr cond) {
		if(cfEnc == null){
			cfCond = (cfCond == null) ? cond : ctx.mkOr(cfCond, cond);
			BoolExpr var = ctx.mkBoolConst(cfVar());
			cfEnc = ctx.mkEq(var, cfCond);
			cfEnc = ctx.mkAnd(cfEnc, encodeExec(ctx));
			if(successor != null){
				cfEnc = ctx.mkAnd(cfEnc, successor.encodeCF(ctx, var));
			}
		}
		return cfEnc;
	}

	protected BoolExpr encodeExec(Context ctx){
		return ctx.mkEq(ctx.mkBoolConst(cfVar()), executes(ctx));
	}
}