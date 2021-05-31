package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.*;

/*
Represents a verification task.
 */

public class VerificationTask {

    private static final Logger logger = LogManager.getLogger(VerificationTask.class);

    private final Program program;
    private final Wmm memoryModel;
    private final WitnessGraph witness;
    private final Arch target;
    private final Settings settings;

    public VerificationTask(Program program, Wmm memoryModel, Arch target, Settings settings) {
    	this(program, memoryModel, new WitnessGraph(), target, settings);
    }
    
    public VerificationTask(Program program, Wmm memoryModel, WitnessGraph witness, Arch target, Settings settings) {
        this.program = program;
        this.memoryModel = memoryModel;
        this.witness = witness;
        this.target = target;
        this.settings = settings;
    }

    public Program getProgram() {
    	return program;
    }
    
    public Wmm getMemoryModel() {
    	return memoryModel;
    }
    
    public WitnessGraph getWitness() {
    	return witness;
    }
    
    public Arch getTarget() {
    	return target;
    }
    
    public Settings getSettings() {
    	return settings;
    }

    public Set<Relation> getRelations() {
    	return memoryModel.getRelationRepository().getRelations();
    }

    public List<Axiom> getAxioms() {
    	return memoryModel.getAxioms();
    }

    public BranchEquivalence getBranchEquivalence() {
        return program.getBranchEquivalence();
    }

    public DependencyGraph<Relation> getRelationDependencyGraph() {
        return memoryModel.getRelationDependencyGraph();
    }


    // ===================== Utility Methods ====================

    public void unrollAndCompile() {
        logger.info("#Events: " + program.getEvents().size());
        if (GlobalSettings.PERFORM_DEAD_CODE_ELIMINATION) {
            program.eliminateDeadCode();
            logger.info("#Events after DCE: " + program.getEvents().size());
        }
        if (GlobalSettings.PERFORM_REORDERING) {
            program.reorder();
            logger.info("Events reordered");
        }
        program.simplify();
        program.unroll(settings.getBound(), 0);
        program.compile(target, 0);

        if (GlobalSettings.ENABLE_DEBUG_OUTPUT) {
            for (Thread t : program.getThreads()) {
                System.out.println("========== Thread " + t.getId() + " ==============");
                for (Event e : t.getEntry().getSuccessors()) {
                    String indent = ((e instanceof Label) ? "" : "   ");
                    //TODO(TH): why this print?
                    // Answer(TH): why not? I use it for inspecting the final program (after all transformations)
                    // HP: I think we should avoid printf ... I this is useful for us for inspection, maybe log it 
                    // (that is the whole idea of the logger, that we can using for debugging, but switch it off for the normal user)
                    System.out.printf("%4d: %s%s%n", e.getCId(), indent, e);
                }
            }
        }
        // AssertionInline depends on compiled events (copies)
        // Thus we need to update the assertion after compilation
        program.updateAssertion();
    }

    public void initialiseEncoding(Context ctx) {
        program.initialise(this, ctx);
        memoryModel.initialise(this, ctx);
    }

    public BoolExpr encodeProgram(Context ctx) {
        BoolExpr cfEncoding = program.encodeCF(ctx);
        BoolExpr finalRegValueEncoding = program.encodeFinalRegisterValues(ctx);
        return ctx.mkAnd(cfEncoding, finalRegValueEncoding);
    }

    public BoolExpr encodeWmmCore(Context ctx) {
        return memoryModel.encodeCore(ctx);
    }

    public BoolExpr encodeWmmRelations(Context ctx) {
        return memoryModel.encode( ctx);
    }

    public BoolExpr encodeWmmConsistency(Context ctx) {
        return memoryModel.consistent(ctx);
    }

    public BoolExpr encodeAssertions(Context ctx) {
        BoolExpr assertionEncoding = program.getAss().encode(ctx);
        if (program.getAssFilter() != null) {
            assertionEncoding = ctx.mkAnd(assertionEncoding, program.getAssFilter().encode(ctx));
        }
        return assertionEncoding;
    }

    public BoolExpr encodeWitness(Context ctx) {
    	return witness.encode(program, ctx);
    }
}
