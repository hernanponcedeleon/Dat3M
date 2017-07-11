package dartagnan.program;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.utils.LastModMap;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

public class Write extends MemEvent {

	private Register reg;
	private String atomic;
	
	public Write(Location loc, Register reg, String atomic) {
		this.reg = reg;
		this.loc = loc;
		this.atomic = atomic;
		this.condLevel = 0;
	}
	
	public Register getReg() {
		return reg;
	}
	
	public String toString() {
		return String.format("%s%s.store(%s, %s)", String.join("", Collections.nCopies(condLevel, "  ")), loc, atomic, reg);
	}

	public LastModMap setLastModMap(LastModMap map) {
		this.lastModMap = map;
		LastModMap retMap = map.clone();
		Set<Event> set = new HashSet<Event>();
		set.add(this);
		retMap.put(loc, set);
		return retMap;
	}
	
//	public LastModMap setLastModMap(LastModMap map) {
//		System.out.println(String.format("Check LastModMap for %s", this));
//		return null;
//	}
	
	public Write clone() {
		return this;
//		Register newReg = reg.clone();
//		Location newLoc = loc.clone();
//		Write newStore = new Write(newLoc, newReg, atomic);
//		newStore.condLevel = condLevel;
//		return newStore;
	}

	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
		System.out.println(String.format("Check encodeDF for %s", this));
		return null;
	}

	public Thread compile(boolean ctrl, boolean leading) {
		Store st = new Store(loc, reg);
		st.setHLId(hashCode());
		st.condLevel = this.condLevel;
		
		Sync sync = new Sync();
		sync.condLevel = this.condLevel;
		Lwsync lwsync = new Lwsync();
		lwsync.condLevel = this.condLevel;

		if(atomic.equals("_sc")) {
			if(leading) {
				return new Seq(sync, st);	
			}
			else {
				return new Seq(lwsync, new Seq(st, sync));
			}
		}
		if(atomic.equals("_rx") || atomic.equals("_na")) {
			return st;
		}
		if(atomic.equals("_rel")) {
			return new Seq(lwsync, st);
		}
		else System.out.println(String.format("Error in the atomic operation type of", this));
		return null;
	}

	public Thread optCompile(boolean ctrl, boolean leading) {
		Store st = new Store(loc, reg);
		st.setHLId(hashCode());
		st.condLevel = this.condLevel;
		
		Sync sync = new OptSync();
		sync.condLevel = this.condLevel;
		Lwsync lwsync = new OptLwsync();
		lwsync.condLevel = this.condLevel;

		if(atomic.equals("_sc")) {
			if(leading) {
				return new Seq(sync, st);	
			}
			else {
				return new Seq(lwsync, new Seq(st, sync));
			}
		}
		if(atomic.equals("_rx") || atomic.equals("_na")) {
			return st;
		}
		if(atomic.equals("_rel")) {
			return new Seq(lwsync, st);
		}
		else System.out.println(String.format("Error in the atomic operation type of", this));
		return null;
	}
	
	public Thread allCompile() {
		Store st = new Store(loc, reg);
		st.setHLId(hashCode());
		st.condLevel = this.condLevel;
		OptSync os = new OptSync();
		os.condLevel = condLevel;
		OptLwsync olws = new OptLwsync();
		olws.condLevel = condLevel;
		return new Seq(os, new Seq(olws, st));
		//return st;
	}

}