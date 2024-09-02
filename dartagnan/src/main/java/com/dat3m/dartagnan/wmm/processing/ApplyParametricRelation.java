package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.definition.Parametric;
import com.dat3m.dartagnan.wmm.definition.ParametricCall;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class ApplyParametricRelation implements WmmProcessor{
    private ApplyParametricRelation() {
    }

    public static WmmProcessor newInstance() {
        return new ApplyParametricRelation();
    }

    @Override
    public void run(Wmm wmm) {
        Set<ParametricCall> parametricCalls = wmm.getRelations().stream()
                .filter(rel -> rel.getDefinition() instanceof ParametricCall)
                .map(rel -> (ParametricCall) rel.getDefinition())
                .filter(call -> !call.getParametric().getDefinedRelation().getDefinition().withoutParametricCall())
                .collect(Collectors.toSet());
        while (!parametricCalls.isEmpty()) {
            for (ParametricCall parametricCall : List.copyOf(parametricCalls)) {
                applyParametricCall(wmm, parametricCall);
                wmm.removeDefinition(parametricCall.getDefinedRelation());
            }
            parametricCalls = wmm.getRelations().stream()
                    .filter(rel -> rel.getDefinition() instanceof ParametricCall)
                    .map(rel -> (ParametricCall) rel.getDefinition())
                    .filter(call -> call.getParametric().getDefinedRelation().getDefinition().withoutParametricCall())
                    .collect(Collectors.toSet());
        }
    }

    private void applyParametricCall(Wmm wmm, ParametricCall parametricCall) {
        Parametric parametric = parametricCall.getParametric();
        Object parameterInput = parametricCall.getParameter();
        Object parameterDummy = parametric.getParameterDummy();
        Definition defWithDummy = parametric.getDefinedRelation().getDefinition();
        Definition defWithInput = defWithDummy.updateComponents(wmm, parameterDummy, parameterInput);
        List<Axiom> axioms = wmm.getConstraints().stream().filter(c -> c instanceof Axiom).toList().stream()
                .map(c -> (Axiom) c).toList();
        for (Axiom axiom : axioms) {
            Definition axiomDef = axiom.getRelation().getDefinition();
            Definition newAxiomDef = (axiom.getRelation() == parametricCall.getDefinedRelation()) ? defWithInput
                    : axiomDef.updateComponents(wmm, parametricCall.getDefinedRelation(), defWithInput.getDefinedRelation());
            Axiom newAxiom = axiom.copy(newAxiomDef.getDefinedRelation());
            if (newAxiom.getRelation() != axiom.getRelation()) {
                String name = axiom.getName();
                wmm.removeConstraint(axiom);
                newAxiom.setName(name);
                wmm.addConstraint(newAxiom);
            }
        }
    }
}
