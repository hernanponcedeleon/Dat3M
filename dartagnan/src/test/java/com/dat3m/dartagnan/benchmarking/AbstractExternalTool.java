package com.dat3m.dartagnan.benchmarking;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.RequestShutdownOnError;

import org.junit.ClassRule;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.RuleChain;
import org.junit.rules.Timeout;
import org.sosy_lab.common.ShutdownManager;

import static org.junit.Assert.assertEquals;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public abstract class AbstractExternalTool {

    protected String name;
    protected Result expected;

    public AbstractExternalTool(String name, Result expected) {
        this.name = name;
        this.expected = expected;
    }

    // =================== Modifiable behavior ====================

    protected long getTimeout() {
    	return 900000;
    }

    protected abstract Provider<String> getProgramPathProvider();
    protected abstract Provider<String> getToolCmdProvider();
    protected abstract Provider<List<String>> getToolOptionsProvider();
    protected abstract Result getResult(String output);
    protected void preExecutionCmds() throws Exception { }
    
    // =============================================================


    @ClassRule
    public static CSVLogger.Initialization csvInit = CSVLogger.Initialization.create();

    // Provider rules
    protected final Provider<ShutdownManager> shutdownManagerProvider = Provider.fromSupplier(ShutdownManager::create);
    protected final Provider<String> filePathProvider = getProgramPathProvider();
    protected final Provider<String> toolCmdProvider = getToolCmdProvider();
    protected final Provider<List<String>> toolOptionsProvider = getToolOptionsProvider();

    // Special rules
    protected final Timeout timeout = Timeout.millis(getTimeout());
    protected final CSVLogger csvLogger = CSVLogger.create(() -> name, () -> expected);
    protected final RequestShutdownOnError shutdownOnError = RequestShutdownOnError.create(shutdownManagerProvider);

    @Rule
    public RuleChain ruleChain = RuleChain.outerRule(shutdownManagerProvider)
            .around(shutdownOnError)
            .around(filePathProvider)
            .around(toolCmdProvider)
            .around(toolOptionsProvider)
            .around(csvLogger)
            .around(timeout);

	@Test
	@CSVLogger.FileName("csv/")
	public void test() throws Exception {
		// This is a NOP for most external tools
		preExecutionCmds();
    	ArrayList<String> cmd = new ArrayList<String>();
    	cmd.add(toolCmdProvider.get());
    	cmd.addAll(toolOptionsProvider.get());
    	cmd.add(filePathProvider.get());
    	ProcessBuilder processBuilder = new ProcessBuilder(cmd);
    	processBuilder.redirectError(ProcessBuilder.Redirect.INHERIT);
    	Process proc = processBuilder.start();
		BufferedReader read = new BufferedReader(new InputStreamReader(proc.getInputStream()));
		proc.waitFor();
		String output = "";
		while(read.ready()) {
			output += read.readLine();
		}
		assertEquals(expected, getResult(output));
	}
}
