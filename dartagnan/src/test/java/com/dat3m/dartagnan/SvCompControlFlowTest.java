package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.dartagnan.utils.ResourceHelper.getCSVFileName;

@RunWith(Parameterized.class)
public class SvCompControlFlowTest extends AbstractSvCompTest {

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/sc.cat"));

        int s1 = 1;
        int s4 = 4;
        int s6 = 6;

        Files.deleteIfExists(Paths.get(getCSVFileName(SvCompControlFlowTest.class, "two-solvers")));
        Files.deleteIfExists(Paths.get(getCSVFileName(SvCompControlFlowTest.class, "incremental")));
        Files.deleteIfExists(Paths.get(getCSVFileName(SvCompControlFlowTest.class, "assume")));
        Files.deleteIfExists(Paths.get(getCSVFileName(SvCompControlFlowTest.class, "refinement")));
        
        List<Object[]> data = new ArrayList<>();

        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/kbfiltr_simpl1.cil-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/kbfiltr_simpl2.cil-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/s3_clnt_2.cil-1-O3.bpl", wmm, s6});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/s3_clnt_3.cil-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/s3_srvr_1.cil-1-O3.bpl", wmm, s4});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/s3_srvr_2.cil-2-O3.bpl", wmm, s4});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/s3_srvr_6.cil-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/s3_srvr_10.cil-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/s3_srvr_13.cil-O3.bpl", wmm, s4});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_5-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_6-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_7-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_8-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_9-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_10-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_11-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_12-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_13-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_14-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_14-2-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_15-1-O3.bpl", wmm, s1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_15-2-O3.bpl", wmm, s1});
        

        return data;
    }

    public SvCompControlFlowTest(String path, Wmm wmm, int bound) {
    	super(path, wmm, bound);
    }
}