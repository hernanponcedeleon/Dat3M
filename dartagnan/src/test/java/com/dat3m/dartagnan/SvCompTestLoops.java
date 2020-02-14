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
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/count_up_down-2.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/eureka_05.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/for_bounded_loop1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/for_infinite_loop_1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/for_infinite_loop_2.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/insertion_sort-1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/insertion_sort-2.bpl", wmm, 3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/matrix-1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/matrix-2.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/nec11.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum01-1.bpl", wmm, 11});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum01_bug02.bpl", wmm, 7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum01_bug02_sum01_bug02_base.case.bpl", wmm, 5});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum03-1.bpl", wmm, 11});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum04-1.bpl", wmm, 9});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum04-2.bpl", wmm, 9});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sum_array-1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/terminator_01.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/terminator_02-1.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/terminator_03-1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/trex01-1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/trex02-2.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/trex03-1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/veris.c_NetBSD-libc_loop.bpl", wmm, 3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/verisec_NetBSD-libc_loop.bpl", wmm, 9});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/verisec_OpenSER_cases1_stripFullBoth_arr.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/multivar_1-2.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/phases_2-1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/phases_2-2.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/simple_2-2.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/simple_3-1.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/underapprox_1-1.bpl", wmm, 7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/underapprox_1-2.bpl", wmm, 7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/underapprox_2-1.bpl", wmm, 7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/underapprox_2-2.bpl", wmm, 7});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/NetBSD_loop.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/SpamAssassin-loop.i.v+cfa-reducer.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/SpamAssassin-loop.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/apache-escape-absolute.i.v+cfa-reducer.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/apache-get-tag.i.v+lhb-reducer.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/apache-get-tag.i.v+nlh-reducer.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/apache-get-tag.bpl", wmm, 3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/id_build.i.v+lhb-reducer.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/id_trans.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/large_const.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sendmail-close-angle.bpl", wmm, 3});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/cggmp2005.bpl", wmm, 5});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/gcnr2008.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/gauss_sum.bpl", wmm, 2});        
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/mod3.c.v+cfa-reducer.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/mod3.c.v+lhb-reducer.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/mod3.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/iftelse.bpl", wmm, 2});
        // Problem with srem.i32 definition
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/loopv1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sumt2.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sumt3.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sumt4.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sumt5.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sumt6.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sumt7.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sumt8.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/sumt9.bpl", wmm, 2});
        // Wrong result due to llvm2bpl transformation.
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/deep-nested.bpl", wmm, 1});	
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/egcd2.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/loops/prod4br.bpl", wmm, 2});        
        return data;
    }

    public SvCompTestLoops(String path, Wmm wmm, int bound) {
    	super(path, wmm, bound);
    }
}