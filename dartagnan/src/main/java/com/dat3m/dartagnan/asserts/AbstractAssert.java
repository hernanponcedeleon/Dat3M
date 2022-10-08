package com.dat3m.dartagnan.asserts;

import java.util.List;

import com.dat3m.dartagnan.encoding.EncodingContext;
import org.sosy_lab.java_smt.api.BooleanFormula;

import com.dat3m.dartagnan.program.Register;

//TODO: None of the Assert classes implement equals or hashcode.
public abstract class AbstractAssert {

    public static final String ASSERT_TYPE_EXISTS = "exists";

    public static final String ASSERT_TYPE_NOT_EXISTS = "not exists";

    public static final String ASSERT_TYPE_FINAL = "final";

    public static final String ASSERT_TYPE_FORALL = "forall";

    private String type;

    public void setType(String type){
        this.type = type;
    }

    public String getType(){
        return type;
    }

    public boolean getInvert(){
        return type != null && (type.equals(ASSERT_TYPE_NOT_EXISTS) || type.equals(ASSERT_TYPE_FORALL));
    }

    public String toStringWithType(){
        if(type != null){
            AbstractAssert child = this;
            if(type.equals(ASSERT_TYPE_FORALL)){
                child = ((AssertNot)child).getChild();
            }
            return type + " (" + child + ")";
        }
        return toString();
    }

    public abstract BooleanFormula encode(EncodingContext context);
    
    public abstract List<Register> getRegs();
}