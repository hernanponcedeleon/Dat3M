package com.dat3m.dartagnan.benchmarking;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.RequestShutdownOnError;

import java.util.ArrayList;
import java.util.List;

import org.junit.ClassRule;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.RuleChain;
import org.junit.rules.Timeout;
import org.sosy_lab.common.ShutdownManager;

public abstract class AbstractExternalTool {

    protected String name;
    protected Result expected;

    public AbstractExternalTool(String name, Result expected) {
        this.name = name;
        this.expected = expected;
    }

    // =================== Modifiable behavior ====================

    protected abstract Provider<String> getProgramPathProvider();
    protected abstract Provider<String> getToolCmdProvider();
    protected abstract Provider<List<String>> getToolOptionsProvider();
    protected abstract long getTimeout();

    protected Provider<Integer> getTimeoutProvider() {
        return Provider.fromSupplier(() -> 0);
    }

    protected void preExecutionCmds() throws Exception { return; }
    
    // =============================================================


    @ClassRule
    public static CSVLogger.Initialization csvInit = CSVLogger.Initialization.create();

    // Provider rules
    protected final Provider<ShutdownManager> shutdownManagerProvider = Provider.fromSupplier(ShutdownManager::create);
    protected final Provider<String> filePathProvider = getProgramPathProvider();
    protected final Provider<Integer> timeoutProvider = getTimeoutProvider();
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
            .around(timeoutProvider)
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
    	processBuilder.redirectOutput(ProcessBuilder.Redirect.INHERIT);
    	processBuilder.redirectError(ProcessBuilder.Redirect.INHERIT);
    	Process proc = processBuilder.start();
		proc.waitFor();
	}
}
