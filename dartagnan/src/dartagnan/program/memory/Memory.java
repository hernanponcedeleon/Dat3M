package dartagnan.program.memory;

import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.program.memory.utils.IllegalMemoryAccessException;

import java.util.*;

public class Memory {

    private BiMap<Location, Address> map;
    private Map<String, Location> locationIndex;

    public Memory(){
        map = HashBiMap.create();
        locationIndex = new HashMap<>();
    }

    public BoolExpr encode(Context ctx){
        List<IntExpr> expressions = new ArrayList<>();
        for(Address address : map.values()){
            expressions.add(address.toZ3Int(ctx));
        }
        return ctx.mkDistinct(expressions.toArray(new IntExpr[0]));
    }

    public Location getLocation(String name){
        return locationIndex.get(name);
    }

    public Location getOrCreateLocation(String name){
        if(!locationIndex.containsKey(name)){
            Location location = new Location(name, new Address());
            map.put(location, location.getAddress());
            locationIndex.put(name, location);
            return location;
        }
        return locationIndex.get(name);
    }

    public Location getOrErrorLocation(String name){
        if(!locationIndex.containsKey(name)){
            throw new IllegalMemoryAccessException("Attempt to access illegal location " + name);
        }
        return locationIndex.get(name);
    }

    public Location getLocationForAddress(Address address){
        if(map.inverse().containsKey(address)){
            return map.inverse().get(address);
        }
        throw new IllegalMemoryAccessException("Attempt to access illegal address " + address);
    }

    public Set<Location> getLocations(){
        return map.keySet();
    }

    public Set<Address> getAllAddresses(){
        return map.values();
    }
}