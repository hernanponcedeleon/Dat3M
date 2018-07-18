package dartagnan.program.event;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.program.*;
import dartagnan.program.Thread;
import dartagnan.program.event.filter.FilterUtils;
import dartagnan.utils.LastModMap;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

public class Read extends MemEvent {

	private Register reg;
	
	public Read(Register reg, Location loc, String atomic) {
		this.reg = reg;
		this.loc = loc;
		this.atomic = atomic;
		this.condLevel = 0;
		this.memId = hashCode();
        addFilters(
                FilterUtils.EVENT_TYPE_ANY,
                FilterUtils.EVENT_TYPE_MEMORY,
                FilterUtils.EVENT_TYPE_READ
        );
	}
	
	public Register getReg() {
		return reg;
	}
	
	public String toString() {
		return String.format("%s%s = %s.load(%s)", String.join("", Collections.nCopies(condLevel, "  ")), reg, loc, atomic);
	}

	public LastModMap setLastModMap(LastModMap map) {
		this.lastModMap = map;
		LastModMap retMap = map.clone();
		Set<Event> set = new HashSet<Event>();
		set.add(this);
		retMap.put(reg, set);
		return retMap;
	}
	
	public Read clone() {
		Read newRead = new Read(reg, loc, atomic);
		newRead.condLevel = condLevel;
		newRead.memId = memId;
		newRead.setUnfCopy(getUnfCopy());
		return newRead;
	}

	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
		System.out.println(String.format("Check encodeDF for %s", this));
		return null;
	}

	public Thread compile(String target, boolean ctrl, boolean leading) {
		Load ld = new Load(reg, loc, atomic);
		ld.setHLId(memId);
		ld.setUnfCopy(getUnfCopy());
		ld.setCondLevel(this.condLevel);
		
		if(!target.equals("power") && !target.equals("arm")) {
			return ld;
		}

		if(atomic.equals("_rx") || atomic.equals("_na")) {
			return ld;
		}

		if(target.equals("power")) {
            Fence lwsync = new Fence("lwsync", this.condLevel);
            if(atomic.equals("_con") || atomic.equals("_acq")) {
                return new Seq(ld, lwsync);
            }

            if(atomic.equals("_sc")) {
				if(leading) {
                    Fence sync = new Fence("sync", this.condLevel);
					return new Seq(sync, new Seq(ld, lwsync));
				}
                return new Seq(ld, lwsync);
			}
		}

		if(target.equals("arm")) {
			if(atomic.equals("_con") || atomic.equals("_acq") || atomic.equals("_sc")) {
				Fence ish = new Fence("ish", this.condLevel);
				return new Seq(ld, ish);
			}			
		}
		
		else System.out.println(String.format("Error in the atomic operation type of %s", this));
		return null;
	}
	
	public Thread optCompile(boolean ctrl, boolean leading) {
		Load ld = new Load(reg, loc, atomic);
		ld.setHLId(hashCode());
		ld.setCondLevel(this.condLevel);

        if(atomic.equals("_rx") || atomic.equals("_na")) {
            return ld;
        }

        OptFence lwsync = new OptFence("lwsync", this.condLevel);
        if(atomic.equals("_con") || atomic.equals("_acq")) {
            return new Seq(ld, lwsync);
        }

		if(atomic.equals("_sc")) {
			if(leading) {
                OptFence sync = new OptFence("sync", this.condLevel);
				return new Seq(sync, new Seq(ld, lwsync));
			}
			return new Seq(ld, lwsync);
		}

		else System.out.println(String.format("Error in the atomic operation type of %s", this));
		return null;
	}
	
	public Thread allCompile() {
		Load ld = new Load(reg, loc, atomic);
		ld.setHLId(hashCode());
		ld.setCondLevel(this.condLevel);
		OptFence os = new OptFence("sync", this.condLevel);
		OptFence olws = new OptFence("lwsync",  this.condLevel);
		return new Seq(os, new Seq(olws, ld));
	}
}