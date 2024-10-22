package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.verification.model.relation.RelationModelManager;

import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.*;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;


public class ExecutionModelManager {
    private final ExecutionModel model;
    private final RelationModelManager rmManager;
    private final Set<String> necessaryRelations;

    private ExecutionModelManager(ExecutionModel model) {
        this.model = model;
        rmManager = RelationModelManager.newRMManager(model);
        necessaryRelations = new HashSet<>(Set.of(PO, RF, CO));
    }

    public static ExecutionModelManager newManager(EncodingContext context)
            throws InvalidConfigurationException{
        ExecutionModel m = ExecutionModel.withContext(context);
        return new ExecutionModelManager(m);
    }

    public ExecutionModel getExecutionModel() { return model; }

    public ExecutionModelManager setEncodingContextForWitness(EncodingContext c) {
        model.setEncodingContextForWitness(c);
        return this;
    }

    public ExecutionModel initializeModel(Model m) {
        model.initialize(m, this);
        extractRelations(new ArrayList<>(necessaryRelations));
        return model;
    }

    public void extractRelations(List<String> relNames) {
        rmManager.extractRelations(relNames);
    }
}