package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.encoding.Encoder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.verification.Context;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.*;

public interface Event extends Encoder, Comparable<Event> {

	int PRINT_PAD_EXTRA = 50;

	int getOId();
	void setOId(int id);

	int getUId();
	void setUId(int id);

	int getCId();
	void setCId(int id);

	// TODO: This should be called "LId" (localId) and be set once after all processing is done.
	int getFId();
	void setFId(int id);

	int getCLine();
	void setCLine(int line);

	Event getSuccessor();
	void setSuccessor(Event event);

	Thread getThread();
	void setThread(Thread thread);

	default List<Event> getSuccessors(){
		List<Event> events = new ArrayList<>();
		Event cur = this;
		while (cur != null) {
			events.add( cur);
			cur = cur.getSuccessor();
		}

		return events;
	}

	boolean is(String param);

	void addFilters(String... params);

	boolean hasFilter(String f);

    void addListener(Event e);

    Set<Event> getListeners();

    default void notify(Event e) {
    	throw new UnsupportedOperationException("notify is not allowed for " + getClass().getSimpleName());
    }



	// Unrolling
    // -----------------------------------------------------------------------------------------------------------------

	default Event getCopy(){
		throw new UnsupportedOperationException("Copying is not allowed for " + getClass().getSimpleName());
	}

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

	default List<Event> compile(Arch target) {
		return Collections.singletonList(this);
	}

	default void delete(Event pred) {
		if (pred != null) {
			pred.setSuccessor(getSuccessor());
		}
	}

	// Encoding
	// -----------------------------------------------------------------------------------------------------------------

	default void initializeEncoding(SolverContext ctx) {
	}

	default void runLocalAnalysis(Program program, Context context) {
	}

	String repr();

	default BooleanFormula exec(){
		return cf();
	}

	BooleanFormula cf();
	void setCfVar(BooleanFormula cfVar);

	// This method needs to get overwritten for conditional events.
	default boolean cfImpliesExec() {
		return true;
	}

	default BooleanFormula encodeExec(SolverContext ctx){
		return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
	}

	// =============== Utility methods ==================

	default boolean wasExecuted(Model model) {
		Boolean expr = model.evaluate(exec());
		return expr != null && expr;
	}

	default boolean wasInControlFlow(Model model) {
		Boolean expr = model.evaluate(cf());
		return expr != null && expr;
	}


}