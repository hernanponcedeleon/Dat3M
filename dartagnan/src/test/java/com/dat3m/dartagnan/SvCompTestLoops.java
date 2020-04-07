package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.wmm.Wmm;
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
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/svcomp.cat"));

        List<Object[]> data = new ArrayList<>();

        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/array-1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/array-2.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/bubble_sort-1.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/bubble_sort-2.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/cggmp2005.bpl", wmm, 5});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/count_up_down-2.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/gcnr2008.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/invert_string-1.bpl", wmm, 3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/invert_string-3.bpl", wmm, 6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/matrix-1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/matrix-2.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/multivar_1-2.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/n.c40.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/nec11.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/nec40.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/phases_2-1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/phases_2-2.bpl", wmm, 5});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/simple_2-2.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/simple_3-1.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum_array-1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum01_bug02_sum01_bug02_base.case.bpl", wmm, 5});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum01_bug02.bpl", wmm, 7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum01-1.bpl", wmm, 11});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum04-1.bpl", wmm, 9});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum04-2.bpl", wmm, 9});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/terminator_01.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/terminator_02-1.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/terminator_03-1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/trex01-1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/trex02-2.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/trex03-1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/underapprox_1-1.bpl", wmm, 7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/underapprox_1-2.bpl", wmm, 7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/underapprox_2-1.bpl", wmm, 7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/underapprox_2-2.bpl", wmm, 7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/veris.c_NetBSD-libc_loop.bpl", wmm, 3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/veris.c_sendmail_tTflag_arr_one_loop.bpl", wmm, 11});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/verisec_NetBSD-libc_loop.bpl", wmm, 9});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/vnew2.bpl", wmm, 7});
        
        return data;
    }

    public SvCompTestLoops(String path, Wmm wmm, int bound) {
    	super(path, wmm, bound);
    }
}