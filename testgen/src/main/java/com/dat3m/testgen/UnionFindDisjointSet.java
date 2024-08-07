package com.dat3m.testgen;

public class UnionFindDisjointSet {
    
    final int total_elements;
    int p[];
    int set_size[];

    public UnionFindDisjointSet(
        final int r_total_elements
    ) throws Exception {
        if( r_total_elements <= 0 ) throw new Exception( "UFDS set size cannot be less than 1." );
        total_elements = r_total_elements;
        p = new int[ total_elements ];
        set_size = new int[ total_elements ];
        for( int i = 0 ; i < total_elements ; i++ ) {
            p[i] = i;
            set_size[i] = 1;
        }
    }

    public int find_set(
        final int i
    ) {
        if( p[i] == i )
            return i;
        return p[i] = find_set( p[i] );
    }

    public boolean are_same_set(
        final int i,
        final int j
    ) {
        return find_set(i) == find_set(j);
    }

    public void merge(
        final int i,
        final int j
    ) {
        if( are_same_set(i, j) )
            return;
        int set_i = find_set(i);
        int set_j = find_set(j);
        if( set_size[set_i] < set_size[set_j] ) {
            int t = set_i; set_i = set_j; set_j = t;
        }
        p[set_j] = set_i;
        set_size[set_i] += set_size[set_j];
    }

}
