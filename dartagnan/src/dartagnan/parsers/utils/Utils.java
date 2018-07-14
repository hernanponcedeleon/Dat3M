package dartagnan.parsers.utils;

import dartagnan.program.Seq;
import dartagnan.program.Skip;
import dartagnan.program.Thread;

import java.util.List;

public class Utils {

    public static Thread listToThread(List<Thread> threads){
        Thread partialThread;

        if(threads.size() > 0){
            partialThread = threads.get(0);
        } else {
            partialThread = new Skip();
        }

        for(int i = 1; i < threads.size(); i++){
            partialThread = new Seq(partialThread, threads.get(i));
        }

        return partialThread;
    }
}
