package com.dat3m.ui;

public enum Task {
	
	REACHABILITY, 
	PORTABILITY; 
	
    @Override
    public String toString() {
        switch(this){
            case REACHABILITY:
                return "Reachability";
            case PORTABILITY:
                return "Portability";
        }
        return super.toString();
    }
}