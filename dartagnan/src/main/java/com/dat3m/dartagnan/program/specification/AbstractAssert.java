package com.dat3m.dartagnan.program.specification;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.Set;

public abstract class AbstractAssert {

    public static final String ASSERT_TYPE_EXISTS = "exists";
    public static final String ASSERT_TYPE_NOT_EXISTS = "not exists";
    public static final String ASSERT_TYPE_FORALL = "forall";

    private String type;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public boolean isSafetySpec() {
        // "Forall" queries are safety specs, while existential ones are not.
        return ASSERT_TYPE_FORALL.equals(type) || ASSERT_TYPE_NOT_EXISTS.equals(type);
    }

    public String toStringWithType() {
        return type != null ? (type + " (" + this + ")") : toString();
    }

    public abstract BooleanFormula encode(EncodingContext context);

    public abstract Set<Register> getRegisters();

    public abstract Set<MemoryObject> getMemoryObjects();
}