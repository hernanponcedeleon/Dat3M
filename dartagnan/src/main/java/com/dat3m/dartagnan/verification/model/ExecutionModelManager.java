package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.model.event.EventModelManager;
import com.dat3m.dartagnan.verification.model.relation.RelationModelManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.math.BigInteger;
import java.util.List;


public class ExecutionModelManager {
    private final ExecutionModelNext executionModel;
    private final EventModelManager eMManager;
    private final RelationModelManager rMManager;

    private final ExecutionModel oldModel; // old one for CAAT use

    private ExecutionModelManager(EncodingContext encodingContext) throws InvalidConfigurationException {
        executionModel = new ExecutionModelNext(encodingContext);

        oldModel = ExecutionModel.withContext(encodingContext);

        eMManager = EventModelManager.newEMManager(executionModel);
        rMManager = RelationModelManager.newRMManager(executionModel, oldModel);
    }

    public static ExecutionModelManager newManager(EncodingContext encodingContext)
        throws InvalidConfigurationException
    {
        return new ExecutionModelManager(encodingContext);
    }

    public ExecutionModelNext getExecutionModel() {
        return executionModel;
    }

    public ExecutionModel getOldModel() {
        return oldModel;
    }

    public void setContextWithFullWmm(EncodingContext context) {
        executionModel.setContextWithFullWmm(context);
    }

    public ExecutionModelNext initializeModel(Model model) {
        oldModel.initialize(model);

        executionModel.clear();
        executionModel.setModel(model);
        eMManager.initialize();
        extractMemoryLayout();
        rMManager.initialize();

        executionModel.setManager(this);
        return executionModel;
    }

    public void extractRelations(List<String> relationNames) {
        rMManager.extractRelations(relationNames);
    }

    private void extractMemoryLayout() {
        for (MemoryObject obj : executionModel.getProgram().getMemory().getObjects()) {
            final boolean isAllocated = obj.isStaticallyAllocated()
                                        || executionModel.isTrue(
                executionModel.getEncodingContext().execution(obj.getAllocationSite())
            );
            if (isAllocated) {
                final BigInteger address = (BigInteger) executionModel.evaluateByModel(
                    executionModel.getEncodingContext().address(obj)
                );
                final BigInteger size = (BigInteger) executionModel.evaluateByModel(
                    executionModel.getEncodingContext().size(obj)
                );
                executionModel.addMemoryObject(obj, new MemoryObjectModel(obj, address, size));
            }
        }
    }
}