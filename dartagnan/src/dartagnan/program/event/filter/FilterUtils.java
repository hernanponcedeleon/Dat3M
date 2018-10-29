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


    public static final Map<String, Integer> toRepositoryCode = new HashMap<>() {{

        // Basic types
        put(EVENT_TYPE_ANY,                 EventRepository.ALL);         // Probably we can remove Skip and Local
        put(EVENT_TYPE_INIT,                EventRepository.INIT);
        put(EVENT_TYPE_READ,                EventRepository.LOAD);
        put(EVENT_TYPE_WRITE,               EventRepository.STORE);
        put(EVENT_TYPE_MEMORY,              EventRepository.MEMORY);
        put(EVENT_TYPE_FENCE,               EventRepository.FENCE);

        // Atomic
        put(EVENT_TYPE_ATOMIC,              EventRepository.MEMORY);
        put(EVENT_TYPE_READ_MODIFY_WRITE,   EventRepository.MEMORY);      // Tighten up
        put(EVENT_TYPE_RMW_NORETURN,        EventRepository.LOAD);        // Tighten up

        // Locks
        put(EVENT_TYPE_LOCK,                EventRepository.ALL);         // Not implemented

        // Fences
        put("Mfence",                       EventRepository.FENCE);
        put("Sync",                         EventRepository.FENCE);
        put("Isync",                        EventRepository.FENCE);
        put("Lwsync",                       EventRepository.FENCE);
        put("Isb",                          EventRepository.FENCE);
        put("Ish",                          EventRepository.FENCE);

        // Memory order
        put("_sc",                          EventRepository.MEMORY | EventRepository.FENCE);
        put("_rx",                          EventRepository.MEMORY | EventRepository.FENCE);
        put("_acq",                         EventRepository.LOAD   | EventRepository.FENCE);
        put("_rel",                         EventRepository.STORE  | EventRepository.FENCE);
        put("_rel_acq",                                              EventRepository.FENCE);
        put("_con",                         EventRepository.LOAD   | EventRepository.FENCE);

        // Linux
        put("Rmb",                          EventRepository.FENCE);
        put("Wmb",                          EventRepository.FENCE);
        put("Mb",                           EventRepository.FENCE);
        put("Before-atomic",                EventRepository.FENCE);
        put("After-atomic",                 EventRepository.FENCE);
        put("After-spinlock",               EventRepository.FENCE);

        // RCU
        put("Rcu-lock",                     EventRepository.RCU_LOCK);
        put("Rcu-unlock",                   EventRepository.RCU_UNLOCK);
        put("Sync-rcu",                     EventRepository.RCU_SYNC);

    }};
}
