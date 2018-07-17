package dartagnan.wmm;

import dartagnan.wmm.arch.*;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class WmmResolver {

    public Set<String> getArchSet(){
        return new HashSet<String>(Arrays.asList("alpha", "arm", "power", "pso", "rmo", "tso", "sc"));
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
}
