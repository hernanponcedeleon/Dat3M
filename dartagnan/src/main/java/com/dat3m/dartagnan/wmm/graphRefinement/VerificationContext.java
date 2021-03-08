package com.dat3m.dartagnan.wmm.graphRefinement;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Irreflexive;
import com.dat3m.dartagnan.wmm.graphRefinement.analysis.BranchEquivalence;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.AxiomData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.WmmMap;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelCo;
import com.dat3m.dartagnan.wmm.relation.unary.RelTrans;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.*;

/*
Represents a verification task.

Note: For now, it uses a custom representation for relations and axioms, which
is computed once on construction. Later changes to the WMM are not dynamically reflected.
 */
public class VerificationContext {
    private final Program program;
    private final Wmm memoryModel;
    private final Arch target;
    private final Settings settings;
    // Here we enhance relations/axioms for now (these enhancements might get integrated into relation/axiom later)
    private final WmmMap wmmMap;



    public VerificationContext(Program program, Wmm memoryModel, Arch target, Settings settings) {
        this.program = program;
        this.memoryModel = memoryModel;
        this.target = target;
        this.settings = settings;
        this.wmmMap = WmmMap.fromMemoryModel(memoryModel);
    }

    public Program getProgram() { return program; }
    public Wmm getMemoryModel() { return memoryModel; }
    public Arch getTarget() { return target; }
    public Settings getSettings() { return settings; }
    public Collection<RelationData> getRelations() { return wmmMap.getRelationValues();}
    public Collection<AxiomData> getAxioms() { return wmmMap.getAxiomValues(); }


    private BranchEquivalence branchEquivalence;
    public BranchEquivalence getBranchEquivalence() {
        if (branchEquivalence == null) {
            branchEquivalence = new BranchEquivalence(program);
        }
        return branchEquivalence;
    }

    public DependencyGraph<RelationData> computeRelationDependencyGraph() {
        return DependencyGraph.from(getRelations());
    }


    public RelationData addNontransitiveWriteOrder() {
        // Add new non-transitive coherence relation "_co" (if not already present)
        Relation wo = new RelCo(false);
        if (wmmMap.contains(wo))
            return wmmMap.get(wo);

        RelationData writeOrder = wmmMap.get(wo);
        wmmMap.get(memoryModel.getRelationRepository().getRelation("co")).addDependency(writeOrder);
        return writeOrder;
    }

    public void replaceAcyclicityAxioms() {
        // Replace acyclicity axioms by irreflexivity axioms
        for (AxiomData axiom : getAxioms().toArray(new AxiomData[0])) {
            if (axiom.isAcyclicity()) {
                wmmMap.remove(axiom);

                RelationData transClosure =  wmmMap.get(new RelTrans(axiom.getWrappedRelation()));
                transClosure.initialize();

                AxiomData irrAxiom = wmmMap.get(new Irreflexive(transClosure.getWrappedRelation()));
                irrAxiom.initialize();
            }
        }
    }



}
