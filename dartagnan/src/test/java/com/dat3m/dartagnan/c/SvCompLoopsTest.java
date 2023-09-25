package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;

@RunWith(Parameterized.class)
public class SvCompLoopsTest extends AbstractSvCompTest {

    public SvCompLoopsTest(String name, int bound) {
        super(name, bound);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> getTestResourcePath("boogie/loops/" + name + "-O3.bpl"));
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "sc");
    }

    @Parameterized.Parameters(name = "{index}: {0}, bound={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"array-1", 1},
                {"array-2", 1},
                {"count_up_down-1", 1},
                {"count_up_down-2", 1},
                {"for_bounded_loop1", 2},
                {"for_infinite_loop_1", 1},
                {"for_infinite_loop_2", 1},
                {"invert_string-3", 1},
                {"matrix-1", 1},
                {"n.c40", 1},
                {"nec11", 1},
                {"nec20", 1},
                {"nec40", 1},
                {"string-2", 2},
                {"sum01_bug02_sum01_bug02_base.case", 2},
                {"sum01_bug02", 3},
                {"sum01-1", 3},
                {"sum01-2", 1},
                {"sum03-1", 11},
                {"sum03-2", 1},
                {"sum04-1", 1},
                {"sum04-2", 1},
                {"terminator_01", 1},
                {"terminator_02-1", 1},
                {"terminator_03-1", 1},
                {"terminator_03-2", 1},
                {"trex01-1", 1},
                {"trex02-2", 1},
                {"trex03-1", 1},
                {"verisec_NetBSD-libc_loop", 3},
                {"vogal-2", 2},
                {"while_infinite_loop_1", 1},
                {"while_infinite_loop_2", 1},
                {"while_infinite_loop_3", 1},
                {"while_infinite_loop_4", 1},
                {"array_2-1", 1},
                {"array_2-2", 1},
                {"diamond_2-2", 5},
                {"functions_1-1", 1},
                {"functions_1-2", 1},
                {"multivar_1-1", 1},
                {"multivar_1-2", 1},
                {"nested_1-1", 1},
                {"nested_1-2", 1},
                {"overflow_1-1", 1},
                {"phases_2-1", 1},
                {"simple_1-1", 1},
                {"simple_1-2", 1},
                {"simple_2-1", 1},
                {"simple_2-2", 1},
                {"simple_3-1", 1},
                {"simple_3-2", 1},
                {"simple_4-1", 1},
                {"simple_4-2", 1},
                {"underapprox_1-1", 1},
                {"underapprox_1-2", 1},
                {"underapprox_2-1", 1},
                {"underapprox_2-2", 1},
                {"simple_array_index_value_1-2", 1},
                {"NetBSD_loop", 1},
                {"id_trans", 1},
                {"large_const", 2},
                {"cggmp2005", 4},
                {"cggmp2005_variant", 1},
                {"gcnr2008", 1},
                {"gj2007", 1},
                {"hhk2008", 1},
                {"jm2006", 1},
                {"jm2006.c.i.v+cfa-reducer", 1},
                {"jm2006_variant", 2},
                {"count_by_1", 1},
                {"count_by_2", 1},
                {"nested-1", 1},
                {"aiob_1", 1},
                {"aiob_2", 1},
                {"aiob_3", 1},
                {"aiob_4", 1},
                {"aiob_4.c.v+cfa-reducer", 1},
                {"aiob_4.c.v+lh-reducer", 1},
                {"aiob_4.c.v+lhb-reducer", 1},
                {"aiob_4.c.v+nlh-reducer", 1},
                {"in-de20", 1},
                {"in-de31", 1},
                {"in-de32", 1},
                {"in-de41", 1},
                {"in-de42", 1},
                {"in-de51", 1},
                {"in-de52", 1},
                {"in-de61", 1},
                {"in-de62", 1},
                {"loopv2", 1},
                {"nested3-2", 1},
                {"nested5-2", 1},
                {"sum_by_3", 2},
                {"sum_natnum", 1},
                {"watermelon", 1},
                {"eq2", 1},
                {"even", 1},
                {"linear-inequality-inv-b", 2},
                {"mod4", 1},
                {"hard", 3},
                {"const", 1}
        });
    }
}