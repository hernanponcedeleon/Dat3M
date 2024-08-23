package com.dat3m.testgen;

import java.util.*;
import java.io.*;

import com.dat3m.testgen.explore.WmmExplorer;
import com.dat3m.testgen.util.Graph;

public class TestgenDriver {

    public static void main(
        String[] args
    ) throws Exception {
        WmmExplorer wmm_explorer = new WmmExplorer( new File( "../cat/sc.cat" ) );
        List <Graph> all_cycles = wmm_explorer.begin_exploration( 2 );
        for( final Graph cycle : all_cycles )
            System.out.println( cycle );
    }

}