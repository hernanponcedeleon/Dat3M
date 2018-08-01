package dartagnan.program.event.filter;

import java.util.HashMap;
import java.util.Map;

public class FilterUtils {

    public static final String EVENT_TYPE_ANY = "_";
    public static final String EVENT_TYPE_INIT = "I";
    public static final String EVENT_TYPE_READ = "R";
    public static final String EVENT_TYPE_WRITE = "W";
    public static final String EVENT_TYPE_MEMORY = "M";
    public static final String EVENT_TYPE_FENCE = "F";

    public static final String EVENT_TYPE_ATOMIC = "A";
    public static final String EVENT_TYPE_READ_MODIFY_WRITE = "RMW";
    public static final String EVENT_TYPE_RMW_READ_NORETURN = "Noreturn";

    public static final String EVENT_TYPE_LOCK = "LKW";


    public static final Map<String, String> map = new HashMap<String, String>() {{

        // Basic types
        put(EVENT_TYPE_ANY, EVENT_TYPE_ANY);
        put(EVENT_TYPE_INIT, EVENT_TYPE_INIT);
        put(EVENT_TYPE_READ, EVENT_TYPE_READ);
        put(EVENT_TYPE_WRITE, EVENT_TYPE_WRITE);
        put(EVENT_TYPE_MEMORY, EVENT_TYPE_MEMORY);
        put(EVENT_TYPE_FENCE, EVENT_TYPE_FENCE);

        // Atomic
        put(EVENT_TYPE_ATOMIC, EVENT_TYPE_ATOMIC);
        put(EVENT_TYPE_READ_MODIFY_WRITE, EVENT_TYPE_READ_MODIFY_WRITE);
        put(EVENT_TYPE_RMW_READ_NORETURN, EVENT_TYPE_RMW_READ_NORETURN);

        // Locks
        put(EVENT_TYPE_LOCK, EVENT_TYPE_LOCK);

        // Fences
        put("Mfence", "Mfence");
        put("Sync", "Sync");
        put("Isync", "Isync");
        put("Lwsync", "Lwsync");
        put("Isb", "Isb");
        put("Ish", "Ish");

        // C11 memory order
        put("SC", "_sc");
        put("RX", "_rx");
        put("AQC", "_acq");
        put("REL", "_rel");
        put("REL_ACQ", "_rel_acq");
        put("CON", "_con");

        // Linux memory order
        put("Acquire", "_acq");
        put("Release", "_rel");

        // Linux
        put("Rmb", "Rmb");
        put("Wmb", "Wmb");
        put("Mb", "Mb");
        put("Before-atomic", "Before-atomic");
        put("After-atomic", "After-atomic");
        put("Before-spinlock", "Before-spinlock");
        put("After-spinlock", "After-spinlock");
        put("Sync-rcu", "Sync-rcu");

    }};

    public static String resolve(String key){
        return map.get(key);
    }
}
