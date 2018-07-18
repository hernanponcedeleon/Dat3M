package dartagnan.program.event;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.expression.AConst;
import dartagnan.program.*;
import dartagnan.program.Thread;
import dartagnan.program.event.filter.FilterUtils;
import dartagnan.utils.LastModMap;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

public class Write extends MemEvent {

	private AConst val;
	private Register reg;
	
	public Write(Location loc, Register reg, String atomic) {
		this.reg = reg;
		this.loc = loc;
		this.atomic = atomic;
		this.condLevel = 0;
		this.memId = hashCode();
		addFilters(
				FilterUtils.EVENT_TYPE_ANY,
				FilterUtils.EVENT_TYPE_MEMORY,
				FilterUtils.EVENT_TYPE_WRITE
		);
	}

    public Write(Location loc, AConst val, String atomic) {
        this.val = val;
        this.loc = loc;
        this.atomic = atomic;
        this.condLevel = 0;
        this.memId = hashCode();
		addFilters(
				FilterUtils.EVENT_TYPE_ANY,
				FilterUtils.EVENT_TYPE_MEMORY,
				FilterUtils.EVENT_TYPE_WRITE
		);
    }

	public Register getReg() {
		return reg;
	}
	
	public String toString() {
	    if(reg != null){
            return String.format("%s%s.store(%s, %s)", String.join("", Collections.nCopies(condLevel, "  ")), loc, atomic, reg);
        }
        return String.format("%s%s.store(%s, %s)", String.join("", Collections.nCopies(condLevel, "  ")), loc, atomic, val);
	}

	public LastModMap setLastModMap(LastModMap map) {
		this.lastModMap = map;
		LastModMap retMap = map.clone();
		Set<Event> set = new HashSet<Event>();
		set.add(this);
		retMap.put(loc, set);
		return retMap;
	}
	
	public Write clone() {
        Write newWrite;
        if(reg != null){
            newWrite = new Write(loc, reg, atomic);
        } else {
            newWrite = new Write(loc, val, atomic);
        }
		newWrite.condLevel = condLevel;
		newWrite.memId = memId;
		newWrite.setUnfCopy(getUnfCopy());
		return newWrite;
	}

	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
		System.out.println(String.format("Check encodeDF for %s", this));
		return null;
	}

	public Thread compile(String target, boolean ctrl, boolean leading) {
        Store st;
	    if(reg != null){
            st = new Store(loc, reg, atomic);
        } else {
            st = new Store(loc, val, atomic);
        }
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

		else System.out.println(String.format("Error in the atomic operation type of", this));
		return null;
	}

	public Thread optCompile(String target, boolean ctrl, boolean leading) {
        Store st;
        if(reg != null){
            st = new Store(loc, reg, atomic);
        } else {
            st = new Store(loc, val, atomic);
        }
		st.setHLId(hashCode());
		st.setCondLevel(this.condLevel);

        if(atomic.equals("_rx") || atomic.equals("_na")) {
            return st;
        }

		OptFence lwsync = new OptFence("Lwsync", this.condLevel);
        if(atomic.equals("_rel")) {
            return new Seq(lwsync, st);
        }

		OptFence sync = new OptFence("Sync", this.condLevel);
		if(atomic.equals("_sc")) {
			if(leading) {
				return new Seq(sync, st);	
			}
			return new Seq(lwsync, new Seq(st, sync));
		}

		else System.out.println(String.format("Error in the atomic operation type of", this));
		return null;
	}
	
	public Thread allCompile() {
        Store st;
        if(reg != null){
            st = new Store(loc, reg, atomic);
        } else {
            st = new Store(loc, val, atomic);
        }
		st.setHLId(hashCode());
		st.setCondLevel(this.condLevel);
		OptFence os = new OptFence("Sync", this.condLevel);
		OptFence olws = new OptFence("Lwsync", this.condLevel);
		return new Seq(os, new Seq(olws, st));
	}

}