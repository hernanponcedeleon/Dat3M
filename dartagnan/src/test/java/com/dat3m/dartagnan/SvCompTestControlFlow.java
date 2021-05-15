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
public class SvCompTestControlFlow extends AbstractSvCompTest {

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/sc.cat"));

        Settings s1 = new Settings(Alias.CFIS, 1, TIMEOUT);
        Settings s4 = new Settings(Alias.CFIS, 4, TIMEOUT);
        Settings s6 = new Settings(Alias.CFIS, 6, TIMEOUT);
        
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

    public SvCompTestControlFlow(String path, Wmm wmm, Settings settings) {
    	super(path, wmm, settings);
    }
}