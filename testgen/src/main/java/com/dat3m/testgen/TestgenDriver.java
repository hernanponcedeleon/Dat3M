package com.dat3m.testgen;

import java.util.*;

import java.io.*;

import com.dat3m.testgen.explore.WmmExplorer;
import com.dat3m.testgen.generate.ProgramGenerator;
import com.dat3m.testgen.util.Graph;
import com.dat3m.testgen.util.RelationType;

public class TestgenDriver {

    public static void main(
        String[] args
    ) throws Exception {
        WmmExplorer wmm_explorer = new WmmExplorer( new File( "../cat/" + args[0] ) );

        wmm_explorer.register_base_relation( "po",    new RelationType( RelationType.base_relation.po  )   );
        wmm_explorer.register_base_relation( "co",    new RelationType( RelationType.base_relation.co  )   );
        wmm_explorer.register_base_relation( "rf",    new RelationType( RelationType.base_relation.rf  )   );
        wmm_explorer.register_base_relation( "ext",   new RelationType( RelationType.base_relation.ext )   );
        wmm_explorer.register_base_relation( "rmw",   new RelationType( RelationType.base_relation.rmw )   );
        wmm_explorer.register_base_relation( "[R]",   new RelationType( RelationType.base_relation.read )  );
        wmm_explorer.register_base_relation( "[W]",   new RelationType( RelationType.base_relation.write ) );
        wmm_explorer.register_base_relation( "[RMW]", new RelationType( RelationType.base_relation.rmw )   );

        wmm_explorer.register_base_relation( "((([R]) \\ ([range(rf)])) ; loc) ; ([W])", null );

        List <Graph> all_cycles = wmm_explorer.begin_exploration( Integer.parseInt( args[1] ) );
        for( final Graph cycle : all_cycles )
            new ProgramGenerator( cycle );
    }

}