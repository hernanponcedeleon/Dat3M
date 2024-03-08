package com.dat3m.dartagnan.parsers.program.visitors.spirv.utils;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuildIn;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MemoryTransformer extends ExprTransformer {

    private final int tid;
    private final Memory memory;
    private final BuildIn decoration;
    private final Map<String, List<String>> decorations;
    private final Map<Expression, Expression> mapping = new HashMap<>();

    public MemoryTransformer(int tid, Memory memory, BuildIn decoration,
                             Map<String, List<String>> decorations) {
        this.tid = tid;
        this.memory = memory;
        this.decoration = decoration;
        this.decorations = decorations;
    }

    @Override
    public Expression visit(MemoryObject memObj) {
        if (memObj.isThreadLocal() && !mapping.containsKey(memObj)) {
            MemoryObject copy = memory.allocate(memObj.size(), true);
            copy.setCVar(String.format("%s@T%s", memObj.getCVar(), tid));
            // TODO: Handle overrides in SpecConstants
            if (decorations.containsKey(memObj.getCVar())) {
                for (String decId : decorations.get(memObj.getCVar())) {
                    decoration.decorate(copy, decId);
                }
            } else {
                for (int i = 0; i < memObj.size(); i++) {
                    copy.setInitialValue(i, memObj.getInitialValue(i));
                }
            }
            mapping.put(memObj, copy);
        }
        return mapping.getOrDefault(memObj, memObj);
    }
}
