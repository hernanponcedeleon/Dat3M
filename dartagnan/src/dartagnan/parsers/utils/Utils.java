package dartagnan.parsers.utils;

import dartagnan.program.Seq;
import dartagnan.program.event.Skip;
import dartagnan.program.Thread;

import java.util.Arrays;
import java.util.List;

public class Utils {

    public static Thread arrayToThread(boolean createSkipOnNull, Thread... threads) {
        return listToThread(createSkipOnNull, Arrays.asList(threads));
    }

    public static Thread listToThread(boolean createSkipOnNull, List<Thread> threads) {
        Thread result = null;
        for (Thread t : threads) {
            if(t != null){
                result = result == null ? t : new Seq(result, t);
            }
        }

        if(result == null && createSkipOnNull){
            result = new Skip();
        }

        return result;
    }
}
