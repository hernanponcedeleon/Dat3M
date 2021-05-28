package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;

import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;

@RunWith(Parameterized.class)
public class SvCompTestLoops extends AbstractSvCompTest {

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/sc.cat"));

        Settings s1 = new Settings(Alias.CFIS, 1, TIMEOUT);
        Settings s2 = new Settings(Alias.CFIS, 2, TIMEOUT);
        Settings s3 = new Settings(Alias.CFIS, 3, TIMEOUT);
        Settings s4 = new Settings(Alias.CFIS, 4, TIMEOUT);
        Settings s5 = new Settings(Alias.CFIS, 5, TIMEOUT);
        Settings s11 = new Settings(Alias.CFIS,11, TIMEOUT);

        List<Object[]> data = new ArrayList<>();

        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/array-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/array-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/bubble_sort-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/count_up_down-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/count_up_down-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/eureka_05-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/for_bounded_loop1-O3.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/for_infinite_loop_1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/for_infinite_loop_2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/invert_string-3-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/matrix-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/matrix-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/n.c40-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/nec11-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/nec20-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/nec40-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/string-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/string-2-O3.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum_array-1-O3.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum01_bug02_sum01_bug02_base.case-O3.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum01_bug02-O3.bpl", wmm, s3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum01-1-O3.bpl", wmm, s3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum01-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum03-1-O3.bpl", wmm, s11});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum03-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum04-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum04-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/terminator_01-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/terminator_02-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/terminator_03-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/terminator_03-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/trex01-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/trex02-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/trex02-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/trex03-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/trex04-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/veris.c_sendmail_tTflag_arr_one_loop-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/verisec_NetBSD-libc_loop-O3.bpl", wmm, s3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/vogal-2-O3.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/while_infinite_loop_1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/while_infinite_loop_2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/while_infinite_loop_3-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/while_infinite_loop_4-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/array_2-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/array_2-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/array_3-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/const_1-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/diamond_2-2-O3.bpl", wmm, s5});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/functions_1-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/functions_1-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/multivar_1-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/multivar_1-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/nested_1-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/nested_1-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/overflow_1-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/phases_2-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/simple_1-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/simple_1-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/simple_2-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/simple_2-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/simple_3-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/simple_3-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/simple_4-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/simple_4-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/underapprox_1-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/underapprox_1-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/underapprox_2-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/underapprox_2-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/simple_array_index_value_1-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/simple_vardep_1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/simple_vardep_2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/NetBSD_loop-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/id_trans-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/large_const-O3.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/cggmp2005-O3.bpl", wmm, s4});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/cggmp2005_variant-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/cggmp2005b-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/css2003-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/gcnr2008-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/gj2007-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/hhk2008-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/jm2006-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/jm2006.c.i.v+cfa-reducer-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/jm2006_variant-O3.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/count_by_1_variant-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/count_by_1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/count_by_2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/nested-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/aiob_1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/aiob_2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/aiob_3-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/aiob_4-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/aiob_4.c.v+cfa-reducer-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/aiob_4.c.v+lh-reducer-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/aiob_4.c.v+lhb-reducer-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/aiob_4.c.v+nlh-reducer-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/in-de20-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/in-de31-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/in-de32-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/in-de41-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/in-de42-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/in-de51-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/in-de52-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/in-de61-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/in-de62-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/loopv2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/loopv3-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/nested3-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/nested5-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/nested5-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum_by_3-O3.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum_natnum-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/watermelon-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/eq2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/even-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/linear-inequality-inv-b-O3.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/mod4-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/egcd2-O3.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/egcd3-O3.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/hard-O3.bpl", wmm, s3});        
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/ps2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/ps3-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sqrt1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/bresenham-O3.bpl", wmm, s2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/const-O3.bpl", wmm, s1});
        
        return data;
    }

    public SvCompTestLoops(String path, Wmm wmm, Settings settings) {
    	super(path, wmm, settings);
    }
}