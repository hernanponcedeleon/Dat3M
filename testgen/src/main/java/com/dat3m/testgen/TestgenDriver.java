package com.dat3m.testgen;

import java.util.*;

import java.io.*;

import com.dat3m.testgen.converter.ProgramConverter;
import com.dat3m.testgen.explore.WmmExplorer;
import com.dat3m.testgen.generate.SMTProgramGenerator;
import com.dat3m.testgen.util.BaseRelations;
import com.dat3m.testgen.util.Graph;
import com.dat3m.testgen.util.ProgramEvent;
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

        /* Phase 1 - Generate all possible cyclical graphs from the cat file definition of the memory model */
        List <Graph> graphs = wmm_explorer.begin_exploration( Integer.parseInt( args[1] ) );

        for( final Graph graph : graphs ) {
            /* Phase 2 - Attempt to generate an abstract program for each relation graph */
            SMTProgramGenerator program_generator = new SMTProgramGenerator( graph, Integer.parseInt( args[2] ) );
            List <ProgramEvent> program_events = program_generator.generate_program();

            /* Phase 2a - Program cannot exist, ignore */
            if( program_events == null )
                continue;

            /* Phase 3 - Print Program */
            ProgramConverter program_converter = new ProgramConverter( program_events );
            System.out.println( program_converter.print_program( "Program relation graph:\n" + graph ) );
        }
    }

}