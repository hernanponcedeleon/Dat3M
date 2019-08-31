package com.dat3m.dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

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

    public abstract BoolExpr encode(Context ctx);
}