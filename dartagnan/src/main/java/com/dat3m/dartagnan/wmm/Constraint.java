package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.*;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.EventGraph;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.Collection;
import java.util.Map;
import java.util.Set;

public interface Constraint {

    Collection<? extends Relation> getConstrainedRelations();

    <T> T accept(Constraint.Visitor<? extends T> visitor);

    default Map<Relation, RelationAnalysis.ExtendedDelta> computeInitialKnowledgeClosure(
            Map<Relation, RelationAnalysis.Knowledge> knowledgeMap,
            Context analysisContext) {
        return Map.of();
    }

    default Map<Relation, RelationAnalysis.ExtendedDelta> computeIncrementalKnowledgeClosure(
            Relation origin,
            EventGraph disabled,
            EventGraph enabled,
            Map<Relation, RelationAnalysis.Knowledge> knowledgeMap,
            Context analysisContext) {
        return Map.of();
    }

    default Map<Relation, EventGraph> getEncodeGraph(VerificationTask task, Context analysisContext) {
        return Map.of();
    }

    /**
     * Encodes the relational information of this constraint.
     *
     * @param context Provides shared elements of the current verification problem and their encoding representations.
     * @return Each model representing a consistent execution has to meet all of those assumptions.
     */
    default Collection<BooleanFormula> consistent(EncodingContext context) {
        return Set.of();
    }


    interface Visitor<T> {

        private static void error(Visitor<?> visitor, Constraint c) {
            final String error = String.format("Visitor %s does not support constraint %s",
                    visitor.getClass().getSimpleName(), c.getClass().getSimpleName());
            throw new UnsupportedOperationException(error);
        }

        default T visitConstraint(Constraint constraint) {
            error(this, constraint);
            return null;
        }

        // -------------------------- Axioms --------------------------
        default T visitAxiom(Axiom axiom) { return visitConstraint(axiom); }
        default T visitEmptiness(Emptiness axiom) { return visitAxiom(axiom); }
        default T visitIrreflexivity(Irreflexivity axiom) { return visitAxiom(axiom); }
        default T visitAcyclicity(Acyclicity axiom) { return visitAxiom(axiom); }

        // -------------------------- Misc --------------------------
        default T visitAssumption(Assumption assume) { return visitConstraint(assume); }
        default T visitForceEncodeAxiom(ForceEncodeAxiom forceEncode) { return visitConstraint(forceEncode); }

        // -------------------------- Definitions --------------------------
        // Derived
        default T visitDefinition(Definition def) { return visitConstraint(def); }
        default T visitUnion(Union def) { return visitDefinition(def); }
        default T visitIntersection(Intersection def) { return visitDefinition(def); }
        default T visitDifference(Difference def) { return visitDefinition(def); }
        default T visitComposition(Composition def) { return visitDefinition(def); }
        default T visitDomainIdentity(DomainIdentity def) { return visitDefinition(def); }
        default T visitRangeIdentity(RangeIdentity def) { return visitDefinition(def); }
        default T visitInverse(Inverse def) { return visitDefinition(def); }
        default T visitTransitiveClosure(TransitiveClosure def) { return visitDefinition(def); }
        // These three are semi-derived (they are derived from sets/filters and not from relations).
        default T visitSetIdentity(SetIdentity def) { return visitDefinition(def); }
        default T visitProduct(CartesianProduct def) { return visitDefinition(def); }
        default T visitFences(Fences fence) { return visitDefinition(fence); }

        // Base
        default T visitUndefined(Definition.Undefined def) { return visitDefinition(def); }
        default T visitFree(Free def) { return visitDefinition(def); }
        default T visitEmpty(Empty def) { return visitDefinition(def); }
        default T visitProgramOrder(ProgramOrder po) { return visitDefinition(po); }
        default T visitExternal(External ext) { return visitDefinition(ext); }
        default T visitInternal(Internal internal) { return visitDefinition(internal); }
        default T visitInternalDataDependency(DirectDataDependency idd) { return visitDefinition(idd); }
        default T visitControlDependency(DirectControlDependency ctrlDirect) { return visitDefinition(ctrlDirect); }
        default T visitAddressDependency(DirectAddressDependency addrDirect) { return visitDefinition(addrDirect); }
        default T visitReadModifyWrites(ReadModifyWrites rmw) { return visitDefinition(rmw); }
        default T visitCoherence(Coherence co) { return visitDefinition(co); }
        default T visitSameLocation(SameLocation loc) { return visitDefinition(loc); }
        default T visitReadFrom(ReadFrom rf) { return visitDefinition(rf); }
        // --- Target-specific definitions
        default T visitCASDependency(CASDependency casDep) { return visitDefinition(casDep); } // IMM
        default T visitLinuxCriticalSections(LinuxCriticalSections rscs) { return visitDefinition(rscs); } // Linux
        // ------ GPU definitions
        default T visitSameVirtualLocation(SameVirtualLocation vloc) { return visitDefinition(vloc); }
        default T visitSameScope(SameScope sc) { return visitDefinition(sc); }
        default T visitSyncBarrier(SyncBar sync_bar){ return visitDefinition(sync_bar); }
        default T visitSyncFence(SyncFence sync_fen){ return visitDefinition(sync_fen); }
        default T visitSyncWith(SyncWith sync_with){ return visitDefinition(sync_with); }
    }
}
