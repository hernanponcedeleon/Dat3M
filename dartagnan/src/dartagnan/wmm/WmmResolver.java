package dartagnan.wmm;

import dartagnan.wmm.arch.*;

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

    public WmmInterface getWmmForArch(String arch){
        switch (arch) {
            case "alpha":
                return new Alpha();
            case "arm":
                return new ARM();
            case "power":
                return new Power();
            case "pso":
                return new PSO();
            case "rmo":
                return new RMO();
            case "tso":
                return new TSO();
            case "sc":
                return new SC();
        }

        throw new RuntimeException("Unrecognised architecture " + arch);
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
