package com.dat3m.dartagnan.program.event.lang.catomic.utils;

public class Tag {

    public static final String RELAXED  		= "memory_order_relaxed";
    public static final String CONSUME  		= "memory_order_consume";
    public static final String ACQUIRE  		= "memory_order_acquire";
    public static final String RELEASE  		= "memory_order_release";
    public static final String ACQUIRE_RELEASE  = "memory_order_acq_rel";
    public static final String SC       		= "memory_order_seq_cst";
    
    public static String intToMo(int i) {
    	switch(i) {
    	case 0: return RELAXED;
    	case 1: return CONSUME;
    	case 2: return ACQUIRE;
    	case 3: return RELEASE;
    	case 4: return ACQUIRE_RELEASE;
    	case 5: return SC;
        default:
        	throw new UnsupportedOperationException("The memory order is not recognized");

    	}
    }

	
}
