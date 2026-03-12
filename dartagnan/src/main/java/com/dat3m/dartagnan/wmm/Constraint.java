package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.axiom.Irreflexivity;
import com.dat3m.dartagnan.wmm.definition.*;

import java.util.List;

public interface Constraint {

    // Note: Can contain the same relation multiple times
    List<? extends Relation> getConstrainedRelations();

    <T> T accept(Constraint.Visitor<? extends T> visitor);



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

        // -------------------------- Definitions --------------------------
        // Derived
        default T visitDefinition(Definition def) { return visitConstraint(def); }
        default T visitUnion(Union def) { return visitDefinition(def); }
        default T visitIntersection(Intersection def) { return visitDefinition(def); }
        default T visitDifference(Difference def) { return visitDefinition(def); }
        default T visitComposition(Composition def) { return visitDefinition(def); }
        default T visitProjection(Projection def) { return visitDefinition(def); }
        default T visitInverse(Inverse def) { return visitDefinition(def); }
        default T visitTransitiveClosure(TransitiveClosure def) { return visitDefinition(def); }
        default T visitSetIdentity(SetIdentity def) { return visitDefinition(def); }
        default T visitProduct(CartesianProduct def) { return visitDefinition(def); }

        // Base
        default T visitUndefined(Definition.Undefined def) { return visitDefinition(def); }
        default T visitFree(Free def) { return visitDefinition(def); }
        default T visitEmpty(Empty def) { return visitDefinition(def); }
        default T visitTagSet(TagSet def) { return visitDefinition(def); }
        default T visitProgramOrder(ProgramOrder po) { return visitDefinition(po); }
        default T visitExternal(External ext) { return visitDefinition(ext); }
        default T visitInternal(Internal internal) { return visitDefinition(internal); }
        default T visitSameInstruction(SameInstruction si) { return visitDefinition(si); }
        default T visitAMOPairs(AMOPairs amo) { return visitDefinition(amo); }
        default T visitLXSXPairs(LXSXPairs lxsx) { return visitDefinition(lxsx); }
        default T visitCoherence(Coherence co) { return visitDefinition(co); }
        default T visitSameLocation(SameLocation loc) { return visitDefinition(loc); }
        default T visitReadFrom(ReadFrom rf) { return visitDefinition(rf); }
        // ----- Internal (not directly accessible from CAT)
        default T visitInternalDataDependency(DirectDataDependency idd) { return visitDefinition(idd); }
        default T visitControlDependency(DirectControlDependency ctrlDirect) { return visitDefinition(ctrlDirect); }
        default T visitAddressDependency(DirectAddressDependency addrDirect) { return visitDefinition(addrDirect); }
        // ----- Target-specific definitions
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
