package dartagnan.program.event.lock;

import dartagnan.program.event.Fence;

public class RCULock extends Fence {

    public RCULock(){
        super("Rcu-lock");
    }
}
