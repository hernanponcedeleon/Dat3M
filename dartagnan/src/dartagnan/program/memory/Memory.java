package dartagnan.program.memory;

import com.google.common.collect.BiMap;
import com.google.common.collect.ImmutableBiMap;
import dartagnan.program.Location;
import dartagnan.program.memory.utils.IllegalMemoryAccessException;

import java.util.Set;

public class Memory {

    private BiMap<Location, Integer> map;

    public Memory(Set<Location> locations){
        ImmutableBiMap.Builder<Location, Integer> builder = new ImmutableBiMap.Builder<>();
        int address = 0;
        for(Location location : locations){
            builder.put(location, address++);
        }
        map = builder.build();
    }

    public Location getLocation(int address){
        if(map.inverse().containsKey(address)){
            return map.inverse().get(address);
        }
        throw new IllegalMemoryAccessException("Attempt to access illegal address " + address);
    }

    public int getAddress(Location location){
        if(map.containsKey(location)){
            return map.get(location);
        }
        throw new IllegalMemoryAccessException("Attempt to access illegal location " + location.getName());
    }

    public Set<Location> getLocations(){
        return map.keySet();
    }
}