package dartagnan.wmm.utils;

import dartagnan.program.event.Event;

public class Tuple {

    private Event first;
    private Event second;

    public Tuple(Event first, Event second) {
        this.first = first;
        this.second = second;
    }

    public Event getFirst(){
        return first;
    }

    public Event getSecond(){
        return second;
    }

    public String toString() {
        return "(" + first + ", " + second + ")";
    }

    @Override
    public int hashCode() {
        return (first.getEId() << 16) + second.getEId();
    }

    public static int toHashCode(int a, int b){
        return (a << 16) + b;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        Tuple tObj = (Tuple) obj;
        return first.getEId() == tObj.getFirst().getEId()
                && second.getEId() == tObj.getSecond().getEId();
    }
}
