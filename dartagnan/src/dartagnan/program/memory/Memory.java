package dartagnan.program.memory;

import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
import dartagnan.program.memory.utils.IllegalMemoryAccessException;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class Memory {

    private BiMap<Location, Address> map;
    private Map<String, Location> locationIndex;

    public Memory(){
        map = HashBiMap.create();
        locationIndex = new HashMap<>();
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
}