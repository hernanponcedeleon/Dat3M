package porthosc.app.modules;

public class Timer {

    private transient double startTime;
    private double elapsedTimeSec;

    public void start() {
        startTime = System.currentTimeMillis();
    }

    public void finish() {
        elapsedTimeSec = (System.currentTimeMillis() - startTime) * 1.0 / 1000;
    }

    public double getStartTime() {
        return startTime;
    }

    public double getElapsedTimeSec() {
        return elapsedTimeSec;
    }
}
