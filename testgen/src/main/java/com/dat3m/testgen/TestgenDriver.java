package com.dat3m.testgen;

import java.util.*;

import java.io.*;

import com.dat3m.testgen.converter.ProgramConverter;
import com.dat3m.testgen.explore.WmmExplorer;
import com.dat3m.testgen.generate.SMTProgramGenerator;
import com.dat3m.testgen.program.ProgramEvent;
import com.dat3m.testgen.program.ProgramGraph;
import com.dat3m.testgen.util.BaseRelationRegistry;
public class TestgenDriver {

    public static void main(
        String[] args
    ) throws Exception {
        WmmExplorer wmm_explorer = new WmmExplorer( new File( "../cat/" + args[0] ) );

        BaseRelationRegistry.register_auto( wmm_explorer, args[0] );

        /* Phase 1 - Generate all possible cyclical graphs from the cat file definition of the memory model */
        List <ProgramGraph> graphs = wmm_explorer.begin_exploration( Integer.parseInt( args[1] ) );

        int next_test_id = 1;
        for( final ProgramGraph graph : graphs ) {
            /* Phase 2 - Attempt to generate an abstract program for each relation graph */
            SMTProgramGenerator program_generator = new SMTProgramGenerator( graph, Integer.parseInt( args[2] ) );
            List <ProgramEvent> program_events = program_generator.generate_program();

            /* Phase 2a - Program cannot exist, ignore */
            if( program_events == null )
                continue;

            /* Phase 3 - Print Program */
            ProgramConverter program_converter = new ProgramConverter( program_events );
            BufferedWriter writer = new BufferedWriter( new FileWriter( "output/litmus/test_" + next_test_id++ + ".litmus" ) );
            writer.write( program_converter.print_program( "Program relation graph:\n" + graph ) + "\n" );
            writer.close();
        }
    }

}