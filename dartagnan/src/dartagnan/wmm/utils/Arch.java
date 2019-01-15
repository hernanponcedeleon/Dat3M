package dartagnan.wmm.utils;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

public class Arch {

    public static final Set<String> targets = Collections.unmodifiableSet(new HashSet<>(
            Arrays.asList("alpha", "arm", "power", "pso", "rmo", "tso", "sc")
    ));

    // Architectures where ctrl = ctrl ; po
    private static final Set<String> ctrlPo = Collections.unmodifiableSet(new HashSet<>(
            Arrays.asList("alpha", "arm", "power", "rmo")
    ));

    public static boolean encodeCtrlPo(String arch){
        if(ctrlPo.contains(arch)){
            return true;
        }

        if(targets.contains(arch)){
            return false;
        }

        throw new RuntimeException("Unrecognised architecture " + arch);
    }
}
