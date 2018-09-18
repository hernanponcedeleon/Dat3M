package dartagnan.wmm;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class WmmResolver {

    private final Set<String> archSet = new HashSet<String>(Arrays.asList("alpha", "arm", "power", "pso", "rmo", "tso", "sc"));

    // Architectures where ctrl = ctrl ; po
    private final Set<String> ctrlPo = new HashSet<String>(Arrays.asList("alpha", "arm", "power", "rmo"));

    public Set<String> getArchSet(){
        return archSet;
    }

    public boolean encodeCtrlPo(String arch){
        if(ctrlPo.contains(arch)){
            return true;
        }

        if(archSet.contains(arch)){
            return false;
        }

        throw new RuntimeException("Unrecognised architecture " + arch);
    }
}
