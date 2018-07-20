package dartagnan.wmm;

import java.util.Arrays;
import java.util.Set;
import java.util.HashSet;
import java.util.Map;
import java.util.HashMap;

public class WmmUtils {

    // Relations encoded in Domain
    protected static Set<String> basicRelations = new HashSet<String>(Arrays.asList(
            "ii", "ic", "ci", "cc",
            "id", "int", "ext",
            "loc", "po",
            "rf", "fr", "co",
            "idd", "ctrlDirect", "ctrl",
            // "data", Note: some data constraints are also encoded in Domain
            "crit"  // TODO: Implementation
    ));

    protected static Map<String, String> basicFenceRelations = new HashMap<String, String>();
    static {
        basicFenceRelations.put("mfence", "Mfence");
        basicFenceRelations.put("ish", "Ish");
        basicFenceRelations.put("isb", "Isb");
        basicFenceRelations.put("sync", "Sync");
        basicFenceRelations.put("lwsync", "Lwsync");
        basicFenceRelations.put("isync", "Isync");
    }
}
