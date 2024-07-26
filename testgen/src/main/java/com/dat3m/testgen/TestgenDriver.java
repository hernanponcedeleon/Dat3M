package com.dat3m.testgen;

import java.io.*;
import java.util.*;

import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.parsers.cat.ParserCat;

public class TestgenDriver {

    public static void main(String[] args) throws Exception {
        
        File model_file = new File( 
            Arrays.stream( args )
                .filter( a -> a.endsWith( ".cat" ) )
                .findFirst()
                .orElseThrow( () -> new IllegalArgumentException( "CAT model not given or format not recognized" ) )
        );
                
        Wmm mcm = new ParserCat().parse( model_file );

        System.out.println( mcm.toString() );

    }

}