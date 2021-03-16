package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.*;

/*
Represents a verification task.
 */
public class VerificationTask {
    private final Program program;
    private final Wmm memoryModel;
    private final Arch target;
    private final Settings settings;

    public VerificationTask(Program program, Wmm memoryModel, Arch target, Settings settings) {
        this.program = program;
        this.memoryModel = memoryModel;
        this.target = target;
        this.settings = settings;
    }

    public Program getProgram() { return program; }
    public Wmm getMemoryModel() { return memoryModel; }
    public Arch getTarget() { return target; }
    public Settings getSettings() { return settings; }


    public Set<Relation> getRelations() { return memoryModel.getRelationRepository().getRelations();}
    public List<Axiom> getAxioms() { return memoryModel.getAxioms(); }


    public BranchEquivalence getBranchEquivalence() {
        return program.getBranchEquivalence();
    }

    public DependencyGraph<Relation> getRelationDependencyGraph() {
        return memoryModel.getRelationDependencyGraph();
    }


    // ===================== Utility Methods ====================

    public void unrollAndCompile() {
        program.simplify();
        program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        program.eliminateDeadCode();
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

    public BoolExpr encodeWmmRelationsWithoutCo(Context ctx) {
        return memoryModel.encodeEmptyCo(ctx);
    }

    public BoolExpr encodeWmmConsistency(Context ctx) {
        return memoryModel.consistent(program, ctx);
    }

    public BoolExpr encodeAssertions(Context ctx) {
        BoolExpr assertionEncoding = program.getAss().encode(ctx);
        if (program.getAssFilter() != null) {
            assertionEncoding = ctx.mkAnd(program.getAssFilter().encode(ctx));
        }
        return assertionEncoding;
    }



}
