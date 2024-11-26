package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.model.event.EventModelManager;
import com.dat3m.dartagnan.verification.model.relation.RelationModelManager;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.Model;

import java.math.BigInteger;
import java.util.List;


public class ExecutionModelManager {
    private final EventModelManager eMManager;
    private final RelationModelManager rMManager;

    private EncodingContext context;
    private Model model;
    private ExecutionModelNext executionModel;

    public ExecutionModelManager(){
        eMManager = new EventModelManager(this);
        rMManager = new RelationModelManager(this);
    }

    public ExecutionModelNext buildExecutionModel(EncodingContext context, Model model) {
        if (this.context != null && this.model != null) {
            if (this.context == context && this.model == model) {
                return executionModel;
            }
        }

        this.context = context;
        this.model = model;
        executionModel = new ExecutionModelNext(this);

        eMManager.buildEventModels(executionModel, context);
        extractMemoryLayout();
        rMManager.buildRelationModels(executionModel, context);

        return executionModel;
    }

    public EncodingContext getContext() {
        return context;
    }

    public boolean isTrue(BooleanFormula formula) {
        return Boolean.TRUE.equals(model.evaluate(formula));
    }

    public Object evaluateByModel(Formula formula) {
        return model.evaluate(formula);
    }

    public void extractRelations(List<String> relationNames) {
        rMManager.extractRelations(relationNames);
    }

    private void extractMemoryLayout() {
        for (MemoryObject obj : context.getTask().getProgram().getMemory().getObjects()) {
            final boolean isAllocated = obj.isStaticallyAllocated()
                                        || isTrue(context.execution(obj.getAllocationSite()));
            if (isAllocated) {
                final BigInteger address = (BigInteger) evaluateByModel(context.address(obj));
                final BigInteger size = (BigInteger) evaluateByModel(context.size(obj));
                executionModel.addMemoryObject(obj, new MemoryObjectModel(obj, address, size));
            }
        }
    }
}