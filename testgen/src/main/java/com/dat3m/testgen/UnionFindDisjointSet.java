package com.dat3m.testgen;

/**
 * Implementation of Union Find Disjoint Set data structure.
 * https://en.wikipedia.org/wiki/Disjoint-set_data_structure
 * 
 * @param total_elements Maximum amount of elements to be included in the UFDS set.
 * @param p Element parent array.
 * @param set_size Set size array.
 */
public class UnionFindDisjointSet {
    
    final int total_elements;
    int p[];
    int set_size[];

    /**
     * Constructor for UnionFindDisjointSet class.
     * 
     * @param r_total_elements Maximum amount of elements to be included in the UFDS set.
     * @throws Exception
     */
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

    /**
     * Returns the set of element i.
     * 
     * @param i Input element.
     */
    public int find_set(
        final int i
    ) {
        if( p[i] == i )
            return i;
        return p[i] = find_set( p[i] );
    }

    /**
     * Returns wether two elements belong in the same set.
     * 
     * @param i Input element 1.
     * @param j Input element 2.
     */
    public boolean are_same_set(
        final int i,
        final int j
    ) {
        return find_set(i) == find_set(j);
    }

    /**
     * Merges the sets of the two given elements.
     * 
     * @param i Input element 1.
     * @param j Input element 2.
     */
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
