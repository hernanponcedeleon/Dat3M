package dartagnan.program.event.lock;

import dartagnan.program.event.Fence;

public class RCUUnlock extends Fence {

    private RCULock lockEvent;

    public RCUUnlock(RCULock lockEvent){
        super("Rcu-unlock");
        this.lockEvent = lockEvent;
    }

    public RCULock getLockEvent(){
        return lockEvent;
    }
}
