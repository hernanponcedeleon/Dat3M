package com.dat3m.testgen;

import java.util.*;

import java.io.*;

import com.dat3m.testgen.explore.WmmExplorer;
import com.dat3m.testgen.generate.ProgramGenerator;
import com.dat3m.testgen.util.BaseRelations;
import com.dat3m.testgen.util.Graph;
public class TestgenDriver {

    public static void main(
        String[] args
    ) throws Exception {
        WmmExplorer wmm_explorer = new WmmExplorer( new File( "../cat/" + args[0] ) );

        wmm_explorer.register_base_relation( "po",    BaseRelations.type.po    );
        wmm_explorer.register_base_relation( "co",    BaseRelations.type.co    );
        wmm_explorer.register_base_relation( "rf",    BaseRelations.type.rf    );
        wmm_explorer.register_base_relation( "ext",   BaseRelations.type.ext   );
        wmm_explorer.register_base_relation( "rmw",   BaseRelations.type.rmw   );
        wmm_explorer.register_base_relation( "[R]",   BaseRelations.type.read  );
        wmm_explorer.register_base_relation( "[W]",   BaseRelations.type.write );
        wmm_explorer.register_base_relation( "[RMW]", BaseRelations.type.rmw   );

        wmm_explorer.register_ignored_relation( "((([R]) \\ ([range(rf)])) ; loc) ; ([W])" );

        List <Graph> all_cycles = wmm_explorer.begin_exploration( Integer.parseInt( args[1] ) );
        for( final Graph cycle : all_cycles )
            new ProgramGenerator( cycle );
    }

}