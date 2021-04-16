package com.dat3m.dartagnan.verification;

import com.microsoft.z3.Context;

// Not used yet. Maybe we will use it sometime.

public class VerificationContext {
    
	private VerificationTask task;
    private Context z3Context;

    public VerificationContext(VerificationTask task, Context context) {
        this.task = task;
        this.z3Context = context;
    }
}