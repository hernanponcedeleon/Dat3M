package dartagnan.program.event;

import dartagnan.expression.ExprInterface;
import dartagnan.program.memory.Location;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.utils.EType;

import java.util.HashSet;
import java.util.Set;

public class Write extends MemEvent implements RegReaderData {

    protected ExprInterface value;

	public Write(Location loc, ExprInterface value, String atomic){
		this.value = value;
		this.loc = loc;
		this.atomic = atomic;
		this.condLevel = 0;
		this.memId = hashCode();
		addFilters(EType.ANY, EType.MEMORY, EType.WRITE);
	}

    @Override
    public Set<Register> getDataRegs(){
        Set<Register> regs = new HashSet<>();
        if(value instanceof Register){
            regs.add((Register) value);
        }
        return regs;
    }

	@Override
	public String toString() {
		return nTimesCondLevel() + loc + ".store(" +  value + "," + atomic + ")";
	}

	@Override
	public Write clone() {
		if(clone == null){
			clone = new Write(loc.clone(), value.clone(), atomic);
			afterClone();
		}
		return (Write)clone;
	}

	@Override
	public Thread compile(String target, boolean ctrl, boolean leading) {
		return _compile(new Store(loc, value, atomic), target, ctrl, leading);
	}

	protected Thread _compile(Store st, String target, boolean ctrl, boolean leading) {
		st.setHLId(memId);
		st.setUnfCopy(getUnfCopy());
		st.setCondLevel(this.condLevel);

		if(!target.equals("power") && !target.equals("arm") && atomic.equals("_sc")) {
            Fence mfence = new Fence("Mfence", this.condLevel);
			return new Seq(st, mfence);
		}
		
		if(!target.equals("power") && !target.equals("arm")) {
			return st;
		}
		
		if(target.equals("power")) {
            if(atomic.equals("_rx") || atomic.equals("_na")) {
                return st;
            }

            Fence lwsync = new Fence("Lwsync", this.condLevel);
            if(atomic.equals("_rel")) {
                return new Seq(lwsync, st);
            }

            if(atomic.equals("_sc")) {
				Fence sync = new Fence("Sync", this.condLevel);
				if(leading) {
					return new Seq(sync, st);
				}
				return new Seq(lwsync, new Seq(st, sync));
			}
		}

		if(target.equals("arm")) {
            if(atomic.equals("_rx") || atomic.equals("_na")) {
                return st;
            }

            Fence ish1 = new Fence("Ish", this.condLevel);
            if(atomic.equals("_rel")) {
                return new Seq(ish1, st);
            }

            Fence ish2 = new Fence("Ish", this.condLevel);
			if(atomic.equals("_sc")) {
				return new Seq(ish1, new Seq(st, ish2));
			}
		}

		throw new RuntimeException("Compilation is not supported for " + this);
	}
}