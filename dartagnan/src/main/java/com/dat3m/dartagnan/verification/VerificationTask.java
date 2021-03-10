package com.dat3m.dartagnan.verification;

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



}
