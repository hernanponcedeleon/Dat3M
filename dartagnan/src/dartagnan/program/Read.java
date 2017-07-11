package dartagnan.program;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.utils.LastModMap;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

public class Read extends MemEvent {

	private Register reg;
	private String atomic;
	
	public Read(Register reg, Location loc, String atomic) {
		this.reg = reg;
		this.loc = loc;
		this.atomic = atomic;
		this.condLevel = 0;
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
//	public LastModMap setLastModMap(LastModMap map) {
//		System.out.println(String.format("Check LastModMap for %s", this));
//		return null;
//	}
	
	public Read clone() {
		return this;
//		Register newReg = reg.clone();
//		Location newLoc = loc.clone();
//		Read newStore = new Read(newReg, newLoc, atomic);
//		newStore.condLevel = condLevel;
//		return newStore;
	}

	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
		System.out.println(String.format("Check encodeDF for %s", this));
		return null;
	}

	public Thread compile(boolean ctrl, boolean leading) {
		Load ld = new Load(reg, loc);
		ld.setHLId(hashCode());
		ld.condLevel = this.condLevel;

		Sync sync = new Sync();
		sync.condLevel = this.condLevel;
		Lwsync lwsync = new Lwsync();
		lwsync.condLevel = this.condLevel;
		
		if(atomic.equals("_sc")) {
			if(leading) {
				return new Seq(sync, new Seq(ld, lwsync));	
			}
			else {
				return new Seq(ld, lwsync);
			}
		}
		if(atomic.equals("_rx") || atomic.equals("_na")) {
			return ld;
		}
		if(atomic.equals("_con") || atomic.equals("_acq")) {
			return new Seq(ld, lwsync);
		}
		else System.out.println(String.format("Error in the atomic operation type of %s", this));
		return null;
	}
	
	public Thread optCompile(boolean ctrl, boolean leading) {
		Load ld = new Load(reg, loc);
		ld.setHLId(hashCode());
		ld.condLevel = this.condLevel;

		Sync sync = new OptSync();
		sync.condLevel = this.condLevel;
		Lwsync lwsync = new OptLwsync();
		lwsync.condLevel = this.condLevel;
		
		if(atomic.equals("_sc")) {
			if(leading) {
				return new Seq(sync, new Seq(ld, lwsync));	
			}
			else {
				return new Seq(ld, lwsync);
			}
		}
		if(atomic.equals("_rx") || atomic.equals("_na")) {
			return ld;
		}
		if(atomic.equals("_con") || atomic.equals("_acq")) {
			return new Seq(ld, lwsync);
		}
		else System.out.println(String.format("Error in the atomic operation type of %s", this));
		return null;
	}
	
	public Thread allCompile() {
		Load ld = new Load(reg, loc);
		ld.setHLId(hashCode());
		ld.condLevel = this.condLevel;
		OptSync os = new OptSync();
		os.condLevel = condLevel;
		OptLwsync olws = new OptLwsync();
		olws.condLevel = condLevel;
		return new Seq(os, new Seq(olws, ld));
		//return ld;
	}
}