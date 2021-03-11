package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Irreflexive;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelCo;
import com.dat3m.dartagnan.wmm.relation.unary.RelTrans;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.*;

import static com.dat3m.dartagnan.utils.Result.PASS;

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


    private BranchEquivalence branchEquivalence;
    public BranchEquivalence getBranchEquivalence() {
        if (branchEquivalence == null) {
            branchEquivalence = new BranchEquivalence(program);
        }
        return branchEquivalence;
    }

    private DependencyGraph<Relation> relationDependencyGraph;
    public DependencyGraph<Relation> getRelationDependencyGraph() {
        if (relationDependencyGraph == null) {
            relationDependencyGraph = DependencyGraph.from(getRelations());
        }
        return relationDependencyGraph;
    }


    // ===================== Utility Methods ====================

    public void unrollAndCompile() {
        program.simplify();
        program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        // AssertionInline depends on compiled events (copies)
        // Thus we need to update the assertion after compilation
        program.updateAssertion();
    }

    public BoolExpr encodeProgram(Context ctx) {
        BoolExpr cfEncoding = program.encodeCF(ctx);
        BoolExpr finalRegValueEncoding = program.encodeFinalRegisterValues(ctx);
        return ctx.mkAnd(cfEncoding, finalRegValueEncoding);
    }

    public BoolExpr encodeWmmCore(Context ctx) {
        return memoryModel.encodeCore(program, ctx, settings);
    }

    public BoolExpr encodeWmmRelations(Context ctx) {
        return memoryModel.encode(program, ctx, settings);
    }

    public BoolExpr encodeWmmRelationsWithoutCo(Context ctx) {
        return memoryModel.encodeEmptyCo(program, ctx, settings);
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
