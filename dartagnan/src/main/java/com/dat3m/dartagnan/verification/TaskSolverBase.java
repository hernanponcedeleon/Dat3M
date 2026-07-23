package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.program.event.common.NoInterface;
import com.dat3m.dartagnan.utils.Utils;
import com.google.common.base.Preconditions;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.*;

import java.util.concurrent.TimeUnit;

import static com.dat3m.dartagnan.configuration.OptionNames.TIMEOUT;

@NoInterface
@Options
public abstract class TaskSolverBase<TSolver, TTask extends Task, TResult extends TaskResult<TTask>> implements AutoCloseable {

    // ================================== Configurables ==================================
    @Option(
            name = TIMEOUT,
            description = "Timeout before interrupting the task solver. Can specify time units ns, ms, s (default), min, and h.")
    @TimeSpanOption(min = 0, codeUnit = TimeUnit.MILLISECONDS, defaultUserUnit = TimeUnit.SECONDS)
    protected int timeout = 0;

    protected boolean hasTimeout() {
        return timeout > 0;
    }

    // ====================================== State ======================================

    protected ShutdownManager shutdownManager = ShutdownManager.create();
    protected final TTask task;
    protected long runtime = 0;
    protected TResult result;

    public TTask getTask() {
        return task;
    }

    public TResult getResult() {
        checkHasRun();
        return result;
    }

    public ResultStatus getResultStatus() {
        checkHasRun();
        return result.getStatus();
    }

    public long getRuntime() {
        checkHasRun();
        return runtime;
    }

    // =================================== Construction ===================================

    protected TaskSolverBase(TTask task, Configuration config) throws InvalidConfigurationException {
        this.task = task;

        config.recursiveInject(this);
    }

    protected TaskSolverBase(TTask task) throws InvalidConfigurationException {
        this(task, task.getConfig());
    }

    public TSolver withShutdownManager(ShutdownManager shutdownManager) {
        this.shutdownManager = shutdownManager;
        return getThis();
    }

    protected abstract TSolver getThis();

    // ===================================== Helper =====================================

    private long startTime;
    private Thread timeoutThread;

    protected void startRun() {
        this.result = null;
        this.runtime = 0;
        this.timeoutThread = null;

        this.startTime = System.currentTimeMillis();
        if (hasTimeout()) {
            timeoutThread = createTimeoutThread();
            timeoutThread.start();
        }
    }

    protected void endRun() throws InterruptedException {
        this.runtime = System.currentTimeMillis() - startTime;
        if (timeoutThread != null) {
            timeoutThread.interrupt();
            timeoutThread.join();
            timeoutThread = null;
        }
    }

    // ===================================== Misc =====================================

    protected void checkHasRun() {
        Preconditions.checkState(result != null, "Model checker has not run yet.");
    }

    @Override
    public void close() {
    }

    private Thread createTimeoutThread() {
        return new Thread(() -> {
            try {
                final long timeoutInMillis = timeout;
                Thread.sleep(timeoutInMillis);
                final String error = String.format("Timeout of %s exceeded.", Utils.toTimeString(timeoutInMillis));
                shutdownManager.requestShutdown(error);
            } catch (InterruptedException e) {
                // Verification ended, nothing to be done.
            }
        });
    }

}
