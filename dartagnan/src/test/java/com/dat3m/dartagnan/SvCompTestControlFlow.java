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
public class SvCompTestControlFlow extends AbstractSvCompTest {

	@Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/svcomp.cat"));

        List<Object[]> data = new ArrayList<>();

        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/s3_clnt_3.cil-2.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/s3_srvr_11.cil.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/s3_srvr_12.cil.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/s3_srvr_1a.cil.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/s3_srvr_1b.cil.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/s3_srvr_6.cil-1.bpl", wmm, 1});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_5.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_6.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_7.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_8.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_9.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_10.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_11.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_12.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_13.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_14-1.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_14-2.bpl", wmm, 2});
        data.add(new Object[]{TEST_RESOURCE_PATH + "boogie/cf/test_locks_15-1.bpl", wmm, 2});
        
        return data;
    }

	public SvCompTestControlFlow(String path, Wmm wmm, int bound) {
		super(path, wmm, bound);
	}
}