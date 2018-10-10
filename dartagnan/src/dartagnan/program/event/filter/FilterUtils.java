package dartagnan.program.event.filter;

import dartagnan.program.utils.EventRepository;

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
    public static final String EVENT_TYPE_RMW_NORETURN = "Noreturn";

    public static final String EVENT_TYPE_LOCK = "LKW";
    public static final String EVENT_TYPE_SYNC_RCU = "Sync-rcu";

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
        put(EVENT_TYPE_RMW_NORETURN, EVENT_TYPE_RMW_NORETURN);

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
        put("After-spinlock", "After-spinlock");
        put("Rcu-lock", "Rcu-lock");
        put("Rcu-unlock", "Rcu-unlock");
        put("Sync-rcu", "Sync-rcu");

    }};

    public static String resolve(String key){
        return map.get(key);
    }

    public static final Map<String, Integer> toRepositoryCode = new HashMap<String, Integer>() {{

        // Basic types
        put(EVENT_TYPE_ANY,                 EventRepository.EVENT_ALL);         // Probably we can remove Skip and Local
        put(EVENT_TYPE_INIT,                EventRepository.EVENT_INIT);
        put(EVENT_TYPE_READ,                EventRepository.EVENT_LOAD);
        put(EVENT_TYPE_WRITE,               EventRepository.EVENT_STORE);
        put(EVENT_TYPE_MEMORY,              EventRepository.EVENT_MEMORY);
        put(EVENT_TYPE_FENCE,               EventRepository.EVENT_FENCE);

        // Atomic
        put(EVENT_TYPE_ATOMIC,              EventRepository.EVENT_MEMORY);
        put(EVENT_TYPE_READ_MODIFY_WRITE,   EventRepository.EVENT_MEMORY);      // Tighten up
        put(EVENT_TYPE_RMW_NORETURN,        EventRepository.EVENT_LOAD);        // Tighten up

        // Locks
        put(EVENT_TYPE_LOCK,                EventRepository.EVENT_ALL);         // Not implemented

        // Fences
        put("Mfence",                       EventRepository.EVENT_FENCE);
        put("Sync",                         EventRepository.EVENT_FENCE);
        put("Isync",                        EventRepository.EVENT_FENCE);
        put("Lwsync",                       EventRepository.EVENT_FENCE);
        put("Isb",                          EventRepository.EVENT_FENCE);
        put("Ish",                          EventRepository.EVENT_FENCE);

        // Memory order
        put("_sc",                          EventRepository.EVENT_MEMORY | EventRepository.EVENT_FENCE);
        put("_rx",                          EventRepository.EVENT_MEMORY | EventRepository.EVENT_FENCE);
        put("_acq",                         EventRepository.EVENT_LOAD   | EventRepository.EVENT_FENCE);
        put("_rel",                         EventRepository.EVENT_STORE  | EventRepository.EVENT_FENCE);
        put("_rel_acq",                                                    EventRepository.EVENT_FENCE);
        put("_con",                         EventRepository.EVENT_LOAD   | EventRepository.EVENT_FENCE);

        // Linux
        put("Rmb",                          EventRepository.EVENT_FENCE);
        put("Wmb",                          EventRepository.EVENT_FENCE);
        put("Mb",                           EventRepository.EVENT_FENCE);
        put("Before-atomic",                EventRepository.EVENT_FENCE);
        put("After-atomic",                 EventRepository.EVENT_FENCE);
        put("After-spinlock",               EventRepository.EVENT_FENCE);

        // RCU
        put("Rcu-lock",                     EventRepository.EVENT_RCU_LOCK);
        put("Rcu-unlock",                   EventRepository.EVENT_RCU_UNLOCK);
        put("Sync-rcu",                     EventRepository.EVENT_RCU_SYNC);

    }};
}
