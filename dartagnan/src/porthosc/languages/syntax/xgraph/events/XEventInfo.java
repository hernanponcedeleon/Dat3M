package porthosc.languages.syntax.xgraph.events;

import porthosc.languages.syntax.xgraph.process.XProcessId;

import java.util.Objects;


public class XEventInfo {

    private static int eventGlobalCounter = 0;

    // TODO: code origin
    //public final String controlLabel;

    ///** instruction that events come from which gives the shared variables
    // *  and local registers affected by the event, if any */
    //public final String instruction; // todo: returnType
    /**
     * identifier of the process that event comes from
     */
    private final XProcessId processId;

    // todo: perhaps add nullable labels to the event info - for jumps // <- ??
    /**
     * ensures that events are unique
     */
    private final int eventId;


    //todo: package-private (after removing the folder 'tests' from tests project root)
    public XEventInfo(XProcessId processId) {
        // TODO: verify process id string for bad symbols
        this.processId = processId;
        this.eventId = newEventId();
    }

    public String getText() {
        return processId + "_" + getEventId();
    }

    public XProcessId getProcessId() {
        return processId;
    }

    public int getEventId() {
        return eventId;
    }

    @Override
    public String toString() {
        return getText();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) { return true; }
        if (!(o instanceof XEventInfo)) { return false; }
        XEventInfo that = (XEventInfo) o;
        return getEventId() == that.getEventId() &&
                Objects.equals(getProcessId(), that.getProcessId());
    }

    public boolean weakEquals(Object o) {
        if (this == o) { return true; }
        if (!(o instanceof XEventInfo)) { return false; }
        XEventInfo that = (XEventInfo) o;
        return Objects.equals(getProcessId(), that.getProcessId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getProcessId(), getEventId());
    }

    public int weakHashCode() {
        return Objects.hash(getProcessId());
    }


    private static int newEventId() {
        return eventGlobalCounter++;
    }
}
