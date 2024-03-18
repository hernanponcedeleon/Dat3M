package com.dat3m.dartagnan.parsers.program.visitors.spirv.transformers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.LeafExpression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.HashMap;
import java.util.Map;

public class MemoryTransformer extends ExprTransformer {

    private final int tid;
    private final Memory memory;
    private final Map<String, Type> types;
    private final BuiltIn builtInDecoration;
    private final Map<Expression, Expression> mapping = new HashMap<>();

    public MemoryTransformer(int tid, Memory memory, Map<String, Type> types, BuiltIn builtInDecoration) {
        this.tid = tid;
        this.memory = memory;
        this.types = types;
        this.builtInDecoration = builtInDecoration;
    }

    @Override
    public Expression visitLeafExpression(LeafExpression expr) {
        if (expr instanceof MemoryObject memObj) {
            if (memObj.isThreadLocal() && !mapping.containsKey(memObj)) {
                MemoryObject copy = memory.allocate(memObj.size(), true);
                copy.setCVar(String.format("%s@T%s", memObj.getCVar(), tid));
                for (int i = 0; i < memObj.size(); i++) {
                    copy.setInitialValue(i, memObj.getInitialValue(i));
                }
                builtInDecoration.decorate(memObj.getCVar(), copy, types.get(memObj.getCVar()));
                mapping.put(memObj, copy);
            }
            return mapping.getOrDefault(memObj, memObj);
        }
        return expr;
    }
}
